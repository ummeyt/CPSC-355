//Name: Ummey Zarin Tashnim
//ID: 30034931
//Professor: Leonard Manzara
//TA: Md. Reza Rabbani

//This progarm was translated from C to asembly
fmt:	 	.string "multiplier = 0x%08x (%d)  multiplicand = 0x%08x (%d)\n\n"
prod_mul:	.string "product = 0x%08x  multiplier = 0x%08x\n"
p_result:	.string "64-bit result = 0x%016lx (%ld)\n"

define(mul_er, w19)
define(mul_cand, w20)
define(product, w21)
define(i, w22)
define(negative, w23)
define(result, x24)	
define(temp1, x25)
define(temp2, x26)
define(true, 1)
define(false, 0)
	
		.balign 4
		.global main

main: 		stp	x29, x30, [sp, -16]!
		mov	x29, sp

		mov	mul_cand, 286331153	//
		mov	mul_er, 333		//initialization
		mov	product, 0		//
		mov	i, 0			//
	
		adrp	x0, fmt			//
		add	x0, x0, :lo12:fmt	//
		mov	w1, mul_er		//prints out the multiplier (twice)
		mov	w2, mul_er		//and the multiplicand (twice)
		mov	w3, mul_cand		//
		mov	w4, mul_cand		//
		bl	printf			//

		cmp	mul_er, 0 		//if (multiplier >= 0)
		b.ge	not_neg			//then
		mov	negative, true		//else set negative = true
		
		b	test				

not_neg:	mov	negative, false
		b	test

top:		tst	mul_er, 0x1		//if (multiplier & 0x1)
		b.eq	right_shift
		add	product, product, mul_cand

		b	right_shift

test:		cmp	i, 32			//for loop condition i > 32
		b.lt	top			
		b	after_loop		//exit loop and continue on

right_shift:	asr	mul_er, mul_er, 1	//arithmetic right shift by 1 
		tst	product, 0x1		//if (product & 0x1)
		b.eq	else
		orr	mul_er, mul_er, 0x80000000

		asr	product, product, 1	//arithmetic right shift by 1

		add	i, i, 1			//increment i
		b	test			//branch back to loop condition

else:		and	mul_er, mul_er, 0x7FFFFFFF
		asr	product, product, 1	//arithmetic right shift by 1

		add 	i, i, 1			//increment i
		b	test			//branch back to loop condition
	
after_loop:	cmp	negative, true		//if negative != true
		b.ne	next
		sub	product, product, mul_cand

		b	next
	
next:		adrp	x0, prod_mul		//
		add	x0, x0, :lo12:prod_mul	//prints out the product
		mov	w1, product		//and multiplier
		mov	w2, mul_er		//
		bl	printf			//

		sxtw	temp1, product		//sign extend word on product & stored in temp1
		lsl	temp1, temp1, 32	//logical shift left by 32
		sxtw	temp2, mul_er		//sign extend word on muliplier & stored in temp2
		and	temp2, temp2, 0xFFFFFFFF //multiplier & 0xFFFFFFFF
		add	result, temp1, temp2	//result = temp1 + temp2

		adrp	x0, p_result		//
		add	x0, x0, :lo12:p_result	//
		mov	x1, result		//prints result out twice 
		mov	x2, result		//
		bl	printf			//

done:		mov 	w0, 0
		ldp 	x29, x30,[sp], 16
		ret	

	



