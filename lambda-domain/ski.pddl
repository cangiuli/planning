;; SKI combinator calculus

(define (domain ski)
  (:requirements :strips :adl)
  (:predicates
   ;; Domain
   (s ?l)
   (k ?l)
   (i ?l)
   (app ?l ?e1 ?e2)

   ;; Machine
   (eval ?l ?e ?k)
   (cont ?l ?e ?k)
   (retn ?l ?e ?k)
   )

  ;; Rules:
  ;; (app I X) -> X
  ;; (app (app K X) Y) -> X
  ;; (app (app (app S X) Y) Z) -> (app (app X Z) (app Y Z))
  ;;
  ;; Abstract machine:
  ;; (eval (app X Y)) -> (eval X) * (cont Y)
  ;; (eval I) -> (retn I)
  ;; (eval K) -> (retn K)
  ;; (eval S) -> (retn S)
  ;; (retn I) * (cont X) -> (retn X)
  ;; (retn K) * (cont X) -> (retn (app K X))
  ;; (retn (app K X)) * (cont Y) -> (retn X)
  ;; (retn S) * (cont X) -> (retn (app S X))
  ;; (retn (app S X)) * (cont Y) -> (retn (app (app S X) Y))
  ;; (retn (app (app S X) Y)) * (cont Z) -> (retn (app (app X Z) (app Y Z)))
  ;;
  ;; Example:
  ;; (eval (app (app K X) Y))
  ;; -> (eval (app K X))
  ;;    (cont Y)
  ;; -> (eval K)
  ;;    (cont X)
  ;;    (cont Y)
  ;; -> (retn K)
  ;;    (cont X)
  ;;    (cont Y)
  ;; -> (retn (app K X))
  ;;    (cont Y)
  ;; -> (retn X)

  ;; Stuff for the domain being represented

  ;; (eval (app X Y)) -> (eval X) * (cont Y)
  (:action Eval-App
           :parameters (?l ?e1 ?e2 ?k ?e)
           :precondition (and
                          (eval ?l ?e ?k)
                          (app ?e ?e1 ?e2))
           :effect (and
                    (not (eval ?l ?e ?k))
                    (eval ?l ?e1 ?e)
                    (cont ?e ?e2 ?k)))

  ;; (eval I) -> (retn I)
  (:action Eval-I
           :parameters (?l ?e ?k)
           :precondition (and
                          (eval ?l ?e ?k)
                          (i ?e))
           :effect (and
                    (not (eval ?l ?e ?k))
                    (retn ?l ?e ?k)))

  ;; (eval K) -> (retn K)
  (:action Eval-K
           :parameters (?l ?e ?k)
           :precondition (and
                          (eval ?l ?e ?k)
                          (k ?e))
           :effect (and
                    (not (eval ?l ?e ?k))
                    (retn ?l ?e ?k)))

  ;; (eval S) -> (retn S)
  (:action Eval-S
           :parameters (?l ?e ?k)
           :precondition (and
                          (eval ?l ?e ?k)
                          (s ?e))
           :effect (and
                    (not (eval ?l ?e ?k))
                    (retn ?l ?e ?k)))

  ;; (retn I) * (cont X) -> (retn X)
  (:action Retn-I
           :parameters (?l ?e1 ?k ?e2 ?k2 ?e)
           :precondition (and
                          (retn ?l ?e1 ?k)
                          (i ?e1)
                          (cont ?k ?e2 ?k2))
           :effect (and
                    (not (retn ?l ?e1 ?k))
                    (not (cont ?k ?e2 ?k2))
                    (retn ?l ?e2 ?k2)))


  ;; (retn K) * (cont X) -> (retn (app K X))
  (:action Retn-K1
           :parameters (?l ?e1 ?k ?e2 ?k2 ?e)
           :precondition (and
                          (retn ?l ?e1 ?k)
                          (k ?e1)
                          (cont ?k ?e2 ?k2))
           :effect (and
                    (not (retn ?l ?e1 ?k))
                    (not (cont ?k ?e2 ?k2))
                    (retn ?l ?e ?k2)
                    (app ?k ?e1 ?e2)))

  ;; (retn K) * (cont X) -> (retn (app K X))
  (:action Retn-K1
           :parameters (?l ?e1 ?k ?e2 ?k2 ?e)
           :precondition (and
                          (retn ?l ?e1 ?k)
                          (k ?e1)
                          (cont ?k ?e2 ?k2))
           :effect (and
                    (not (retn ?l ?e1 ?k))
                    (not (cont ?k ?e2 ?k2))
                    (retn ?l ?e ?k2)
                    (app ?k ?e1 ?e2)))

  ;; (retn (app K X)) * (cont Y) -> (retn X)
  (:action Retn-K2
           :parameters (?l ?e1 ?k ?e2 ?e3 ?e4 ?k2)
           :precondition (and
                          (retn ?l ?e1 ?k)
                          (app ?e1 ?e2 ?e3)
                          (k ?e2)
                          (cont ?k ?e4 ?k2))
           :effect (and
                    (not (retn ?l ?e1 ?k))
                    (not (app ?e1 ?e2 ?e3))
                    (not (k ?e2))
                    (not (cont ?k ?e4 ?k2))
                    (retn ?l ?e3 ?k2)))

  ;; (retn S) * (cont X) -> (retn (app S X))
  (:action Retn-S1
           :parameters (?l ?e1 ?k ?e2 ?k2)
           :precondition (and
                          (retn ?l ?e1 ?k)
                          (s ?e1)
                          (cont ?k ?e2 ?k2))
           :effect (and
                    (not (retn ?l ?e1 ?k))
                    (not (cont ?k ?e2 ?k2))
                    (retn ?l ?k ?k2)
                    (app ?k ?e1 ?e2)))

  ;; (retn (app S X)) * (cont Y) -> (retn (app (app S X) Y))
  (:action Retn-S2
           :parameters (?l ?e1 ?k ?e2 ?e3 ?e4 ?k2)
           :precondition (and
                          (retn ?l ?e1 ?k)
                          (app ?e1 ?e2 ?e3)
                          (s ?e2)
                          (cont ?k ?e4 ?k2))
           :effect (and
                    (not (retn ?l ?e1 ?k))
                    (not (cont ?k ?e4 ?k2))
                    (retn ?l ?k ?k2)
                    (app ?k ?e1 ?e4)))

  ;; (retn (app (app S X) Y)) * (cont Z) -> (retn (app (app X Z) (app Y Z)))
  (:action Retn-S3
           :parameters (?l ?e1 ?k ?e2 ?ey ?e3 ?ex ?ez ?k2)
           :precondition (and
                          (retn ?l ?e1 ?k)
                          (app ?e1 ?e2 ?ey)
                          (app ?e2 ?e3 ?ex)
                          (s ?e3)
                          (cont ?k ?ez ?k2))
           :effect (and
                    (not (retn ?l ?e1 ?k))
                    (not (app ?e1 ?e2 ?ey))
                    (not (app ?e2 ?e3 ?ex))
                    (not (s ?e3))
                    (retn ?l ?e1 ?k2)
                    (app ?e1 ?e2 ?e3)
                    (app ?e2 ?ex ?ez)
                    (app ?e3 ?ey ?ez) ;; need to deep copy ?ez
                    ))

)
