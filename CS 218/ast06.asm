;  CS 218, Assignment #6
;	Jason Kyle De Lara
;	assignmnet 6
;	section 1001

;  Write a simple assembly language program to calculate
;  calculate the base area of each rectangulat prism in
;  a series of rectangular prism's.

;  The lengths are provided as vigesimal (base 20) values
;  represented as ASCII characters and must be converted
;  into integer in order to perform the calculations.

; --------------------------------------------------------------
;  Macro to convert vigesimal value in ASCII format into an integer.
;  Assumes valid data, no error checking is performed.

;  Call:  vigesimal2int  <stringAddr>, <integerAddr>, <stringLength>
;	Arguments:
;		%1 -> <stringAddr>, string address
;		%2 -> <integerAddr>, address for integer result
;		%3 -> <stringLength>, immediate value

;  Reads <stringAddr>, converts to integer and places in <integer>
;  Note, should preserve any registers that the macro alters.

; Note,	<stringAddr> is passed as address in RSI
;	<integerAddr> is passed as address on RDI
;	<stringLength> is passed as an immediate value

%macro	vigesimal2int	3
	push	rcx
	push	rsi
	push	rdi

	lea	rsi, [%1]			; string address (example)
	lea	rdi, [%2]			; integer address (example)

	mov rcx, 0
	movsx r15, byte[rsi+rcx]					;sign
	mov rax, 0					;sum
	inc rcx
%%startLP:
	
	movsx r8, byte[rsi+rcx]	
	
	cmp r8, NULL
	je %%exitLP

	cmp r8, 57
	jle %%A	
	cmp r8, 72
	jle %%B
	cmp r8, 75
	jle %%C

%%A:	cmp r8, 48
	jge %%con1	
%%B:	cmp r8, 65
	jge %%con2
%%C:	cmp r8, 74
	jge %%con3		
	

%%con1:
	sub r8, 48
	jmp %%endOfCon
%%con2:
	sub r8, 65
	add r8, 10
	jmp %%endOfCon
%%con3:
	sub r8, 74
	add r8, 18
	jmp %%endOfCon


%%endOfCon:
	
	imul rax, 20
	add rax, r8

	inc rcx
	jmp %%startLP

%%exitLP:
	cmp r15,45
	jne %%done
	imul rax, -1
%%done:
	mov qword[rdi], rax

	pop	rdi
	pop	rsi
	pop	rcx

%endmacro

; --------------------------------------------------------------
;  Macro to convert integer to vigesimal value in ASCII format.

;  Call:  int2vigesimal    <integer>, <stringAddr>, <stringLength>
;	Arguments:
;		%1 -> <integer>, value
;		%2 -> <stringAddr>, string address
;		%3 -> <stringLength>, immediate value

; Reads <integer>, place <stringLenth> characters,
;	including the sign and NULL, into <stringAddr>
; Note, should preserve any registers that the macro alters.

; Note,	<integer> is passed as value in RSI
;	<stringAddr> is passed as address on RDI
;	<stringLength> is passed as an immediate value

%macro	int2vigesimal	3
	push	rcx
	push	rdx
	push	rsi
	push	rdi
	push	r8

	mov eax, dword[%1]
	mov rcx, 0
	mov ebx, 20
	mov r15, %3
	sub r15, 2

	cmp eax,0
	jle %%negative
	mov r10,43
	jmp %%divide
%%negative:
	mov r8, -1
	imul r8
	mov r10,45

%%divide:
	mov edx,0
	idiv ebx
	push rdx
	inc rcx
	cmp rcx, r15
	jne %%divide
	lea rbx, [%2]
	mov rdi, 0
	mov qword[rbx+rdi], r10
	inc rdi
%%stackloop:
	pop rax	

	cmp rax,9
	jle %%con4
	cmp rax,17
	jle %%con5
	cmp rax,19
	jle %%con6
	
%%con4:	cmp rax,0
	jge %%D
%%con5:	cmp rax,10
	jge %%E
%%con6:	cmp rax,18		
	jge %%F

%%D:	
	add rax, "0"
	jmp %%done
%%E:
	add rax, "A"
	sub rax, 10
	jmp %%done
%%F:
	add rax, "A"
	sub rax, 9
	jmp %%done

%%done:
	mov qword[rbx+rdi], rax
	inc rdi
	loop %%stackloop
	mov byte[rbx+rdi], NULL

	pop	r8
	pop	rdi
	pop	rsi
	pop	rdx
	pop	rcx
