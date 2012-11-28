;; Simple threaded imperative computation with memory cells


(define (domain threads)
	(:requirements :strips :adl :typing)
	(:types label)
	(:predicates
		; memory management
		(malloc ?x - label) ; (fresh)
		(free ?x - label) ; x is a memory slot that can be alloced (fresh-ctr)
		(also ?x ?y - label) ; y is also free mem; but allocate x first (la)

		; data
		; Alternate interpretation: "zero" is NULL, "succ" redundant to "ptr"
		(zero ?addr - label)      ; addr's value is 0
		(succ ?addr ?n - label)   ; addr's value is 1 higher than n
		(ptr ?name ?addr - label) ; variable "name" points to memory "addr"

		; instructions -- each instruction has
		; me:   the address of this instruction
		; next: the address of the next instruction
		; out:  for continuations (sometimes)
		; and sometimes some arguments
		(incr ?me ?next ?name - label) ; in-place increment
		(load ?me ?next ?name ?name - label) ; "*temp = *x;"
		(store ?me ?next ?addr ?name - label) ; "*x = *temp"
		(fork ?me ?next
		          ?child1 ?child2 ; both must 'exit' before 'next' can run
		          - label)
		; 'join' is automatically created when Forking. Do not use directly.
		(join ?child1 ?child2 ?next ?out - label)
		(exit ?me - label)
		(done ?out - label)
		(eval ?next ?out)
	)

	; TODO: freshvar -> malloc; basically copy verbatim

	(:action Incr
		:parameters (?me ?next ?name ?addr1 ?addr2 - label)
		:precondition (and
				(eval ?me ?out)
				(incr ?me ?next ?name) ; x++
				(ptr ?name ?addr1)
				(malloc ?addr2)
			)
		:effect (and
				(not (malloc ?addr2))
				(not (eval ?me ?out))
				(eval ?next ?out) ; advance PC
				(not (ptr ?name ?addr1)) ; change what x points to...
				(ptr ?name ?addr2) ; ...new "head"
				(succ ?addr2 ?addr1) ; link
			)
	)

	; TODO: load
	; TODO: store

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
				(eval ?child2 ?child1)
			)
	)
	(:action Join
		:parameters (?next ?child1 ?child2 ?out - label)
		:precondition (and
				(join ?child1 ?child2 ?next ?out) ; recover "out"
				(done ?child1)
				(done ?child2)
			)
		:efect (and
				(not (done ?child1)) ; these supplant the eval token
				(not (done ?child2)) ; so we need to remove them
				(eval ?next ?out)
			)
	)
	(:action Exit
		:parameters (?me - label)
		:precondition (and (eval ?me ?out) (exit ?me))
		:effect (and (not eval ?me ?out) (done ?out))
	)
)
