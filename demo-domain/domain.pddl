(define (domain maths)
  (:requirements :strips :adl :typing)
  (:types label)
  (:predicates
               (la ?x ?y - label)
               (fresh-ctr ?x - label)

               (fresh ?x - label)

               (zero ?l - label)
               (succ ?l ?n - label)
               (pred ?l ?n - label)

               (eval ?x ?r - label)
               (retn ?x ?r - label)
               (cont-s ?in ?out - label)
               (pred-s ?in ?out - label)
)

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


  (:action EvaluateZ
      :parameters (?x ?r - label)
      :precondition (and
                     (eval ?x ?r)
                     (zero ?x))
      :effect (and
               (not (eval ?x ?r))
               (retn ?x ?r)))

  (:action EvaluateS1
      :parameters (?x ?n ?r ?k - label)
      :precondition (and
                     (eval ?x ?r)
                     (succ ?x ?n)
                     (fresh ?k))
      :effect (and
               (not (fresh ?k))
               (not (eval ?x ?r))
               (eval ?n ?k)
               (cont-s ?k ?r)))

  (:action EvaluateS2
      :parameters (?x ?l ?r ?k - label)
      :precondition (and
                     (retn ?x ?k)
                     (cont-s ?k ?r)
                     (fresh ?l))
      :effect (and
               (not (fresh ?l))
               (not (retn ?x ?k))
               (not (cont-s ?k ?r))
               (succ ?l ?x)
               (retn ?l ?r)))

  (:action EvaluateP1
      :parameters (?x ?n ?r ?k - label)
      :precondition (and
                     (eval ?x ?r)
                     (pred ?x ?n)
                     (fresh ?k))
      :effect (and
               (not (fresh ?k))
               (not (eval ?x ?r))
               (eval ?n ?k)
               (pred-s ?k ?r)))

  (:action EvaluateP2
      :parameters (?x ?n ?r ?k - label)
      :precondition (and
                     (retn ?x ?k)
                     (succ ?x ?n)
                     (pred-s ?k ?r))
      :effect (and
               (not (retn ?x ?k))
               (not (pred-s ?k ?r))
               (retn ?n ?r)))


)
