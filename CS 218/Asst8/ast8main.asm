;  CS 218 - Assignment 8
;  Provided Main.

;  DO NOT EDIT THIS FILE

; --------------------------------------------------------------------
;  Write four assembly language procedures.

;  The first procedure, insertionSort(), sorts the numbers into ascending
;  order (small to large).  Uses the bucket sort algorithm (from asst #7).

;  The second procedure, listStats(), finds the minimum, median, maximum,
;  sum, and average for a list of numbers.  Note, for an odd number of items,
;  the median value is defined as the middle value.  For an even number of
;  values, it is the integer average of the two middle values.

;  The third procedure, coVariance(), to computes the
;  correlation coefficient for the two data sets.

;  Summation and division performed as integer values.
;  Due to the data sizes, the summation for the dividend (top)
;  must be performed as a quad-word.

; ----------

section	.data

; -----
;  Define standard constants.

TRUE		equ	1
FALSE		equ	0

EXIT_SUCCESS	equ	0			; Successful operation

STDIN		equ	0			; standard input
STDOUT		equ	1			; standard output
STDERR		equ	2			; standard error

SYS_read	equ	0			; call code for read
SYS_write	equ	1			; call code for write
SYS_open	equ	2			; call code for file open
SYS_close	equ	3			; call code for file close
SYS_fork	equ	57			; call code for fork
SYS_exit	equ	60			; call code for terminate
SYS_creat	equ	85			; call code for file open/create
SYS_time	equ	201			; call code for get time

LF		equ	10
NULL		equ	0
ESC		equ	27

; -----
;  Data Sets for Assignment #8.

xList1		dd	 174630,  378510,  264110, -741730,  466030
		dd	-185310,  489780,  125970,  537540, -122019
		dd	 296890,  345440, -312031,  212355,  123329
		dd	 441123,  156212
yList1		dd	 285130, -223110,  354213, -914650,  746057
		dd	 119520,  235118, -119750,  119570,  212063
		dd	-119610,  810510,  120080,  273000,  387111
		dd	 218763,  212183
len1		dd	17
xMin1		dd	0
xMed1		dd	0
xMax1		dd	0
xSum1		dd	0
xAve1		dd	0
yMin1		dd	0
yMed1		dd	0
yMax1		dd	0
ySum1		dd	0
yAve1		dd	0
coVar1		dq	0


xList2		dd	 412327,  412255,  454917,  423615,  416361
		dd	 411000,  412320,  419122,  431204,  430726
		dd	 411129,  412413, -438455,  415935,  454837
		dd	-411739,  413241,  417543,  413845,  413949
		dd	 412153,  423219, -426123,  412617,  410459
		dd	 411416,  414115,  415551,  465467, -416769
		dd	-411328,  414130,  414432,  423633,  412611
		dd	 411338,  443140, -443542,  428644,  467546
		dd	 411321,  434215,  442251,  414613,  415419
		dd	 414257,  411439,  412453,  416765,  456679
yList2		dd	 161227,  165155,  613117,  621175,  613261
		dd	 161183,  163414,  672511, -641628, -632112
		dd	 161126, -162117, -673327,  674727,  682184
		dd	 161374,  613102,  695725, -652126,  612229
		dd	 162188,  162315,  631101, -615518, -631115
		dd	 161126,  162117,  664105,  685910,  672114
		dd	 164524,  166143, -612334,  694712,  662103
		dd	 163172, -162176,  654756, -643165,  625156
		dd	 166453,  167140,  681991,  614568, -632162
		dd	 166146,  162147, -621967,  646777,  622144
len2		dd	50
xMin2		dd	0
xMed2		dd	0
xMax2		dd	0
xSum2		dd	0
xAve2		dd	0
yMin2		dd	0
yMed2		dd	0
yMax2		dd	0
ySum2		dd	0
yAve2		dd	0
coVar2		dq	0


xList3		dd	 645244,  456434,  756243,  923661,  525436
		dd	 463441, -223653, -656234,  626923, -641263
		dd	 125318,  744543,  856612,  124710,  588310
		dd	-425324,  222443,  656234,  621412, -629803
		dd	 727553, -334230, -556291,  548968,  336223
		dd	 138647,  122217,  458399,  125697, -122921
		dd	 138683,  343250,  556201,  522328,  331565
		dd	 168683,  314314, -511611,  411228,  311245
		dd	-138626,  214317,  715227,  914527,  518412
		dd	 397774,  115402,  413625,  618726, -112978
		dd	 117788, -315405,  115301,  512308,  311525
		dd	 113526,  211547, -110765,  911210,  111463
		dd	 123534,  216543,  665134,  614512,  610385
		dd	 155372,  317676,  116556,  489165, -515671
		dd	-143553, -317640, -215491,  416856,  316293
		dd	 166546,  217647,  213467,  912377, -514428
		dd	 186455,  513872,  213285,  214739,  113446
		dd	 178664,  118772, -212175,  616952,  817249
		dd	-166883,  198150,  112331,  517978, -718567
		dd	 146666, -215678,  213577,  917767,  516415
yList3		dd	 118640,  186220,  117522,  315624,  902653
		dd	 128619,  129713, -376455,  353345,  543775
		dd	-178939,  134961,  157843,  134455,  134984
		dd	 125973,  237619, -118023,  122317,  145962
		dd	 141446,  144815,  158651,  452367, -166915
		dd	-132448,  148830,  213472,  233839,  212136
		dd	 134638,  234440, -454422,  768944,  674658
		dd	 314621,  346625,  122351,  471613,  151941
		dd	 425357,  147599,  143653,  216165,  567974
		dd	 132527,  127555,  141217,  253215,  136173
		dd	 353683,  345614,  511321, -441258, -311291
		dd	-135326, -216417, -713427,  112327,  118484
		dd	 313848,  364105,  114501, -510988, -311573
		dd	-112536,  911467,  145105,  118910,  211481
		dd	 215424,  214543, -314734,  611782,  610356
		dd	 153472, -614676,  216356, -418765,  315632
		dd	 144553,  116440,  517491,  417668, -316291
		dd	 165646,  114547, -713467,  115677,  514416
		dd	-185537, -514632,  717855,  214549,  113427
		dd	 176354,  164172,  415475,  634162, -117290
len3		dd	100
xMin3		dd	0
xMed3		dd	0
xMax3		dd	0
xSum3		dd	0
xAve3		dd	0
yMin3		dd	0
yMed3		dd	0
yMax3		dd	0
ySum3		dd	0
yAve3		dd	0
coVar3		dq	0


; --------------------------------------------------------

extern	insertionSort, listStats, coVariance

section	.text
global	main
main:

; **************************************************
;  Call procedures for data set 1.

;  call insertionSort(xList1, len1)
	mov	rdi, xList1
	mov	esi, dword [len1]
	call	insertionSort

;  call insertionSort(yList1, len1)
	mov	rdi, yList1
	mov	esi, dword [len1]
	call	insertionSort

;  call listStats(xList1, len1, xSum1, xAve1, xMin1, xMed1, xMax1)
	mov	rdi, xList1
	mov	esi, dword [len1]
	mov	rdx, xSum1
	mov	rcx, xAve1
	mov	r8, xMin1
	mov	r9, xMed1
	mov	rax, xMax1
	push	rax
	call	listStats
	add	rsp, 8

;  call listStats(yList1, len1, ySum1, yAve1, yMin1, yMed1, yMax1)
	mov	rdi, yList1
	mov	esi, dword [len1]
	mov	rdx, ySum1
	mov	rcx, yAve1
	mov	r8, yMin1
	mov	r9, yMed1
	mov	rax, yMax1
	push	rax
	call	listStats
	add	rsp, 8

;  coVar1 = coVariance(xList1, yList1, len1)
	mov	rdi, xList1
	mov	rsi, yList1
	mov	edx, dword [len1]
	call	coVariance
	mov	qword [coVar1], rax


; **************************************************
;  Call procedures for data set 2.

;  call insertionSort(xList2, len2)
	mov	rdi, xList2
	mov	esi, dword [len2]
	call	insertionSort

;  call insertionSort(yList2, len2)
	mov	rdi, yList2
	mov	esi, dword [len2]
	call	insertionSort

;  call listStats(xList2, len2, xSum2, xAve2, xMin2, xMed2, xMax2)
	mov	rdi, xList2
	mov	esi, dword [len2]
	mov	rdx, xSum2
	mov	rcx, xAve2
	mov	r8, xMin2
	mov	r9, xMed2
	mov	rax, xMax2
	push	rax
	call	listStats
	add	rsp, 8

;  call listStats(yList2, len2, ySum2, yAve2, yMin2, yMed2, yMax2)
	mov	rdi, yList2
	mov	esi, dword [len2]
	mov	rdx, ySum2
	mov	rcx, yAve2
	mov	r8, yMin2
	mov	r9, yMed2
	mov	rax, yMax2
	push	rax
	call	listStats
	add	rsp, 8

;  coVar2 = coVariance(xList2, yList2, len2)
	mov	rdi, xList2
	mov	rsi, yList2
	mov	edx, dword [len2]
	call	coVariance
	mov	qword [coVar2], rax


; **************************************************
;  Call procedures for data set 3.

;  call insertionSort(xList3, len3)
	mov	rdi, xList3
	mov	esi, dword [len3]
	call	insertionSort
	add	rsp, 16

;  call insertionSort(yList3, len3)
	mov	rdi, yList3
	mov	esi, dword [len3]
	call	insertionSort

;  call listStats(xList3, len3, xSum3, xAve3, xMin3, xMed3, xMax3)
	mov	rdi, xList3
	mov	esi, dword [len3]
	mov	rdx, xSum3
	mov	rcx, xAve3
	mov	r8, xMin3
	mov	r9, xMed3
	mov	rax, xMax3
	push	rax
	call	listStats
	add	rsp, 8

;  call listStats(yList3, len3, ySum3, yAve3, yMin3, yMed3, yMax3)
	mov	rdi, yList3
	mov	esi, dword [len3]
	mov	rdx, ySum3
	mov	rcx, yAve3
	mov	r8, yMin3
	mov	r9, yMed3
	mov	rax, yMax3
	push	rax
	call	listStats
	add	rsp, 8

;  coVar3 = coVariance(xList3, yList3, len3)
	mov	rdi, xList3
	mov	rsi, yList3
	mov	edx, dword [len3]
	call	coVariance
	mov	qword [coVar3], rax
; ******************************
;  Done, terminate program.

last:
	mov	rax, SYS_exit
	mov	rbx, EXIT_SUCCESS
	syscall

