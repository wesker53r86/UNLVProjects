;  CS 218 - Assignment 8
;  Functions Template.

; --------------------------------------------------------------------
;  Write some assembly language functions.

;  The function, insertionSort(), sorts the numbers into ascending
;  order (large to small).  Uses the insertion sort algorithm from
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


push 	rsi
dec 	rsi
push 	r8					;set i
push 	r9					;set j
mov 	r8,0 				; index=0
insertionforloop:
cmp		r8,rsi				;i=1,i<length-1
je		endloop
mov 	rax,dword[rdi+r8*4]	; value = Arr[i]
mov		r9,r8;
dec		r9					;j=i-1

insertionwhileloop:
cmp		r9,0				;while{j>=0} and (Arr[j]>value)
jl		endwhile
mov		rbx,dword[rdi+r9]
cmp		rax,rbx
jle		endwhile



endloop:


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


;	YOUR CODE GOES HERE




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



;	YOUR CODE GOES HERE



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



;	YOUR CODE GOES HERE




; ********************************************************************************

