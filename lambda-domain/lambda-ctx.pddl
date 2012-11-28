
(define (domain lambda)
  (:requirements :strips :adl :typing)
  (:types label)
  (:predicates
   ;; Framework boilerplate
   (la ?x ?y - label)
   (fresh-ctr ?x - label)
   (fresh ?x - label)
   (complete ?answer - label)

   ;; Stuff for the domain being represented
   (binding ?var ?val ?res)

   (app ?l ?e1 ?e2 - label)
   (lam ?l ?var ?e - label)
   (var ?l ?var - label)

   (closure ?l ?var ?body ?ctx - label)

   (eval ?ctx ?e ?out - label)
   (retn ?v ?out - label)
   (cont-app1 ?in ?e2 ?out - label)
   (cont-app2 ?in ?v2 ?out - label)
   )


  ;; Framework boilerplate
  (:action Finish
           :parameters (?answer - label)
           :precondition (retn ?answer r)
           :effect (complete ?answer))

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

;;
  (:action Eval-Lam
           :parameters (?l ?var ?e ?ctx ?out ?clos - label)
           :precondition (and
                          (eval ?ctx ?l ?out)
                          (lam ?l ?var ?e)
                          (fresh ?clos)
                          )
           :effect (and
                    (not (eval ?ctx ?l ?out))
                    (not (fresh ?clos))
                    (closure ?clos ?var ?e ?ctx)
                    (retn ?clos ?out)))

  )
