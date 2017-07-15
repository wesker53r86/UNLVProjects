;  Assignment #10
;  Support Functions -> Provided Template.

; -----
;  Function: getParams
;	Read, checks, and returns a, b, draw color and draw speed

;  Function plotLissajou()
;	Plots Lissajou function (as per provided algorithm).

; ---------------------------------------------------------
;	MACROS (if any) GO HERE

; ---------------------------------------------------------

section  .data

; -----
;  Define standard constants.

TRUE		equ	1
FALSE		equ	0

LF		equ	10
NULL		equ	0

SUCCESS		equ	0			; successful operation
NOSUCCESS	equ	1

STDIN		equ	0			; standard input
STDOUT		equ	1			; standard output
STDERR		equ	2			; standard error

SYS_read	equ	0			; code for read
SYS_write	equ	1			; code for write
SYS_open	equ	2			; code for file open
SYS_close	equ	3			; code for file close
SYS_fork	equ	57			; code for fork
SYS_exit	equ	60			; code for terminate
SYS_creat	equ	85			; code for file open/create
SYS_time	equ	201			; code for get time

; -----
;  OpenGL constants

GL_COLOR_BUFFER_BIT	equ	16384
GL_POINTS		equ	0
GL_POLYGON		equ	9
GL_PROJECTION		equ	5889

GLUT_RGB		equ	0
GLUT_SINGLE		equ	0

; -----
;  Local variables for getParams() function.

ABMIN		equ	1
ABMAX		equ	50
COLORMIN	equ	100
COLORMAX	equ	0x0ffffff
SPEEDMIN	equ	0
SPEEDMAX	equ	100

dTwenty		dd	20
tmpNum		dd	0

errUsage	db	"Usgae: lissajou -a <vigesimalNumber> ",
		db	"-b <vigesimalNumber> -dc <vigesimalNumber> "
		db	"-ds <vigesimalNumber>", LF, NULL

errOptions	db	"Error, invalid command line options."
		db	LF, NULL

errASpec	db	"Error, invalid A value specifier."
		db	LF, NULL
errAValue	db	"Error, A value out of range (1 - 2A)."
		db	LF, NULL

errBSpec	db	"Error, invalid B value specifier."
		db	LF, NULL
errBValue	db	"Error, B value out of range (1 - 2A)."
		db	LF, NULL

errDcSpec	db	"Error, invalid draw color specifier."
		db	LF, NULL
errDcValue	db	"Error, draw color value out of range (50 - 54H30F)."
		db	LF, NULL

errDsSpec	db	"Error, invalid draw speed specifier."
		db	LF, NULL
errDsValue	db	"Error, draw speed out value of range (1 - 50)."
		db	LF, NULL

; -----
;  Local variables for plotLissajou() routine.

t		dq	0.0
x		dq	1.0
y		dq	1.0
lpMax		dq	0.0

tOld		dq	0.0

fZero		dq	0.0
fTwo		dq	2.0
myPi		dq	3.14159365358979
circleDegrees	dq	36000.0

red		 	dq	0
green		dq	0
blue		dq	0

tStep		dq	0.0001			; t step
speed		dq	0.0			; circle deformation speed
scale		dq	10000.0			; scale factor for speed

a		dq	1.0001
b		dq	2.0

; ------------------------------------------------------------

section  .text

; -----
;  Open GL routines.

extern glutInit, glutInitDisplayMode, glutInitWindowSize
extern glutInitWindowPosition
extern glutCreateWindow, glutMainLoop
extern glutDisplayFunc, glutIdleFunc, glutReshapeFunc, glutKeyboardFunc
extern glutSwapBuffers
extern gluPerspective
extern glClearColor, glClearDepth, glDepthFunc, glEnable, glShadeModel
extern glClear, glLoadIdentity, glMatrixMode, glViewport
extern glTranslatef, glRotatef, glBegin, glEnd, glVertex3f, glColor3f
extern glVertex2f, glVertex2i, glColor3ub, glOrtho, glFlush, glVertex2d
extern glutPostRedisplay

extern	cos, sin

