//Name: Ummey Zarin Tashnim
//ID: 30034931
//Professor: Leonard Manzara
//TA: Md. Reza Rabbani

//This progarm was translated from C to asembly
fmt:	 	.string "v[%d]: %d\n"
sorted_array:	.string "\nSorted array:\n"
define(i_r, w19)
define(v_r, w20)
define(j_r, w21)
define(temp_r, w22)

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
		add	x28, fp, vOffset 		//16 bytes for frame record - base address of the array vo

		mov	i_r, 0				//initialize i_r
		str	i_r, [fp, iOffset]		//store i_r offset
		b	init_loop_test			//branch to init_loop_test

init_loop:	ldr	v_r, [fp, vOffset]		//load v_r
		bl	rand				//branch to random fuction
		and	v_r, w0, 0xFF			//rand() & 0xFF	
		str	v_r, [x28, i_r, SXTW 2]		//v[i] = rand() & 0xFF
	
		adrp	x0, fmt				//
		add	w0, w0, :lo12:fmt		//
		mov	w1, i_r				//w1 = i_r
		mov	w2, v_r				//w2 = v[i]
		bl	printf				//print the unsorted arrays

		ldr	i_r, [fp, iOffset]		//load register i_r
		add	i_r, i_r, 1			//increment i_r
		str	i_r, [fp, iOffset]		//store register i_r

init_loop_test:	ldr	i_r, [fp, iOffset]
		cmp	i_r, size			//while i_r < size
		b.lt	init_loop			//go into the 1st loop
	
		mov	i_r, 1				//i_r = 1
		b	loop_i_test				

loop_i:		ldr	temp_r, [x28, i_r, SXTW 2] 	//temp = v[i]
		mov	j_r, i_r		 	//j_r = i_r
		b	loop_j_test			

next:		str	temp_r, [x28, j_r, SXTW 2]	//v[j] = temp
		add	i_r, i_r, 1			//increment i_r

loop_i_test:	cmp	i_r, size			//while i < size
		b.lt	loop_i				//goto loop i
		b	print_sorted_array		//else print the sorted array

loop_j:		ldr	w24, [x28, w21, SXTW 2]		//load v[j] to w24
		str	w25, [x28, w21, SXTW 2]		//write w25 to v[j]
		str	w24, [x28, w23, SXTW 2]		//write w24 to v[j-1]
		sub	j_r, j_r, 1			//decrement j_r

loop_j_test:	cmp	j_r, 0				//while j > 0
		b.le	next				//go to next
		sub	w23, j_r, 1			//set w23 to j-1	
		ldr	w25, [x28, w23, SXTW 2]		//set w25 to v[j-1]
	
and_cond:	cmp	temp_r, w25			// temp < v[j-1]
		b.lt	loop_j				// goto loop j for sorting
		b	next				// else exit to for(i)
	
print_sorted_array:
		adrp	x0, sorted_array		//
		add	x0, x0, :lo12:sorted_array	//print "Sorted array: "
		bl	printf				//

		mov	i_r, 0				//i_r = 0
	
final_loop:	cmp	i_r, size			//while i_r >= size
		b.ge	done				//branch to done
		ldr	w24, [x28, i_r, SXTW 2]		//v_r = v[i]

		adrp	x0, fmt				//
		add	w0, w0, :lo12:fmt		//
		mov	w1, i_r				//print the sorted array 
		mov	w2, w24				//
		bl	printf				//

		add	i_r, i_r, 1			//increment i_r

		b	final_loop 			//branch back to final_loop
done:	
		mov 	w0, 0
		ldp 	fp, lr, [sp], dealloc		//deallocate memory
		ret	
