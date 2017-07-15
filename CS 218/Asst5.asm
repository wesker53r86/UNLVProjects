; *****************************************************************

section	.data

; -----
;  Define constants.

NULL		equ	0			; end of string

TRUE		equ	1
FALSE		equ	0

EXIT_SUCCESS	equ	0			; successful operation
SYS_exit	equ	60			; call code for terminate

; -----
;  Data Set

widths		dw	 148,  194,  162,  163,  118
		dw	 161,  145,  152,  129,  165
		dw	 112,  100,  185,  163,  125
		dw	 176,  147,  155,  110,  113
		dw	 108,  145,  161,  164,  165
		dw	 177,  120,  156,  147,  161
		dw	 152,  119,  165,  161,  131
		dw	 165,  114,  123,  115,  114

heights		dw	 233,  214,  223,  211,  234
		dw	 212,  200,  285,  263,  205
		dw	 264,  213,  224,  213,  265
		dw	 244,  212,  213,  212,  223
		dw	 265,  264,  273,  216,  234
		dw	 253,  213,  243,  213,  235
		dw	 244,  169,  234,  233,  232
		dw	 234,  223,  215,  214,  201

lengths		dd	1145, 1134, 1123, 1123, 1123
		dd	1153, 1153, 1243, 1153, 1135
		dd	1134, 1134, 1156, 1164, 1142
		dd	1153, 1153, 1184, 1142, 1134
		dd	1145, 1134, 1123, 1123, 1123
		dd	1134, 1134, 1156, 1164, 1142
		dd	1153, 1153, 1184, 1142, 1134
		dd	1156, 1164, 1142, 1134, 1001

length		dd	40

baMin		dd	0
baEstMed	dd	0
baMax		dd	0
baSum		dd	0
baAve		dd	0

vMin		dd	0
vEstMed		dd	0
vMax		dd	0
vSum		dd	0
vAve		dd	0

saMin		dd	0
saEstMed	dd	0
saMax		dd	0
saSum		dd	0
saAve		dd	0

dVarA		dd	0
dVarB		dd	0
dVarC		dd	0
dVarD		dd	0
dVarCo		dd	0

dVarX		dd	0
dVarY		dd	0
dVarZ		dd	0
; -----
; Additional variables (if any)


; --------------------------------------------------------------
; Uninitialized data

section	.bss

baseAreas	resd	40
volumes		resd	40
surfaceAreas	resd	40

; *****************************************************************

section	.text
global _start
_start:

; -----
;-------------------------------------------Base
;baMin
mov edx, 0
mov rsi, 0
mov eax, dword[lengths+rsi*4]
mov dword[dVarA], eax
movzx eax, word[widths+rsi*2]
mul dword[dVarA]
mov dword[dVarCo],eax

inc rsi

baMinlp:
mov edx,0
mov eax,0
cmp rsi, 40
je next1

mov eax,dword[lengths+rsi*4]
mov dword[dVarA],eax
movzx eax,word[widths+rsi*2]
mul dword[dVarA]
cmp eax,dword[dVarCo]
jb baMinEx
inc rsi
loop baMinlp

baMinEx:
mov dword[dVarCo], eax
inc rsi
loop baMinlp

next1:
mov eax,dword[dVarCo]
mov dword[baMin],eax

;baEstMed

mov edx, 0
mov rsi,0
mov eax,dword[lengths+rsi*4]
mov dword[dVarA],eax
movzx eax,word[widths+rsi*2]
mul dword[dVarA]
add dword[baEstMed],eax
mov edx,0

mov rsi,39
mov eax,dword[lengths+rsi*4]
mov dword[dVarA],eax
movzx eax,word[widths+rsi*2]
mul dword[dVarA]
add dword[baEstMed],eax
mov edx,0

mov rsi,19
mov eax,dword[lengths+rsi*4]
mov dword[dVarA],eax
movzx eax,word[widths+rsi*2]
mul dword[dVarA]
add dword[baEstMed],eax
mov edx,0

