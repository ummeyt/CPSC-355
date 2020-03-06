//Name: Ummey Zarin Tashnim
//ID: 30034931
//Professor: Leonard Manzara
//TA: Md. Reza Rabbani

//This progarm was translated from C to asembly
//NOTE: There are 2 bugs in this program.
//1. In dequeue, when the queue should be empty, the message doesn't print as instructed
//2. In display, every number seems to have "<-- tail of queue" to it.
//unfortunately, I didn't have enough time to fix this (even with the extension)
	
//global variables	
	
	
	
	
	
	
	
	
	

	.text
	QUEUESIZE = 8
	MODMASK = 0x7

overflow:	.string "\nQueue overflow! Cannot enqueue into a full queue.\n"
underflow:	.string "\nQueue underflow! Cannot dequeue from an empty queue.\n"
emptyQueue:	.string "\nEmpty queue\n"
curr_queue:	.string "\nCurrent queue contents:\n"
queue_i:	.string "  %d"
point_head:	.string " <-- head of queue"
point_tail:	.string " <-- tail of queue"
end_line:	.string "\n"

	.data
	.global head
head:	.word -1
	.global tail
tail:	.word -1

//array
	.bss
	.global queue_s
queue_s:.skip QUEUESIZE * 4

	.text
	.global enqueue					//void enqueue(int value)
enqueue:
	stp	x29, x30, [sp, -16]!
	mov	x29, sp

	mov	w19, w0				//keep w0 safe from being overwritten
	
	bl	queueFull				//call queueFull
	cmp	w0, 1				//if (!queueFull())
	b.ne	nextIf					//go to nextIf

	adrp	x0, overflow				//else
	add	x0, x0, :lo12:overflow			//
	bl	printf					//print full queue overflow
	b	return					//
	
nextIf:	bl	queueEmpty				//call queueEmpty
	cmp	w0, 1				//if (!queueEmpty())
	b.ne	else					//go to else

	adrp	x0, tail				//get the address of tail
	add	x0, x0, :lo12:tail			//

	adrp	x1, head				//get the address of head
	add	x1, x1, :lo12:head			//

	str	wzr, [x0]				//tail = 0
	str	wzr, [x1]				//head = tail = 0

	b	afterElse				//go to afterElse
	
else:	adrp	x0, tail				//get the address of tail
	add	x0, x0, :lo12:tail			//
	ldr	w9, [x0]				//

	add	w9, w9, 1			//tail = ++tail
	and	w9, w9, MODMASK			//tail = ++tail & MODMASK
	str	w9, [x0]				//store tail at it's address

afterElse:
	adrp	x0, tail				//get address of tail
	add	x0, x0, :lo12:tail			//
	ldr	w9, [x0]				//

	adrp	x0, queue_s				//get address of queue
	add	x0, x0, :lo12:queue_s			//
	str	w19, [x0, w9, SXTW 2]		//queue[tail] = value

return:	ldp	x29, x30, [sp], 16			
	ret	


	


	.global queueFull				//int queueFull()
queueFull:
	stp	x29, x30, [sp, -16]! 
	mov	x29, sp

	adrp	x0, tail				//get the address of tail
	add	x0, x0, :lo12:tail			//
	ldr	w9, [x0]				//

	adrp	x0, head				//get the address of head
	add	x0, x0, :lo12:head			//
	ldr	w10, [x0]				//

	add	w9, w9, 1			//tail = tail + 1
	and	w9, w9, MODMASK			//tail = tail & MODMASK

	cmp	w9, w10				//if (((tail + 1) & MODMASK) != head)
	b.ne	retFalse				//go to retFalse
	mov	w0, 1				//else return 1
	b	return1					//go to return1
	
retFalse:
	mov	w0, 0				//return 0
	
return1:
	ldp	x29, x30, [sp], 16
	ret	



	

	.global queueEmpty				//int queueEmpty()	
queueEmpty:
	stp	x29, x30, [sp, -16]!
	mov	x29, sp

	adrp	x0, head				//get the address of head
	add	x0, x0, :lo12:head			//
	ldr	w10, [x0]				//load head

	cmp	w10, -1				//if (head != -1)
	b.ne	setFalse				//go to setFalse
	mov	x0, 1 				//else return 1
	b	return2					//go to return2

setFalse:
	mov	x0, 0				//return 0

return2:
	ldp	x29, x30, [sp], 16
	ret	




	.global dequeue					//int dequeue()
