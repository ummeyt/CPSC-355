//Name: Ummey Zarin Tashnim
//ID: 30034931
//Professor: Leonard Manzara
//TA: Md. Reza Rabbani

//This progarm was translated from C to asembly
fmt:	 	.string "v[%d]: %d\n"
sorted_array:	.string "\nSorted array:\n"





fp	       .req x29
lr	       .req x30

		size = 50
		v_size = size * 4			//50 * 4 = 200
		i_size = 4				//4 bytes
		j_size = 4				//4 bytes
		temp_size = 4				//4 bytes
		all_sizes = v_size + i_size + j_size + temp_size 
		
		vOffset = 16				//vOffset = 16 bytes
		iOffset = 16 + v_size			//iOffset = 16 + 4 = 20 bytes
		jOffset = 16 + v_size + i_size		//jOffset = 16 + 16 + 20 = 52 bytes
	        tempOffset = 16 + v_size + i_size + j_size//tempOffset = 16 + 16 + 20 + 52 = 104 bytes
	
		alloc = -(16 + all_sizes) & -16		//calculate of how much memory to allocate 
		dealloc = -alloc			//deallocate calculation
	
		.balign	4
		.global main
	
main: 		stp	fp, lr, [sp, alloc]!		//allocate memory
		mov	fp, sp
		add	x28, fp, vOffset 		//16 bytes for frame record - base address of the array v

		mov	w19, 0				//initialize w19
		str	w19, [fp, iOffset]		//store w19 offset
		b	init_loop_test			//branch to init_loop_test

init_loop:	ldr	w20, [fp, vOffset]		//load w20
		bl	rand				//branch to random fuction
		and	w20, w0, 0xFF			//rand() & 0xFF	
		str	w20, [x28, w19, SXTW 2]		//v[i] = rand() & 0xFF
	
		adrp	x0, fmt				//
		add	w0, w0, :lo12:fmt		//
		mov	w1, w19				//w1 = w19
		mov	w2, w20				//w2 = v[i]
		bl	printf				//print the unsorted arrays

		ldr	w19, [fp, iOffset]		//load register w19
		add	w19, w19, 1			//increment w19
		str	w19, [fp, iOffset]		//store register w19

init_loop_test:	ldr	w19, [fp, iOffset]
		cmp	w19, size			//while w19 < size
		b.lt	init_loop			//go into the 1st loop
	
		mov	w19, 1				//w19 = 1
		b	loop_i_test				

loop_i:		ldr	w22, [x28, w19, SXTW 2] 	//temp = v[i]
		mov	w21, w19		 	//w21 = w19
		b	loop_j_test			

next:		str	w22, [x28, w21, SXTW 2]	//v[j] = temp
		add	w19, w19, 1			//increment w19

loop_i_test:	cmp	w19, size			//while i < size
		b.lt	loop_i				//goto loop i
		b	print_sorted_array		//else print the sorted array

loop_j:		ldr	w24, [x28, w21, SXTW 2]		// load v[j] to w24 	198	103
		str	w25, [x28, w21, SXTW 2]		// write w25 to v[j]
		str	w24, [x28, w23, SXTW 2]		// write w24 to v[j-1]
		sub	w21, w21, 1			// j--
loop_j_test:	
		cmp	w21, 0				// if j>0, repeat
		b.le	next				// else exit to for(i)
		sub	w23, w21, 1			// set w23 to j-1	
		ldr	w25, [x28, w23, SXTW 2]		// set w25 to v[j-1]	105	198
and_cond:	cmp	w22, w25			// temp < v[j-1]
		b.lt	loop_j				// goto loop j for sorting
		b	next				// else exit to for(i)
	
print_sorted_array:
		adrp	x0, sorted_array		//
		add	x0, x0, :lo12:sorted_array	//print "Sorted array: "
		bl	printf				//

		mov	w19, 0				//w19 = 0
	
final_loop:	cmp	w19, size			//while w19 < size
		b.ge	done				//branch to done
		ldr	w24, [x28, w19, SXTW 2]		//w20 = v[i]

		adrp	x0, fmt				//
		add	w0, w0, :lo12:fmt		//
		mov	w1, w19				//print the sorted array 
		mov	w2, w24				//
		bl	printf				//

		add	w19, w19, 1			//increment w19

		b	final_loop 			//branch back to final_loop
done:	
		mov 	w0, 0
		ldp 	fp, lr, [sp], dealloc		//deallocate memory
		ret	
