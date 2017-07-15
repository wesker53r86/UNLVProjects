;  CS 218 - Assignment #11
;  Functions Template

; ***********************************************************************
;  Data declarations
;	Note, the error message strings should NOT be changed.
;	All other variables may changed or ignored...

section	.data

; -----
;  Define standard constants.

LF		equ	10			; line feed
NULL		equ	0			; end of string
SPACE		equ	0x20			; space

TRUE		equ	1
FALSE		equ	0

SUCCESS		equ	0			; Successful operation
NOSUCCESS	equ	1			; Unsuccessful operation

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

O_CREAT		equ	0x40
O_TRUNC		equ	0x200
O_APPEND	equ	0x400

O_RDONLY	equ	000000q			; file permission - read only
O_WRONLY	equ	000001q			; file permission - write only
O_RDWR		equ	000002q			; file permission - read and write

S_IRUSR		equ	00400q
S_IWUSR		equ	00200q
S_IXUSR		equ	00100q

; -----
;  Define program specific constants.

GRAYSCALE	equ	1
BRIGHTEN	equ	2
DARKEN		equ	3

MIN_FILE_LEN	equ	5
BUFF_SIZE	equ	500000			; buffer size
;BUFF_SIZE	equ	3			; buffer size

; -----
;  Local variables for getOptions() procedure.

eof		db	FALSE

usageMsg	db	"Usage: ./image <-gr|-br|-dk> <inputFile.bmp> "
		db	"<outputFile.bmp>", LF, NULL
errIncomplete	db	"Error, incomplete command line arguments.", LF, NULL
errExtra	db	"Error, too many command line arguments.", LF, NULL
errOption	db	"Error, invalid image processing option.", LF, NULL
errReadSpec	db	"Error, invalid read specifier.", LF, NULL
errWriteSpec	db	"Error, invalid write specifier.", LF, NULL
errReadName	db	"Error, invalid source file name.  Must be '.bmp' file.", LF, NULL
errWriteName	db	"Error, invalid output file name.  Must be '.bmp' file.", LF, NULL
errReadFile	db	"Error, unable to open input file.", LF, NULL
errWriteFile	db	"Error, unable to open output file.", LF, NULL

; -----
;  Local variables for readHeader() procedure.

HEADER_SIZE	equ	54

errReadHdr	db	"Error, unable to read header from source image file."
		db	LF, NULL
errFileType	db	"Error, invalid file signature.", LF, NULL
errDepth	db	"Error, unsupported color depth.  Must be 24-bit color."
		db	LF, NULL
errCompType	db	"Error, only non-compressed images are supported."
		db	LF, NULL
errSize		db	"Error, bitmap block size inconsistant.", LF, NULL
errWriteHdr	db	"Error, unable to write header to output image file.", LF,
		db	"Program terminated.", LF, NULL

; -----
;  Local variables for getRow() procedure.

buffMax		dq	BUFF_SIZE
curr		dq	BUFF_SIZE
wasEOF		db	FALSE
pixelCount	dq	0

errRead		db	"Error, reading from source image file.", LF,
		db	"Program terminated.", LF, NULL

; -----
;  Local variables for writeRow() procedure.

errWrite	db	"Error, writting to output image file.", LF,
		db	"Program terminated.", LF, NULL


; ------------------------------------------------------------------------
;  Unitialized data

section	.bss

buffer		resb	BUFF_SIZE
header		resb	HEADER_SIZE


; ############################################################################

section	.text

extern	printString				; Utility print string function

; ***************************************************************
;  Routine to get arguments.
;	Verify files by atemptting to open the files (to make
;	sure they are valid and available).

;  Command Line format:
;	./image <-gr|-br|-dk> <inputFileName> <outputFileName>

; -----
;  Arguments:
;	argc (value)
;	argv table (address)
;	image option variable (address)
;	read file descriptor (address)
;	write file descriptor (address)
;  Returns:
;	SUCCES or NOSUCCESS

global	getArguments
getArguments:



	push rdi
	push rsi
	
	

	mov r15,0
	cmp rdi, 4
	jl argerror1
	cmp rdi, 4
	jg argerror2
readlp:
	cmp r15,rdi
	je endrdlp
	movsxd rbx,dword[rsi+r15*4];read argv
	movsxd r13,dword[rbx]
	
	;there are 4-5 args
	
	;error check 
	
	cmp r15,1
	je imageop ;place image option variable
	
	cmp r15,2
	je rdfile;place read file descriptor
	
	cmp r15,3
	je wrfile;place write file descriptor
	
	jmp incrementrdlp
	
imageop:
	mov qword[rdx],r13
	cmp r13, "-gr"
	je contargs
	cmp r13, "-br"
	je contargs
	cmp r13, "-dk"
	je contargs
	jmp argerror3
	contargs:
	
	jmp incrementrdlp
rdfile:
	mov rax, SYS_open
	mov rdi,r13 
	mov rsi, O_RDONLY
	syscall
	
	mov qword[rcx],rax
	jmp incrementrdlp
wrfile:
	mov rax, SYS_open
	mov rdi,r13 
	mov rsi, O_RDONLY
	syscall
	
	mov qword[r8],rax
	jmp incrementrdlp
