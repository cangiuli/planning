
(define (domain lambda)
  (:requirements :strips :adl :typing :derived-predicates)
  (:types  label address)
  (:predicates

   ;; Framework boilerplate

   (la ?x ?y - label)
   (fresh-ctr ?x - label)
   (fresh ?x - label)

   (aa ?x ?y - address)
   (addr-fresh-ctr ?x - address)
   (addr-fresh ?x - address)



   (complete ?answer - address)

   ;; Stuff for the domain being represented
   (binding ?ctx - label ?var ?val - address ?rest - label)
   (is-bound ?ctx - label ?var ?val - address)

   (app ?l ?e1 ?e2 - address)
   (lam ?l ?var ?e - address)
   (var ?l ?var - address)

   (closure ?l ?var ?body - address ?ctx - label)

   (eval ?ctx - label ?e - address ?out - label)
   (retn ?v - address ?out - label)
   (cont-app1 ?in ?ctx - label ?e2 - address ?out - label)
   (cont-app2 ?in - label ?v1 - address ?out - label)

   )


   (:derived (is-bound ?ctx - label ?var ?val - address)
              (exists (?rest - label)
                      (or
                       (binding ?ctx ?var ?val ?rest)
                       (exists (?v ?e - address)
                               (and
                                (binding ?ctx ?v ?e ?rest)
                                (is-bound ?rest ?var ?val))))))



  ;; Framework boilerplate
  (:action Finish
           :parameters (?answer - address)
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
  (:action FreshAddress
           :parameters (?x ?y - address)
           :precondition (and
                          (addr-fresh-ctr ?x)
                          (not (addr-fresh ?x))
                          (aa ?x ?y)
                          )

           :effect (and
                    (not (addr-fresh-ctr ?x))
                    (addr-fresh-ctr ?y)
                    (addr-fresh ?y)))

;;
  (:action Eval-Var
           :parameters (?ctx ?out - label ?l ?var ?val - address)
           :precondition (and
                          (eval ?ctx ?l ?out)
                          (var ?l ?var)
                          (is-bound ?ctx ?var ?val))
           :effect (and
                    (not (eval ?ctx ?l ?out))
                    (retn ?val ?out)))

  (:action Eval-Lam
           :parameters (?ctx ?out - label ?l ?var ?e ?clos - address)
           :precondition (and
                          (eval ?ctx ?l ?out)
                          (lam ?l ?var ?e)
                          (addr-fresh ?clos)
                          )
           :effect (and
                    (not (eval ?ctx ?l ?out))
                    (not (addr-fresh ?clos))
                    (closure ?clos ?var ?e ?ctx)
                    (retn ?clos ?out)))


  (:action Eval-App1
           :parameters (?l ?e1 ?e2 - address ?ctx ?out ?k - label)
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
           :parameters (?v ?e2 - address ?ctx ?out ?k - label)
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
           :parameters (?clos ?var ?body ?v2 - address
                        ?ctx ?out ?k ?ctx2 - label)
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
