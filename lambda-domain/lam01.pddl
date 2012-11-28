(define (problem lambda2)
  (:domain lambda)
  (:objects
       x0 x1 x2 x3 x4 x5 x6 - address
       i0 i1 i2 i3 i4 i5 i6 - address

       r empty - label

       l0 l1 l2 l3 l4 l5 l6 l7 l8 l9 l10 l11 l12 l13 l14 l15 l16 l17 l18 l19 l20         - label)
    (:init

     (aa i0 i1) (aa i1 i2) (aa i2 i3) (aa i3 i4) (aa i4 i5) (aa i5 i6)

(la l0 l1) (la l1 l2) (la l2 l3) (la l3 l4) (la l4 l5) (la l5 l6) (la l6 l7) (la l7 l8) (la l8 l9) (la l9 l10) (la l10 l11) (la l11 l12) (la l12 l13) (la l13 l14) (la l14 l15) (la l15 l16) (la l16 l17) (la l17 l18) (la l18 l19) (la l19 l20)


      (fresh-ctr l0)
      (addr-fresh-ctr i0)

      (var i0 x0)
      (lam i1 x0 i0)

      (eval empty i1 r) )
    (:goal (exists (?x - address) (complete ?x)))
)
