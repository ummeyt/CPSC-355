//Name: Ummey Zarin Tashnim
//ID: 30034931
//Professor: Leonard Manzara
//TA: Md. Reza Rabbani

//This progarm was translated from C to asembly
fmt:	 	.string "v[%d]: %d\n"
sorted_array:	.string "\nSorted array:\n"
debug:	 	.string "debug: i:%d size:%d\n"
define(i_r, w19)
define(v_r, w20)
define(j_r, w21)
define(temp_r, w22)

fp	.req x29
lr	.req x30

		size = 50
		v_size = size * 4
		i_size = 4
		j_size = 4
		temp_size = 4
		all_sizes = v_size + i_size + j_size + temp_size 

		vOffset = 16
		iOffset = 16 + v_size
		jOffset = 16 + v_size + i_size
		tempOffset = 16 + v_size + i_size + j_size
	
		alloc = -(16 + all_sizes) & -16 
		dealloc = -alloc
	
		.balign	4
		.global main
	
main: 		stp	fp, lr, [sp, alloc]!
		mov	fp, sp

		add	x28, fp, vOffset 

		mov	i_r, 0				//initialize i
		str	i_r, [fp, iOffset]		//set i offset
		bl	loop_test			//branch to loop_test

inside_loop:	bl	rand				//branch to random fuction
		and	v_r, w0, 0xFF			
		str	v_r, [x28, i_r, SXTW 2]		//v[i] = rand() & 0xFF
	
		adrp	x0, fmt				//
		add	w0, w0, :lo12:fmt		//
		mov	w1, i_r				//w1 = i
		mov	w2, v_r				//w2 = v[i]
		bl	printf				//print unsorted arrays

		ldr	i_r, [fp, iOffset]
		add	i_r, i_r, 1
		str	i_r, [fp, iOffset]
		

loop_test:	ldr	i_r, [fp, iOffset]
		cmp	i_r, size
		b.lt	inside_loop
//
		mov	i_r, 1
		b	loop2_test

inside_loop2:	str	v_r, [x28, i_r, SXTW 2] 	//temp = v[i]
		mov	temp_r, v_r

		mov	j_r, i_r

		b	loop_inside_loop_test  		//where does j = i go???
	
enter_loop_inside_loop:
		sub	w25, j_r, 1			//j-1
		str	w25, [x28, w25, SXTW 2]		//v[j-1]
		str	v_r, [x28, j_r, SXTW 2]		//v[j]
		mov	v_r, w25			//v[j] = v[j-1]
	
		ldr	j_r, [fp, jOffset]
		sub	j_r, j_r, 1
		str	j_r, [fp, jOffset]

		b	loop_inside_loop_test


loop_inside_loop_test:
	//	ldr	j_r, [fp, jOffset]
		cmp	j_r, 0				//j > 0 
		b.gt	and_cond

		b	next

and_cond:	sub	w25, j_r, 1			//j-1
		str	w25, [x28, w25, SXTW 2]		//v[j-1]
		str	v_r, [x28, j_r, SXTW 2]		//v[j]
		mov	v_r, w25			//v[j] = v[j-1]

//		ldr	j_r, [fp, jOffset]
		cmp	temp_r, w26			//&& temp < v[j-1] 

		b.lt	enter_loop_inside_loop

next:		str	v_r, [x28, j_r, SXTW 2]		//v[j]
		mov	v_r, temp_r			//v[j] = temp

		ldr	i_r, [fp, iOffset]
		add	i_r, i_r, 1
		str	i_r, [fp, iOffset]
//		b	loop2_test
loop2_test://	ldr	i_r, [fp, iOffset]	
		cmp	i_r, size
		b.lt	inside_loop2
		mov	i_r, 0
 		b	print_sorted_array


print_sorted_array:
		adrp	x0, sorted_array			
		add	x0, x0, :lo12:sorted_array	
		bl	printf

		mov	i_r, 0
		
		b	loop3

loop3:		cmp	i_r, size
		b.ge	done

		str	v_r, [x28, i_r, SXTW 2]		//v[i]

		adrp	x0, fmt			
		add	w0, w0, :lo12:fmt	
		mov	w1, i_r
		mov	w2, v_r
		bl	printf			

	/*	adrp	x0, debug			
		add	w0, w0, :lo12:debug	
		mov	w1, i_r
		mov	w2, size
		bl	printf			
*/
		ldr	i_r, [fp, iOffset]
		add	i_r, i_r, 1			//increment i
		str	i_r, [fp, iOffset]

		b	loop3
done:	
		mov 	w0, 0
		ldp 	fp, lr, [sp], dealloc
		ret	

