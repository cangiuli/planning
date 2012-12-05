; THIS IS GENERATED CODE: DO NOT EDIT
; A plan SHOULD be found
(define (problem prob40-loop)
    (:domain threads)
    (:objects
        n0 n1 n2 n3 n4 n5 n6 - number
        out - label
        x - label

        main0 main1 main2
        - label

    )
    (:init
        (succ n0 n1) (succ n1 n2) (succ n2 n3)
        (succ n3 n4) (succ n4 n5) (succ n5 n6)

        ; .data
        (value x n2)

        ; .text
        ; main
        (branch main0 x main1 main2)
        (decr main1 main0 x)
        (exit main2)

        (eval main0 out)
    )
    (:goal (and
            (done out)
            (value n n0)
        )
    )
)
