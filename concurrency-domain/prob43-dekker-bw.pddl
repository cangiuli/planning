; THIS IS GENERATED CODE: DO NOT EDIT
; A plan SHOULD be found
(define (problem prob43-dekker-bw)
    (:domain threads)
    (:objects
        n0 n1 n2 n3 n4 n5 n6 - number
        out - label
        flag0 flag1 turn num_in_section thread1_waiting thread2_iters - label

        thread00 thread01 thread02 thread03 thread04 thread05 thread06 thread07 thread08 thread09 thread010 thread011 thread012 thread013
        thread10 thread11 thread12 thread13 thread14 thread15 thread16 thread17 thread18 thread19 thread110 thread111
        main0 main1
        - label

    )
    (:init
        (succ n0 n1) (succ n1 n2) (succ n2 n3)
        (succ n3 n4) (succ n4 n5) (succ n5 n6)

        ; .data
        (value flag0 n0)
        (value flag1 n0)
        (value turn n0)
        (value num_in_section n0)
        (value thread1_waiting n0)
        (value thread2_iters n0)

        ; .text
        ; thread0
        (set thread00 thread01 flag0 n1)
        (set thread01 thread02 thread2_iters n0)
        (set thread02 thread03 thread1_waiting n1)
        (branch thread03 flag1 thread04 thread08)
        (branch thread04 turn thread05 thread03)
        (set thread05 thread06 flag0 n0)
        (branch thread06 turn thread06 thread07)
        (set thread07 thread03 flag0 n1)
        (set thread08 thread09 thread1_waiting n0)
        (incr thread09 thread010 num_in_section)
        (decr thread010 thread011 num_in_section)
        (set thread011 thread012 turn n1)
        (set thread012 thread00 flag0 n0)
        (exit thread013)

        ; thread1
        (set thread10 thread11 flag1 n1)
        (branch thread11 flag0 thread12 thread16)
        (branch thread12 turn thread11 thread13)
        (set thread13 thread14 flag1 n0)
        (branch thread14 turn thread15 thread14)
        (set thread15 thread11 flag1 n1)
        (incr thread16 thread17 thread2_iters)
        (incr thread17 thread18 num_in_section)
        (decr thread18 thread19 num_in_section)
        (set thread19 thread110 turn n0)
        (set thread110 thread10 flag1 n0)
        (exit thread111)

        ; main
        (fork main0 main1 thread00 thread10)
        (exit main1)

        (eval main0 out)
    )
    (:goal (and
            (value thread1_waiting n1)
            (value thread2_iters n4)
        )
    )
)
