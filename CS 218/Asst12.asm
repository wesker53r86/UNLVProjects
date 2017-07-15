;  Threading program, provided template

; ***************************************************************

section	.data

; -----
;  Define standard constants.

LF		equ	10			; line feed
NULL		equ	0			; end of string
ESC		equ	27			; escape key

TRUE		equ	1
FALSE		equ	-1

SUCCESS		equ	0			; Successful operation
NOSUCCESS	equ	1			; Unsuccessful operation

STDIN		equ	0			; standard input
STDOUT		equ	1			; standard output
STDERR		equ	2			; standard error

SYS_read	equ	0			; system call code for read
SYS_write	equ	1			; system call code for write
SYS_open	equ	2			; system call code for file open
SYS_close	equ	3			; system call code for file close
SYS_fork	equ	57			; system call code for fork
SYS_exit	equ	60			; system call code for terminate
SYS_creat	equ	85			; system call code for file open/create
SYS_time	equ	201			; system call code for get time

; -----
;  Message strings

header		db	LF, "*******************************************", LF
		db	ESC, "[1m", "Primes Program", ESC, "[0m", LF, LF, NULL
msgStart	db	"--------------------------------------", LF	
		db	"Start Prime Count", LF, NULL
msgDoneMain	db	"Prime Count: ", NULL
msgProgDone	db	LF, "Completed.", LF, NULL

primeLimit	dq	10000
isSequential	db	TRUE			; bool

; -----
;  Globals (used by threads)

iCounter	dq	0
primeCount	dq	0

myLock		dq	0

; -----
;  Thread data structures

pthreadID0	dq	0, 0, 0, 0, 0
pthreadID1	dq	0, 0, 0, 0, 0
pthreadID2	dq	0, 0, 0, 0, 0

; -----
;  Local variables for thread function.

msgThread1	db	" ...Thread starting...", LF, NULL

; -----
;  Local variables for printMessageValue

newLine		db	LF, NULL

; -----
;  Local variables for getParams function

LIMITMIN	equ	1000
LIMITMAX	equ	100000000

errUsage	db	"Usgae: ./primes <-s|-p> ",
		db	"-l <vigesimalNumber>", LF, NULL
errOptions	db	"Error, invalid command line options."
		db	LF, NULL
errSSpec	db	"Error, invalid sequential/parallel specifier."
		db	LF, NULL
errPLSpec	db	"Error, invalid prime limit specifier."
		db	LF, NULL
errPLValue	db	"Error, prime out of range."
		db	LF, NULL

; -----
;  Local variables for int2Vegismal function

dTwenty		dd	20
tmpNum		dd	0

; -----

section	.bss

tmpString	resb	20


; ***************************************************************

section	.text

; -----
; External statements for thread functions.

extern	pthread_create, pthread_join

; ================================================================
;  Prime number counting program.

global main
main:

; -----
;  Check command line arguments

	mov	rdi, rdi			; argc
	mov	rsi, rsi			; argv
	mov	rdx, isSequential
	mov	rcx, primeLimit
	call	getParams

	cmp	rax, TRUE
	jne	progDone

; -----
;  Initial actions:
;	Display initial messages

	mov	rdi, header
	call	printString

	mov	rdi, msgStart
	call	printString

;  Create new thread(s)
;	pthread_create(&pthreadID0, NULL, &threadFunction0, NULL);
;  if sequntial, start 1 thread
;  if parallel, start 3 threads

	cmp
	mov rdi, pthreadID0
	mov rsi, NULL
	mov rdx, primeCounter
	mov rcx, NULL
	call pthread_create
	
	mov rdi, pthreadID1
	mov rsi, NULL
	mov rdx, primeCounter
	mov rcx, NULL
	call pthread_create
	

;  Wait for thread(s) to complete.
;	pthread_join (pthreadID0, NULL);


	mov rdi, pthreadID0
	mov rsi, NULL
	call pthread_join
	
	mov rdi, pthreadID1
	mov rsi, NULL
	call pthread_join
	

	
; -----
;  Display final count

showFinalResults:
	mov	rdi, msgDoneMain
	call	printString

	mov	rdi, qword [primeCount]
	mov	rsi, tmpString
	call	intToVegismal

	mov	rdi, tmpString
	call	printString

	mov	rdi, newLine
	call	printString

; **********
;  Program done, display final message
;	and terminate.

	mov	rdi, msgProgDone
	call	printString

progDone:
	mov	rax, SYS_exit			; system call for exit
	mov	rdi, SUCCESS			; return code SUCCESS
	syscall

; ******************************************************************
;  Thread function, primeCounter()
;	Display initail thread start message
;	Determine which numbers between 1 and
;	primeLimit (gloabally available) are prime.

