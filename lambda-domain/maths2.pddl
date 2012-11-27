;; This has succ and pred but represents them with labels for
;; nicer output.

(define (domain maths2)
  (:requirements :strips :adl :typing)
  (:types label)
  (:predicates
   ;; Framework boilerplate
   (la ?x ?y - label)
   (fresh-ctr ?x - label)
   (fresh ?x - label)
   (complete ?answer - label)


   ;; Stuff for the domain being represented
   (zero ?l - label)
   (succ ?l ?n - label)
   (pred ?l ?n - label)

   (eval ?e ?out - label)
   (retn ?v ?out - label)
   (cont-s ?in ?out - label)
   (pred-s ?in ?out - label)
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
  ;; Stuff for the domain being represented
  (:action Eval-Zero
           :parameters (?l ?out - label)
           :precondition (and
                          (eval ?l ?out)
                          (zero ?l))
           :effect (and
                    (not (eval ?l ?out))
                    (retn l0 ?out)))

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
           :parameters (?v ?sv ?k ?out - label)
           :precondition (and
                          (retn ?v ?k)
                          (cont-s ?k ?out)
                          (la ?v ?sv))
           :effect (and
                    (not (retn ?v ?k))
                    (not (cont-s ?k ?out))
                    (retn ?sv ?out)))

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
           :parameters (?sv ?v ?k ?out - label)
           :precondition (and
                          (retn ?sv ?k)
                          (la ?v ?sv)
                          (pred-s ?k ?out))
           :effect (and
                    (not (retn ?sv ?k))
                    (not (pred-s ?k ?out))
                    (retn ?v ?out)))


  )