%endmacro

; --------------------------------------------------------------
;  Simple macro to display a string to the console.
;	Call:	printString  <stringAddr>

;	Arguments:
;		%1 -> <stringAddr>, string address

;  Count characters (excluding NULL).
;  Display string starting at address <stringAddr>

%macro	printString	1
	push	rax			; save altered registers
	push	rdi
	push	rsi
	push	rdx
	push	rcx

	mov	rdx, 0
	mov	rdi, %1
%%countLoop:
	cmp	byte [rdi], NULL
	je	%%countLoopDone
	inc	rdi
	inc	rdx
	jmp	%%countLoop
%%countLoopDone:

	mov	rax, SYS_write		; system call for write (SYS_write)
	mov	rdi, STDOUT		; standard output
	mov	rsi, %1			; address of the string
	syscall				; call the kernel

	pop	rcx			; restore registers to original values
	pop	rdx
	pop	rsi
	pop	rdi
	pop	rax
%endmacro

; --------------------------------------------------------------

section	.data

; -----
;  Define constants.

TRUE		equ	1
FALSE		equ	0

EXIT_SUCCESS	equ	0			; Successful operation

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

LF		equ	10
SPACE		equ	" "
NULL		equ	0
ESC		equ	27

NUMS_PER_LINE	equ	5

; -----
;  Assignment #6 Provided Data

STR_LENGTH	equ	10

lengths		db	"+00001A2K", NULL, "-0000J213", NULL, "+00001G30", NULL
		db	"-0000J914", NULL, "+00007GK2", NULL, "-00001CD8", NULL
		db	"+0000F212", NULL, "+0000GHKJ", NULL, "+00000294", NULL
		db	"+000017B4", NULL, "+00001G1C", NULL, "+0000CEK4", NULL
		db	"+00001J51", NULL, "-000025GK", NULL, "+00001345", NULL
		db	"+00001H43", NULL, "+00003943", NULL, "+000014E5", NULL
		db	"+00005D22", NULL, "+00000275", NULL, "+0000121J", NULL
		db	"+0000E1K3", NULL, "+0000D655", NULL, "+0000321K", NULL
		db	"+00001K53", NULL, "+00003DK4", NULL, "+00001214", NULL
		db	"+00001A51", NULL, "+00001DK1", NULL, "+00003F21", NULL
		db	"+000025D3", NULL, "+00001J72", NULL, "+00002999", NULL
		db	"+00001CK5", NULL, "+00002E53", NULL, "+00002143", NULL
		db	"+0000AC53", NULL, "+00001KF3", NULL, "+00002A43", NULL
		db	"+0000BK12", NULL

widths		db	"+000001DE", NULL, "+000002K8", NULL, "+00000K35", NULL
		db	"+00000C12", NULL, "-000002J5", NULL, "+00000J41", NULL
		db	"+000003B5", NULL, "+000005H4", NULL, "+00000H51", NULL
		db	"+00000A45", NULL, "+000003G3", NULL, "+00000G25", NULL
		db	"+00000K93", NULL, "-00000F14", NULL, "+00000F23", NULL
		db	"+000002K1", NULL, "+00000415", NULL, "+0000032H", NULL
		db	"+000001H4", NULL, "+00000152", NULL, "+000001F1", NULL
		db	"+000005F2", NULL, "+00000231", NULL, "+000003E2", NULL
		db	"+000004E2", NULL, "+00000151", NULL, "+0000045D", NULL
		db	"+000001D2", NULL, "+00000511", NULL, "+0000051B", NULL
		db	"+000003C4", NULL, "+00000332", NULL, "+000002A5", NULL
		db	"+000004B5", NULL, "+00000143", NULL, "+00000251", NULL
		db	"+000001A3", NULL, "+00000234", NULL, "+00000D43", NULL
		db	"+000002F2", NULL

len		dd	40

baseAreasSum	dd	0
baseAreasAve	dd	0
baseAreasMax	dd	0
baseAreasMin	dd	0

; -----
;  Misc. variables for main.

hdr		db	"------------------------------------"
		db	"-------------------------"
		db	LF, ESC, "[1m", "CS 218 - Assignment #6"
		db	ESC, "[0m", LF
		db	"Rectangular Prism Base Areas", LF, LF
		db	"Base Area's:", LF, NULL

