(define (problem threads1)
	(:domain threads)
	(:objects
		addr_x x temp1 temp2
		out i0 i1
		c1i0 c1i1 c1i2 c1i3
		c2i0 c2i1 c2i2 c2i3
		; will need to malloc twice
		m1 m2 m3
		- label
	)
	(:init
		; .data (temp1 and temp2 are, of course, in .bss)
		(zero addr_x)
		(ptr x addr_x)
		; heap
		(free m1) (also m1 m2) (also m2 m3)

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
			(exists (?a0 ?a1 - label)
				(and (zero ?a0) (succ ?a1 ?a0) (ptr x ?a1)) ; x = 1
			)
		)
	)
)