; ******************************************************************
;  Generic function to display a string to the screen.
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
	push	rbp
	mov	rbp, rsp
	push	rbx
	push	rsi
	push	rdi
	push	rdx

; -----
;  Count characters in string.

	mov	rbx, rdi			; str addr
	mov	rdx, 0
strCountLoop:
	cmp	byte [rbx], NULL
	je	strCountDone
	inc	rbx
	inc	rdx
	jmp	strCountLoop
strCountDone:

	cmp	rdx, 0
	je	prtDone

; -----
;  Call OS to output string.

	mov	rax, SYS_write			; system code for write()
	mov	rsi, rdi			; address of characters to write
	mov	rdi, STDOUT			; file descriptor for standard in
						; EDX=count to write, set above
	syscall					; system call

; -----
;  String printed, return to calling routine.

prtDone:
	pop	rdx
	pop	rdi
	pop	rsi
	pop	rbx
	pop	rbp
	ret

; ******************************************************************
;  Function getParams()
;	Get, check, convert, verify range, and return the
;	A value, B value, draw color, and draw speed.

;  Example HLL call:
;	stat = getParams(argc, argv, &aValue, &bValue,
;				&drawSpeed, &drawColor)

;  This routine performs all error checking, conversion of ASCII/Vegismal
;  to integer, verifies legal range of each value.
;  For errors, applicable message is displayed and FALSE is returned.
;  For good data, all values are returned via addresses with TRUE returned.

;  Command line format (fixed order):
;	-a <vegismalNumber> -b <vegismalNumber> -ds <vegismalNumber>
;				dc <vegismalNumber>

; -----
;  Arguments:
;	rdi 1) ARGC, value 
;	rsi 2) ARGV, address
;	rdx 3) a value (dowrd), address
;	rcx 4) b value (dword), address
;	r8  5) draw color (dword), address
;	r9  6) draw speed (dword), address

global getParams
getParams:
	mov r15, rdi
	push rdi
	mov r14, rsi
	push rsi

mov rdi, r15
mov rsi, r14
cmp rdi,1
je promptuser
call rdparams
	
	
promptuser:

mov rbx,qword[errUsage]
mov qword[rdi],rbx
call printString
jmp ending

ending:
pop rdi
pop rsi



ret

global rdparams
rdparams:
;rdi is argc
;rsi is argv
;returns rdx,rcx,r8,r9

push r15
push r14
push r13
push rbx

mov r15,rdi ;save argc
mov r14,rsi ;save argv

cmp qword[rdi],1
je promptuser

;main checkers
mov r13,0 ;index

checkinglp:
cmp rbx,NULL
je lastphase
mov rbx,qword[r14+r13*8]

cmp r13,1
je acheck
cmp r13,2
je avalue
cmp r13,3
je bcheck
cmp r13,4
je bvalue
cmp r13,5
je dccheck
cmp r13,6







incrementlp:
inc r13
jmp checkinglp

acheck:
cmp rbx,"-a"
jne aerror
jmp incrementlp

avalue:

mov qword[rdi],rbx
call vigesimal2int
cmp qword[rdi],1
jl averror
cmp qword[rdi],2A
jg averror
mov rbx,qword[rdi]
mov qword[rdx],rbx
jmp incrementlp

bcheck:
cmp rbx,"-b"
jne berror
jmp incrementlp

bvalue:
mov qword[rdi],rbx
call vigesimal2int
cmp qword[rdi],1
jl averror
cmp qword[rdi],2A
jg averror
mov rbx,qword[rdi]
mov qword[rdx],rbx
jmp incrementlp

dccheck:
cmp rbx,"-dc"
jne dcerror
jmp incrementlp

dcvalue:
mov qword[rdi],rbx
call vigesimal2int
cmp qword[rdi],50
jl dcverror
cmp qword[rdi],54H30F
jg dcverror
jmp incrementlp

dscheck:
cmp rbx,"-ds"
jne dserror
jmp incrementlp

dsvalue:
mov qword[rdi],rbx
call vigesimal2int
cmp qword[rdi],1
jl dsverror
cmp qword[rdi],50
jg dsverror
jmp incrementlp



lastphase:
cmp r13,qword[rdi]
jne invalidcount
jmp rddone

