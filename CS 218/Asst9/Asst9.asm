;  CS 218 - Assignment 9
;  Functions Template.

; --------------------------------------------------------------------
;  Write assembly language functions.

;  The value returning function, rdVigesimalNum(), should read
;  a vigesimal number from the user (STDIN) and perform
;  apprpriate error checking and conversion (string to integer).

;  The void function, insertionSort(), sorts the numbers into
;  ascending order (large to small).

;  The value returning function, lstAverage(), to return the
;  average of a list.

;  The void function, listStats(), finds the minimum, median,
;  and maximum, sum, and average for a list of numbers.
;  The median is determined after the list is sorted.
;  Must call the lstAverage() function.

;  The value returning function, coVariance(), computes the
;  co-variance for the two passed data sets.


; ********************************************************************************

section	.data

; -----
;  Define standard constants.

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

; -----
;  Define program specific constants.

MINNUM		equ	-1000000
MAXNUM		equ	1000000
BUFFSIZE	equ	50			; 50 chars including NULL

; -----
;  NO static local variables allowed...


; ********************************************************************************

section	.text

; --------------------------------------------------------
;  Read an ASCII vigesimal number from the user.
;  Perform appropriate error checking and, if OK,
;  convert to integer.

; -----
;  HLL Call:
;	status = rdVigesimalNum(&numberRead, promptStr, errMsg1,
;					errMsg2, errMSg3);

;  Arguments Passed:
;	1) numberRead, addr - rdi
;	2) promptStr, addr - rsi
;	3) errMsg1, addr - rdx
;	4) errMsg2, addr - rcx
;	5) errMsg3, addr - r8

;  Returns:
;	number read (via reference)
;	TRUE or FALSE

global	rdVigesimalNum
rdVigesimalNum:

	push rbp
	mov rbp,rsp
	sub rsp,55
	push rbx
	push r12;char count
	push r13
	push r14
	mov rbx,rdx
	push rdx
	mov rdx,rbx
	mov dword[rbp-55],0
	
	mov r14,rbx

starto:
mov rbx,rdi
mov rdi,rsi
call printString
mov rdi, rbx

mov r10,0

mov dword[rbp-55],0
lea r10,[rbp-50]
mov r12,0
;---------print chars
readlp:
cmp r12,BUFFSIZE
jg readerror3
mov rax,SYS_read
mov rdi,STDIN
lea rsi,[rbp-51];chr
mov rdx,1

sysCall

mov al,byte[rbp-51];chr
mov byte[r10],al
inc r10
cmp al,LF
je readDone

inc r12
jmp readlp

readerror3:
mov rax,SYS_read
mov rdi, STDIN
lea rsi, [rbp-51]
mov rdx, 1

syscall

mov al, byte[rbp-51]
cmp al, LF
jne readerror3

mov rdx,r14
mov rbx,rdi
mov rdi, rdx
call printString
mov rdi,rbx
jmp starto

readDone:
mov byte[r10],NULL
sub rbp,50
mov rdi,rbp
add rbp,50
call printString
call vigesimal2int

pop rdx
pop r14
pop r13
pop r12
pop rbx
mov rsp,rbp
pop rbp
ret




;vigesimal function:
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
	movsx r8, byte[rbp-50+rbx]
	
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
	mov rdi,r14
	call printString
	mov rdi,r15
	jmp starto 
readerror2:
	mov r15,rdi 
	mov rdi,r10
	call printString
	mov rdi,r15
	pop rdi
	jmp starto
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
cmp rax,3
jl readerror2
cmp rax,200
jg readerror2
mov rdi,rax
mov rax, TRUE	

	pop r8
	pop rcx
	pop	rdx
	pop	rsi
	


	ret

; --------------------------------------------------------
;  Insertion sort function.

; -----
;  Insertion sort algorithm

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

; -----
;  HLL Call:
;	call insertionSort(list, len)

global	insertionSort
insertionSort:

	mov rbx,rsi
	push rsi
	mov rsi,rbx
	push r15;index
	push r14;value
	push r13;jindex
	push r12;jvalue
	

	mov r15,1;set index
	dec rsi;length-1
insertlp:
	cmp r15,rsi;for(i=1,i<length-1,i++)
	je endinslp
	mov r14d,dword[rdi+r15*4];value = Arr[i]
	mov r13,r15;j=i
	dec r13;j=i-1
	
	
insertwhilelp:
	cmp r13,0;while (j>0)and(Arr[j]>value)
	jl endwhilelp
	cmp dword[rdi+r13*4],r14d
	jle endwhilelp
	
	mov r12d,dword[rdi+r13*4];Arr[j]
	inc r13;j+1
	mov dword[rdi+r13*4],r12d;Arr[j+1]=Arr[j]
	dec r13;j
	dec r13;j=j-1
	jmp insertwhilelp
endwhilelp:
	inc r13;j+1
	mov dword[rdi+r13*4],r14d;Arr[j+1]=value
	inc r15
	jmp insertlp
	
endinslp:

	pop r12
	pop r13
	pop r14
	pop r15
	pop rsi
	ret

; --------------------------------------------------------
;  Find statistical information for a list of integers:
;	sum, average, minimum, median, and maximum

;  Note, for an odd number of items, the median value is defined as
;  the middle value.  For an even number of values, it is the integer
;  average of the two middle values.

;  This function must call the lstAvergae() function
;  to get the average.

;  Note, assumes the list is already sorted.

; -----
;  HLL Call:
;	call listStats(list, len, sum, ave, min, med, max)


