;  Must include:
;	Name
;	Assignmnet Number
;	Section

; -----
;  Short description of program goes here...


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

NULL equ 0
bVar1	db	43
bVar2	db	24
bAns1	db	0
bAns2	db	0
wVar1	dw	5567
wVar2	dw	3724
wAns1	dw	0
wAns2	dw	0
dVar1	dd	258643176
dVar2	dd	120789321
dVar3	dd	-57142	
dAns1	dd	0
dAns2	dd	0
flt1	dd	9.5
flt2	dd	-13.125
threePi	dd	9.4247
qVar1	dq	214578927150
myClass db	"CS 218",NULL
edName	db	"Ed Jorgensen", NULL
myName	db	"your name goes here", NULL

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
mov al,byte[bVar1]
add al,byte[bVar2]
mov byte[bAns1],al

mov al, byte[bVar1]
sub al,byte[bVar2]
mov, byte[bAns2],al

mov ax,word[wVar1]
add ax,word[wVar2]
mov word[wAns1],ax

mov ax,word[wVar1]
sub ax,word[wVar2]
mov word[wAns2],ax

mov eax,dWord[dVar1]
add eax,dword[dVar2]
mov dword [dAns1],eax

mov eax,dWord[dVar1]
sub eax,dword[dVar2]
mov dword[dAns2],eax






; *****************************************************************
;	Done, terminate program.

last:
	mov	eax, SYS_exit		; call call for exit (SYS_exit)
	mov	ebx, EXIT_SUCCESS	; return code of 0 (no error)
	syscall