;------errors
aerror:
movsx rbx,byte[errASpec]
mov qword[rdi],rbx
call printString
jmp ending

averror:
movsx rbx,byte[errAValue]
mov qword[rdi],rbx
call printString
jmp ending

berror:
movsx rbx,byte[errBSpec]
mov qword[rdi],rbx
call printString
jmp ending

bverror:
movsx rbx,byte[errBValue]
mov qword[rdi],rbx
call printString
jmp ending

dcerror:
movsx rbx,byte[errDcSpec]
mov qword[rdi],rbx
call printString
jmp ending

dcverror:
movsx rbx,byte[errDcValue]
mov qword[rdi],rbx
call printString
jmp ending

dserror:
movsx rbx,byte[errDsSpec]
mov qword[rdi],rbx
call printString
jmp ending

dsverror:
movsx rbx,byte[errDsValue]
mov qword[rdi],rbx
call printString
jmp ending

invalidcount:
movsx rbx,byte[errOptions]
mov qword[rdi],rbx
call printString
jmp ending

promptuser:
jmp ending

rddone:


ret






; ******************************************************************
;  Function: Check and convert ASCII/vegismal to integer
;	return false 

;  Example HLL Call:
;	stat = vegismal2int(vStr, &num);




global vigesimal2int
vigesimal2int:

	mov rbx,rsi
	push rsi
	mov rsi,rbx
	mov rbx,rdx
	push rdx
	mov rdx,rbx
	mov r10,rcx
	push rcx
	mov rcx,r10
	mov rbx,r8
	push r8
	mov r8,rbx
	
	

	mov rbx,0
	mov r9,1
	mov rax, 0					;sum
	mov rcx,0					
conStart:
	movsx r8, byte[rdi+rbx]
	
	cmp r8,"+"
	je sign
	cmp r8,"-"
	je sign
	cmp r8," "
	je skipstep
	
	jmp startLP
sign:
	cmp rcx, 0 ;checks to see if there is a sign
	jne readerror1
	mov r15, r8					;sign
	
	inc rcx
	inc rbx
	jmp conStart
	
skipstep:
inc rbx
jmp conStart
	
startLP:
	
	cmp r8, LF
	je exitLP

	cmp r8, "9"
	jle A	
	cmp r8, "K"
	jle B
	cmp r8, "k"
	jle C
	
	
	jmp readerror1

A:	cmp r8, "0"
	jge con1
	
	jmp readerror1

	
B:	
	cmp r8,"I"
	je readerror1
	
	cmp r8, "J"
	jge con22
	cmp r8, "A"
	jge con21
	
	jmp readerror1
	
C:	cmp r8, "i"
	je readerror1

	cmp r8, "j"
	jge con32
	cmp r8,"a"
	jge con31
	
	jmp readerror1
	

con1:
	sub r8, "0"
	jmp endOfCon
con21:
	sub r8, "A"
	add r8, 10
	jmp endOfCon
con22:
	sub r8, "J"
	add r8, 18
	jmp endOfCon
con31:
	sub r8, "a"
	add r8, 10
	jmp endOfCon
con32:
	sub r8, "j"
	add r8,18
	jmp endOfCon

endOfCon:
	
	imul rax, 20
	add rax, r8

	inc rcx
	inc rbx
	jmp conStart
	
readerror1:
	mov r15,rdi
	mov qword[rdi],"invalid"
	call printString
	mov rdi,r15
	jmp ending
readerror2:
	mov r15,rdi 
	mov qword[rdi],"invalid"
	call printString
	mov rdi,r15
	pop rdi
	jmp ending
conv:

	cmp r15,"-"
	jne done
	imul rax, -1
	jmp done
exitLP:
	cmp rbx,0
	jne conv

	mov rax, FALSE
	jmp done

	

done:

mov qword[rdi],rax
mov rax, TRUE	

	pop r8
	pop rcx
	pop	rdx
	pop	rsi
	


	ret





; ******************************************************************
;  Plot Function.
;  Note, function is called by openGL

;  Compute and plot the points.
;	x = cos (((2.0 * Pi) / (a+speed)) * t)
;	y = sin (((2.0 * Pi) / b) * t)

