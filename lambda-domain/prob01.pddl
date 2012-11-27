(define (problem lambda1)
  (:domain lambda)
  (:objects
       r
       i0 i1 i2 i3 i4 i5 i6
       l0 l1 l2 l3 l4 l5 l6  - label)
    (:init
      (la l0 l1) (la l1 l2) (la l2 l3) (la l3 l4) (la l4 l5) (la l5 l6)
      (fresh-ctr l0)

      (zero i0)
      (succ i1 i0)
      (eval i1 r) )
    (:goal (exists (?x - label) (retn ?x r)))
)
