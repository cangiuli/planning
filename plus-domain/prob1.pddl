; Add two and two. Succeeds.

(define (problem plus1)
  (:domain plus)
  (:objects
    p0 p1 p2 p3 p4 p5 p6 p7 p8 p9 p10 - ptr)

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

    ;; Plus (S (S Z)) (S (S Z)) _
    (S p0 p1)
    (S p1 p2)
    (Z p2)
    (S p3 p4)
    (S p4 p5)
    (Z p5)

    ;; ptr initialization
    (ptr-next p6))

  (:goal (exists (?ans - ptr) (Plus p0 p3 ?ans))))
