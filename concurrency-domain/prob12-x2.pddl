; For x to be 2, the children must not interleave. Solution must contain e.g.:
; LOAD c1
; INCR c1
; STORE c1
; LOAD c2
; INCR c2
; STORE c2
(define (problem threads-x2)
	(:domain threads)
	(:objects
        n0 n1 n2 n3 - number

        addr_x x temp1 temp2
		out i0 i1
		c1i0 c1i1 c1i2 c1i3
		c2i0 c2i1 c2i2 c2i3
		- label
	)
	(:init
        (succ n0 n1) (succ n1 n2) (succ n2 n3)

		; .data
		(value x n0)
		(value temp1 n0)
		(value temp2 n0)

		; .text
		(eval i0 out)
		(fork i0 i1 c1i0 c2i0)
		; child program 1
		(load c1i0 c1i1 temp1 x)
		(incr c1i1 c1i2 temp1)
		(load c1i2 c1i3 x temp1)
		(exit c1i3)
		; child program 2
		(load c2i0 c2i1 temp2 x)
		(incr c2i1 c2i2 temp2)
		(load c2i2 c2i3 x temp2)
		(exit c2i3)
		; parent joins and immediately exits
		(exit i1)
	)
	(:goal (and
			(done out)
            (value x n2) ; x = 2
		)
	)
)