incrementrdlp:
	inc r15
	jmp readlp
	mov rax,0

argerror1:
	movsx rdi, byte[errIncomplete]
	call printString
	mov rax, 1
	jmp endrdlp
argerror2:	
	movsx rdi, byte[errExtra]
	call printString
	mov rax, 1
	jmp endrdlp
argerror3:
	movsx rdi, byte[errOption]
	call printString
	mov rax, 1
	jmp endrdlp
argerror4:
	movsx rdi, byte[errReadSpec]
	call printString
	mov rax, 1
	jmp endrdlp
argerror5:
	movsx rdi, byte[errWriteSpec]
	call printString
	mov rax, 1
	jmp endrdlp
argerror6:
	movsx rdi, byte[errReadName]
	call printString
	mov rax, 1
	jmp endrdlp
argerror7:
	movsx rdi, byte[errWriteName]
	call printString
	mov rax, 1
	jmp endrdlp
argerror8:
	movsx rdi, byte[errReadFile]
	call printString
	mov rax, 1
	jmp endrdlp
argerror9:
	movsx rdi, byte[errWriteFile]
	call printString
	mov rax, 1
	jmp endrdlp
endrdlp:


;print success or no success
pop rsi
pop rdi
	ret

; ***************************************************************
;  Read and verify header information
;	status = readHeader(readFileDesc, writeFileDesc,
;				fileSize, picWidth, picHeight)

; -----
;  2 -> BM				(+0)
;  4 file size				(+2)
;  4 skip				(+6)
;  4 header size			(+10)
;  4 skip				(+14)
;  4 width				(+18)
;  4 height				(+22)
;  2 skip				(+26)
;  2 depth (16/24/32)			(+28)
;  4 compression method code		(+30)
;  4 bytes of pixel data		(+34)
;  skip remaing header entries

; -----
;   Arguments:
;	read file descriptor (value)
;	write file descriptor (value)
;	file size (address)
;	image width (address)
;	image height (address)

;  Returns:
;	file size (via reference)
;	image width (via reference)
;	image height (via reference)
;	SUCCESS or NOSUCCESS

global	readHeader
readHeader:
	push rdi
	push rsi
	mov r14,rdi
	mov r13,rsi
	
;open the file
	mov rax,SYS_open
	mov edi,dword[r14]
	mov rsi,O_RDONLY
	syscall

	mov r12,rax
;read the file
	mov rax,SYS_read
	mov rdi,r12
	mov rsi,header
	mov rdx,HEADER_SIZE

	syscall
	
	mov r15,0
;verify signature
	mov r11,0
siglp:
	cmp r15,2
	je siglpend
	add r11b,byte[header+r15]
	inc r15
	jmp siglp
siglpend:
	cmp r11,"BM"
	jne hderror1
;get header size
	mov r11,0
	mov r15,2
hsizelp:
	cmp r15,6
	je hsizelpend
	add r11b,byte[header+r15]
	inc r15
	jmp hsizelp
hsizelpend:
	mov qword[rdx],r11

;get header width
	mov r15,18
	mov r11,0
hwidthlp:
	cmp r15,22
	je hwidthend
	add r11b,byte[header+r15]
	inc r15
	jmp hwidthlp
hwidthend:
	mov qword[rcx],r11

;get header height
	mov r15,22
	mov r11,0
hheightlp:
	cmp r15,26
	je hheightend
	add r11b,byte[header+r15]
	inc r15
	jmp hheightlp
hheightend:
	mov qword[r8],r11

	mov rax, SYS_write
	mov rdi, qword[r13]
	mov rsi, header
	mov rdx, HEADER_SIZE
	jmp hdending
	
;print success or no success
;error loops
hderror1:
	movsx rdi, byte[errReadHdr]
	call printString
	mov rax,1
	jmp hdending
hderror2:
	movsx rdi, byte[errFileType]
	call printString
	mov rax, 1
	jmp hdending
hderror3:
	movsx rdi,byte[errDepth]
	call printString
	mov rax, 1
	jmp hdending
hderror4:
	movsx rdi, byte[errCompType]
	call prinString
	mov rax, 1
	jmp hdending
hderror5:
	
	
hdending:


	ret

; ***************************************************************
;  Return a row from read buffer
;	This routine performs all buffer management

; ----
;  HLL Call:
;	status = readRow(readFileDesc, picWidth, rowBuffer);

;   Arguments:
;	read file descriptor (value)
;	image width (value)
;	row buffer (address)
;  Returns:
;	SUCCESS or NOSUCCESS

; -----
;  This routine returns SUCCESS when row has been returned
;	and returns NOSUCCESS only if there is an
;	error on write (which would not normally occur).

;  The read buffer itself and some misc. variables are used
;  ONLY by this routine and as such are not passed.

global	getRow
getRow:
	push rdi
	push rsi

	mov r15,rdi
	mov r14,rsi;width
	mov r13,rdx
	
	mov eax,r14d
	mov ebx,3
	imul ebx;width*3
	mov r12d,eax
	
	
	
