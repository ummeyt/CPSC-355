	.arch armv8-a
	.file	"asg.c"
	.section	.rodata
	.align	3
.LC0:
	.string	"v[%d]: %d\n"
	.align	3
.LC1:
	.string	"\nSorted array:"
	.text
	.align	2
	.global	main
	.type	main, %function
main:
.LFB0:
	.cfi_startproc
	stp	x29, x30, [sp, -240]!
	.cfi_def_cfa_offset 240
	.cfi_offset 29, -240
	.cfi_offset 30, -232
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	str	wzr, [x29, 236]
	b	.L2
.L3:
	bl	rand
	and	w2, w0, 255
	ldrsw	x0, [x29, 236]
	lsl	x0, x0, 2
	add	x1, x29, 24
	str	w2, [x1, x0]
	ldrsw	x0, [x29, 236]
	lsl	x0, x0, 2
	add	x1, x29, 24
	ldr	w1, [x1, x0]
	adrp	x0, .LC0
	add	x0, x0, :lo12:.LC0
	mov	w2, w1
	ldr	w1, [x29, 236]
	bl	printf
	ldr	w0, [x29, 236]
	add	w0, w0, 1
	str	w0, [x29, 236]
.L2:
	ldr	w0, [x29, 236]
	cmp	w0, 49
	ble	.L3
	mov	w0, 1
	str	w0, [x29, 236]
	b	.L4
.L8:
	ldrsw	x0, [x29, 236]
	lsl	x0, x0, 2
	add	x1, x29, 24
	ldr	w0, [x1, x0]
	str	w0, [x29, 228]
	ldr	w0, [x29, 236]
	str	w0, [x29, 232]
	b	.L5
.L7:
	ldr	w0, [x29, 232]
	sub	w0, w0, #1
	sxtw	x0, w0
	lsl	x0, x0, 2
	add	x1, x29, 24
	ldr	w2, [x1, x0]
	ldrsw	x0, [x29, 232]
	lsl	x0, x0, 2
	add	x1, x29, 24
	str	w2, [x1, x0]
	ldr	w0, [x29, 232]
	sub	w0, w0, #1
	str	w0, [x29, 232]
.L5:
	ldr	w0, [x29, 232]
	cmp	w0, 0
	ble	.L6
	ldr	w0, [x29, 232]
	sub	w0, w0, #1
	sxtw	x0, w0
	lsl	x0, x0, 2
	add	x1, x29, 24
	ldr	w0, [x1, x0]
	ldr	w1, [x29, 228]
	cmp	w1, w0
	blt	.L7
.L6:
	ldrsw	x0, [x29, 232]
	lsl	x0, x0, 2
	add	x1, x29, 24
	ldr	w2, [x29, 228]
	str	w2, [x1, x0]
	ldr	w0, [x29, 236]
	add	w0, w0, 1
	str	w0, [x29, 236]
.L4:
	ldr	w0, [x29, 236]
	cmp	w0, 49
	ble	.L8
	adrp	x0, .LC1
	add	x0, x0, :lo12:.LC1
	bl	puts
	str	wzr, [x29, 236]
	b	.L9
.L10:
	ldrsw	x0, [x29, 236]
	lsl	x0, x0, 2
	add	x1, x29, 24
	ldr	w1, [x1, x0]
	adrp	x0, .LC0
	add	x0, x0, :lo12:.LC0
	mov	w2, w1
	ldr	w1, [x29, 236]
	bl	printf
	ldr	w0, [x29, 236]
	add	w0, w0, 1
	str	w0, [x29, 236]
.L9:
	ldr	w0, [x29, 236]
	cmp	w0, 49
	ble	.L10
	mov	w0, 0
	ldp	x29, x30, [sp], 240
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa 31, 0
	ret
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.ident	"GCC: (GNU) 7.1.1 20170622 (Red Hat 7.1.1-3)"
	.section	.note.GNU-stack,"",@progbits
