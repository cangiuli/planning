;; A really simple loop that executes twice
(define (problem threads-x0)
	(:domain threads)
	(:objects
        n0 n1 n2 n3 - number

		x
		out i0 i1 i2 i3 i4
		- label
	)
	(:init
        (succ n0 n1) (succ n1 n2) (succ n2 n3)

		; .data
		(value x n2)

		; .text
		(eval i0 out)
        (branch i0 x i1 i2)
        (decr i1 i0 x)
        (exit i2)

	)
	(:goal (and
			(done out)
            (value x n0) ; x = 0
		)
	)
)
