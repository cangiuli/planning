(define (problem ski1)
  (:domain ski)
  (:objects
    l0 l1
    e0 e1 e2)

  (:init
    (eval l0 e0 l1)
    (app e0 e1 e2)
    (i e1)
    (i e2))

  (:goal (exists (?x ?e) (retn ?x ?e l1))))