mov rsi,20
mov eax,dword[lengths+rsi*4]
mov dword[dVarA],eax
movzx eax,word[widths+rsi*2]
mul dword[dVarA]
add dword[baEstMed],eax
mov edx,0

mov eax,dword[baEstMed]
mov ebx,4
div ebx
mov dword[baEstMed],eax

loop next2


next2:

;baMax
mov eax,0
mov edx,0
mov rsi,0
mov eax,dword[lengths+rsi*4]
mov dword[dVarA],eax
movzx eax, word[widths+rsi*2]
mul dword[dVarA]
mov dword[dVarCo],eax
inc rsi

baMaxlp:
mov edx,0
mov eax,0
cmp rsi, 40
je next3
mov eax, dword[lengths+rsi*4]
mov dword[dVarA],eax
movzx eax, word[widths+rsi*2]
mul dword[dVarA]
cmp eax,dword[dVarCo]
ja baMaxEx
inc rsi
loop baMaxlp

baMaxEx:
mov dword[dVarCo],eax
inc rsi
loop baMaxlp

next3:
mov eax, dword[dVarCo]
mov dword[baMax],eax


;baSum
mov eax, 0
mov edx, 0
mov rsi, 0

mov eax, dword[lengths+rsi*4]
mov dword[dVarA],eax
movzx eax, word[widths+rsi*2]
mul dword[dVarA]
mov dword[dVarCo],eax
inc rsi

baSumlp:
mov eax, 0
mov edx, 0
cmp rsi,40
je next4
mov eax, dword[lengths+rsi*4]
mov dword[dVarA],eax
movzx eax, word[widths+rsi*2]
mul dword[dVarA]
add dword[dVarCo],eax
inc rsi
loop baSumlp

next4:
mov eax, dword[dVarCo]
mov dword[baSum],eax

;baAve
mov edx,0
mov eax,dword[baSum]
mov ebx,dword[length]
div ebx
mov dword[baAve],eax
loop next5

;-----------------------------------------------------Volume
next5:
;vMin
mov eax,0
mov edx,0
mov rsi,0

mov eax,dword[lengths+rsi*4]
mov dword[dVarA],eax
movzx eax, word[widths+rsi*2]
mov dword[dVarB],eax
movzx eax, word[heights+rsi*2]
mov dword[dVarC],eax
mov eax, dword[dVarA]
mul dword[dVarB]
mul dword[dVarC]

mov dword[dVarCo],eax
inc rsi

vMinlp:
mov edx,0
mov eax,0
cmp rsi,40
je next6

mov eax,dword[lengths+rsi*4]
mov dword[dVarA],eax
movzx eax, word[widths+rsi*2]
mov dword[dVarB],eax
movzx eax, word[heights+rsi*2]
mov dword[dVarC],eax
mov eax, dword[dVarA]
mul dword[dVarB]
mul dword[dVarC]

cmp eax,dword[dVarCo]
jl vMinEx
inc rsi
loop vMinlp

vMinEx:
mov dword[dVarCo],eax
inc rsi
loop vMinlp

next6:
mov eax, dword[dVarCo]
mov dword[vMin],eax

;vEstMed
mov edx,0
mov eax,0

mov rsi, 0

mov eax,dword[lengths+rsi*4]
mov dword[dVarA],eax
movzx eax, word[widths+rsi*2]
mov dword[dVarB],eax
movzx eax, word[heights+rsi*2]
mov dword[dVarC],eax
mov eax, dword[dVarA]
mul dword[dVarB]
mul dword[dVarC]
add dword[vEstMed],eax

mov rsi, 39

mov eax,dword[lengths+rsi*4]
mov dword[dVarA],eax
movzx eax, word[widths+rsi*2]
mov dword[dVarB],eax
movzx eax, word[heights+rsi*2]
mov dword[dVarC],eax
mov eax, dword[dVarA]
mul dword[dVarB]
mul dword[dVarC]
add dword[vEstMed],eax

mov rsi, 19

