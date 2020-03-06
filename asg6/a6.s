//Name: Ummey Zarin Tashnim
//ID: 30034931
//Professor: Leonard Manzara
//TA: Md. Reza Rabbani

//This program reads a list of input values from a file whose name is specified at the
//command line and computes the cude root of positive real numbers using Newton's method.

//Register equates for heavily used registers
	
	
	
	
	
	

//Assembler equates
	buf_size = 8
	alloc = -(16 + buf_size) & -16
	dealloc = -alloc
	buf_s = 16
	AT_FDCWD = -100
	
d23:	.double 0r1.0e-10		//initialize error value

//Format strings
	.text
colume:		.string "Input:\t\t Cube Root:\n"
output:		.string "%f\t%0.10f\n"	
openfile_error:	.string "Error opening file: %s\nAborting.\n"
input_error:	.string "Usage:	./a6  filename\n"
	
	.balign 4
	.global main

main:	stp	x29, x30, [sp, alloc]!
	mov	x29, sp

	add	x21, x29, buf_s		//calculate buf base
	cmp	w0, 2				//check for 2 x24 arguments
	b.ne	inputerror			//if not, go to inputerror
	ldr	x22, [x1, 8]		//else load x22 from user

	mov 	w0, AT_FDCWD                   	//1st arg: cwd
	mov	x1, x22           	//2nd arg: pathname
	mov 	w2, 0				//3rd arg: read-only
	mov 	w3, 0                           //4th arg: not used
	mov 	w8, 56                          //openat I/O request
	svc 	0                               //call system function
	mov 	w19, w0                        //record file descriptor

	cmp 	w19, 0                    	//error check: branch over
	b.ge    openok                          //if file opened sucessfully

	adrp    x0, openfile_error              //error handling code
	add 	x0, x0, :lo12:openfile_error    //
	bl  	printf                          //print openfile_error

	mov 	w0, -1                          //return -1
	b   	exit                            //exit program

openok: adrp    x0, colume			//when file opens succesfully
	add 	x0, x0, :lo12:colume		//
	bl 	printf                 		//print colume header
	
//Read from file	
top:	mov	w0, w19                       	//1st arg: fd
	mov	x1, x21                  //2nd arg: buf
	mov	w2, buf_size                    //3rd arg: n
	mov	x8, 63                          //read I/O request
	svc	0                               //call system function
	mov	x20, x0                     //record $ of bytes actually read

//Error checking for read()
	cmp	x20, buf_size               //if nread != 8, then
	b.ne	eof                             //read failed, go to endoffile

//Cube root - Newton Method
	ldr	x24, [x21]		//load x24
	fmov	d0, x24			//x24 as arg1
	bl	cubeRoot			//call cubeRoot()
	
	adrp	x0, output			//
	add	x0, x0, :lo12:output		//
	fmov	d1, d0 				//cube root
	fmov	d0, x24			//x24
	bl	printf				//print output values

	b	top				//go to top

//Close binary file
eof:	mov 	w0, w19                        //1st arg: fd
	mov 	x9, 57                          //close I/O request
	svc 	0                               //call system function
	mov 	w0, 0                           //return 0

exit:	ldp 	x29, x30, [sp], dealloc		//dealloc
	ret                                


inputerror:
	adrp	x0, input_error			//error handling code
	add	x0, x0, :lo12:input_error	//
	bl	printf				//print input_error

	mov	w0, -1				//return -1
	b	exit				//exit program
	

	

	
	
	
	
	
	
	.balign 4
	.global cubeRoot			//cubeRoot()

cubeRoot:
	stp 	x29, x30, [sp, -16]! 
	mov 	x29, sp              

	fmov	d14, 3.0			//d14 = 3.0
	fmov	d15, d0				//d15 = x24

	fdiv	d9, d15, d14			//d9 = x24 /3
	
	adrp	x0, d23			//
	add	x0, x0, :lo12:d23	//
	ldr	d23, [x0]		//load d23

	fmul	d23, d15, d23	//d23 = x24 * 1.0e-10
	
cubeRootLoop:
	fmul	d16, d9, d9			//d16 = d9 * d9
	fmul	d10, d16, d9			//d10 = (d9 * d9) * d9
	
	fsub	d11, d10, d15			//d11 = d10 - x24
	fmul	d13, d14, d16			//d13 = 3.0 * (d9 * d9)

	fdiv	d13, d11, d13			//d13 = d11 / d13
	fsub	d9, d9, d13			//d9 = d9 - d11/d13

cubeRootTest:	
	fabs	d12, d11			//d12 = d11
	fcmp	d12, d23		//if |d11| >= 1.0e-10	
	b.ge	cubeRootLoop			//go to cubeRootLoop

next:	fmov	d0, d9				//else return d9
	ldp	x29, x30, [sp], 16
        ret 
