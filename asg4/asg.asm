
	// Strings
first:	 .string "first"
second:	 .string "second"
initialString:	 .string "Initial pyramid values:\n"
finalString:	 .string "\nChanged pyramid values:\n"
string1:	 .string "Pyramid %s origin = (%d, %d)\n"
string2:	 .string "\tBase width = %d  Base length = %d\n"
string3:	 .string "\tHeight = %d\n"
string4:	 .string "\tVolume = %d\n\n"

	// Assembler registers
	FP .req x29
	LR .req x30

	// Assembler equates
	FALSE = 1
	TRUE = 0

	point_x = 0
	point_y = 4

	dimension_width = 0
	dimension_length = 4

	pyramid_origin = 0
	pyramid_base = 8
	pyramid_height = 16
	pyramid_volume = 20
	pyramid_size = 24

	result_s = 16
	first_s = 40
	second_s = 64

	alloc = -(16 + (pyramid_size * 3)) & -16   // Sets alloc as 96
	dealloc = -alloc
	.balign 4			// Align machine instructions
	.global main			// Program starts at main
main:
	stp FP, LR, [sp, alloc]!	// Store FP and LR into stack
	mov FP, sp			// Set FP as stack pointer

	// first = newPyramid()
	add x8, FP, result_s		// Pass FP+16 as result address
	bl newPyramid			// Call newPyramid()
	ldp x0, x1, [FP, result_s]	// Load first 16 bytes from result
	stp x0, x1, [FP, first_s]	// Store first 16 bytes into local variable first
	ldr x0, [FP, result_s + 16]	// Load last 8 bytes from result
	str x0, [FP, first_s + 16]	// Store last 8 bytes into local variable first

	// second = newPyramid()
	add x8, FP, result_s		// Pass FP+16 as result address
	bl newPyramid			// Call newPyramid()
	ldp x0, x1, [FP, result_s]	// Load first 16 bytes from result
	stp x0, x1, [FP, second_s]	// Store first 16 bytes into local variable second
	ldr x0, [FP, result_s + 16]	// Load last 8 bytes from result
	str x0, [FP, second_s + 16]	// Store last 8 bytes into local variable second

	// printf("Initial pyramid values:\n")
	adrp x0, initialString		// Print Initial String
	add x0, x0, :lo12:initialString // Print Initial String
	bl printf			// Branch link to printf

	// printPyramid("first", &first)
	adrp x0, first			// Get the string "first" into x0
	add x0, x0, :lo12:first		// Get the string "first" into x0
	add x1, FP, first_s		// Set x1 as memory address of pyramid first
	bl printPyramid			// printPyramid("first", &first);

	// printPyramid("second", &second)
	adrp x0, second			// Get the string "second" into x0
	add x0, x0, :lo12:second	// Get the string "second" into x0
	add x1, FP, second_s		// Set x1 as memory address of pyramid second
	bl printPyramid			// printPyramid("second", &second)

debugBreak:
	// if (equalSize(&first, &second))
	add x0, FP, first_s		// Pass &first as first argument
	add x1, FP, second_s		// Pass &second as second argument
	bl equalSize			// equalSize(&first, &second)

	cmp w0, TRUE			// Compare equalSize(&first, &second) to TRUE
	b.ne printChangedValues		// Branch away if FALSE

	// move(&first, -5, 7)
	add x0, FP, first_s		// Pass &first as first argument
	mov w1, -5			// Pass -5 as second argument
	mov w2, 7			// Pass 7 as third argument
	bl move				// move(&first, -5, 7)

	// scale(&second, 3)
	add x0, FP, second_s		// Pass &second as first argument
	mov w1, 3			// Pass 3 as second argument
	bl scale			// scale(&second, 3)

	// Continuation of main()
printChangedValues:
	// printf("\nChanged pyramid values:\n")
	adrp x0, finalString            // Print final string
	add x0, x0, :lo12:finalString   // Print final string
	bl printf                       // Branch link to printf

	// printPyramid("first", &first)
	adrp x0, first                  // Get the string "first" into x0
	add x0, x0, :lo12:first         // Get the string "first" into x0
	add x1, FP, first_s             // Set x1 as memory address of pyramid first
	bl printPyramid                 // printPyramid("first", &first);

	// printPyramid("second", &second)
	adrp x0, second                 // Get the string "second" into x0
	add x0, x0, :lo12:second        // Get the string "second" into x0
	add x1, FP, second_s            // Set x1 as memory address of pyramid second
	bl printPyramid                 // printPyramid("second", &second)

	ldp FP, LR, [sp], dealloc	// Restore state from stack
	ret                             // return to OS


	alloc = -(16 + 24) & -16
	dealloc = - alloc
	p .req x20
