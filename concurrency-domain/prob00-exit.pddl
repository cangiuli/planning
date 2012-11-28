(define (problem threads0)
	(:domain threads)
	(:objects
		out i0
		- label
	)
	(:init
		; .text
		(eval i0 out)
		; parent joins and immediately exits
		(exit i0)
	)
	(:goal (done out))
)