mov eax,dword[lengths+rsi*4]
mov dword[dVarA],eax
movzx eax, word[widths+rsi*2]
mov dword[dVarB],eax
movzx eax, word[heights+rsi*2]
mov dword[dVarC],eax
mov eax, dword[dVarA]
mul dword[dVarB]
mul dword[dVarC]
add dword[vEstMed],eax

mov rsi, 20
mov eax,dword[lengths+rsi*4]
mov dword[dVarA],eax
movzx eax, word[widths+rsi*2]
mov dword[dVarB],eax
movzx eax, word[heights+rsi*2]
mov dword[dVarC],eax
mov eax, dword[dVarA]
mul dword[dVarB]
mul dword[dVarC]
add dword[vEstMed], eax


next7:

;vMax
mov edx,0
mov eax,0
mov rsi,0

mov eax,dword[lengths+rsi*4]
mov dword[dVarA],eax
movzx eax, word[widths+rsi*2]
mov dword[dVarB],eax
movzx eax, word[heights+rsi*2]
mov dword[dVarC],eax
mov eax, dword[dVarA]
mul dword[dVarB]
mul dword[dVarC]

mov dword[dVarCo],eax
inc rsi

vMaxlp:
mov edx,0
mov eax,0
cmp rsi,40
je next8

mov eax,dword[lengths+rsi*4]
mov dword[dVarA],eax
movzx eax, word[widths+rsi*2]
mov dword[dVarB],eax
movzx eax, word[heights+rsi*2]
mov dword[dVarC],eax
mov eax, dword[dVarA]
mul dword[dVarB]
mul dword[dVarC]

cmp eax,dword[dVarCo]
ja vMaxEx

inc rsi
loop vMaxlp

vMaxEx:
mov dword[dVarCo],eax
inc rsi
loop vMaxlp

next8:
mov eax,dword[dVarCo]
mov dword[vMax],eax

;vSum

mov edx,0
mov eax,0
mov rsi,0

vSumlp:
mov edx,0
cmp rsi,40
je next9

mov eax,dword[lengths+rsi*4]
mov dword[dVarA],eax
movzx eax, word[widths+rsi*2]
mov dword[dVarB],eax
movzx eax, word[heights+rsi*2]
mov dword[dVarC],eax
mov eax, dword[dVarA]
mul dword[dVarB]
mul dword[dVarC]

add dword[vSum],eax
inc rsi
loop vSumlp



next9:

;vAve
mov edx,0
mov ebx,dword[length]
mov eax,dword[vSum]
div ebx
mov dword[vAve],eax


;-----------------------------------------Surface Area
next10:
;saMin
mov edx,0
mov eax,0
mov rsi,0

;----
mov dword[dVarD],0

mov eax,dword[lengths+rsi*4]
mov dword[dVarA],eax
movzx eax,word[widths+rsi*2]
mov dword[dVarB],eax
movzx eax,word[heights+rsi*2]
mov dword[dVarC],eax

mov eax,dword[dVarA]
mul dword[dVarB]
mov dword[dVarX],eax
mov eax,dword[dVarB]
mul dword[dVarC]
mov dword[dVarY],eax
mov eax,dword[dVarC]
mul dword[dVarA]
mov dword[dVarZ],eax

mov eax,dword[dVarX]
add dword[dVarD],eax
mov eax,dword[dVarY]
add dword[dVarD],eax
mov eax,dword[dVarZ]
add dword[dVarD],eax

mov ebx,2
mov eax,dword[dVarD]
mul ebx
;----
mov dword[dVarCo],eax
inc rsi


saMinlp:
mov edx,0
mov eax,0
cmp rsi,40
je next11

mov dword[dVarD],0

mov eax,dword[lengths+rsi*4]
mov dword[dVarA],eax
movzx eax,word[widths+rsi*2]
mov dword[dVarB],eax
movzx eax,word[heights+rsi*2]
mov dword[dVarC],eax