;read value of descriptor rdi

	mov rax, SYS_read
	mov rdi, qword[r15]
	mov rsi, buffer
	mov rdx, r14
	syscall
	
	mov rsi,buffer

	mov r11,0;width index counter
	mov rdx,r13
getrowlp:

	cmp r11,r12
	je getrowfin

	cmp qword[curr],BUFF_SIZE
	jl currset
	mov rax, SYS_read
	mov rdi, qword[r15]
	mov rsi, buffer
	mov rdx, r14
	syscall
	
	mov qword[curr],0
	mov rsi,buffer ;header is inital information
	currset:
	mov bl, byte[rsi+curr]
	inc qword[curr]
	mov byte[rdx+r11],bl
	inc r11
	jmp getrowlp
	
getrowfin:
	pop rsi
	pop rdi
;get image width
;use curr as index
;return rax if read is succes or nosuccess

	ret

; ***************************************************************
;  Write image row to output file.
;	Writes exactly (width*3) bytes to file.
;	No requirement to buffer here.

; -----
;  HLL Call:
;	status = writeRow(writeFileDesc, pciWidth, rowBuffer);

;  Arguments are:
;	write file descriptor (value)
;	image width (value)
;	row buffer (address)

;  Returns:
;	SUCCESS or NOSUCESS

; -----
;  This routine returns SUCCESS when row has been written
;	and returns NOSUCCESS only if there is an
;	error on write (which would not normally occur).

;  The read buffer itself and some misc. variables are used
;  ONLY by this routine and as such are not passed.

global	writeRow
writeRow:
push rdi
push rsi


mov r15, rdi;descriptor
mov r14, rsi;width
mov r13, rdx;address

mov rax, SYS_write
mov rdi, qword[r15]
mov rsi, r13
mov rdx, r14

cmp rax,0
jge goodtimes

	mov rax,1
	jmp ending
goodtimes:
mov rax,0

ending:
pop rdx
pop rsi
pop rdi
;	YOUR CODE GOES HERE


	ret

; ***************************************************************
;  Convert pixels to grayscale.

; -----
;  HLL Call:
;	status = imageCvtToBW(picWidth, rowBuffer);

;  Arguments are:
;	image width (value)
;	row buffer (address)
;  Returns:
;	updated row buffer (via reference)

global	imageCvtToBW
imageCvtToBW:

	push rdi

	mov r15,0 ;byte navigator
	mov r14,rdi
	mov r13,rsi
	mov r12,0 ;pixel navigator
	mov ebx,3
	mov eax,r14d
	mov edx,0
	imul ebx
	mov r12d,eax
	mov rax,0
	mov rbx,0
	
BWloop:
	cmp r15,r12;if r15 > pixelsize, end loop
	jg  endBWloop
	mov r8,r15;store address of original position
	movsx ax,byte[rsi+r15];red
	inc r15
	movsx bx,byte[rsi+r15];green
	add ax,bx;red+green
	inc r15
	movsx bx,byte[rsi+r15];blue
	add ax,bx;red+green+blue
	mov bx,3
	mov dx,0
	idiv bx;red+green+blue / 30
	mov byte[rsi+r8],al
	inc r8
	mov byte[rsi+r8],al
	inc r8
	mov byte[rsi+r8],al
	inc r15
	jmp BWloop
endBWloop:

pop rdi
;	YOUR CODE GOES HERE


	ret

; ***************************************************************
;  Update pixels to increase brightness

; -----
;  HLL Call:
;	status = imageBrighten(picWidth, rowBuffer);

;  Arguments are:
;	image width (value)
;	row buffer (address)
;  Returns:
;	updated row buffer (via reference)

global	imageBrighten
imageBrighten:


;	YOUR CODE GOES HERE
	push rdi

	mov r15,0
	mov rax,rdi
	mov ebx, 3
	imul ebx
	mov r14d,eax
	mov eax,0
	mov ebx,0
Brightloop:
	
	cmp r15,r14
	jg Brightend
	movsx ax,byte[rsi+r15];color value
	mov bx,2
	idiv bx;color/2
	movsx bx,byte[rsi+r15]
	add ax,bx;color value /2 + color value
	cmp ax,255
	jl brightcont
		mov ax,255
	brightcont:
	mov byte[rsi+r15],al
	
	inc r15
	jmp Brightloop
	
	
Brightend:
	pop rdi
	ret

; ***************************************************************
;  Update pixels to darken (decrease brightness)

; -----
;  HLL Call:
;	status = imageDarken(picWidth, rowBuffer);

;  Arguments are:
;	image width (value)
;	row buffer (address)
;  Returns:
;	updated row buffer (via reference)

global	imageDarken
imageDarken:
push rdi


mov r15,0
mov rax,rdi
mov edx,0
mov ebx,3
imul ebx
mov r14d,eax


Darkloop:
	cmp r15,r14
	jg Darkloopend
	movsx ax,byte[rsi+r15];color
	mov bx, 2
	idiv bx;color / 2
	mov byte[rsi+r15],al
	inc r15
	jmp Darkloop
Darkloopend:

pop rdi

;	YOUR CODE GOES HERE


	ret

; ***************************************************************

