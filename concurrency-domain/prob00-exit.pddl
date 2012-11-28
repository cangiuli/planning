; simplest possible program
(define (problem threads-exit)
	(:domain threads)
	(:objects
		out i0
		- label
	)
	(:init
		; .text
		(eval i0 out)
		(exit i0)
	)
	(:goal (done out))
)
