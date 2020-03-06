//Name: Ummey Zarin Tashnim
//ID: 30034931
//Professor: Leonard Manzara
//TA: Md. Reza Rabbani

//This progarm was translated from C to asembly
fmt:	 	.string "v[%d]: %d\n"
sorted_array:	.string "\nSorted array:\n"

define(v, w21)
define(i, w22)
define(j, w23)
define(temp, w24)
fine(array_size, w26)
//ne(array_s, w27)
//		array_size = 50
//		alloc = 16  & -16
//		dealloc = -alloc
//		array_s = 25
		
		.global main
	
main: 		stp	x29, x30, [sp, 20 & -16]!
		mov	x29, sp

		mov	v, 0
		mov	i, 0
//		mov	j, i
		mov	temp, 0
  		mov	array_size, 50
//		mov	array_s, 25
		b	loop_test

inside_loop:	//str	x20, [v, i]//v[i] = rand() & 0xFF

		adrp	x0, fmt			
		add	x0, x0, :lo12:fmt	
		mov	w1, i
//		mov	w2, v[i]
		bl	printf			

		add	i, i, 1


loop_test:	cmp	i, array_size
		b.lt	inside_loop
		mov	i, 1
		b	loop2_test
	
inside_loop2:	//d	x25, x29, #0x02
		//str	temp, [x25, i]//temp = v[i]

//		mov	j, i
		b	loop2_test


enter_loop_inside_loop:
		//v[j] = v[j-1]

		sub	j, j, 1

loop2_test:	cmp	i, array_size
		b.lt	inside_loop2
 		mov	i, 0
		b	print_sorted_array

loop_inside_loop_test:
		cmp	j, 0	//j > 0 && temp < v[j-1]
		b	enter_loop_inside_loop

		//v[j] = temp
	
		add	i, i, 1
		b	loop2_test

print_sorted_array:
		adrp	x0, sorted_array			
		add	x0, x0, :lo12:sorted_array	
		bl	printf

		mov	i, 0
		b	loop3_test


inside_loop3:	adrp	x0, fmt			
		add	x0, x0, :lo12:fmt	
		mov	w1, i
	//	mov	w2, v[i]
		bl	printf

		add	i, i, 1

loop3_test:	cmp	i, array_size
		b.lt	inside_loop3

		mov 	w0, 0
		ldp 	x29, x30, [sp], 20 & 16
		ret	