dequeue:
	stp	x29, x30, [sp, -16]!
	mov	x29, sp

	bl	queueEmpty				//call queueEmpty
	cmp	w0, 1				//if (!queueEmpty())
	b.ne	doNext					//go to doNext
	adrp	x0, underflow				//else
	add	x0, x0, :lo12:underflow			//
	bl	printf					//print empty queue overflow
	mov	x0, -1					//return -1
	b	return3					//go to return3
	
doNext:	adrp	x1, head				//get the address of head
	add	x1, x1, :lo12:head			//
	ldr	w10, [x1]				//load head

	adrp	x0, tail				//get the address of tail
	add	x0, x0, :lo12:tail			//
	ldr	w9, [x0]				//load tail
	
	adrp	x2, queue_s				//get the address of queue
	add	x2, x2, :lo12:queue_s			//
	ldr	w19, [x2, w10, SXTW 2]		//value = queue[head]
	
	cmp	w10, w9				//if (head != tail)
	b.ne	else2					//go to else2

	mov	w11, -1					//w11 = -1
	str	w11, [x0]				//tail = -1
 	str	w11, [x1]				//head = tail = -1

	b	retValue				//go to retValue

else2:	add	w10, w10, 1
	and	w10, w10, MODMASK			//head = ++head & MODMASK
	str	w10, [x1]				//store head

retValue:
	mov	w0, w19				//return value
return3:
	ldp	x29, x30, [sp], 16
	ret	

	

		
	.global display					//void display()
display:
	stp	x29, x30, [sp, -16]!
	mov	x29, sp

	bl	queueEmpty				//call queueEmpty
	cmp	w0, 1				//if (!queueEmpty())
	b.ne	go_next					//go to do_next

	adrp	x0, emptyQueue				//else
	add	x0, x0, :lo12:emptyQueue		//
	bl	printf					//print overflow_empty
	bl	return4
	
go_next:
	adrp	x0, tail				//get the address of tail
	add	x0, x0, :lo12:tail			//
	ldr	w9, [x0]				//load tail

	adrp	x1, head				//get the address of head
	add	x1, x1, :lo12:head			//
	ldr	w10, [x1]				//load head	

	sub	w22, w9, w10			//count = tail - head
	add	w22, w22, 1			//count = tail - head + 1
	
	cmp	w22, 0				//if (count > 0)
	b.gt	print_curr				//go to print_curr
	add	w22, w22, QUEUESIZE		//else count += QUEUESIZE
	
print_curr:
	adrp	x0, curr_queue				//
	add	x0, x0, :lo12:curr_queue		//
	bl	printf					//print curr_queue

	adrp	x0, head				//get the address of head
	add	x0, x0, :lo12:head			//
	ldr	w10, [x0]				//load head

test1:	mov	w20, w10				//i = head
	mov	w21, wzr				//j = 0	
	b	loop_test				//go to loop_test

loop:	adrp	x0, queue_i				//
	add	x0, x0, :lo12:queue_i			//
	adrp	x11, queue_s				//
	add	x11, x11, :lo12:queue_s			//
	ldr	w1, [x11, w20, SXTW 2]			//load queue[i]
	bl	printf					//print queue[i]

test2:	adrp	x0, head				//get the address of head
	add	x0, x0, :lo12:head			//
	ldr	w10, [x0]				//

test3:	cmp	w20, w10				//if (i != head)
	b.ne	is_tail					//go to is_tail

	adrp	x0, point_head				//else
	add	x0, x0, :lo12:point_head		//
	bl	printf					//print point_head

test4:	
is_tail:
	adrp	x0, tail				//get the address of tail
	add	x0, x0, :lo12:tail			//
	ldr	w9, [x0]				//

	cmp	w20, w9					//if (i != tail)
	b.ne	not_tail				//go to not_tail

	adrp	x0, point_tail				//else
	add	x0, x0, :lo12:point_tail		//	
	bl	printf					//print point_tail
	
not_tail:	
	adrp	x0, end_line				//
	add	x0, x0, :lo12:end_line			//
	bl	printf					//print end_line

	add	w20, w20, 1				//i = ++i
	and	w20, w20, MODMASK			//i = ++i & MODMASK

	add	w21, w21, 1				//increment j

loop_test:
	cmp 	w21, w22				//while(j < count)
	b.lt	loop					//go to top
		
return4:
	ldp	x29, x30, [sp], 16			
	ret



