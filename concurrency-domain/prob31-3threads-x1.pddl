; This program is similar to the program in the problem2* series, but with three
; threads. The goal is to see whether with T threads looping N times, do answers
; range from 2 to N*T? or from T to N*T?
;
; This variant of the problem (with the goal being for x to be 1) is impossible.
(define (problem threads-3threads-x1)
	(:domain threads)
	(:objects
		addr_x x temp1 temp2 temp3
		out i0 i1
		c0i0 c0i1
		c1i0 c1i1 c1i2 c1i3 c1i4 c1i5 c1i6
		c2i0 c2i1 c2i2 c2i3 c2i4 c2i5 c2i6
		c3i0 c3i1 c3i2 c3i3 c3i4 c3i5 c3i6
		; will need to malloc six times
		m1 m2 m3 m4 m5 m6 m7
		- label
	)
	(:init
		; .data
		(zero addr_x)
		(ptr x addr_x)
		; .bss
		(ptr temp1 temp1)
		(ptr temp2 temp2)
		(ptr temp3 temp3)
		; heap
		(free m1) (also m1 m2) (also m2 m3) (also m3 m4) (also m4 m5)
		          (also m5 m6) (also m6 m7)

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
		(exit c1i6)
		; child program 2
		(load c2i0 c2i1 temp2 x)
		(incr c2i1 c2i2 temp2)
		(load c2i2 c2i3 x temp2)
		(load c2i3 c2i4 temp2 x)
		(incr c2i4 c2i5 temp2)
		(load c2i5 c2i6 x temp2)
		(exit c2i6)
		; child program 3
		(load c3i0 c3i1 temp3 x)
		(incr c3i1 c3i2 temp3)
		(load c3i2 c3i3 x temp3)
		(load c3i3 c3i4 temp3 x)
		(incr c3i4 c3i5 temp3)
		(load c3i5 c3i6 x temp3)
		(exit c3i6)
		; parent joins and immediately exits
		(exit i1)
	)
	(:goal (and
			(done out)
			(zero addr_x)
			(exists (?a1 - label)
				(and (succ ?a1 addr_x) (ptr x ?a1)) ; x = 1
			)
		)
	)
)