global listStats
listStats:
	push rbp
	mov rbp,rsp
	mov rbx,rdi
	push rdi
	mov rdi,rbx
	mov rbx,rsi
	push rsi
	mov rsi,rbx
	;rdx sum
	;rcx ave
	;r8 min
	;r9 med
	;rbp+16 max
	push r15;index
	push r14;value container
	push rax;for good measure

	mov r15,0
sumlp:
	cmp r15d,dword[rsi];i<length
	je endsum
	mov r14d,dword[rdi+r15*4];Arr[i]
	add dword[rdx],r14d;sum=sum+Arr[i]
	inc r15;i++
	jmp sumlp
endsum:

avglp:

	mov eax,dword[rdx];mov sum to prepare for division
	mov r14,rdx;save address of rdx
	mov edx,0
	idiv dword[rsi];sum/length
	mov dword[rcx],eax;average
	mov rdx,r14 ;restores address of rdx
	
min:
	mov r15,0
	mov eax,dword[rdi+r15*4]
	mov dword[r8],eax
max:
	movsxd r15,dword[rsi]
	dec r15
	mov eax,dword[rdi+r15*4]
	mov dword[rbp+16],eax
med:
	mov r15,rdx ;save rdx for later
	mov r14d,2
	mov eax,dword[rsi]
	mov edx,0
	idiv r14d
	cmp edx,0
	je evenmed
	
	mov r14d, dword[rdi+rax*4]
	dec eax
	add r14d, dword[rdi+rax*4]
	mov eax, r14d
	mov r14d, 2
	mov edx,0
	idiv r14d
	mov dword[r9],eax
	mov rdx,r15
	jmp medend
	
evenmed:
	dec rax
	mov r14d, dword[rdi+rax*4]
	mov dword[r9],r14d
	
medend:
	pop rax
	pop r14
	pop r15
	pop rsi
	pop rdi
	pop rbp
	
	

	ret

; --------------------------------------------------------
;  Function to calculate the average of a list.
;  Note, must call the lstSum() function.

; -----
;  HLL Call:
;	ans = lstAverage(lst, len)

;  Arguments Passed:
;	1) list, address - rdi
;	2) length, value - rsi

;  Returns:
;	average (in eax)

global	lstAverage
lstAverage:

	mov rbx,rdi
	push rdi;list
	mov rdi,rbx
	mov rbx,rsi
	push rsi;length
	mov rsi,rbx
	push rbx;value
	push r12;index
	push r11
	push rdx
	
	mov r12d,0
	mov ebx, dword[rdi+r12]
	mov	eax, 0
aveglp:
	cmp r12d,dword[rsi]
	je endavglp
	mov ebx,dword[rdi+r12*4]
	add eax,ebx
	inc r12d
	jmp aveglp
endavglp:
	mov edx,0
	idiv dword[rsi]
	
	pop rdx
	pop r11
	pop r12
	pop rbx
	pop rsi
	pop rdi

	ret

; --------------------------------------------------------
;  Function to calculate the co-variance
;  between two lists.  Note, the two data sets
;  must be of equal size.

; -----
;  HLL Call:
;	coVariance(xList, yList, len)

global	coVariance
coVariance:

	mov rbx,rdi
	push rdi ;xList
	mov rdi,rbx
	mov rbx,rsi
	push rsi ;yList
	mov rsi,rbx
	mov rbx,rdx
	push rdx ;length
	mov rdx,rbx
	push r15; index
	push r14; xave store
	push r13; yave store
	push r12; rax portion sum
	push r11; rdx portion sum
	push r10; save length
	push rbx; for good measure
	
	
	
	mov rbx, rsi;save ylist for later
	mov rsi, rdx;length to rsi
	call lstAverage
	mov r14, rax;store xave
	
	mov rsi,rbx ;restore ylist
	mov rbx,rdi; store xlist
	mov rdi,rsi; rdi is ylist
	mov rsi,rdx; rsi is list
	call lstAverage
	mov r13,rax ;store yave
	mov rsi,rdi ;restore ylist
	mov rdi,rbx ;restore xlist
	
	mov r15,0
	mov r12,0
	mov r13,0
	movsxd r10,dword[rdx]
colp:
	cmp r15,r10
	je colpend
	movsxd rax, dword[rdi+r15*4]
	sub rax, r14
	
	movsxd rbx, dword[rdi+r15*4]
	sub rbx, r13
	
	imul rbx
	add r12, rax
	adc r13, rdx
	
	inc r15
	jmp colp

colpend:
	mov rax,r12
	mov rdx,r13
	dec r10
	idiv r10

	pop rbx
	pop r10
	pop r11
	pop r12
	pop r13
	pop r14
	pop r15	
	pop rdx
	pop rsi
	pop rdi
	ret

; ******************************************************************
;  Generic procedure to display a string to the screen.
;  String must be NULL terminated.

;  Algorithm:
;	Count characters in string (excluding NULL)
;	Use syscall to output characters

; -----
;  HLL Call:
;	printString(stringAddr);

;  Arguments:
;	1) address, string

;  Returns:
;	nothing

global	printString
printString:

; -----
;  Count characters to write.
;  Note, count placed in RDX for system call.

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
	mov	rsi, rdi			; address of char to write
	mov	rdi, STDOUT			; file descriptor for std in
						; rdx=count to write, set above
	syscall					; system call

; -----
;  String printed, return to calling routine.

printStringDone:
	ret

; ******************************************************************

