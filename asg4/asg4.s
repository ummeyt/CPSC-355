//Name: Ummey Zarin Tashnim
//ID: 30034931
//Professor: Leonard Manzara
//TA: Md. Reza Rabbani

//This progarm was translated from C to asembly
pyra:	 	.string "Pyramid %s origin = (%d, %d)\n"
base:		.string "\tBase width = %d Base length = %d\n"
height:		.string "\tHeight = %d\n"
volume:		.string "\tVolume = %d\n"
ini_pyra:	.string "Initial pyramid values:\n"
first:		.string "first"
second:		.string "second"
changed_pyra:	.string "\nChanged pyramid values:\n"

//Equate for point struct
	point_x = 0			
	point_y = 4
	struct_point_size = 8

//Equate for dimension struct
	dim_width = 0
	dim_length = 4
	struct_dim_size = 8

//Equate for pyramid struct
	pyra_origin = 0					//0 
	pyra_base = pyra_origin + struct_point_size	//0 + 8 = 8
	pyra_height = pyra_base + struct_dim_size	//8 + 8 = 16
	pyra_volume = pyra_height + 4			//16 + 4 = 20
	struct_pyramid_size = pyra_volume + 4		//20 + 4 = 24

	p_size = struct_pyramid_size			
	pyra_s = 16					//pyramid offset	

	.balign 4
	.global main

newPyramid:
	stp	x29, x30, [sp, -16]!
	mov	x29, sp

//initialization	
	str	wzr, [x29, pyra_s + pyra_origin + point_x]	//p.origin.x = 0
	str	wzr, [x29, pyra_s + pyra_origin + point_y]	//p.origin.y = 0
	mov	w9, 2						//w9 = 2
	str	w9, [x29, pyra_s + pyra_base + dim_width]	//w9 = p.base.width
	mov	w10, 2						//w10 = 2
	str	w10, [x29, pyra_s + pyra_base + dim_length]	//w10 = p.base.length
	mov	w11, 3						//w11 = 3
	str	w11, [x29, pyra_s + pyra_height]		//w11 = p.height
	
	mul	w12, w9, w10					//w12 = p.base.width * p.base.length
	mul	w12, w12, w11					//w12 = w12 * p.height
	mov	w13, 3 						//w13 = 3
	sdiv	w12, w12, w13		    			//w12 = w12 / w13
	str	w12, [x29, pyra_s + pyra_volume]		//p.volume = (p.base.width * p.base.length * p.height) / 3

//connecting/linking it to the stack
	ldr 	w9, [x29, pyra_s + pyra_origin + point_x]
	str 	w9, [x8, pyra_s + pyra_origin + point_x]
	
	ldr 	w9, [x29, pyra_s + pyra_origin + point_y]
	str 	w9, [x8, pyra_s + pyra_origin + point_y]

	ldr 	w9, [x29, pyra_s + pyra_base + dim_width]
	str 	w9, [x8, pyra_s + pyra_base + dim_width]

	ldr 	w9, [x29, pyra_s + pyra_base + dim_length]
	str 	w9, [x8, pyra_s + pyra_base + dim_length]

	ldr 	w9, [x29, pyra_s + pyra_height]
	str 	w9, [x8, pyra_s + pyra_height]

	ldr	w9, [x29, pyra_s + pyra_volume]
	str	w9, [x8, pyra_s + pyra_volume]
	
	ldp	x29, x30, [sp], 16
	ret


	
	

	first_s = 16						//first pyramid offset				
	second_s = first_s + p_size	 			//16 + 24 = 40 - second pyramid offset

//Memory Allocation	
	alloc = -(16 + (p_size * 2)) & -16
	dealloc = -alloc

main:	stp	x29, x30, [sp, alloc]!
	mov	x29, sp

	add	x8, x29, first_s				//add first offset into stack
	bl	newPyramid					//call newPyramid

	add	x8, x29, second_s				//add second offset into stack
	bl	newPyramid					//call newPyramid

	adrp	x0, ini_pyra
	add	x0, x0, :lo12:ini_pyra				
	bl	printf						//print initial pyramid

	adrp	x0, first
	add	x0, x0, :lo12:first
	add	x1, x29, first_s				//char *name - pass first argument
	bl	printPyramid					//call printPyramid

	adrp	x0, second
	add	x0, x0, :lo12:second
	add	x1, x29, second_s				//char *name - pass first argument
	bl	printPyramid					//call printPyramid

	add 	x0, x29, first_s
	add 	x1, x29, second_s
	bl	equalSize					//call equalSIze

	cmp	w0, 0					//if (!equalSize(&first, &second))
	b.ne	printNext					//then go to printNext

	add 	x0, x29, first_s
	mov 	x1, -5						//x1 = pass deltaX argument = set to -5
	mov 	x2, 7						//x2 = pass deltaY argument = set to 7
	bl	move						//call move

	add 	x0, x29, second_s
	mov	x1, 3						//x1 = pass factor argument = set to 3
	bl	scale						//call scale