; -----
;  Arguments:
;	N/A (global variable accessed)
;  Returns:
;	N/A (global variable accessed)

global primeCounter
primeCounter:


	mov rdi, msgThread1
	call printString
	
	
	call spinLock
	lock inc qword[iCounter]; compensate for 2 being prime
	mov r15, qword[iCounter] ;counter
	mov r14, 0 ;index
	mov r13, 3 ;digit
	mov r12, 0
	call spinUnlock
Primelp:
	cmp r13,qword[primeLimit]
	jg endPrimelp
	mov eax, r13d
checkPrimelp:
	mov eax, r13d
	mov ebx, 2
	mov edx, 0
	idiv ebx
	cmp edx,0
	je isPrime

	
	mov rdi, r13
	call PrimeCounter2
	cmp rax,0
	je isPrime
	
	inc r13
	jmp Primelp
isPrime:
	lock inc qword[primeCount]
	inc r13
	jmp Primelp

endPrimelp:

	ret
	
	



; ******************************************************************
;  Mutex lock
;	checks lock (shared gloabl variable)
;		if unlocked, sets lock
;		if locked, lops to recheck until lock is free

global	spinLock
spinLock:
	mov	rax, 1			; Set the EAX register to 1.

lock	xchg	rax, qword [myLock]	; Atomically swap the RAX register with
					;  the lock variable.
					; This will always store 1 to the lock, leaving
					;  the previous value in the RAX register.

	test	rax, rax	        ; Test RAX with itself. Among other things, this will
					;  set the processor's Zero Flag if RAX is 0.
					; If RAX is 0, then the lock was unlocked and
					;  we just locked it.
					; Otherwise, RAX is 1 and we didn't acquire the lock.

	jnz	spinLock		; Jump back to the MOV instruction if the Zero Flag is
					;  not set; the lock was previously locked, and so
					; we need to spin until it becomes unlocked.
	ret

; ******************************************************************
;  Mutex unlock
;	unlock the lock (shared global variable)

global	spinUnlock
spinUnlock:
	mov	rax, 0			; Set the RAX register to 0.

	xchg	rax, qword [myLock]	; Atomically swap the RAX register with
					;  the lock variable.
	ret

; ******************************************************************
;  Check if a passed number is prime.
;	note, uses iSqrt() function for integer square root approximation

;  Arguments:
;	number (value)
;  Returns:
;	TRUE/FALSE

global PrimeCounter2
PrimeCounter2:


	push rdi
	
	mov r15,0;index
	mov r14,3;divisor
	call iSqrt
	mov r13,rax

PrimeCountlp2:

	mov eax, edi; get value
	mov ebx, r14d;get divisor
	mov edx, 0 ;reset remainder
	cmp r14,r13
	jg notPrime
	idiv ebx
	cmp edx, 0
	je isnotPrime
	add r14,2
	jmp PrimeCountlp2

isPrime:
	mov rax,TRUE
	jmp endPrimeCountlp2
notPrime:
	mov rax,FALSE
	jmp endPrimeCountlp2
endPrimeCountlp2:
	pop rdi
	
	ret
; ******************************************************************
;  Function to calculate and return an integer estimate of
;  the square root of a given number.

;  To estimate the square root of a number, use the following
;  algorithm:
;	sqrt_est = number
;	iterate 50 times
;		sqrt_est = ((number/sqrt_est)+sqrt_est)/2

; -----
;  Call:
;	ans = iSqrt(number)

;  Arguments Passed:
;	1) number, value - rdi

;  Returns:
;	square root value (in eax)

global	iSqrt
iSqrt:
	push rdi

	mov r15,0;iterate this 50 times
	mov rbx, rdi;sqrt # = num
	mov rax, rdi;num
	mov rdx, 0
isqrtlp:

	cmp r15, 50
	jge endisqrtlp
	mov rax, rdi;num
	idiv rbx;num/sqrtest
	add rax,rbx;(num/sqrtest)+sqrtest
	mov rbx,2;/2
	idiv rbx;(((num/sqerest)+sqrtest)/2)
	mov rbx,rax ;rbx= sqrtest
	inc r15;i++
	jmp isqrtlp

endisqrtlp:
	mov rax, rbx
	
	pop rdi
	
	ret

; ******************************************************************
;  Convert integer to ASCII/Vegismal string.
;	Note, no error checking required on integer.

; -----
;  Arguments:
;	1) integer, value
;	2) string, address
; -----
;  Returns:
;	ASCII/Vegismal string (NULL terminated)

