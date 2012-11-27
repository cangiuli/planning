;; This has succ and pred but represents them with labels for
;; nicer output.



(define (domain lambda)
  (:requirements :strips :adl :typing)
  (:types label)
  (:predicates
   ;; Framework boilerplate
   (la ?x ?y - label)
   (fresh-ctr ?x - label)
   (fresh ?x - label)
   (complete ?answer - label)

   ;; Substitution things
   (allow-subst)
   (subst ?e1 ?x ?e2 ?e - label) ;; [e1/x]e2 = e
;;   (subst ?e1 ?x ?e2 ?out - label) ;; [e1/x]e2 = e
;;   (subst-retn ?e ?out - label)
;;   (subst-cont ?k ?e ?out - label)

   ;; Stuff for the domain being represented
   (app ?l ?e1 ?e2 - label)
   (lam ?l ?var ?e - label)
   (var ?l ?var - label)

   (eval ?e ?out - label)
   (retn ?v ?out - label)
   (cont-s ?in ?out - label)
   (pred-s ?in ?out - label)
   )

  (:functions (ctr))

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

  )