mov eax,dword[dVarA]
mul dword[dVarB]
mov dword[dVarX],eax
mov eax,dword[dVarB]
mul dword[dVarC]
mov dword[dVarY],eax
mov eax,dword[dVarC]
mul dword[dVarA]
mov dword[dVarZ],eax

mov eax,dword[dVarX]
add dword[dVarD],eax
mov eax,dword[dVarY]
add dword[dVarD],eax
mov eax,dword[dVarZ]
add dword[dVarD],eax

mov ebx,2
mov eax,dword[dVarD]
mul ebx

cmp eax,dword[dVarCo]
jb saMinEx
inc rsi
jmp saMinlp

saMinEx:
mov dword[dVarCo],eax
inc rsi
jmp saMinlp


next11:
mov eax, dword[dVarCo]
mov dword[saMin],eax


;saEstMed

mov edx,0
mov rsi,0


mov dword[dVarD],0
mov eax,dword[lengths+rsi*4]
mov dword[dVarA],eax
movzx eax,word[widths+rsi*2]
mov dword[dVarB],eax
movzx eax,word[heights+rsi*2]
mov dword[dVarC],eax

mov eax,dword[dVarA]
mul dword[dVarB]
mov dword[dVarX],eax
mov eax,dword[dVarB]
mul dword[dVarC]
mov dword[dVarY],eax
mov eax,dword[dVarC]
mul dword[dVarA]
mov dword[dVarZ],eax

mov eax,dword[dVarX]
add dword[dVarD],eax
mov eax,dword[dVarY]
add dword[dVarD],eax
mov eax,dword[dVarZ]
add dword[dVarD],eax

mov ebx,2
mov eax,dword[dVarD]
mul ebx

add dword[dVarCo],eax

mov rsi,39


mov dword[dVarD],0
mov eax,dword[lengths+rsi*4]
mov dword[dVarA],eax
movzx eax,word[widths+rsi*2]
mov dword[dVarB],eax
movzx eax,word[heights+rsi*2]
mov dword[dVarC],eax

mov eax,dword[dVarA]
mul dword[dVarB]
mov dword[dVarX],eax
mov eax,dword[dVarB]
mul dword[dVarC]
mov dword[dVarY],eax
mov eax,dword[dVarC]
mul dword[dVarA]
mov dword[dVarZ],eax

mov eax,dword[dVarX]
add dword[dVarD],eax
mov eax,dword[dVarY]
add dword[dVarD],eax
mov eax,dword[dVarZ]
add dword[dVarD],eax

mov ebx,2
mov eax,dword[dVarD]
mul ebx

add dword[dVarCo],eax

mov rsi,19


mov dword[dVarD],0
mov eax,dword[lengths+rsi*4]
mov dword[dVarA],eax
movzx eax,word[widths+rsi*2]
mov dword[dVarB],eax
movzx eax,word[heights+rsi*2]
mov dword[dVarC],eax

mov eax,dword[dVarA]
mul dword[dVarB]
mov dword[dVarX],eax
mov eax,dword[dVarB]
mul dword[dVarC]
mov dword[dVarY],eax
mov eax,dword[dVarC]
mul dword[dVarA]
mov dword[dVarZ],eax

mov eax,dword[dVarX]
add dword[dVarD],eax
mov eax,dword[dVarY]
add dword[dVarD],eax
mov eax,dword[dVarZ]
add dword[dVarD],eax

mov ebx,2
mov eax,dword[dVarD]
mul ebx

add dword[dVarCo],eax

mov rsi,20


mov dword[dVarD],0
mov eax,dword[lengths+rsi*4]
mov dword[dVarA],eax
movzx eax,word[widths+rsi*2]
mov dword[dVarB],eax
movzx eax,word[heights+rsi*2]
mov dword[dVarC],eax

mov eax,dword[dVarA]
mul dword[dVarB]
mov dword[dVarX],eax
mov eax,dword[dVarB]
mul dword[dVarC]
mov dword[dVarY],eax
mov eax,dword[dVarC]
mul dword[dVarA]
mov dword[dVarZ],eax

