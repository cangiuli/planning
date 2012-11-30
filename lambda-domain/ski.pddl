;; SKI combinator calculus

(define (domain ski)
  (:requirements :strips :adl :typing)
  (:types dest ptr)
  (:predicates
    ;; Destinations

    ;; Pointers

    ;; Expressions/continuations
    (S ?e - ptr)
    (K ?e - ptr)
    (I ?e - ptr)
    (S1 ?e ?ex - ptr)
    (S2 ?e ?ex ?ey - ptr)
    (K1 ?e ?ex - ptr)
    (App ?e ?ex ?ey)

    ;; Machine frames
    (eval ?l ?e ?l')
    (cont ?l ?e ?l')
    (retn ?l ?e ?l'))

  ;; Eval rules

  (:action Eval-App
    :parameters ()
    :precondition (and
      (eval ?l ?e ?l')
      (App ?e ?ex ?ey)
      (dest-next ?l'')
      (dest-succ ?l'' ?lnext))
    :effect (and
      (not (eval ?l ?e ?l'))
      (eval ?l ?ex ?l'')
      (cont ?l'' ?ey ?l')
      (not (dest-next ?l''))
      (dest-next ?lnext)))

  (:action Eval-S
    :parameters ()
    :precondition (and
      (eval ?l ?e ?l')
      (S ?e))
    :effect (and
      (not (eval ?l ?e ?l'))
      (retn ?l ?e ?l')))

  (:action Eval-K
    :parameters ()
    :precondition (and
      (eval ?l ?e ?l')
      (K ?e))
    :effect (and
      (not (eval ?l ?e ?l'))
      (retn ?l ?e ?l')))

  (:action Eval-I
    :parameters ()
    :precondition (and
      (eval ?l ?e ?l')
      (I ?e))
    :effect (and
      (not (eval ?l ?e ?l'))
      (retn ?l ?e ?l')))

  (:action Eval-S1
    :parameters ()
    :precondition (and
      (eval ?l ?e ?l')
      (S1 ?e ?ex))
    :effect (and
      (not (eval ?l ?e ?l'))
      (retn ?l ?e ?l')))

  (:action Eval-S2
    :parameters ()
    :precondition (and
      (eval ?l ?e ?l')
      (S2 ?e ?ex ?ey))
    :effect (and
      (not (eval ?l ?e ?l'))
      (retn ?l ?e ?l')))

  (:action Eval-K1
    :parameters ()
    :precondition (and
      (eval ?l ?e ?l')
      (K1 ?e ?ex))
    :effect (and
      (not (eval ?l ?e ?l'))
      (retn ?l ?e ?l')))

  ;; Retn rules (yielding Eval)

  (:action Retn-I
    :parameters ()
    :precondition (and
      (retn ?l ?e ?l')
      (cont ?l' ?ec ?l'')
      (I ?e))
    :effect (and
      (not (retn ?l ?e ?l'))
      (not (cont ?l' ?ec ?l''))
      (eval ?l ?ec ?l'')))

  (:action Retn-K1
    :parameters ()
    :precondition (and
      (retn ?l ?e ?l')
      (cont ?l' ?ec ?l'')
      (K1 ?e ?ex))
    :effect (and
      (not (retn ?l ?e ?l'))
      (not (cont ?l' ?ec ?l''))
      (eval ?l ?e ?l'')))

  (:action Retn-S2
    :parameters ()
    :precondition (and
      (retn ?l ?e ?l')
      (cont ?l' ?ec ?l'')
      (S2 ?e ?ex ?ey)
      (ptr-next ?e')
      (ptr-succ ?e' ?e1)
      (ptr-succ ?e1 ?e2)
      (ptr-succ ?e2 ?enext))
    :effect (and
      (not (retn ?l ?e ?l'))
      (not (cont ?l' ?ec ?l''))
      (eval ?l ?e' ?l'')
      (App ?e' ?e1' ?e2')
      (App ?e1' ?ex ?ec)
      (App ?e2' ?ey ?ec)
      (not (ptr-next ?e'))
      (ptr-next ?enext)))

  ;; Retn rules (yielding Retn)
  ;; O P T I M I Z A T I O N 

  (:action Retn-K
    :parameters ()
    :precondition (and
      (retn ?l ?e ?l')
      (cont ?l' ?ec ?l'')
      (K ?e)
      (ptr-next ?e')
      (ptr-succ ?e' ?enext))
    :effect (and
      (not (retn ?l ?e ?l'))
      (not (cont ?l' ?ec ?l''))
      (retn ?l ?e' ?l'')
      (K1 ?e' ?ec)
      (not (ptr-next ?e'))
      (ptr-next ?enext)))

  (:action Retn-S
    :parameters ()
    :precondition (and
      (retn ?l ?e ?l')
      (cont ?l' ?ec ?l'')
      (S ?e)
      (ptr-next ?e')
      (ptr-succ ?e' ?enext))
    :effect (and
      (not (retn ?l ?e ?l'))
      (not (cont ?l' ?ec ?l''))
      (retn ?l ?e' ?l'')
      (S1 ?e' ?ec)
      (not (ptr-next ?e'))
      (ptr-next ?enext)))

  (:action Retn-S1
    :parameters ()
    :precondition (and
      (retn ?l ?e ?l')
      (cont ?l' ?ec ?l'')
      (S1 ?e ?ex)
      (ptr-next ?e')
      (ptr-succ ?e' ?enext))
    :effect (and
      (not (retn ?l ?e ?l'))
      (not (cont ?l' ?ec ?l''))
      (retn ?l ?e' ?l'')
      (S2 ?e' ?ex ?ec)
      (not (ptr-next ?e'))
      (ptr-next ?enext)))

)
