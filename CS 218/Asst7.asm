; CS 218
;Rehum Mikaelo Padua
; Assignment #7
;Section 1001

; Sort a list of number using the insertion sort algorithm.
; Also finds the minimum, median, maximum, and average of the list.

; -----
; Insertion Sort

;	insertionSort(array Arr) {
;		for i = 1 to length-1 do {
;			value := Arr[i];
;			j = i - 1;
;			while ( (j ≥ 0) and (Arr[j] > value) ) {
;				Arr[j+1] = Arr[j];
;				j = j - 1;
;			};
;			Arr[j+1] = value;
;		};
;	};

; --------------------------------------------------------------
;  Macro to convert integer to vigesimal value in ASCII format.


%macro	int2vigesimal	3
	push	rcx
	push	rdx
	push	rsi
	push	rdi
	push	r8

;--------------------
mov eax, dword [%1]
mov r9,%3
sub r9,2
mov rcx,0
mov ebx,20

cmp eax,0
jle %%negative
mov r11,43
jmp%%pushloop

%%negative:
mov r8,-1
imul r8
mov r11,45

%%pushloop:
mov edx,0
idiv ebx
push rdx
inc rcx
cmp rcx,r9
jne %%pushloop
lea rbx,[%2]

mov rdi,0
mov qword[rbx+rdi],r11
inc rdi
%%poploop:
pop rax
cmp rax,18
jge %%JKintcalc
cmp rax,10
jge %%ABintcalc
cmp rax,0
jge %%09intcalc

%%poploop2:
mov qword[rbx+rdi],rax
inc rdi
loop %%poploop

mov byte[rbx+rdi],NULL

jmp %%next19


;---------------------
%%JKintcalc:
add rax,"A"
sub rax,9
jmp %%poploop2
%%ABintcalc:
add rax,"A"
sub rax,10
jmp %%poploop2
%%09intcalc:
add rax,"0"
jmp %%poploop2

%%next19:

pop r8
pop rdi
pop rsi
pop rdx
pop rcx

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



; ---------------------------------------------

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
NULL		equ	0
ESC		equ	27

LIMIT		equ	10000
STR_LENGTH	equ	12

; -----
;  Provided data

lst	dd	 -147,  1123,  2245,  4440,  -165
	dd	    1,    54,    28,    13,  -222
	dd	   69,  -126,  -571,  -147,  -228
	dd	   27,     0,  -177,   -75,    14
	dd	 -181,    25,    15,    22, -1217
	dd	    1,    10,  -129,  -212,  -134
	dd	  127,    64,  -140,   172,    24
	dd	  125,    16,    62,     8,    92
	dd	-2161,  -134,   151,    32,    12
	dd	   29,   114,    22,  -113,  1131
	dd	 1113, -1232,  2146,  3376,  5120
	dd	 2356,  3164, 34565,  3155, 23157
	dd	-1001,   128,    33,   105,  8327
	dd	  101,   115,   108, 12233, -2115
	dd	 1227,  1226,  5129,   117,   107
	dd	  105,   109,   730,  -150,  3414
	dd	 1107,  6103,  1245,  6440,   465
	dd	 2311,   254,  4528,   913,  6722
	dd	-1149,  2126,  5671,  4647,  4628
	dd	 -327, -2390,   177,  8275,  5614
	dd	 3121,   415,  -615,    22,  7217
	dd	  -11,    10,   129,  -812,  2134
	dd	-1221,   -34,  6151,   432,   114
	dd	  629,   114,   522,  2413,   131
	dd	 5639,   126,    62,    41,   127
	dd	 -877,   199,  5679,   101,  3414
	dd	  117,    54,    40,  -172,  4524
	dd	  125,    16,  9762,     0, 11292
	dd	-2101,   133,   133,    50,  4532
	dd	 8619,    15,  1618,   113,  -115
	dd	 1219,  3116,   -62,    17,   127
	dd	 6787,  4569,    79, 15675,    14
	dd	 1104,  6825,    84,    43,    76
	dd	  134, -4626,   100,  4566,  2346
	dd	   14,  6786,   617,   183, -3512
	dd	 7881, -8320,  3467,  4559, -1190
	dd	  103,   112,   146,   186,   191
	dd	  186,   134,  1125, -5675,  3476
	dd	 2137,  2113, -1647,   114,    15
	dd	-6571, -7624,   128,   113,  3112
	dd	  724,  6316,    17,   183, -4352
	dd	 1121,   320,  4540,  5679, -1190
	dd	 9125,   116,  -122,   117,   127
	dd	 5677,   101,  3727,   125,  3184
	dd	 1897,  6374,   190,     3,    24
	dd	  125,   116,  8126,  6784, 12329
	dd	 1104,   124,  -112,   143,   176
	dd	 7534,  2126,  6112,   156,  1103
	dd	 6759,  6326,  2171,  -147, -5628
	dd	 7527,  7569,  3177,  6785,  3514
	dd	  153,   172,  5146,   176,   170
	dd	 1156,   164,  4165,  -155,  5156
	dd	  894,  6325,  2184,    43,    76
	dd	 5634,  7526,  3413,  7686,  7563
	dd	 2147,   113,  -143,   140,   165
	dd	  191,   154,  2168,   143,   162
	dd	 -511,  6383,  -133,    50,  -825
	dd	 5721,  5615,  4568,  7813,  1231
	dd	  169,   146,  1162,   147,   157
	dd	  167,   169,  2177,   175,  2144
	dd	 5527,  6364,  -330,   172,    24
	dd	 7525,  5616,  5662,  6328,  2342
	dd	  181,   155,  2145,   132,   167
	dd	  185,   150,  5149,   182,   434
	dd	 6581,  3625,  6315,     9,  -617
	dd	 7855, 16737,  6129,  4512,   134
	dd	  177,   164,  3160,   172,   184
	dd	  175,   166,  6762,   158,  4572
	dd	 6561,    83,  1133,   150,   135
	dd	 5631, -8185,  2178,   197,   185
	dd	  147,   123,  3645,    40, -1766
	dd	-3451, -1954,  4628, -1613,  5432
	dd	 5649,  6366,  2162,   167,   167
	dd	  177,   169,  2177,  -175,   169
	dd	 1161,   122,  1151,    32, -8770
	dd	   29,  5464, -3242, -1213,   131
	dd	 5684,   179,  2117,   183,   190
	dd	  100, -4611,  3123,  3122,  -131
	dd	 1123,  1142,  3146,    76,  5460
	dd	  156, 18964,  3466,   155,  4357
