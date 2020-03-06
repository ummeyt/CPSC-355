//Name: Ummey Zarin Tashnim
//ID: 30034931
//Professor: Leonard Manzara
//TA: Md. Reza Rabbani

//This progarm is suppose to take in some 2 numbers (month and day) and output the month
//and day and tell us the season which it falls under

//NOTE: I just have to add in the season calculation where
	//Winter is Dec 21 to Match 30
	//Spring is March 21 to June 20
	//Summer is June 21 to Sept 20
	//Fall is Sept 21 to Dec 20

	
	
	

//Months
	.text
//output_fmt:	.string "%s %d%s is %s\n "	
output_fmt:	.string "%s %d%s is \n "
jan:	.string "January"
feb:	.string "February"
mar:	.string "March"
apr:	.string "April"
may:	.string "May"
jun:	.string "June"
jul:	.string "July"
aug:	.string "August"
sep:	.string "September"
oct:	.string "October"
nov:	.string "November"
dec:	.string "December"

//Seasons		
win:	.string "Winter"
spr:	.string "Spring"
sum:	.string "Summer"
fall:	.string "Fall"

//Suffix	
rd:	.string "rd"		
st:	.string "st"
nd:	.string "nd"
th:	.string "th"

	.data
error_fmt:	.string "usage: a5b mm dd\n"

w19:	.dword	jan, feb, mar, apr, may, jun, jul, aug, sep, oct, nov, dec	
w22:	.dword win, spr, sum, fall
prefix:	.dword	st, nd, rd, th, th, th, th, th, th, th, th, th, th, th, th, th, th, th, th, th, st, nd, rd, th, th, th, th, th, th, th, st

	.text
	argc	.req	w22			//number of arguments
	argv	.req	x23			//values of the argument

	.balign 4
	.global main

main:	stp 	x29, x30, [sp, -16]!
	mov	x29, sp

	mov	argc, w0			//x0 contains argc 
	mov	argv, x1			//x1 contains argv

	mov	w25, 1				//w19
	mov	w26, 2				//w20
	
	cmp	argc, 3				//if the number of inputs is less than 3
	b.lt	error				//go to error

	ldr	x0, [argv, w25, SXTW 3]		//load argv(w19) into x0
	bl	atoi				//call atoi()
	mov	w19, w0			//w19 = w0
	cmp	w19, 12			//if w19 >= 12
	b.gt	error				//go to error
	cmp     w19, 0                        //if w19 < 0
	b.lt    error                           //go to error

	ldr     x0, [argv, w26, SXTW 3]         //load argv(w20) into x0
	bl      atoi                            //call atoi()
	mov     w20, w0                         //w20 = w0
	cmp     w20, 31                         //if w20 > 31
	b.gt    error                           //go to error
	cmp     w20, 0                          //if w20 < 0
	b.lt    error                           //go to error

//	ldr     x0, [x28, w22, SXTW 3]       //load w22 into x0
//	bl      atoi                            //call atoi()
//	mov	w22, w0			//w22 = w0
//	cmp	w22, 4			//if w22 >= 0
//	b.gt	error				//go to error
//	cmp     w22, 0                        //if w22 < 0
//	b.lt    error                           //go to error

	adrp    x22, w19                      
	add     x22, x22, :lo12:w19           //get w19
	sub     w19, w19, 1                 //w19 = w19 - 1

	adrp    x23, prefix                      
	add     x23, x23, :lo12:prefix          //get prefix

//	adrp    x24, w22
//	add     x24, x24, :lo12:w22		//get w22
	
	adrp    x0, output_fmt                    
	add 	x0, x0, :lo12:output_fmt          
	ldr     x1, [x22, w19, SXTW 3]	//1st arg - w19
	mov     w2, w20                         //2nd arg - w20
	sub     w20, w20, 1                     //w20 = w20 - 1
	ldr     x3, [x23, w20, SXTW 3]          //3rd arg - prefix
//	ldr	x4, [x24, w22, SXTW 3]	//4th arg - w22
	bl      printf                          //print output_fmt

	ldp     x29, x30, [sp], 16                  
	ret                                         

error:	adrp    x0, error_fmt                        
	add 	x0, x0, :lo12:error_fmt             
	bl  	printf                          //print error

	ldp     x29, x30, [sp], 16                  
	ret                                         

	
