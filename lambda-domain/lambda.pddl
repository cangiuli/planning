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
   (subst ?e1 ?x ?e2 ?e - label) ;; [e1/x]e2 = e
;;   (subst ?e1 ?x ?e2 ?out - label) ;; [e1/x]e2 = e
;;   (subst-retn ?e ?out - label)
;;   (subst-cont ?k ?e ?out - label)

   ;; Stuff for the domain being represented
   (zero ?l - label)
   (succ ?l ?n - label)
   (pred ?l ?n - label)
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

  ;; Small-step Substitution.

  ; (:action Subst-Var-Eq
  ;          :parameters (?e1 ?x ?e2 ?e ?out - label)
  ;          :precondition (and
  ;                         (subst ?e1 ?x ?e2 ?out)
  ;                         (var ?e2 ?x)
  ;                         )
  ;          :effect (and
  ;                   (not (subst ?e1 ?x ?e2 ?out))
  ;                   (subst-retn ?e1 ?out)))

  ; (:action Subst-Var-Neq
  ;          :parameters (?e1 ?x ?y ?e2 ?e ?out - label)
  ;          :precondition (and
  ;                         (subst ?e1 ?x ?e2 ?out)
  ;                         (var ?e2 ?y)
  ;                         (not (= ?x ?y))
  ;                         )
  ;          :effect (and
  ;                   (not (subst ?e1 ?x ?e2 ?out))
  ;                   (subst-retn ?e2 ?out)))

  ; ;; We will do Penn style substitution
  ; (:action Subst-Lam-Eq
  ;          :parameters (?e1 ?x ?e2 ?ebody ?e - label)
  ;          :precondition (and
  ;                         (lam ?e2 ?x ?ebody)
  ;                         )
  ;          :effect (subst ?e1 ?x ?e2 ?e2))


  ;; Normal Substitution.
  (:action Subst-Var-Eq
           :parameters (?e1 ?x ?e2 ?e - label)
           :precondition (and
                          (var ?e2 ?x)
                          )
           :effect (subst ?e1 ?x ?e2 ?e1))

  (:action Subst-Var-Neq
           :parameters (?e1 ?x ?e2 ?e ?y - label)
           :precondition (and
                          (var ?e2 ?y)
                          (not (= ?x ?y))
                          )
           :effect (subst ?e1 ?x ?e2 ?e2))

  ;; We will do Penn style substitution
  (:action Subst-Lam-Eq
           :parameters (?e1 ?x ?e2 ?ebody ?e - label)
           :precondition (and
                          (lam ?e2 ?x ?ebody)
                          )
           :effect (subst ?e1 ?x ?e2 ?e2))


  (:action Subst-Lam
           :parameters (?e1 ?x ?e2 ?y ?ebody ?ebody2 ?e - label)
           :precondition (and
                          (lam ?e2 ?y ?ebody)
                          (not (= ?x ?y))
                          (subst ?e1 ?x ?ebody ?ebody2)
                          (fresh ?e)
                          )
           :effect (and
                    (lam ?e ?y ?ebody2)
                    (subst ?e1 ?x ?e2 ?e)))



  ; (:action Subst-Zero
  ;          :parameters (?e1 ?x ?e2 - label)
  ;          :precondition (zero ?e2)
  ;          :effect (subst ?e1 ?x ?e2 ?e2))

  ; (:action Subst-Succ
  ;          :parameters (?e1 ?x ?e2 ?en ?en2 ?e - label)
  ;          :precondition (and
  ;                         (succ ?e2 ?en)
  ;                         (subst ?e1 ?x ?en ?en2)
  ;                         (fresh ?e)
  ;                         )
  ;          :effect (and
  ;                   (succ ?e ?en2)
  ;                   (subst ?e1 ?x ?e2 ?e)))

  ; (:action Subst-Pred
  ;          :parameters (?e1 ?x ?e2 ?en ?en2 ?e - label)
  ;          :precondition (and
  ;                         (pred ?e2 ?en)
  ;                         (subst ?e1 ?x ?en ?en2)
  ;                         (fresh ?e)
  ;                         )
  ;          :effect (and
  ;                   (pred ?e ?en2)
  ;                   (subst ?e1 ?x ?e2 ?e)))



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
