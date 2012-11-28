; This problem demonstrates an interesting property I discovered about the
; "interleaving x++ threads" programs, when writing a 15-213 exam question when
; I TAed it long ago. The idea is when the thread bodies look like:
;     for i = 0 to N {
;         temp <- x;
;         temp++;
;         x <- temp;
;     }
; Then possible values for x at the end of the program range from 2 to 2N, yet
; not 1 (as long as N isn't 1).
;
; This variant of the problem (with the goal being for x to be 2) is possible.
(define (problem threads-loop-x2)
	(:domain threads)
	(:objects
		addr_x x temp1 temp2
		out i0 i1
		c1i0 c1i1 c1i2 c1i3 c1i4 c1i5 c1i6
		c2i0 c2i1 c2i2 c2i3 c2i4 c2i5 c2i6
		; will need to malloc four times
		m1 m2 m3 m4 m5
		- label
	)
	(:init
		; .data
		(zero addr_x)
		(ptr x addr_x)
		; .bss
		(ptr temp1 temp1)
		(ptr temp2 temp2)
		; heap
		(free m1) (also m1 m2) (also m2 m3) (also m3 m4) (also m4 m5)

		; .text
		(eval i0 out)
		(fork i0 i1 c1i0 c2i0)
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
		; parent joins and immediately exits
		(exit i1)
	)
	(:goal (and
			(done out)
			(zero addr_x) (succ m1 addr_x) (succ m2 m1) (ptr x m2) ; x = 2
			; (exists (?a0 ?a1 ?a2 - label)
			; 	(and (zero ?a0) (succ ?a1 ?a0) (succ ?a2 ?a1) (ptr x ?a2)) ; x = 2
			; )
		)
	)
)
