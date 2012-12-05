; THIS IS GENERATED CODE: DO NOT EDIT
; A plan should NOT be found
(define (problem prob60-livelock-mutex)
    (:domain threads)
    (:objects
        n0 n1 n2 n3 n4 n5 n6 - number
        out - label
        flag0 flag1 num_in_section thread1_waiting thread2_iters - label

        thread00 thread01 thread02 thread03 thread04 thread05 thread06 thread07 thread08 thread09 thread010
        thread10 thread11 thread12 thread13 thread14 thread15 thread16 thread17 thread18
        main0 main1
        - label

    )
    (:init
        (succ n0 n1) (succ n1 n2) (succ n2 n3)
        (succ n3 n4) (succ n4 n5) (succ n5 n6)

        ; .data
        (value flag0 n0)
        (value flag1 n0)
        (value num_in_section n0)
        (value thread1_waiting n0)
        (value thread2_iters n0)

        ; .text
        ; thread0
        (set thread00 thread01 flag0 n1)
        (set thread01 thread02 thread2_iters n0)
        (set thread02 thread03 thread1_waiting n1)
        (branch thread03 flag1 thread04 thread06)
        (set thread04 thread05 flag0 n0)
        (set thread05 thread03 flag0 n1)
        (set thread06 thread07 thread1_waiting n0)
        (incr thread07 thread08 num_in_section)
        (decr thread08 thread09 num_in_section)
        (set thread09 thread00 flag0 n0)
        (exit thread010)

        ; thread1
        (set thread10 thread11 flag1 n1)
        (branch thread11 flag0 thread12 thread14)
        (set thread12 thread13 flag1 n0)
        (set thread13 thread11 flag1 n1)
        (incr thread14 thread15 thread2_iters)
        (incr thread15 thread16 num_in_section)
        (decr thread16 thread17 num_in_section)
        (set thread17 thread10 flag1 n0)
        (exit thread18)

        ; main
        (fork main0 main1 thread00 thread10)
        (exit main1)

        (eval main0 out)
    )
    (:goal (and
            (value num_in_section n2)
        )
    )
)
