;; Check that Peterson's Algorithm obeys a very strict bounded waiting
;; property.

(define (problem peterson-bw)
    (:domain threads)
    (:objects
        n0 n1 n2 n3 n4 n5 n6 - number
        out - label
        flag0 flag1 turn tmp0 tmp1 num_in_section thread1_waiting thread2_iters - label

        thread00 thread01 thread02 thread03 thread04 thread05 thread06 thread07 thread08 thread09 thread010 thread011 thread012 thread013 thread014
        thread10 thread11 thread12 thread13 thread14 thread15 thread16 thread17 thread18 thread19 thread110 thread111 thread112
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
        (value tmp0 n0)
        (value tmp1 n0)
        (value num_in_section n0)
        (value thread1_waiting n0)
        (value thread2_iters n0)

        ; .text
        ; thread0
        (set thread00 thread01 flag0 n1)
        (set thread01 thread02 turn n1)
        (set thread02 thread03 thread2_iters n0)
        (set thread03 thread04 thread1_waiting n1)
        (set thread04 thread05 tmp0 n1)
        (branch thread05 tmp0 thread06 thread010)
        (branch thread06 flag1 thread08 thread07)
        (set thread07 thread08 tmp0 n0)
        (branch thread08 turn thread05 thread09)
        (set thread09 thread05 tmp0 n0)
        (set thread010 thread011 thread1_waiting n0)
        (incr thread011 thread012 num_in_section)
        (decr thread012 thread013 num_in_section)
        (set thread013 thread00 flag0 n0)
        (exit thread014)

        ; thread1
        (set thread10 thread11 flag1 n1)
        (set thread11 thread12 turn n0)
        (set thread12 thread13 tmp1 n1)
        (branch thread13 tmp1 thread14 thread18)
        (branch thread14 flag0 thread16 thread15)
        (set thread15 thread16 tmp1 n0)
        (branch thread16 turn thread17 thread13)
        (set thread17 thread13 tmp1 n0)
        (incr thread18 thread19 thread2_iters)
        (incr thread19 thread110 num_in_section)
        (decr thread110 thread111 num_in_section)
        (set thread111 thread10 flag1 n0)
        (exit thread112)

        ; main
        (fork main0 main1 thread00 thread10)
        (exit main1)

        (eval main0 out)
    )
    (:goal (and
            (value thread1_waiting n1)
            (value thread2_iters n2)
            ; GOALS
        )
    )
)
