; THIS IS GENERATED CODE: DO NOT EDIT
; A plan SHOULD be found
(define (problem prob41-dekker)
    (:domain threads)
    (:objects
        n0 n1 n2 n3 n4 n5 n6 - number
        out - label
        flag0 flag1 turn num_in_section - label

        thread00 thread01 thread02 thread03 thread04 thread05 thread06 thread07 thread08 thread09 thread010
        thread10 thread11 thread12 thread13 thread14 thread15 thread16 thread17 thread18 thread19 thread110
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

        ; .text
        ; thread0
        (set thread00 thread01 flag0 n1)
        (branch thread01 flag1 thread02 thread06)
        (branch thread02 turn thread03 thread01)
        (set thread03 thread04 flag0 n0)
        (branch thread04 turn thread04 thread05)
        (set thread05 thread01 flag0 n1)
        (incr thread06 thread07 num_in_section)
        (decr thread07 thread08 num_in_section)
        (set thread08 thread09 turn n1)
        (set thread09 thread010 flag0 n0)
        (exit thread010)

        ; thread1
        (set thread10 thread11 flag1 n1)
        (branch thread11 flag0 thread12 thread16)
        (branch thread12 turn thread11 thread13)
        (set thread13 thread14 flag1 n0)
        (branch thread14 turn thread15 thread14)
        (set thread15 thread11 flag1 n1)
        (incr thread16 thread17 num_in_section)
        (decr thread17 thread18 num_in_section)
        (set thread18 thread19 turn n0)
        (set thread19 thread110 flag1 n0)
        (exit thread110)

        ; main
        (fork main0 main1 thread00 thread10)
        (exit main1)

        (eval main0 out)
    )
    (:goal (and
            (done out)
        )
    )
)
