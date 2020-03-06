	// Assembler registers
	user_month  .req w19
	user_day    .req w20
	user_season .req x21

	argv_r .req x22
	seasons_s .req x23
	months_s .req x24
	days_s .req x25
	FP .req x29
	LR .req x30

	// Month strings
	.text
jan:	 .string "January"
feb:	 .string "February"
mar:	 .string "March"
apr:	 .string "April"
may:	 .string "May"
jun:	 .string "June"
jul:	 .string "July"
aug:	 .string "August"
sep:	 .string "September"
oct:	 .string "October"
nov:	 .string "November"
dec:	 .string "December"

	// Season strings
winter:	 .string "Winter"
spring:	 .string "Spring"
summer:	 .string "Summer"
fall:	 	.string "Fall"

	// Day strings
day1:	 .string "1st"
day2:	 .string "2nd"
day3:	 .string "3rd"
day4:	 .string "4th"
day5:	 .string "5th"
day6:	 .string "6th"
day7:	 .string "7th"
day8:	 .string "8th"
day9:	 .string "9th"
day10:	 .string "10th"
day11:	 .string "11th"
day12:	 .string "12th"
day13:	 .string "13th"
day14:	 .string "14th"
day15:	 .string "15th"
day16:	 .string "16th"
day17:	 .string "17th"
day18:	 .string "18th"
day19:	 .string "19th"
day20:	 .string "20th"
day21:	 .string "21st"
day22:	 .string "22nd"
day23:	 .string "23rd"
day24:	 .string "24th"
day25:	 .string "25th"
day26:	 .string "26th"
day27:	 .string "27th"
day28:	 .string "28th"
day29:	 .string "29th"
day30:	 .string "30th"
day31:	 .string "31st"

	// Error and output strings
error:	 .string "usage: a5b mm dd\n"
outputText:	 .string "%s %s is %s\n"

	// External pointer arrays for months, seasons and days
	.balign 8
	.data
months:	  .dword jan, feb, mar, apr, may, jun, jul, aug, sep, oct, nov, dec
seasons:	 .dword winter, spring, summer, fall
days:		 .dword	day1, day2, day3, day4, day5, day6, day7, day8, day9, day10, day11, day12, day13, day14, day15, day16, day17, day18, day19, day20, day21, day22, day23, day24, day25, day26, day27, day28, day29, day30, day31

	.text
	.balign 4
	.global main
main:		stp FP, LR, [sp, -16]!		// Allocate memory on stack and sotre FP and LR
	mov FP, sp			// Set FP as stack pointer
	mov argv_r, x1                  // Move arguments base address to register
	cmp w0, 3			// Check number of arguments passed
	b.ne printError			// If arguments not 2, print error

	adrp seasons_s, seasons			  // Higher order bits of seasons array address
	add seasons_s, seasons_s, :lo12:seasons	  // Lower order bits of seasons array address

	adrp days_s, days			  // Higher order bits of days array address
	add days_s, days_s, :lo12:days		  // Lower order bits of days array address

	adrp months_s, months			  // Higher order bits of months array address
	add months_s, months_s, :lo12:months	  // Lower order bits of months array address

	ldr x0, [argv_r, 8]		// Load user month into x0
	bl atoi				// Pass it to atoi() to convert string to number
	mov user_month, w0		// Move number value of month to register

	ldr x0, [argv_r, 16]		// Load user date into x0
	bl atoi				// Pass it to atoi() to convert string to number
	mov user_day, w0		// Move number value of day to register

	// Check to make sure month is in range [1, 12] and days are in range [1, 31]
	cmp user_month, 1		// month ? 1
	b.lt printError			// If month < 1, print error

	cmp user_month, 12		// month ? 12
	b.gt printError			// If month > 12, print error

	cmp user_day, 1			// day ? 1
	b.lt printError			// If day < 1, print error

	cmp user_day, 31		// day ? 31
	b.gt printError			// If day > 31, print error

	//  Calculate seasons
JanFebCheck:
	cmp user_month, 3		// month ? 3
	b.ge checkMarch			// if month >= 3, branch to march check

	ldr user_season, [seasons_s]	// Load winter for January and February
	b output			// Branch to user output

