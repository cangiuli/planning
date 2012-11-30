;; SKI combinator calculus

(define (domain ski)
  (:requirements :strips :adl :typing)
  (:types dst ptr)
  (:predicates
    ;; Destinations
    (dst-next ?l - dst)
    (dst-succ ?l ?lp - dst)

    ;; Pointers
    (ptr-next ?e - ptr)
    (ptr-succ ?e ?ep - ptr)

    ;; Expressions/continuations
    (S ?e - ptr)
    (K ?e - ptr)
    (I ?e - ptr)
    (S1 ?e ?ex - ptr)
    (S2 ?e ?ex ?ey - ptr)
    (K1 ?e ?ex - ptr)
    (App ?e ?ex ?ey - ptr)

    ;; Machine frames
    (eval ?l - dst ?e - ptr ?lp - dst)
    (cont ?l - dst ?e - ptr ?lp - dst)
    (retn ?l - dst ?e - ptr ?lp - dst))

  ;; Eval rules

  (:action Eval-App
    :parameters (?l ?lp ?lpp ?lnext - dst
                 ?e ?ex ?ey - ptr)
    :precondition (and
      (eval ?l ?e ?lp)
      (App ?e ?ex ?ey)
      (dst-next ?lpp)
      (dst-succ ?lpp ?lnext))
    :effect (and
      (not (eval ?l ?e ?lp))
      (eval ?l ?ex ?lpp)
      (cont ?lpp ?ey ?lp)
      (not (dst-next ?lpp))
      (dst-next ?lnext)))

  (:action Eval-S
    :parameters (?l ?lp - dst
                 ?e - ptr)
    :precondition (and
      (eval ?l ?e ?lp)
      (S ?e))
    :effect (and
      (not (eval ?l ?e ?lp))
      (retn ?l ?e ?lp)))

  (:action Eval-K
    :parameters (?l ?lp - dst
                 ?e - ptr)
    :precondition (and
      (eval ?l ?e ?lp)
      (K ?e))
    :effect (and
      (not (eval ?l ?e ?lp))
      (retn ?l ?e ?lp)))

  (:action Eval-I
    :parameters (?l ?lp - dst
                 ?e - ptr)
    :precondition (and
      (eval ?l ?e ?lp)
      (I ?e))
    :effect (and
      (not (eval ?l ?e ?lp))
      (retn ?l ?e ?lp)))

  (:action Eval-S1
    :parameters (?l ?lp - dst
                 ?e ?ex - ptr)
    :precondition (and
      (eval ?l ?e ?lp)
      (S1 ?e ?ex))
    :effect (and
      (not (eval ?l ?e ?lp))
      (retn ?l ?e ?lp)))

  (:action Eval-S2
    :parameters (?l ?lp - dst
                 ?e ?ex ?ey - ptr)
    :precondition (and
      (eval ?l ?e ?lp)
      (S2 ?e ?ex ?ey))
    :effect (and
      (not (eval ?l ?e ?lp))
      (retn ?l ?e ?lp)))

  (:action Eval-K1
    :parameters (?l ?lp - dst
                 ?e ?ex - ptr)
    :precondition (and
      (eval ?l ?e ?lp)
      (K1 ?e ?ex))
    :effect (and
      (not (eval ?l ?e ?lp))
      (retn ?l ?e ?lp)))

  ;; Retn rules (yielding Eval)

  (:action Retn-I
    :parameters (?l ?lp ?lpp - dst
                 ?e ?ec - ptr)
    :precondition (and
      (retn ?l ?e ?lp)
      (cont ?lp ?ec ?lpp)
      (I ?e))
    :effect (and
      (not (retn ?l ?e ?lp))
      (not (cont ?lp ?ec ?lpp))
      (eval ?l ?ec ?lpp)))

  (:action Retn-K1
    :parameters (?l ?lp ?lpp - dst
                 ?e ?ec ?ex - ptr)
    :precondition (and
      (retn ?l ?e ?lp)
      (cont ?lp ?ec ?lpp)
      (K1 ?e ?ex))
    :effect (and
      (not (retn ?l ?e ?lp))
      (not (cont ?lp ?ec ?lpp))
      (eval ?l ?e ?lpp)))

  (:action Retn-S2
    :parameters (?l ?lp ?lpp - dst
                 ?e ?ec ?ex ?ey ?ep ?e1 ?e2 ?enext - ptr)
    :precondition (and
      (retn ?l ?e ?lp)
      (cont ?lp ?ec ?lpp)
      (S2 ?e ?ex ?ey)
      (ptr-next ?ep)
      (ptr-succ ?ep ?e1)
      (ptr-succ ?e1 ?e2)
      (ptr-succ ?e2 ?enext))
    :effect (and
      (not (retn ?l ?e ?lp))
      (not (cont ?lp ?ec ?lpp))
      (eval ?l ?ep ?lpp)
      (App ?ep ?e1 ?e2)
      (App ?e1 ?ex ?ec)
      (App ?e2 ?ey ?ec)
      (not (ptr-next ?ep))
      (ptr-next ?enext)))

  ;; Retn rules (yielding Retn)
  ;; O P T I M I Z A T I O N 

  (:action Retn-K
    :parameters (?l ?lp ?lpp - dst
                 ?e ?ec ?ep ?enext - ptr)
    :precondition (and
      (retn ?l ?e ?lp)
      (cont ?lp ?ec ?lpp)
      (K ?e)
      (ptr-next ?ep)
      (ptr-succ ?ep ?enext))
    :effect (and
      (not (retn ?l ?e ?lp))
      (not (cont ?lp ?ec ?lpp))
      (retn ?l ?ep ?lpp)
      (K1 ?ep ?ec)
      (not (ptr-next ?ep))
      (ptr-next ?enext)))

  (:action Retn-S
    :parameters (?l ?lp ?lpp - dst
                 ?e ?ec ?ep ?enext - ptr)
    :precondition (and
      (retn ?l ?e ?lp)
      (cont ?lp ?ec ?lpp)
      (S ?e)
      (ptr-next ?ep)
      (ptr-succ ?ep ?enext))
    :effect (and
      (not (retn ?l ?e ?lp))
      (not (cont ?lp ?ec ?lpp))
      (retn ?l ?ep ?lpp)
      (S1 ?ep ?ec)
      (not (ptr-next ?ep))
      (ptr-next ?enext)))

  (:action Retn-S1
    :parameters (?l ?lp ?lpp - dst
                 ?e ?ex ?ec ?ep ?enext - ptr)
    :precondition (and
      (retn ?l ?e ?lp)
      (cont ?lp ?ec ?lpp)
      (S1 ?e ?ex)
      (ptr-next ?ep)
      (ptr-succ ?ep ?enext))
    :effect (and
      (not (retn ?l ?e ?lp))
      (not (cont ?lp ?ec ?lpp))
      (retn ?l ?ep ?lpp)
      (S2 ?ep ?ex ?ec)
      (not (ptr-next ?ep))
      (ptr-next ?enext)))

)