printNext:	
	adrp	x0, changed_pyra
	add	x0, x0, :lo12:changed_pyra
	bl	printf						//print changed pyramid

	adrp	x0, first
	add	x0, x0, :lo12:first
	add	x1, x29, first_s				//char *name - pass first name argument
	bl	printPyramid					//call printPyramid

	adrp	x0, second
	add	x0, x0, :lo12:second
	add	x1, x29, second_s				//char *name - pass second name argument
	bl	printPyramid					//call printPyramid
	
	ldp	x29, x30, [sp], dealloc
	ret



move:	stp	x29, x30, [sp, -16]!
	mov	x29, sp

	ldr	w9, [x0, pyra_s + pyra_origin + point_x]			//p->origin.x 
	add	w9, w9, w1					//p->origin.x += deltaX
	str	w9, [x0, pyra_s + pyra_origin + point_x]
	ldr	w9, [x0, pyra_s + pyra_origin + point_y]	//p->origin.y
	add	w9, w9, w2					//p->origin.y += deltaY
	str	w9, [x0, pyra_s + pyra_origin + point_y]

	ldp	x29, x30, [sp], 16
	ret	



scale:	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	
	ldr	w19, [x0, pyra_s + pyra_base + dim_width]	//p->base.width
	mul	w19, w19, w1					//p->base.width *= factor
	str	w19, [x0, pyra_s + pyra_base + dim_width]	
	
	ldr	w20, [x0, pyra_s + pyra_base + dim_length]	//p->base.length
	mul	w20, w20, w1					//p->base.length *= factor
	str	w20, [x0, pyra_s + pyra_base + dim_length]	

	ldr	w21, [x0, pyra_s + pyra_height]			//p->height
	mul	w21, w21, w1					//p->height *= factor
	str	w21, [x0, pyra_s + pyra_height]			

	ldr	w23, [x0, pyra_s + pyra_volume]			//p->base.volume
	mul	w23, w19, w20					//w23 = p->base.width * p->base.length
	mul	w23, w23, w21					//w23 = w23 * p->height
	mov	w24, 3 						//w24 = 3
	sdiv	w23, w23, w24		    			//w23 = (p->base.width * p->base.length * p->height) / 3
	str	w23, [x0, pyra_s + pyra_volume]			

	ldp	x29, x30, [sp], 16
	ret	

	

printPyramid:
	stp	x29, x30, [sp, -16]!
	mov	x29, sp

	ldr	w19, [x1, pyra_s + pyra_origin + point_x]	//p->origin.x
	ldr	w20, [x1, pyra_s + pyra_origin + point_y]	//p->origin.y
	ldr	w21, [x1, pyra_s + pyra_base + dim_width]	//p->base.width
	ldr	w22, [x1, pyra_s + pyra_base + dim_length]	//p->base.length
	ldr	w23, [x1, pyra_s + pyra_height]			//p->height
	ldr	w24, [x1, pyra_s + pyra_volume]			//p->volume

	mov 	x1, x0 						//name of pyramid
	adrp	x0, pyra
	add	x0, x0, :lo12:pyra		
	mov	w2, w19						//print p->origin.x
	mov	w3, w20						//print p->origin.y
	bl	printf				

	adrp	x0, base
	add	x0, x0, :lo12:base			
	mov	w1, w21						//print p->base.width
	mov	w2, w22						//print p->base.length
	bl	printf				

	adrp	x0, height
	add	x0, x0, :lo12:height		
	mov	w1, w23						//print p->height
	bl	printf				

	adrp	x0, volume
	add	x0, x0, :lo12:volume		
	mov	w1, w24						//print p->volume
	bl	printf				

	ldp	x29, x30, [sp], 16
	ret	



	result_s = 16
equalSize:
	stp	x29, x30, [sp, -(16 + result_s)]!
	mov	x29, sp

	mov	w9, 0					//return = 0
	str	w9, [x29, result_s]

	ldr	w9, [x0, first_s + pyra_base + dim_width]	//load p1->base.width
	ldr	w10, [x1, second_s + pyra_base + dim_width]	//load p2->base.width 

	cmp	w9, w10						//if w19 != w20
	b.ne	retFalse					//go to retFalse

	ldr	w9, [x0, pyra_s + pyra_base + dim_length]	//p1->base.length
	ldr	w10, [x1, pyra_s + pyra_base + dim_length]	//p2->base.length

	cmp	w9, w10						//if w21 != w22
	b.ne	retFalse					//go to retFalse

	ldr	w9, [x0, pyra_s + pyra_height]			//load p1->height	
	ldr	w10, [x1, pyra_s + pyra_height]			//load p2->height


	cmp	w9, w10						//if w23 != w24
	b.ne	retFalse					//go to retFalse
	mov	w9, 1					//else return = 1
	str	w9, [x29, result_s]
	
retFalse:
	ldr	w0, [x29, result_s]
	ldp	x29, x30, [sp], (16 + result_s)
	ret