; -----
;  Gloabal variables accessed.
;  Globals are set via provided main.

common	aValue		1:4			; A value
common	bValue		1:4			; B value
common	drawColor	1:4			; draw color
common	drawSpeed	1:4			; draw speed
common	stop		1:1

global	plotLissajou
plotLissajou:
;	save preserved registers
push rdi ;argc
push rsi ;argv
push rdx ;a value
push rcx ;b value
push r8 ;dc 
push r9 ;ds

movsxd r13,dword[rdx]; store a
movsxd r12,dword[rcx]; store b


; -----
; Prepare for drawing
;	glClear(GL_COLOR_BUFFER_BIT);

	mov	rdi, GL_COLOR_BUFFER_BIT
	call	glClear

; -----
;  set draw color(r,g,b)

	; glColor3ub(r,g,b)
	mov eax,dword[r8]
	mov sil,ah
	mov dl,al
	ror eax,16
	mov dil, al
	call glColor3ub
	; glBegin(GL_POINTS);
	mov rdi, GL_POINTS
	call glBegin
	 
; -----
;  Set speed based on user entered drawSpeed
;	speed = drawSpeed / scale

cvtsi2sd xmm0,r9
divsd xmm0,qword[scale]
movsd qword[speed],xmm0

; -----
;  Get and convert aValue and bValue from int to float.

	mov eax,dword[aValue]
	cvtsi2sd xmm15,rax
	movsd qword[a],xmm15
	
	mov eax,dword[bValue]
	cvtsi2sd xmm14,rax
	movsd qword[b],xmm14

; -----
;  Set lpMax based on largest of a or b.

	movsd		xmm0, qword [a]
	movsd		xmm1, qword [b]
	ucomisd		xmm0, xmm1
	jb		useB
	movsd		qword [lpMax], xmm0
	jmp		setMdone
useB:	movsd		qword [lpMax], xmm1
setMdone:

; -----
;  Adjust a based on calculated speed value.


; -----
;  Check for animation stop.


; -----
;  Main plot loop.
movsd xmm12,qword[lpMax]
mulsd xmm12,qword[myPi]
divsd xmm12,qword[tStep]

mainPlotLoop:

;  iterate:
;	x = cos (((2.0 * Pi) / (a+speed)) * t)
;	y = sin (((2.0 * Pi) / b) * t)
;	plot (x,y)
;	t = t + step


cmp xmm14,xmm12
jge plottingdone


;solve for x
cvtsi2sd xmm0,r13 			;a
addsd xmm0 qword[speed]		;a+speed 
cvtsi2sd xmm1,qword[myPi]	;num = pi
mulsd xmm1,qword[fTwo]     ;rax = 2*pi
divsd xmm1,xmm0
mulsd xmm1,qword[t];rax*t
movsd xmm0,xmm1
call cos ;xmm1
movsd xmm4,xmm0 ;x

;solve for y
cvtsi2sd xmm0,r12 			;b 
cvtsi2sd xmm1,qword[myPi]	;num = pi
mulsd xmm1,qword[fTwo]     ;num = 2*pi
divsd xmm1,xmm0				;num/b
mulsd xmm1,qword[t];rax*t
movsd xmm0,xmm1
call sin ;xmm1
movsd xmm5,xmm0 ;y

movsd xmm0,xmm4
movsd xmm1,xmm5
call glVertex2d


movsd xmm3,qword[t]
addsd xmm3,qword[tStep]
movsd qword[t],xmm3

inc xmm14
jmp mainPlotLoop

plottingdone:
; -----
;  plotting done, show image

	call	glEnd
	call	glFlush

	call	glutPostRedisplay

; -----
;  if t > circle degrees
;	resset t to 0.0

	movsd	xmm0, qword [t]
	movsd	xmm1, qword [myPi]
	mulsd	xmm1, qword [circleDegrees]
	ucomisd	xmm0, xmm1
	jb	plotDone
	movsd	xmm0, qword [fZero]
	movsd	qword [t], xmm0

; -----
;  done

plotDone:
	pop	r12
	pop	r15
	pop	rbp
	ret

; ******************************************************************

