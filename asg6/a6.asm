//Name: Ummey Zarin Tashnim
//ID: 30034931
//Professor: Leonard Manzara
//TA: Md. Reza Rabbani

//This program reads a list of input values from a file whose name is specified at the
//command line and computes the cude root of positive real numbers using Newton's method.

//Register equates for heavily used registers
	define(fd_r, w19)
	define(nread_r, x20)
	define(buf_base_r, x21)
	define(path_name, x22)
	define(error_value, d23)
	define(input, x24)

//Assembler equates
	buf_size = 8
	alloc = -(16 + buf_size) & -16
	dealloc = -alloc
	buf_s = 16
	AT_FDCWD = -100
	
error_value:	.double 0r1.0e-10		//initialize error value

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

	add	buf_base_r, x29, buf_s		//calculate buf base
	cmp	w0, 2				//check for 2 input arguments
	b.ne	inputerror			//if not, go to inputerror
	ldr	path_name, [x1, 8]		//else load path_name from user

	mov 	w0, AT_FDCWD                   	//1st arg: cwd
	mov	x1, path_name           	//2nd arg: pathname
	mov 	w2, 0				//3rd arg: read-only
	mov 	w3, 0                           //4th arg: not used
	mov 	w8, 56                          //openat I/O request
	svc 	0                               //call system function
	mov 	fd_r, w0                        //record file descriptor

	cmp 	fd_r, 0                    	//error check: branch over
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
top:	mov	w0, fd_r                       	//1st arg: fd
	mov	x1, buf_base_r                  //2nd arg: buf
	mov	w2, buf_size                    //3rd arg: n
	mov	x8, 63                          //read I/O request
	svc	0                               //call system function
	mov	nread_r, x0                     //record $ of bytes actually read

//Error checking for read()
	cmp	nread_r, buf_size               //if nread != 8, then
	b.ne	eof                             //read failed, go to endoffile

//Cube root - Newton Method
	ldr	input, [buf_base_r]		//load input
	fmov	d0, input			//input as arg1
	bl	cubeRoot			//call cubeRoot()
	
	adrp	x0, output			//
	add	x0, x0, :lo12:output		//
	fmov	d1, d0 				//cube root
	fmov	d0, input			//input
	bl	printf				//print output values

	b	top				//go to top

//Close binary file
eof:	mov 	w0, fd_r                        //1st arg: fd
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
	

	

	define(x, d9)
	define(y, d10)
	define(dy, d11)
	define(absdy, d12)
	define(dydx, d13)
	
	.balign 4
	.global cubeRoot			//cubeRoot()

cubeRoot:
	stp 	x29, x30, [sp, -16]! 
	mov 	x29, sp              

	fmov	d14, 3.0			//d14 = 3.0
	fmov	d15, d0				//d15 = input

	fdiv	x, d15, d14			//x = input /3
	
	adrp	x0, error_value			//
	add	x0, x0, :lo12:error_value	//
	ldr	error_value, [x0]		//load error_value

	fmul	error_value, d15, error_value	//error_value = input * 1.0e-10
	
cubeRootLoop:
	fmul	d16, x, x			//d16 = x * x
	fmul	y, d16, x			//y = (x * x) * x
	
	fsub	dy, y, d15			//dy = y - input
	fmul	dydx, d14, d16			//dydx = 3.0 * (x * x)

	fdiv	dydx, dy, dydx			//dydx = dy / dydx
	fsub	x, x, dydx			//x = x - dy/dydx

cubeRootTest:	
	fabs	absdy, dy			//absdy = dy
	fcmp	absdy, error_value		//if |dy| >= 1.0e-10	
	b.ge	cubeRootLoop			//go to cubeRootLoop

next:	fmov	d0, x				//else return x
	ldp	x29, x30, [sp], 16
        ret 
