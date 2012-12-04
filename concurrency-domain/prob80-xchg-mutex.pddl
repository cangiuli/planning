; Mutexes using atomic operations

; Xchg mutexes provide mutual exclusion, but not bounded waiting.
; This problem should not have a successful plan.

(define (problem xchg-mutex)
    (:domain threads)
    (:objects
        n0 n1 n2 n3 n4 n5 n6 - number
        out - label
        lock tmp0 tmp1 num_in_section thread1_waiting thread2_iters - label

        thread00 thread01 thread02 thread03 thread04 thread05 thread06 thread07 thread08 thread09
        thread10 thread11 thread12 thread13 thread14 thread15 thread16 thread17
        main0 main1
        - label

    )
    (:init
        (succ n0 n1) (succ n1 n2) (succ n2 n3)
        (succ n3 n4) (succ n4 n5) (succ n5 n6)

        ; .data
        (value lock n0)
        (value tmp0 n0)
        (value tmp1 n0)
        (value num_in_section n0)
        (value thread1_waiting n0)
        (value thread2_iters n0)

        ; .text
        ; thread0
        (set thread00 thread01 thread2_iters n0)
        (set thread01 thread02 thread1_waiting n1)

	(set thread02 thread03 tmp0 n1)
	(xchg thread03 thread04 tmp0 lock) ; lock
	(branch thread04 tmp0 thread03 thread05) ; if tmp == 0, enter section

        (set thread05 thread06 thread1_waiting n0) ; critical section
        (incr thread06 thread07 num_in_section)
        (decr thread07 thread08 num_in_section)

        (set thread08 thread09 lock n0) ; unlock

	(branch thread09 tmp0 thread00 thread00) ; loop

        ; thread1
        (set thread10 thread11 tmp1 n1)
        (xchg thread11 thread12 tmp1 lock)
        (branch thread12 tmp1 thread11 thread13) ; if tmp == 0, enter section

        (incr thread13 thread14 thread2_iters)
        (incr thread14 thread15 num_in_section)
        (decr thread15 thread16 num_in_section)

        (set thread16 thread17 lock n0)

	(branch thread17 tmp0 thread10 thread10) ; loop

        ; main
        (fork main0 main1 thread00 thread10)
        (exit main1)

        (eval main0 out)
    )
    (:goal (and
            (value num_in_section n2)
            ; GOALS
        )
    )
)