newPyramid:
	stp FP, LR, [sp, alloc]!                        // Store FP and LR to stack
	mov FP, sp                                      // Set FP as stack pointer

	add p, FP, 16                                   // Set memory address of p
	str xzr, [p, pyramid_origin + point_x]          // p.origin.x = 0
	str xzr, [p, pyramid_origin + point_y]          // p.origin.y = 0

	mov w0, 2                                       // Move 2 to register
	str w0, [p, pyramid_base + dimension_width]     // p.base.width = 2
	str w0, [p, pyramid_base + dimension_length]    // p.base.length = 2

	mov w0, 3                                       // Move 3 to register
	str w0, [p, pyramid_height]                     // p.height = 3

	ldr w0, [p, pyramid_base + dimension_width]     // w0 = p.base.width
	ldr w1, [p, pyramid_base + dimension_length]    // w1 = p.base.length
	ldr w2, [p, pyramid_height]                     // w2 = p.height

	mul w0, w0, w1                  // w0 = p.base.width * p.base.length
	mul w0, w0, w2                  // w0 = (p.base.width * p.base.length * p.height)
	mov w1, 3                       // Move 3 to register
	sdiv w0, w0, w1                 // w0 = (p.base.width * p.base.length * p.height) / 3
	str w0, [p, pyramid_volume]     // Store w0 in stack

	ldp x0, x1, [p]                 // Load higher 16 bytes from p
	stp x0, x1, [x8]                // Store higher 16 bytes of p into calling result
	ldr x0, [p, 16]                 // Load lower 8 bytes from p
	str x0, [x8, 16]                // Store lower 8 bytes of p into calling result

	ldp FP, LR, [sp], dealloc       // Load FP and LR from stack
	ret                             // Return to main


	// x0 is address to pyramid, w1 is deltaX integer and w2 is deltaY integer
move:
	stp FP, LR, [sp, -16]!                          // Store FP and LR to stack
	mov FP, sp                                      // Set FP as stack pointer

	// p->origin.x += deltaX
	ldr w9, [x0, pyramid_origin + point_x]          // w9 = p->origin.x
	add w9, w9, w1                                  // w9 = p->origin.x + deltaX
	str w9, [x0, pyramid_origin + point_x]          // Update p->origin.x value in memory

	//p->origin.y += deltaY;
	ldr w9, [x0, pyramid_origin + point_y]          // w9 = p->origin.y
	add w9, w9, w2                                  // w9 = p->origin.x + deltaX
	str w9, [x0, pyramid_origin + point_y]          // Update p->origin.y value in memory

	ldp FP, LR, [sp], 16				// Restore state from stack
	ret                                             // Return to main()
	

	// x0 is memory address to pyramid struct and w1 is factor integer
scale:
	stp FP, LR, [sp, -16]!                          // Store FP and LR to stack
	mov FP, sp                                      // Set FP as stack pointer

	// p->base.width *= factor;
	ldr w9, [x0, pyramid_base + dimension_width]    // w9 = p->base.width
	mul w9, w9, w1                                  // w9 = p->base.width * factor
	str w9, [x0, pyramid_base + dimension_width]    // Update p->base.width value in memory

	// p->base.length *= factor
	ldr w9, [x0, pyramid_base + dimension_length]   // w9 = p->base.length
	mul w9, w9, w1                                  // w9 = p->base.length * factor
	str w9, [x0, pyramid_base + dimension_length]   // Update p->base.length value in memory

	// p->height *= factor;
	ldr w9, [x0, pyramid_height]                    // w9 = p->height
	mul w9, w9, w1                                  // w9 = p->height * factor
	str w9, [x0, pyramid_height]                    // Update p->height value in memory

	// p->volume = (p->base.width * p->base.length * p->height) / 3;
	ldr w9, [p, pyramid_base + dimension_width]     // w10 = p.base.width
	ldr w10, [p, pyramid_base + dimension_length]   // w10 = p.base.length
	ldr w11, [p, pyramid_height]                    // w11 = p.height

	mul w9, w9, w10	                 		// w9 = p.base.width * p.base.length
	mul w9, w9, w11                  		// w9 = (p.base.width * p.base.length * p.height)
	mov w10, 3                       		// Move 3 to register
	sdiv w9, w9, w10                 		// w9 = (p.base.width * p.base.length * p.height) / 3
	str w9, [x0, pyramid_volume]     		// Store w0 in stack

	ldp FP, LR, [sp], 16                            // Restore state from stack
	ret                                             // Return to main()

	name .req x19
