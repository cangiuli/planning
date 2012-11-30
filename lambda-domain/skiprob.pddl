(define (problem ski1)
  (:domain ski)
  (:objects
    d0 d1 d2 d3 d4 d5 d6 d7 d8 d9 d10 - dst
    p0 p1 p2 p3 p4 p5 p6 p7 p8 p9 p10 - ptr)

  (:init
    ;; Generic facts
    (dst-succ d0 d1)
    (dst-succ d1 d2)
    (dst-succ d2 d3)
    (dst-succ d3 d4)
    (dst-succ d4 d5)
    (dst-succ d5 d6)
    (dst-succ d6 d7)
    (dst-succ d7 d8)
    (dst-succ d8 d9)
    (dst-succ d9 d10)

    (ptr-succ p0 p1)
    (ptr-succ p1 p2)
    (ptr-succ p2 p3)
    (ptr-succ p3 p4)
    (ptr-succ p4 p5)
    (ptr-succ p5 p6)
    (ptr-succ p6 p7)
    (ptr-succ p7 p8)
    (ptr-succ p8 p9)
    (ptr-succ p9 p10)

    ;; (I I)
    (eval d0 p0 d1)
    (App p0 p1 p2)
    (I p1)
    (I p2)

    ;; dst/ptr initialization
    (dst-next d2)
    (ptr-next p3))

  (:goal (exists (?e - ptr) (retn d0 ?e d1))))
