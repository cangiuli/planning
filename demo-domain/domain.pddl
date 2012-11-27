(define (domain maths)
  (:requirements :strips :adl :typing :numeric-fluents)
  (:types label)
  (:predicates
   ;; Framework boilerplate
   (la ?x ?y - label)
   (fresh-ctr ?x - label)
   (fresh ?x - label)

   ;; Stuff for the domain being represented
   (zero ?l - label)
   (succ ?l ?n - label)
   (pred ?l ?n - label)

   (eval ?e ?out - label)
   (retn ?v ?out - label)
   (cont-s ?in ?out - label)
   (pred-s ?in ?out - label)
   )

  (:functions (ctr))

  ;; Framework boilerplate
  (:action FreshVar
           :parameters (?x ?y - label)
           :precondition (and
                          (fresh-ctr ?x)
                          (not (fresh ?x))
                          (la ?x ?y))

           :effect (and
                    (not (fresh-ctr ?x))
                    (fresh-ctr ?y)
                    (fresh ?y)))

  ;; Stuff for the domain being represented
  (:action Eval-Zero
           :parameters (?l ?out - label)
           :precondition (and
                          (eval ?l ?out)
                          (zero ?l))
           :effect (and
                    (not (eval ?l ?out))
                    (retn ?l ?out)))

  (:action Eval-Succ1
           :parameters (?l ?n ?k ?out - label)
           :precondition (and
                          (eval ?l ?out)
                          (succ ?l ?n)
                          (fresh ?k))
           :effect (and
                    (not (fresh ?k))
                    (not (eval ?l ?out))
                    (eval ?n ?k)
                    (cont-s ?k ?out)))

  (:action Eval-Succ2
           :parameters (?l ?sl ?k ?out - label)
           :precondition (and
                          (retn ?l ?k)
                          (cont-s ?k ?out)
                          (fresh ?sl))
           :effect (and
                    (not (fresh ?sl))
                    (not (retn ?l ?k))
                    (not (cont-s ?k ?out))
                    (succ ?sl ?l)
                    (retn ?sl ?out)))

  (:action Eval-Pred1
           :parameters (?l ?n ?k ?out - label)
           :precondition (and
                          (eval ?l ?out)
                          (pred ?l ?n)
                          (fresh ?k))
           :effect (and
                    (not (fresh ?k))
                    (not (eval ?l ?out))
                    (eval ?n ?k)
                    (pred-s ?k ?out)))

  (:action Eval-Pred2
           :parameters (?l ?n ?k ?out - label)
           :precondition (and
                          (retn ?l ?k)
                          (succ ?l ?n)
                          (pred-s ?k ?out))
           :effect (and
                    (not (retn ?l ?k))
                    (not (pred-s ?k ?out))
                    (retn ?n ?out)))


  )