global	intToVegismal
intToVegismal:

	push rdi

	mov rax,rdi
	mov rdx,0
	mov rbx,20
	mov r15,0;string byte navigator
	mov r14,0;how many to pop
int2viglp:
	mov rdx,0
	cmp rax,0
	jle placeviglp
	
	idiv rbx
	
	cmp rdx,9
	jle decimallp
	cmp rdx,17
	jle AHlp
	cmp rdx,19
	jle JKlp
	
incrementviglp:
	inc r14
	jmp int2viglp

JKlp:
	add rdx, 56
	push rdx
	jmp incrementviglp
AHlp:
	add rdx, 55 
	push rdx
	jmp incrementviglp
decimallp:
	add rdx, 48
	push rdx
	jmp incrementviglp

placeviglp:
	cmp r14,0
	jle finishviglp
    
	pop rbx
	mov byte[rsi+r15],bl
	inc r15
	dec r14
	jmp placeviglp
finishviglp:
	
	mov byte[rsi+r15],NULL
	pop rdi
	
	ret

; ******************************************************************
;  Generic procedure to display a string to the screen.
;  String must be NULL terminated.
;  Algorithm:
;	Count characters in string (excluding NULL)
;	Use syscall to output characters

;  Arguments:
;	1) address, string
;  Returns:
;	nothing

global	printString
printString:

; -----
; Count characters to write.

	mov	rdx, 0
strCountLoop:
	cmp	byte [rdi+rdx], NULL
	je	strCountLoopDone
	inc	rdx
	jmp	strCountLoop
strCountLoopDone:
	cmp	rdx, 0
	je	printStringDone

; -----
;  Call OS to output string.

	mov	rax, SYS_write			; system code for write()
	mov	rsi, rdi			; address of characters to write
	mov	rdi, STDOUT			; file descriptor for standard in
						; rdx=count to write, set above
	syscall					; system call

; -----
;  String printed, return to calling routine.

printStringDone:
	ret

; ******************************************************************
;  Function getParams()
;	Get, check, convert, verify range, and return the
;	thread count and prime limit.

;  Example HLL call:
;	stat = getParams(argc, argv, &isSequntial, &primeLimit)

;  This routine performs all error checking, conversion of ASCII/Vegismal
;  to integer, verifies legal range of each value.
;  For errors, applicable message is displayed and FALSE is returned.
;  For good data, all values are returned via addresses with TRUE returned.

;  Command line format (fixed order):
;	<-s|-p> -l <vegismalNumber>

; -----
;  Arguments:
;	1) ARGC, value
;	2) ARGV, address
;	3) sequential(bool), address
;	4) prime limit (dword), address

global getParams
getParams:

	push rdi
	push rsi

	mov r15, rdi
	mov r14, rsi
	
	cmp rdi,3
	jg error1
	cmp rdi,3
	jl error2

	cmp rdi,0
	je usage
	
	mov rdx,qword[r14+1*8]
	mov rcx,qword[r14+3*8]
	
	pop rsi 
	pop rdi
	
	



; ******************************************************************
;  Function: Check and convert ASCII/vegismal to integer
;	return false 

;  Example HLL Call:
;	stat = vegismal2int(vStr, &num);

global	vegismal2int
vegismal2int:

	push rdi

	mov r15,0;index
	mov rbx,0;running sum
	mov r13,0;push count
	mov r14,0
infovigilp:
mov r14b,byte[rdi+r15]
cmp r14,NULL
je vigilps
push r14
inc r13
jmp infovigilp
vigilps:
dec r13
mov rax,0

vigilp:
	cmp r13,0
	jl finishvigilp

	pop r14
	
	cmp r14,"9"
	jle digivigilp
	
	cmp r14,"H"
	jle AHvigilp
	
	cmp r14, "K"
	jle JKvigilp
incrementvigilp:
	dec r13
	jmp vigilp
	
JKvigilp:
	sub r14,"J"
	add r14,18
	mov rax,0
	mov rdx,0
	mov eax,r13d
	mov ebx,20
	imul ebx
	add eax, r14d
	add ebx, eax
	jmp incrementvigilp
AHvigilp:
	sub r14,"A"
	add r14,10
	mov rax,0
	mov rdx,0
	mov eax,r13d
	mov ebx,20
	imul ebx
	add eax, r14d
	add ebx, eax
	jmp incrementvigilp
digivigilp:
	sub r14,"0"
	mov rax,0
	mov rdx,0
	mov eax,r13d
	mov ebx,20
	imul ebx
	add eax, r14d
	add ebx, eax
	jmp incrementvigilp

finishvigilp:
	mov qword[rsi],rbx
	
	pop rdi
	
	ret
; ******************************************************************

