(define (problem plus3)
  (:domain plus)
  (:objects
    p0 p1 p2 p3 p4 p5 p6 p7 p8 p9 p10
    p11 p12 p13 p14 p15 p16 p17 p18 - ptr)

  (:init
    ;; Generic facts (ptr-succ p0 p1)
    (ptr-succ p1 p2)
    (ptr-succ p2 p3)
    (ptr-succ p3 p4)
    (ptr-succ p4 p5)
    (ptr-succ p5 p6)
    (ptr-succ p6 p7)
    (ptr-succ p7 p8)
    (ptr-succ p8 p9)
    (ptr-succ p9 p10)
    (ptr-succ p10 p11)
    (ptr-succ p11 p12)
    (ptr-succ p12 p13)
    (ptr-succ p13 p14)
    ;; result: it correctly fails to find a plan, because there are not enough pointers
    ;; result': but if i add enough pointers, it silently fails as in prob2

    ;; Plus 9 1 _
    (S p0 p1)
    (S p1 p2)
    (S p2 p3)
    (S p3 p4)
    (S p4 p5)
    (S p5 p6)
    (S p6 p7)
    (S p7 p8)
    (S p8 p9)
    (Z p9)
    (S p10 p11)
    (Z p11)

    ;; ptr initialization
    (ptr-next p12))

  (:goal (exists (?ans - ptr) (Plus p0 p5 ?ans))))
