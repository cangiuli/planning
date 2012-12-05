; THIS IS GENERATED CODE: DO NOT EDIT
; A plan SHOULD be found
(define (problem prob50-broken-mutex)
    (:domain threads)
    (:objects
        n0 n1 n2 n3 n4 n5 n6 - number
        out - label
        locked num_in_section - label

        thread00 thread01 thread02 thread03 thread04 thread05
        thread10 thread11 thread12 thread13 thread14 thread15
        main0 main1
        - label

    )
    (:init
        (succ n0 n1) (succ n1 n2) (succ n2 n3)
        (succ n3 n4) (succ n4 n5) (succ n5 n6)

        ; .data
        (value locked n0)
        (value num_in_section n0)

        ; .text
        ; thread0
        (branch thread00 locked thread00 thread01)
        (set thread01 thread02 locked n1)
        (incr thread02 thread03 num_in_section)
        (decr thread03 thread04 num_in_section)
        (set thread04 thread05 locked n1)
        (exit thread05)

        ; thread1
        (branch thread10 locked thread10 thread11)
        (set thread11 thread12 locked n1)
        (incr thread12 thread13 num_in_section)
        (decr thread13 thread14 num_in_section)
        (set thread14 thread15 locked n0)
        (exit thread15)

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
