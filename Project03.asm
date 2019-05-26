TITLE Integer Accumulator    (Project03.asm)

; Author: Ian Collier
; Course / Project ID:   CS271 / Project #3             Date: 01/27/2019
; Description: A program to find the sum and average of user-entered integers

INCLUDE Irvine32.inc

; Constants

UPPER_LIMIT = -1
LOWER_LIMIT = -100
MIN_ENTRIES = 1

.data

; Variables

; Text
extra1		BYTE	"Includes extra credit option - number lines during user input.",0
intro1		BYTE	"Welcome to Int Accumulator (made by Ian Collier).",0
greet1		BYTE	"Give me your name: ",0
greet2		BYTE	"Hello ",0
intro2		BYTE	"Enter several numbers between -1 and -100 (inclusive) to get their sum.",0
intro3		BYTE	"Enter a non-negative number to finish.",0
prompt1		BYTE	". Give a number: ",0
result1		BYTE	"Amount of numbers you just entered: ",0
result2		BYTE	"The sum of your numbers is: ",0
result3		BYTE	"The rounded avg. is: ",0
err1		BYTE	"You didn't enter any numbers.",0
err2		BYTE	"Number out of range.",0
bye1		BYTE	"Goodbye ",0

; Input variables
userName	BYTE	33 DUP(0)	; User name string
userIn		DWORD	?			; Input holder
numberAvg	DWORD	0			; Average of valid numbers
numberSum	DWORD	0			; Sum of valid numbers
numberN		DWORD	0			; Count of valid numbers entered
promptN		DWORD	0			; Count of lines during user input


.code
main PROC

; introduction
	; Print title of program
	mov		edx,OFFSET intro1
	call	WriteString
	call	Crlf
	call	Crlf
	mov		edx,OFFSET extra1
	call	WriteString
	call	Crlf
	call	Crlf

	; Print the name prompt
	mov		edx,OFFSET greet1
	call	WriteString

	; Get the name prompt input
	mov		edx, OFFSET userName
	mov		ecx, 32
	call	 ReadString

	; Print the greeting and name user entered
	mov		edx,OFFSET greet2
	call	WriteString
	mov		edx,OFFSET userName
	call	WriteString
	call	Crlf
	call	Crlf

	; Print the instructions
	mov		edx,OFFSET intro2
	call	WriteString
	call	Crlf
	mov		edx,OFFSET intro3
	call	WriteString
	call	Crlf

; accumulator
	calcLoop:
		; Increment input line count
		mov		eax, promptN
		inc		eax
		mov		promptN, eax

		; Get number input
		mov		eax, promptN		; Line number
		call	WriteDec
		mov		edx,OFFSET prompt1	; Prompt
		call	WriteString
		call	ReadInt
		mov		userIn, eax

		; If above upper limit (positive) jump to results
		mov		eax, userIn
		cmp		eax, UPPER_LIMIT
		jg		resultsShow

		; If below lower limit print err
		mov		eax, userIn
		cmp		eax, LOWER_LIMIT
		jl		calcLoopErr

		; Else
		; Increment count
		mov eax, numberN
		inc eax
		mov numberN, eax

		; Add to running sum
		mov eax, numberSum
		add eax, userIn
		mov numberSum, eax

		; Update running avg.
		mov eax, numberSum
		cdq
		mov ebx, numberN
		idiv ebx				; Need to do signed int division
		mov numberAvg, eax

		; Loop
		jmp calcLoop

		; Prints out of range message and loops back
		calcLoopErr:
			mov		edx,OFFSET err2
			call	WriteString
			call	Crlf
			jmp calcLoop

; results
	resultsShow:
		; Check if any numbers were entered
		mov		eax, numberN
		cmp		eax, MIN_ENTRIES
		jge		resultsShowGood

		; If not print err and jump to bye
			mov		edx,OFFSET err1
			call	WriteString
			call	Crlf

			jmp byeShow

		; If yes print results
		resultsShowGood:

			; Print numbers entered
			mov		edx,OFFSET result1
			call	WriteString
			mov		eax, numberN
			call	WriteDec
			call	Crlf

			; Print sum
			mov		edx,OFFSET result2
			call	WriteString
			mov		eax, numberSum
			call	WriteInt
			call	Crlf

			; Print average
			mov		edx,OFFSET result3
			call	WriteString
			mov		eax, numberAvg
			call	WriteInt
			call	Crlf

; farewell
	byeShow:
	; Print the goodbye and user name
	call	Crlf
	mov		edx,OFFSET bye1
	call	WriteString
	mov		edx,OFFSET userName
	call	WriteString
	call	Crlf

	; Exit to OS
	exit
main ENDP

END main
