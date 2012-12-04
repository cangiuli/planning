;; Simple threaded imperative computation with memory cells


(define (domain threads)
	(:requirements :strips :adl :typing)
	(:types label number)
	(:predicates
		; data
		(value ?name - label ?value - number) ; assignable "name" holds "value"
        (succ ?n ?m) ; n+1 = m

		; instructions -- each instruction has
		; me:   the address of this instruction
		; next: the address of the next instruction
		; out:  for continuations (sometimes)
		; and sometimes some arguments
		(incr ?me ?next ?name - label) ; in-place increment
		(decr ?me ?next ?name - label) ; in-place decrement
		(load ?me ?next ?dest ?src - label) ; "dest <- src;", store is the same
		(set ?me ?next ?dest - label ?n - number) ; "dest <- n;"
		(branch ?me ?name ?iftrue ?iffalse - label)
		(brancheq ?me ?name1 ?name2 ?ifeq ?ifneq - label)

		(fork ?me ?next
		          ?child1 ?child2 ; both must 'exit' before 'next' can run
		          - label)
		; 'join' is automatically created when Forking. Do not use directly.
		(join ?child1 ?child2 ?next ?out - label)
		(exit ?me - label)
		; 'done' is automatically generated when Exiting. Do not use directly.
		(done ?out - label)
		(eval ?next ?out - label) ; instruction pointer

		; atomic operations
		(xchg ?me ?next ?dest ?src - label)
		(xadd ?me ?next ?dest ?result - label) ; only supports adding 1
	)

	(:action Xchg
		:parameters (?me ?out ?next ?dest ?src - label ?dv ?sv - number)
		:precondition (and
				(eval ?me ?out)
				(xchg ?me ?next ?dest ?src)
				(value ?dest ?dv)
				(value ?src ?sv)
			)
		:effect (and
				(not (eval ?me ?out))
				(eval ?next ?out)
				(not (value ?dest ?dv))
				(not (value ?src ?sv))
				(value ?dest ?sv)
				(value ?src ?dv)
			)
	)
	(:action Xadd
		:parameters (?me ?out ?next ?dest ?result - label ?dv ?sv ?rv - number)
		:precondition (and
				(eval ?me ?out)
				(xadd ?me ?next ?dest ?result)
				(value ?dest ?dv)
				(succ ?dv ?sv) ; sv == successor val
				(value ?result ?rv) ; rv == old return val
			)
		:effect (and
				(not (eval ?me ?out))
				(eval ?next ?out)
				(not (value ?dest ?dv))
				(not (value ?result ?rv))
				(value ?dest ?sv)
				(value ?result ?dv)
			)
	)

	(:action BranchEq
		:parameters (?me ?out ?name1 ?name2 ?ifeq ?ifneq - label ?val - number)
		:precondition (and
				(eval ?me ?out)
				(brancheq ?me ?name1 ?name2 ?ifeq ?ifneq)
				(value ?name1 ?val)
				(value ?name2 ?val)
			)
		:effect (and
				(not (eval ?me ?out))
				(eval ?ifeq ?out) ; jump to true branch
			)
	)
	(:action BranchNeq
		:parameters (?me ?out ?name1 ?name2 ?ifeq ?ifneq - label ?val1 ?val2 - number)
		:precondition (and
				(eval ?me ?out)
				(brancheq ?me ?name1 ?name2 ?ifeq ?ifneq)
				(value ?name1 ?val1)
				(value ?name2 ?val2)
				(not (= ?val1 ?val2))
			)
		:effect (and
				(not (eval ?me ?out))
				(eval ?ifneq ?out) ; jump to false branch
			)
	)

	(:action BranchTrue
		:parameters (?me ?out ?iftrue ?iffalse ?name - label ?val - number)
		:precondition (and
				(eval ?me ?out)
				(branch ?me ?name ?iftrue ?iffalse) ; x++
                ;; Anything that isn't 0.
				(value ?name ?val)
                (not (= ?val n0))
			)
		:effect (and
				(not (eval ?me ?out))
				(eval ?iftrue ?out) ; jump to true branch
			)
	)

	(:action BranchFalse
		:parameters (?me ?out ?iftrue ?iffalse ?name - label)
		:precondition (and
				(eval ?me ?out)
				(branch ?me ?name ?iftrue ?iffalse) ; x++
				(value ?name n0)
			)
		:effect (and
				(not (eval ?me ?out))
				(eval ?iffalse ?out) ; jump to false branch
			)
	)


    (:action Incr
		:parameters (?me ?out ?next ?name - label ?val1 ?val2 - number)
		:precondition (and
				(eval ?me ?out)
				(incr ?me ?next ?name) ; x++
				(value ?name ?val1)
                (succ ?val1 ?val2)
			)
		:effect (and
				(not (eval ?me ?out))
				(eval ?next ?out) ; advance IP
				(not (value ?name ?val1)) ; change what x points to...
				(value ?name ?val2) ; ...new "head"
			)
	)

    (:action Decr
		:parameters (?me ?out ?next ?name - label ?val1 ?val2 - number)
		:precondition (and
				(eval ?me ?out)
				(decr ?me ?next ?name) ; x--
				(value ?name ?val1)
                (succ ?val2 ?val1)
			)
		:effect (and
				(not (eval ?me ?out))
				(eval ?next ?out) ; advance IP
				(not (value ?name ?val1)) ; change what x points to...
				(value ?name ?val2) ; ...new "head"
			)
	)


	; Requires the thing to be initialised.
	(:action Load
		:parameters (?me ?out ?next ?dest ?src - label ?val ?oldval - number)
		:precondition (and
				(eval ?me ?out)
				(load ?me ?next ?dest ?src)
				(value ?src ?val)
				(value ?dest ?oldval)
			)
		:effect (and
				(not (eval ?me ?out))
				(eval ?next ?out)
				(not (value ?dest ?oldval))
				(value ?dest ?val)
			)
	)

	(:action Set
		:parameters (?me ?out ?next ?dest - label ?val ?oldval - number)
		:precondition (and
				(eval ?me ?out)
				(set ?me ?next ?dest ?val)
				(value ?dest ?oldval)
			)
		:effect (and
				(not (eval ?me ?out))
				(eval ?next ?out)
				(not (value ?dest ?oldval))
				(value ?dest ?val)
			)
	)


	(:action Fork
		:parameters (?me ?out ?next ?child1 ?child2 - label)
		:precondition (and
				(eval ?me ?out)
				(fork ?me ?next ?child1 ?child2)
			)
		:effect (and
				(not (eval ?me ?out))
				; this is effectively a continuation atom to save "out"
				(join ?child1 ?child2 ?next ?out)
				; I could use "?me" for the 'out' of both evals,
				; but Join would then require "done ?me" twice...
				(eval ?child1 ?child1)
				(eval ?child2 ?child2)
			)
	)
	(:action Join
		:parameters (?next ?child1 ?child2 ?out - label)
		:precondition (and
				(join ?child1 ?child2 ?next ?out) ; recover "out"
				(done ?child1)
				(done ?child2)
			)
		:effect (and
				(not (done ?child1)) ; these eggplant the eval token
				(not (done ?child2)) ; so we need to remove them
				(eval ?next ?out)
			)
	)
	(:action Exit
		:parameters (?me ?out - label)
		:precondition (and (eval ?me ?out) (exit ?me))
		:effect (and (not (eval ?me ?out)) (done ?out))
	)
)
