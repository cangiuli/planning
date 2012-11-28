; simplest possible concurrent program
(define (problem threads-forkjoin)
	(:domain threads)
	(:objects
		out i0 i1
		c1i0
		c2i0
		- label
	)
	(:init
		; .text
		(eval i0 out)
		(fork i0 i1 c1i0 c2i0)
		; child program 1
		(exit c1i0)
		; child program 2
		(exit c2i0)
		; parent joins and immediately exits
		(exit i1)
	)
	(:goal (done out))
)
