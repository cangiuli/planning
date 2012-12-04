;; SKI combinator calculus

(define (domain plus)
  (:requirements :strips :adl :typing)
  (:types ptr)
  (:predicates
    ;; Pointers
    (ptr-next ?e - ptr)
    (ptr-succ ?e ?ep - ptr)

    ;; Expressions
    (Plus ?n1 ?n2 ?ans - ptr)
    (Z ?l - ptr)
    (S ?l ?n - ptr))

  ;; Plus rules

  (:action Plus-Z
    :parameters (?n1 ?n2 - ptr)
    :precondition (and
      (Z ?n1))
    :effect (and
      (Plus ?n1 ?n2 ?n2)))

  (:action Plus-S
    :parameters (?n1 ?n2 ?n1p ?fresh ?freshp ?ansp - ptr)
    :precondition (and
      (Plus ?n1p ?n2 ?ansp)
      (S ?n1 ?n1p)
      (ptr-next ?fresh)
      (ptr-succ ?fresh ?freshp))
    :effect (and
      (not (Plus ?n1p ?n2 ?ansp))
      (not (ptr-next ?fresh))
      (ptr-next ?freshp)
      (Plus ?n1 ?n2 ?fresh)
      (S ?fresh ?ansp)))
)
