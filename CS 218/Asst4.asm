;  Must include:
;	Rehum Mikaelo Padua
;	Assignment 04
;	Section 1001

; -----
;  Short description of program goes here...
;This program calculates the sum,average,median,maximum,and minimum of a list of variables.
;It also gets the count, sum, and average of odd numnbers, and numbers of divisor 9
; *****************************************************************
;  Static Data Declarations (initialized)

section	.data

; -----
;  Define standard constants.

NULL		equ	0			; end of string

TRUE		equ	1
FALSE		equ	0

EXIT_SUCCESS	equ	0			; Successful operation
SYS_exit	equ	60			; call code for terminate

; -----
;  Declare variables.

length	dd 100	


lst		dd	3717, 1116, 1539, 1240, 1674
		dd	1629, 2412, 1818, 1242,  333 
		dd	2313, 1215, 2726, 1140, 2565
		dd	2871, 1614, 2418, 2513, 1422 
		dd	1809, 1215, 1525,  712, 1441
		dd	3622,  891, 1729, 1615, 2724 
		dd	1217, 1224, 1580, 1147, 2324
		dd	1425, 1816, 1262, 2718, 1192 
		dd	1435, 1235, 2764, 1615, 1310
		dd	1765, 1954,  967, 1515, 1556 
		dd	 342, 7321, 1556, 2727, 1227
		dd	1927, 1382, 1465, 3955, 1435 
		dd	 225, 2419, 2534, 1345, 2467
		dd	1615, 1959, 1335, 2856, 2553 
		dd	1035, 1833, 1464, 1915, 1810
		dd	1465, 1554,  267, 1615, 1656 
		dd	2192,  825, 1925, 2312, 1725
		dd	2517, 1498,  677, 1475, 2034 
		dd	1223, 1883, 1173, 1350, 2415
		dd	1089, 1125, 1118, 1713, 3025

		
	
lstMin		dd	0
estMed		dd	0
lstMax		dd	0
lstSum		dd	0
lstAve		dd	0


oddCnt		dd	0
oddSum		dd	0
oddAve		dd	0

nineCnt		dd	0
nineSum		dd	0
nineAve		dd	0


; ----------------------------------------------
;  Uninitialized Static Data Declarations.

section	.bss

;	Place data declarations for uninitialized data here...
;	(i.e., large arrays that are not initialized)


; *****************************************************************

section	.text
global _start
_start:


; -----
;Estimated Median
mov rsi,0
mov eax,dword[estMed]
add eax,dword[lst+rsi*4]
mov rsi,100
add eax,dword[lst+rsi*4]
mov rsi,50
add eax,dword[lst+rsi*4]
mov rsi,51
add eax,dword[lst+rsi*4]
mov dword[estMed],eax



;lstMin

mov rsi,0
mov rax,0
mov esi,0
mov eax,0
mov ebx,0
mov ecx,0
mov edx,0
mov eax,dword[lst+rsi*4]
mov dword[lstMin],eax


minlp: 
mov eax, dword[lstMin]
inc rsi
mov ebx,dword[lst+rsi*4]
cmp eax,ebx
jb minlp
mov rax,rsi
mov dword[lstMin], ebx
cmp rsi,100
jne minlp
mov ecx,dword[lst+rax*4]
mov dword[lstMin],ecx



;lstMax

mov rsi,0
mov rax,0
mov esi,0
mov eax,0
mov ebx,0
mov ecx,0
mov edx,0
mov eax,dword[lst+rsi*4]
mov dword[lstMax],eax


maxlp: 
mov eax,dword[lstMax]
inc rsi
mov ebx,dword[lst+rsi*4]
cmp eax,ebx
jb newmax
cmp rsi,100
jne maxlp
loop maxdone

newmax:
mov dword[lstMax],ebx
cmp rsi,100
jne maxlp
loop maxdone

maxdone:
loop sumlp

sumlp:
mov rsi,0
mov eax,0
mov ebx,0
mov ecx,0
mov eax,dword[lst+rsi*4]
mov dword[lstSum],eax

addlp:
cmp rsi,100
je addfin
inc rsi
add eax,dword[lst+rsi*4]
loop addlp

addfin:
mov dword[lstSum],eax
loop avg

avg:
mov ebx,100
mov edx,0
div ebx
mov dword[lstAve],eax
loop odd

odd:
mov rsi,0
mov eax,0
mov ebx,0
mov ecx,0
mov edx,0
loop counto

counto:
mov rsi,0
mov eax,0
mov ebx,0
mov ecx,0
mov edx,0
loop countodd

countodd:
cmp rsi,100
je counterodd
mov ecx,2
mov edx,0
mov eax,dword[lst+rsi*4]
div ecx
cmp edx,0
jne addcountodd
inc rsi
loop countodd

addcountodd:
inc ebx
inc rsi
loop countodd


counterodd:
mov dword[oddCnt],ebx
loop sumo

sumo:
mov rsi,0
mov eax,0
mov ebx,0
mov ecx,0
mov edx,0
loop sumodd

sumodd:
cmp rsi,100
je summerodd
mov ecx,2
mov edx,0
mov eax,dword[lst+rsi*4]
div ecx
cmp edx,0
jne addsumodd
inc rsi
loop sumodd

addsumodd:
add ebx,dword[lst+rsi*4]
inc rsi
loop sumodd

summerodd:
mov dword[oddSum],ebx
loop aveo

aveo:
mov rsi,0
mov eax,0
mov ebx,0
mov ecx,0
mov edx,0
loop aveodd

aveodd:
mov edx,0
mov eax,dword[oddSum]
div dword[oddCnt]
mov dword[oddAve],eax
loop nine


nine:
mov rsi,0
mov eax,0
mov ebx,0
mov ecx,0
mov edx,0
loop ninecount

ninecount:
cmp rsi,100
je counternine
mov ecx,9
mov edx,0
mov eax,dword[lst+rsi*4]
div ecx
cmp edx,0
jne addcountnine
inc rsi
loop ninecount

addcountnine:
inc ebx
inc rsi
loop ninecount


counternine:
mov dword[nineCnt],ebx
loop ninesumo

ninesumo:
mov rsi,0
mov eax,0
mov ebx,0
mov ecx,0
mov edx,0
loop sumnine

sumnine:
cmp rsi,100
je summernine
mov ecx,9
mov edx,0
mov eax,dword[lst+rsi*4]
div ecx
cmp edx,0
jne addsumnine
inc rsi
loop sumnine

addsumnine:
add ebx,dword[lst+rsi*4]
inc rsi
loop sumnine

summernine:
mov dword[nineSum],ebx
loop nineaveo

nineaveo:
mov rsi,0
mov eax,0
mov ebx,0
mov ecx,0
mov edx,0
loop avenine

avenine:
mov edx,0
mov eax,dword[nineSum]
div dword[nineCnt]
mov dword[nineAve],eax


; *****************************************************************
;	Done, terminate program.

last:
	mov	eax, SYS_exit		; call call for exit (SYS_exit)
	mov	ebx, EXIT_SUCCESS	; return code of 0 (no error)
	syscall