mov eax,dword[dVarX]
add dword[dVarD],eax
mov eax,dword[dVarY]
add dword[dVarD],eax
mov eax,dword[dVarZ]
add dword[dVarD],eax

mov ebx,2
mov eax,dword[dVarD]
mul ebx

add dword[dVarCo],eax

mov ebx,4
mov eax,dword[dVarCo]
div ebx
mov dword[saEstMed],eax

next12:

mov edx,0
mov eax,0
mov rsi,0

;----
mov dword[dVarD],0

mov eax,dword[lengths+rsi*4]
mov dword[dVarA],eax
movzx eax,word[widths+rsi*2]
mov dword[dVarB],eax
movzx eax,word[heights+rsi*2]
mov dword[dVarC],eax

mov eax,dword[dVarA]
mul dword[dVarB]
mov dword[dVarX],eax
mov eax,dword[dVarB]
mul dword[dVarC]
mov dword[dVarY],eax
mov eax,dword[dVarC]
mul dword[dVarA]
mov dword[dVarZ],eax

mov eax,dword[dVarX]
add dword[dVarD],eax
mov eax,dword[dVarY]
add dword[dVarD],eax
mov eax,dword[dVarZ]
add dword[dVarD],eax

mov ebx,2
mov eax,dword[dVarD]
mul ebx
;----
mov dword[dVarCo],eax
inc rsi


saMaxlp:
mov edx,0
mov eax,0
cmp rsi,40
je next13


mov dword[dVarD],0
mov eax,dword[lengths+rsi*4]
mov dword[dVarA],eax
movzx eax,word[widths+rsi*2]
mov dword[dVarB],eax
movzx eax,word[heights+rsi*2]
mov dword[dVarC],eax

mov eax,dword[dVarA]
mul dword[dVarB]
mov dword[dVarX],eax
mov eax,dword[dVarB]
mul dword[dVarC]
mov dword[dVarY],eax
mov eax,dword[dVarC]
mul dword[dVarA]
mov dword[dVarZ],eax

mov eax,dword[dVarX]
add dword[dVarD],eax
mov eax,dword[dVarY]
add dword[dVarD],eax
mov eax,dword[dVarZ]
add dword[dVarD],eax

mov ebx,2
mov eax,dword[dVarD]
mul ebx

cmp eax,dword[dVarCo]
ja saMaxEx
inc rsi
jmp saMaxlp

saMaxEx:
mov dword[dVarCo],eax
inc rsi
jmp saMaxlp


next13:
mov eax, dword[dVarCo]
mov dword[saMax],eax

;saSum
mov rsi,0
mov ebx,0
mov eax,0
mov edx,0

saSumlp:
cmp rsi,40
je next14

;----
mov dword[dVarD],0

mov eax,dword[lengths+rsi*4]
mov dword[dVarA],eax
movzx eax,word[widths+rsi*2]
mov dword[dVarB],eax
movzx eax,word[heights+rsi*2]
mov dword[dVarC],eax

mov eax,dword[dVarA]
mul dword[dVarB]
mov dword[dVarX],eax
mov eax,dword[dVarB]
mul dword[dVarC]
mov dword[dVarY],eax
mov eax,dword[dVarC]
mul dword[dVarA]
mov dword[dVarZ],eax

mov eax,dword[dVarX]
add dword[dVarD],eax
mov eax,dword[dVarY]
add dword[dVarD],eax
mov eax,dword[dVarZ]
add dword[dVarD],eax

mov ebx,2
mov eax,dword[dVarD]
mul ebx
;----

add dword[saSum],eax
inc rsi
jmp saSumlp

;saAve
next14:
mov edx,0
mov eax,dword[saSum]
mov ebx,dword[length]
div ebx
mov dword[saAve],eax



; *****************************************************************
;	Done, terminate program.

last:
	mov	eax, SYS_exit		; call call for exit (SYS_exit)
	mov	ebx, EXIT_SUCCESS	; return code of 0 (no error)
	syscall