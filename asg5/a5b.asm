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

//so it would look something like:
//  if ((m==2 && d>=20) || (m==5 && d>=21) || (m==8 && d>=22) || (m==11 && d>=21))
//    m += 1;               //add one to month
//  printf(" is %s\n", season[(m/3)%4]);		

	define(month, w19)
	define(day, w20)
	define(season, w22)

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

month:	.dword	jan, feb, mar, apr, may, jun, jul, aug, sep, oct, nov, dec	
season:	.dword win, spr, sum, fall
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

	mov	w25, 1				//month
	mov	w26, 2				//day
	
	cmp	argc, 3				//if the number of inputs is less than 3
	b.lt	error				//go to error

	ldr	x0, [argv, w25, SXTW 3]		//load argv(month) into x0
	bl	atoi				//call atoi()
	mov	month, w0			//month = w0
	cmp	month, 12			//if month >= 12
	b.gt	error				//go to error
	cmp     month, 0                        //if month < 0
	b.lt    error                           //go to error

	ldr     x0, [argv, w26, SXTW 3]         //load argv(day) into x0
	bl      atoi                            //call atoi()
	mov     day, w0                         //day = w0
	cmp     day, 31                         //if day > 31
	b.gt    error                           //go to error
	cmp     day, 0                          //if day < 0
	b.lt    error                           //go to error

//	ldr     x0, [x28, season, SXTW 3]       //load season into x0
//	bl      atoi                            //call atoi()
//	mov	season, w0			//season = w0
//	cmp	season, 4			//if season >= 0
//	b.gt	error				//go to error
//	cmp     season, 0                        //if season < 0
//	b.lt    error                           //go to error

	adrp    x22, month                      
	add     x22, x22, :lo12:month           //get month
	sub     month, month, 1                 //month = month - 1

	adrp    x23, prefix                      
	add     x23, x23, :lo12:prefix          //get prefix

//	adrp    x24, season
//	add     x24, x24, :lo12:season		//get season
	
	adrp    x0, output_fmt                    
	add 	x0, x0, :lo12:output_fmt          
	ldr     x1, [x22, month, SXTW 3]	//1st arg - month
	mov     w2, day                         //2nd arg - day
	sub     day, day, 1                     //day = day - 1
	ldr     x3, [x23, day, SXTW 3]          //3rd arg - prefix
//	ldr	x4, [x24, season, SXTW 3]	//4th arg - season
	bl      printf                          //print output_fmt

	ldp     x29, x30, [sp], 16                  
	ret                                         

error:	adrp    x0, error_fmt                        
	add 	x0, x0, :lo12:error_fmt             
	bl  	printf                          //print error

	ldp     x29, x30, [sp], 16                  
	ret                                         

	
