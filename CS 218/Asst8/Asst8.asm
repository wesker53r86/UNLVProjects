;  CS 218 - Assignment 8
;  Functions Template.

; --------------------------------------------------------------------
;  Write some assembly language functions.

;  The function, insertionSort(), sorts the numbers into ascending
;  order (small to large).  Uses the insertion sort algorithm from
;  assignment #7 (modified to sort in descending order).

;  The function, listStats(), finds the sum, average, minimum,
;  median, and maximum for a list of numbers.
;  Note, the median is determined after the list is sorted.
;	This function must call the lstAvergae()
;	function to get the average.

;  The function, coVariance(), computes the sample covariance for
;  the two data sets.  Summation and division performed as quads.

; ********************************************************************************

section	.data

; -----
;  Define constants.

TRUE		equ	1
FALSE		equ	0

; -----
;  Local variables for insertionSort() function (if any).

h		dd	0
i		dd	0
j		dd	0
tmp		dd	0
dThree		dd	3

; -----
;  Local variables for listStats() function (if any).


; -----
;  Local variables for coVariance() function (if any).



section	.bss

; -----
;  Unitialized variables.

qSum		resq	1
qTmp		resq	1


; ********************************************************************************

section	.text

; --------------------------------------------------------
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

; -----
;  HLL Call:
;	call insertionSort(list, len)

;  Arguments Passed:
;	1) list, addr - rdi
;	2) length, value - rsi

;  Returns:
;	sorted list (list passed by reference)

global insertionSort
insertionSort:

mov r10, 0
loopie1: ;for loop start
inc r10
cmp r10,rsi ;r10 = i
je exitsort

mov eax,dword[rdi+r10*4] ; rax = value
mov rbx,r10
dec rbx ;rbx = j=i-1

loopiecheck: ; while loop start
cmp rbx,0 ;if j < 0, end
jl whileloopiend

cmp dword[rdi+rbx*4], eax ;if Arr[j] <= value, end
jle whileloopiend 

loopie2:
mov 	r8,rbx ;r8 = j
inc 	r8 ;r8=j+1
mov 	edx,dword[rdi+rbx*4];rdx=Arr[j]
mov 	dword[rdi+r8*4],edx ;Arr[j+1]=Arr[j]
dec 	rbx ;j=j-1
jmp 	loopiecheck ;while loop end

whileloopiend:
inc 	rbx ;j=j+1
mov 	dword[rdi+rbx*4], eax ;Arr[j+1] = value
jmp 	loopie1 ;for loop end


exitsort:

ret

; --------------------------------------------------------
;  Find statistical information for a list of integers:
;	sum, average, minimum, median, and maximum

;  Note, for an odd number of items, the median value is defined as
;  the middle value.  For an even number of values, it is the integer
;  average of the two middle values.

;  This function must call the lstSum() and lstAvergae() functions
;  to get the corresponding values.

;  Note, assumes the list is already sorted.

; -----
;  Call:
;	call listStats(list, len, sum, ave, min, med, max)

;  Arguments Passed:
;	1) list, addr - rdi
;	2) length, value - rsi
;	6) sum, addr - rdx
;	7) ave, addr - rcx
;	3) minimum, addr - r8
;	4) median, addr - r9
;	5) maximum, addr - stack, rbp+16

;  Returns:
;	sum, average, minimum, median, and maximum
;		via pass-by-reference

global listStats
listStats:

;sum & ave
call 	lstAverage ; average call
movsxd 	r11, eax	;
mov		qword[rcx],r11	;return average
mov 	rbx,qword[rax]	;store average in rbx
mov 	rdx,0			;setup for multiplication
mov 	rax,rbx			;setup for mulitplication
imul 	rsi			;average * length
mov 	qword[rdx],rax  ;return sum

;minimum
mov 	eax,dword[rdi+0]
mov 	dword[r8],eax ;return minimum
;maximum
push 	rsi
dec 	rsi
mov	eax,dword[rdi+rsi*4]
mov 	dword[rbp+16],eax
pop 	rsi
;median
mov 	eax,dword[rsi]
mov 	edx,0
mov		ebx,2
idiv 	ebx
cmp		edx,0
je		evlp
mov		ebx,dword[rdi+rax*4]
dec 	eax
add		ebx,dword[rdi+rax*4]
mov 	eax,ebx
mov 	edx,0
mov		ebx,2
idiv 	ebx
mov		dword[r9],eax
jmp 	odevlpend
evlp:
dec 	eax
mov		ebx,dword[rdi+rax*4]
mov		dword[r9],ebx

odevlpend:

ret

; --------------------------------------------------------
;  Function to calculate the average of a list.

; -----
;  Call:
;	ans = lstAverage(lst, len)

;  Arguments Passed:
;	1) list, address - rdi
;	1) length, value - rsi

;  Returns:
;	average (in eax)

global lstAverage
lstAverage:

mov r8,rdi
mov r9,rsi

push rdi
push rsi



mov 	rsi,0 ; index = 0
mov 	ebx,0 ;	sum=0
avglp:
cmp 	rsi,r9 ;i=length
je 		avglpend	;end loop
mov 	eax,dword[rdi+rsi*4] ;eax = Arr[i]
add 	ebx,eax	;sum = sum + eax
inc 	rsi ;i++
jmp 	avglp ;loop again


avglpend:
mov 	eax,ebx ;eax=sum
mov 	edx,0
idiv 	esi; sum/length


pop 	rsi
pop 	rdi

ret

; --------------------------------------------------------
;  Function to calculate the covariance for
;  two lists (of equal size).

; -----
;  Call:
;	coVariance(xList, yList, len)

;  Arguments Passed:
;	1) xList, address - rdi
;	2) yList, address - rsi
;	3) length, value - rdx

;  Returns:
;	covariance (in rax)

global coVariance
coVariance:


;get average
push	r12
push 	rdx ;length
push	rsi ;save yList
push	rdi ;save xList

mov		r10,rdx ;move length to r10
mov		r9,rsi ;move y-list to r9
mov		r8,rdi ;move x-list to r18

; X-list average
mov 	rdi, r8 ; xlist
mov 	rsi, r10; length
call 	lstAverage
push 	rax ;save x-ave for later
; Y-list average
mov 	rdi,r9 ;ylist
mov 	rsi,r10;length
call	lstAverage
push 	rax ;save y-ave for later

pop 	rax ;get y-ave
movsxd		r9, dword[eax]; r9 = y-ave		
pop		rax ;get x-ave
movsxd	r8,	dword[eax]; r8 = x-ave

pop 	rdi ; get x-List
pop 	rsi	; get y-List
pop		rdx ; get length

push 	rdi
push	rsi
push	rdx

mov 	r12, 0 ;index=0

mov 	rcx, 0 ;summation

colp:
cmp 	r12,rdx ;if x = length
je		coend	;end loop
movsxd	rax,dword[rdi+r12*4]	;get X[i]
sub 	rax,r8					;X[i]-Xave
push 	rax						;save Xsum

movsxd 	rax,dword[rsi+r12*4]	;get Y[i]
sub		rax,r9					;Y[i]-Yave
mov		rbx,rax 				;move Ysum to rbx

pop 	rax						;get Xsum

imul	rbx						; Xsum * Ysum
add		rcx,rax					; add into summation
inc 	r12						; i++
jmp 	colp

coend:

mov 	rdx,0					;get ready for division
mov 	rax,rcx					;mov summation to rax
dec 	r12					;length-1
idiv 	r12						;Sum/(n-1)


pop 	rdx
pop		rsi
pop		rdi

ret

; ********************************************************************************