len	dd	400

min	dd	0
med	dd	0
max	dd	0
sum	dd	0
avg	dd	0

; -----
;  Misc. data definitions (if any).



; -----
;  Provided string definitions.

newLine		db	LF, NULL

hdr		db	LF, "---------------------------"
		db	"---------------------------"
		db	LF, ESC, "[1m", "CS 218 - Assignment #7", ESC, "[0m"
		db	LF, "Shell Sort", LF, LF, NULL

hdrMin		db	"Minimum:  ", NULL
hdrMax		db	"Maximum:  ", NULL
hdrMed		db	"Median:   ", NULL
hdrSum		db	"Sum:      ", NULL
hdrAve		db	"Average:  ", NULL

; ---------------------------------------------

section .bss

tmpString	resb	STR_LENGTH

; ---------------------------------------------

section	.text
global	_start
_start:

; ******************************

mov r10, 0
loopie1: ;for loop start
inc r10
cmp r10,400 ;r10 = i
je exitsort

mov eax,dword[lst+r10*4] ; rax = value
mov rbx,r10
dec rbx ;rbx = j=i-1

loopiecheck: ; while loop start
cmp rbx,0 ;if j < 0, end
jl whileloopiend

cmp dword[lst+rbx*4], eax ;if Arr[j] <= value, end
jle whileloopiend 

loopie2:
mov r8,rbx ;r8 = j
inc r8 ;r8=j+1
mov edx,dword[lst+rbx*4];rdx=Arr[j]
mov dword[lst+r8*4],edx ;Arr[j+1]=Arr[j]
dec rbx ;j=j-1
jmp loopiecheck ;while loop end

whileloopiend:
inc rbx ;j=j+1
mov dword[lst+rbx*4], eax ;Arr[j+1] = value
jmp loopie1 ;for loop end


exitsort:

;min
mov r10,0
mov eax, dword[lst+r10*4]
mov dword[min],eax

;max
mov ebx,dword[len]
dec ebx
mov eax, dword[lst+ebx*4]
mov dword[max],eax

;med
mov eax,dword[len]
mov edx,0
mov ebx, 2
idiv ebx
mov ebx, 0
mov eax, dword[lst+ebx*4]
dec eax
add eax,dword[lst+ebx*4]
mov dword[med],eax

mov rdx,0
mov rbx,0
mov rax,0
;sum
mov rsi,0
mov eax,0

sumlp: ;for loop start
cmp esi, dword[len];for(i=1,i<length,i++)
je exitsum

mov ebx,dword[lst+esi*4] ;Arr[i]
add dword[sum],ebx ;sum = sum+Arr[i]
inc esi ;i++
jmp sumlp
exitsum:

;ave
mov eax,dword[sum]
mov edx,0
mov ebx, dword[len]
idiv ebx
mov dword[avg],eax

; ******************************
;  Display results to screen in vigesimal.

	printString	hdr

	printString	hdrMin
	int2vigesimal	min, tmpString, STR_LENGTH
	printString	tmpString
	printString	newLine

	printString	hdrMax
	int2vigesimal	max, tmpString, STR_LENGTH
	printString	tmpString
	printString	newLine

	printString	hdrMed
	int2vigesimal	med, tmpString, STR_LENGTH
	printString	tmpString
	printString	newLine

	printString	hdrSum
	int2vigesimal	sum, tmpString, STR_LENGTH
	printString	tmpString
	printString	newLine

	printString	hdrAve
	int2vigesimal	avg, tmpString, STR_LENGTH
	printString	tmpString
	printString	newLine
	printString	newLine

; ******************************
;  Done, terminate program.

last:
	mov	rax, SYS_exit
	mov	rbx, EXIT_SUCCESS
	syscall

