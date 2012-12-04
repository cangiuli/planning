; Mutexes using atomic operations

; Xadd mutexes provide mutual exclusion and bounded waiting.
; This problem should not have a successful plan.

(define (problem xadd-mutex)
    (:domain threads)
    (:objects
        n0 n1 n2 n3 n4 n5 n6 - number
        out - label
        turn tickets tmp0 tmp1 num_in_section thread1_waiting thread2_iters - label

        thread00 thread01 thread02 thread03 thread04 thread05 thread06 thread07 thread08 thread09
        thread10 thread11 thread12 thread13 thread14 thread15 thread16 thread17
        main0 main1
        - label

    )
    (:init
        (succ n0 n1) (succ n1 n2) (succ n2 n3)
        (succ n3 n4) (succ n4 n5) (succ n5 n6)

        ; .data
        (value turn n0)
        (value tickets n0)
        (value tmp0 n0)
        (value tmp1 n0)
        (value num_in_section n0)
        (value thread1_waiting n0)
        (value thread2_iters n0)

        ; .text
        ; thread0

	(xadd thread00 thread02 tickets tmp0) ; take ticket
	; thread01 missing 'cause I'm too lazy to renumber them
        (set thread02 thread03 thread2_iters n0)
        (set thread03 thread04 thread1_waiting n1) ; indicate i'm in line
	(brancheq thread04 tmp0 turn thread05 thread04) ; if my_ticket == turn, enter section

        (set thread05 thread06 thread1_waiting n0) ; critical section
        (incr thread06 thread07 num_in_section)
        (decr thread07 thread08 num_in_section)

        (incr thread08 thread09 turn) ; unlock -- indicate next turn

	(branch thread09 tmp0 thread00 thread00) ; loop

        ; thread1
        (xadd thread10 thread12 tickets tmp1) ; take ticket
        ; thread11 missing, etc
        (brancheq thread12 tmp1 turn thread13 thread12) ; if my_ticket == turn, enter section

        (incr thread13 thread14 thread2_iters)
        (incr thread14 thread15 num_in_section)
        (decr thread15 thread16 num_in_section)

        (incr thread16 thread17 turn) ; unlock -- indicate next turn

	(branch thread17 tmp1 thread10 thread10) ; loop

        ; main
        (fork main0 main1 thread00 thread10)
        (exit main1)

        (eval main0 out)
    )
    (:goal (and
            (value thread1_waiting n1)
            (value thread2_iters n2) ; 2, the lowest number greater than 1, is the strongest BW guarantee
            ; GOALS
        )
    )
)