printPyramid:
	stp FP, LR, [sp, -16]!				// Store FP and LR into stack
	mov FP, sp					// Move stack pointer to FP

	mov name, x0					// Set name as argument string
	mov p, x1					// Set p as address to p in memory

	// Print 1: printf("Pyramid %s origin = (%d, %d)\n", name, p->origin.x, p->origin.y)
	mov x1, name					// w1 = name
	ldr w2, [p, pyramid_origin + point_x]		// w2 = p->origin.x
	ldr w3, [p, pyramid_origin + point_y]		// w3 = p->origin.y

	adrp x0, string1				// Pass string to first argument
	add x0, x0, :lo12:string1			// Pass string to first argument
	bl printf					// Branch link to printf()

	// Print 2:  printf("\tBase width = %d  Base length = %d\n", p->base.width, p->base.length)
	ldr w1, [p, pyramid_base + dimension_width]	// w1 = p->base.width
	ldr w2, [p, pyramid_base + dimension_length]	// w2 = p->base.length

	adrp x0, string2				// Pass string to first argument
	add x0, x0, :lo12:string2			// Pass string to first argument
	bl printf					// Branch link to printf()

	// Print 3: printf("\tHeight = %d\n", p->height)
	ldr w1, [p, pyramid_height]			// w1 = p->height
	adrp x0, string3				// Pass string to first argument
	add x0, x0, :lo12:string3			// Pass string to first argument
	bl printf					// Branch link to printf()

	// Print 4: printf("\tVolume = %d\n\n", p->volume)
	ldr w1, [p, pyramid_volume]			// w1 = p1->volume
	adrp x0, string4				// Pass string to first argument
	add x0, x0, :lo12:string4			// Pass string to first argument
	bl printf					// Branch link to printf()

	ldp FP, LR, [sp], 16				// Restore state from stack
	ret						// Return to main()


	alloc = -(16 + 4) & -16					// Sets alloc to -32
	dealloc = -alloc
	result_s = 16

	// x0 is address to pyramid 1 and x1 is address to pyramid 2
equalSize:
	stp FP, LR, [sp, alloc]!			// Store FP and LR into stack
	mov FP, sp					// Move stack pointer to frame pointer

	// if (p1->base.width == p2->base.width)
	ldr w9, [x0, pyramid_base + dimension_width]	// w9 =  p1->base.width
	ldr w10, [x1, pyramid_base + dimension_width]	// w10 = p2->base.width
	cmp w9, w10					// w9 ? w10
	b.ne equalSizeReturn				// Branch to return if w9 != w10

	// if (p1->base.length == p2->base.length)
	ldr w9, [x0, pyramid_base + dimension_length]	// w9 = p1->base.length
	ldr w10, [x1, pyramid_base + dimension_length]	// w10 = p2->base.length
	cmp w9, w10					// w9 ? w10
	b.ne equalSizeReturn				// Branch to return if w9 != w10

	// if (p1->height == p2->height)
	ldr w9, [x0, pyramid_height]			// w9 = p1->height
	ldr w10, [x1, pyramid_height]			// w10 = p2->height
	cmp w9, w10					// w9 ? w10
	b.ne equalSizeReturn				// Branch to return if w9 != w10

	mov w0, TRUE					// result = TRUE
	str w0, [FP, result_s]				// Store result into stack

equalSizeReturn:
	ldr w0, [FP, result_s]				// Load result from stack
	ldp FP, LR, [sp], dealloc			// Restore state from stack
	ret						// Return result to main()
