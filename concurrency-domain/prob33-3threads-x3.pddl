; This program is similar to the program in the problem2* series, but with three
; threads. The goal is to see whether with T threads looping N times, do answers
; range from 2 to N*T? or from T to N*T?
;
; This variant of the problem (with the goal being for x to be 3) is possible.
(define (problem threads-3threads-x3)
	(:domain threads)
	(:objects
	n0 n1 n2 n3 n4 n5 n6 n7 n8 n9 n10 - number

		addr_x x temp1 temp2 temp3
		out i0 i1
		c0i0 c0i1
		c1i0 c1i1 c1i2 c1i3 c1i4 c1i5 c1i6 c1i7 c1i8 c1i9
		c2i0 c2i1 c2i2 c2i3 c2i4 c2i5 c2i6 c2i7 c2i8 c2i9
		c3i0 c3i1 c3i2 c3i3 c3i4 c3i5 c3i6 c3i7 c3i8 c3i9
		- label
	)
	(:init
	(succ n0 n1) (succ n1 n2) (succ n2 n3)
	(succ n3 n4) (succ n4 n5) (succ n5 n6)
	(succ n6 n7) (succ n7 n8) (succ n8 n9)
	(succ n9 n10)

		; .data
	(value x n0)
	(value temp1 n0)
	(value temp2 n0)
	(value temp3 n0)

		; .text
		(eval i0 out)
		(fork i0 i1 c0i0 c3i0)
		; child 0 -- forks children 1 and 2
		(fork c0i0 c0i1 c1i0 c2i0)
		(exit c0i1)
		; child program 1
		(load c1i0 c1i1 temp1 x)
		(incr c1i1 c1i2 temp1)
		(load c1i2 c1i3 x temp1)
		(load c1i3 c1i4 temp1 x)
		(incr c1i4 c1i5 temp1)
		(load c1i5 c1i6 x temp1)
		(load c1i6 c1i7 temp1 x)
		(incr c1i7 c1i8 temp1)
		(load c1i8 c1i9 x temp1)
		(exit c1i9)
		; child program 2
		(load c2i0 c2i1 temp2 x)
		(incr c2i1 c2i2 temp2)
		(load c2i2 c2i3 x temp2)
		(load c2i3 c2i4 temp2 x)
		(incr c2i4 c2i5 temp2)
		(load c2i5 c2i6 x temp2)
		(load c2i6 c2i7 temp2 x)
		(incr c2i7 c2i8 temp2)
		(load c2i8 c2i9 x temp2)
		(exit c2i9)
		; child program 3
		(load c3i0 c3i1 temp3 x)
		(incr c3i1 c3i2 temp3)
		(load c3i2 c3i3 x temp3)
		(load c3i3 c3i4 temp3 x)
		(incr c3i4 c3i5 temp3)
		(load c3i5 c3i6 x temp3)
		(load c3i6 c3i7 temp3 x)
		(incr c3i7 c3i8 temp3)
		(load c3i8 c3i9 x temp3)
		(exit c3i9)
		; parent joins and immediately exits
		(exit i1)
	)
	(:goal (and
			(done out)
			(value x n3) ; x = 3
		)
	)
)