checkMarch:
	cmp user_month, 3		// Check if month is march
	b.ne checkApril			// Branch to april check if not march

	cmp user_day, 20		// Check if date of march less than 20
	b.gt springMarch		// If after march 20, branch to sprint setter

winterMarch:
	ldr user_season, [seasons_s]	// Load winter for March if March 1 to March 20
	b output			// Branch to user output

springMarch:
	ldr user_season, [seasons_s, 8]		// Load spring for March if March 21 to March 31
	b output				// Branch to user output

checkApril:
	cmp user_month, 4			// Check if month is april
	b.ne checkMay				// Branch to may check if not april

	ldr user_season, [seasons_s, 8]		// Load spring if it is april
	b output				// Branch to user output

checkMay:
	cmp user_month, 5			// Check if the month is may
	b.ne checkJune				// If not may, branch to checkJune

	ldr user_season, [seasons_s, 8]		// If month is may, load spring as season
	b output				// Branch to user output

checkJune:
	cmp user_month, 6			// Check if month is june
	b.ne checkJuly				// If not june, branch to checkJuly

	cmp user_day, 20			// If june, check the day of the month
	b.gt juneSummer				// If day is greater than 20, branch to juneSummer

	ldr user_season, [seasons_s, 8]		// Load spring if June 1 to June 20
	b output				// Branch to user output

juneSummer:
	ldr user_season, [seasons_s, 16]	// Load summer if June 21 to June 30
	b output				// Branch to user output

checkJuly:
	cmp user_month, 7			// Check if month is july
	b.ne checkAugust			// If not july, branch to checkAugust

	ldr user_season, [seasons_s, 16]	// If july, set season as summer
	b output				// Branch to user output

checkAugust:
	cmp user_month, 8			// Check if month is august
	b.ne checkSeptember			// If not august, branch to checkSeptember

	ldr user_season, [seasons_s, 16]	// If august, set season as summer
	b output

checkSeptember:
	cmp user_month, 9			// Check if month is september
	b.ne checkOctober			// If not september, branch to checkOctober

	cmp user_day, 20			// If september, check day of month
	b.gt septemberFall			// If day > 20, branch to septemberFall

	ldr user_season, [seasons_s, 16]	// If september day <= 20, set season as summer
	b output				// Branch to user output

septemberFall:
	ldr user_season, [seasons_s, 24]	// If semptember day > 20, set seasons as fall
	b output				// Branch to user output

checkOctober:
	cmp user_month, 10			// Check if month is october
	b.ne checkNovember			// If not october, branch to checkNovember

	ldr user_season, [seasons_s, 24]	// If october, set season as fall
	b output				// Branch to user output

checkNovember:
	cmp user_month, 11			// Check if month is november
	b.ne checkDecember			// If not november, branch to checkDecember

	ldr user_season, [seasons_s, 24]	// If novermber, set season to fall
	b output

checkDecember:
	cmp user_month, 12			// Check if month is december
	b.ne printError				// If not december, print error

	cmp user_day, 20			// If december, check user date
	b.gt decemberWinter			// If user date > 20, branch to decemberWinter

	ldr user_season, [seasons_s, 24]	// If december date <= 20, set season to fall
	b output				// Branch to user output

decemberWinter:
	ldr user_season, [seasons_s]		// If december date >20, set season to winter
	b output				// Branch to user output

output:
	// printf("%s %s is %s\n")
	adrp x0, outputText			// Load higher bits of outputText
	add x0, x0, :lo12:outputText		// Load lower bits of outputText

	sub user_month, user_month, 1		// month = month - 1
	ldr x1, [months_s, user_month, SXTW 3]	// Load month string into x1

	sub user_day, user_day, 1		// day = day -1
	ldr x2, [days_s, user_day, SXTW 3]	// Load day string into x2

	mov x3, user_season			// Set 3rd argument as user season

	bl printf				// Call printf() function
	b done					// Branch to done

printError:
	// printf("usage: a5b mm dd\n")
	adrp x0, error				// Higher order bits of error
	add x0, x0, :lo12:error			// Lower order bits of error
	bl printf				// Call printf() function
done:
	mov w0, 0				// Set 0 as return value
	ldp FP, LR, [sp], 16			// Load FP and LR from register, deallocate stack mem
	ret					// Return to calling function