sHdr		db	LF, "Base Area's Sum:  ", NULL
avHdr		db	LF, "Base Area's Ave:  ", NULL
minHdr		db	LF, "Base Area's Min:  ", NULL
maxHdr		db	LF, "Base Area's Max:  ", NULL

numCount	dd	0
tempNum		dd	0

newLine		db	LF, NULL
dTwenty		dd	20
dTwo		dd	2
spaces		db	"   ", NULL

; --------------------------------------------------------------
;  Uninitialized (empty) variables

section	.bss

tmpString	resb	20
intLengths	resd	42
intWidths	resd	42
baseAreas	resd	42

; --------------------------------------------------------------

section	.text
global	_start
_start:

; -----
;  Display assignment initial headers.

	printString	hdr

; -----
;  Convert vigesimal data, in ASCII format, to integer.

	mov	ecx, dword [len]
	mov	rsi, lengths
	mov	rdi, intLengths

cvtLloop:
	vigesimal2int	rsi, rdi, STR_LENGTH

	add	rsi, STR_LENGTH
	add	rdi, 4

	dec	ecx
	cmp	ecx, 0
	jne	cvtLloop

	mov	ecx, dword [len]
	mov	rsi, widths
	mov	rdi, intWidths

cvtWloop:
	vigesimal2int	rsi, rdi, STR_LENGTH

	add	rsi, STR_LENGTH
	add	rdi, 4

	dec	ecx
	cmp	ecx, 0
	jne	cvtWloop
; -----
;  Calculate the rectangle prism base areas
;  Also find areas sum, average, min, and max.

	mov ecx, dword[len]
	mov rsi,0
	

startLp:
	mov eax, dword[intLengths+rsi*4]
	mov r8d, dword[intWidths+rsi*4]
	imul r8d
	mov dword[baseAreas+rsi*4],eax

	inc rsi
	dec ecx
	cmp ecx,0
	jne startLp
	
	mov rsi,0
	mov ecx, dword[len]
	mov eax, dword[baseAreas+rsi*4]
	mov dword[baseAreasMin],eax
	mov dword[baseAreasMax],eax
	mov dword[baseAreasSum],0
baSumLp:	
	mov eax, dword[baseAreas+rsi*4]
	add dword[baseAreasSum],eax
	cmp eax, dword[baseAreasMin]
	jge baMinDone
	mov dword[baseAreasMin], eax
baMinDone:
	cmp eax, dword[baseAreasMax]
	jle baMaxDone
	mov dword[baseAreasMax], eax
baMaxDone:
	inc rsi
	dec ecx
	cmp ecx,0
	jne baSumLp

	mov eax, dword[baseAreasSum]
	mov edx, 0
	mov r9d,2	
	idiv r9d
	mov dword[baseAreasAve],eax

; -----
;  Convert vigesimal data, in ASCII format, to integer.
;  Display the rectangle base areas.
;  For every 5th line, print a newLine (for formatting).

	mov	ecx, dword [len]
	mov	rdi, intLengths
	mov	rsi, 0
	mov	dword [numCount], 0

cvtBAloop:
	mov	eax, dword [baseAreas+rsi*4]
	mov	dword [tempNum], eax

	int2vigesimal	tempNum, tmpString, STR_LENGTH
	printString	tmpString
	printString	spaces

	inc	dword [numCount]
	cmp	dword [numCount], NUMS_PER_LINE
	jl	skipNewline1
	printString	newLine
	mov	dword [numCount], 0
skipNewline1:

	inc	rsi
	dec	rcx
	cmp	rcx, 0
	jne	cvtBAloop

; -----
;  Convert sum, average, minimum, and maximum to
;	vigesimal, in ASCII format, for printing.

	printString	sHdr
	int2vigesimal	baseAreasSum, tmpString, 12
	printString	tmpString

	printString	avHdr
	int2vigesimal	baseAreasAve, tmpString, 12
	printString	tmpString

	printString	minHdr
	int2vigesimal	baseAreasMin, tmpString, 12
	printString	tmpString

	printString	maxHdr
	int2vigesimal	baseAreasMax, tmpString, 12
	printString	tmpString

	printString	newLine
	printString	newLine

; -----
; Done, terminate program.

last:
	mov	rax, SYS_exit
	mov	rbx, EXIT_SUCCESS
	syscall


