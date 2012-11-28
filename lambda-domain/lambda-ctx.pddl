
(define (domain lambda)
  (:requirements :strips :adl :typing :derived-predicates)
  (:types label)
  (:predicates
   ;; Framework boilerplate
   (la ?x ?y - label)
   (fresh-ctr ?x - label)
   (fresh ?x - label)

   (complete ?answer - label)

   ;; Stuff for the domain being represented
   (binding ?ctx ?var ?val ?rest)
   (is-bound ?ctx ?var ?val)

   (app ?l ?e1 ?e2 - label)
   (lam ?l ?var ?e - label)
   (var ?l ?var - label)

   (closure ?l ?var ?body ?ctx - label)

   (eval ?ctx ?e ?out - label)
   (retn ?v ?out - label)
   (cont-app1 ?in ?ctx ?e2 ?out - label)
   (cont-app2 ?in ?v1 ?out - label)

   )


   (:derived (is-bound ?ctx ?var ?val)
              (exists (?rest)
                      (or
                       (binding ?ctx ?var ?val ?rest)
                       (exists (?v ?e)
                               (and
                                (binding ?ctx ?v ?e ?rest)
                                (is-bound ?rest ?var ?val))))))



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
  (:action Eval-Var
           :parameters (?l ?var ?val ?ctx ?out - label)
           :precondition (and
                          (eval ?ctx ?l ?out)
                          (var ?l ?var)
                          (is-bound ?ctx ?var ?val))
           :effect (and
                    (not (eval ?ctx ?l ?out))
                    (retn ?val ?out)))

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


  (:action Eval-App1
           :parameters (?l ?e1 ?e2 ?ctx ?out ?k - label)
           :precondition (and
                          (eval ?ctx ?l ?out)
                          (app ?l ?e1 ?e2)
                          (fresh ?k)
                          )
           :effect (and
                    (not (eval ?ctx ?l ?out))
                    (not (fresh ?k))
                    (cont-app1 ?k ?ctx ?e2 ?out)
                    (eval ?ctx ?e1 ?k)))

  (:action Eval-App2
           :parameters (?v ?e2 ?ctx ?out ?k - label)
           :precondition (and
                          (retn ?v ?k)
                          (cont-app1 ?k ?ctx ?e2 ?out)
                          ;; we reuse the continuation variable
                          ;; this would be dubious in some situations
                          )
           :effect (and
                    (not (retn ?v ?k))
                    (not (cont-app1 ?k ?ctx ?e2 ?out))

                    (cont-app2 ?k ?v ?out)
                    (eval ?ctx ?e2 ?k)))

  (:action Eval-App3
           :parameters (?clos ?var ?body ?v2 ?ctx ?out ?k ?ctx2 - label)
           :precondition (and
                          (retn ?v2 ?k)
                          (cont-app2 ?k ?clos ?out)
                          (closure ?clos ?var ?body ?ctx)
                          )
           :effect (and
                    (not (retn ?v2 ?k))
                    (not (cont-app2 ?k ?clos ?out))

                    (binding ?ctx2 ?var ?v2 ?ctx)
                    (eval ?ctx2 ?body ?out)))


  )
