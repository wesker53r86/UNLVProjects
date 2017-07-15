#  CS 218, MIPS Assignment #5
# Rehum Mikaelo Padua
# Section 1001

#  Write an assembly language procedure to
#  determine of a target array can be split into
#  two subsets that each total the same sum.

#  Specifically, given an array of integers, is it possible to
#  divide the ints into two groups, so that the sums of the
#  two groups are the same.  Every int must be in one group
#  or the other.

#####################################################################
#  data segment

.data

# -----
#  Constants

TRUE = 1
FALSE = 0

# -----
#  Array declarations
#	Note, uses an array of addresses

arr0:		.word	 2,  5, 10,  4
arr1:		.word	 2,  5, 11,  4
arr2:		.word	 9,  1,  8,  2,  7
		.word	 3,  6,  4,  5, 11 
arr3:		.word	11, 13, 15, 17, 19
		.word	21, 23, 25, 27, 29
arr4:		.word	10, 12, 14, 16, 18
		.word	20, 22, 28, 99
arr5:		.word	30, 61, 93, 16, 47
		.word	55, 72, 11, 99,  7
		.word	28, 82
arr6:		.word	30, 61, 93, 16, 47
		.word	55, 72, 11, 99,  7
		.word	28, 81
arr7:		.word	172, 512, 832, 691
		.word	204, 448, 777, 342
arr8:		.word	172, 512, 832, 615
		.word	204, 448, 777, 342
arr9:		.word	10, 12, 14, 16, 18
		.word	11, 13, 15, 17, 19
		.word	20, 22, 24, 26, 28
		.word	21, 23, 25, 27, 29

arrCount:	.word	10
addrs:		.space	10*4
lengths:	.word	 4,  4, 10, 10,  9
		.word	12, 12,  8,  8, 20

# -----
#  Variables for main

hdr:		.ascii	"\nMIPS Assignment #5\n"
		.asciiz	"Sum Split Array Determination Program\n"

yesMsg:		.asciiz	"\nYes, the array can be split into two sets.\n"
noMsg:		.asciiz	"\nNo, the target sum can not be split into two set.\n"

endMsg:		.ascii	"\n\n**********************************************"
		.asciiz	"\nGame over, thanks for playing.\n"

# -----
#  Local variables for prtList() function.

title:		.ascii	"\n**********************************************\n"
		.asciiz	"Set of Numbers: \n\n"
tab:		.asciiz	"\t"
newLine:	.asciiz	"\n"


#####################################################################
#  text/code segment

.text

.globl main
.ent main
main:

# -----
#  Display program header.

	la	$a0, hdr
	li	$v0, 4
	syscall					# print header

# -----
#  Populate array of addresses.
#	The array of addresses allows a loop for calling the
#	function on a series of different arrays.

	la	$t0, addrs

	la	$t1, arr0
	sw	$t1, ($t0)
	add	$t0, $t0, 4
	la	$t1, arr1
	sw	$t1, ($t0)
	add	$t0, $t0, 4
	la	$t1, arr2
	sw	$t1, ($t0)
	add	$t0, $t0, 4
	la	$t1, arr3
	sw	$t1, ($t0)
	add	$t0, $t0, 4
	la	$t1, arr4
	sw	$t1, ($t0)
	add	$t0, $t0, 4
	la	$t1, arr5
	sw	$t1, ($t0)
	add	$t0, $t0, 4
	la	$t1, arr6
	sw	$t1, ($t0)
	add	$t0, $t0, 4
	la	$t1, arr7
	sw	$t1, ($t0)
	add	$t0, $t0, 4
	la	$t1, arr8
	sw	$t1, ($t0)
	add	$t0, $t0, 4
	la	$t1, arr9
	sw	$t1, ($t0)

# -----
#  Main processing loop
#	Note, calls the functions with the arrays
#	from a table of addresses (populated above).

	lw	$s0, arrCount
	la	$s1, addrs
	la	$s2, lengths
doNext:

# -----
#  Display set of numbers.

	lw	$a0, ($s1)			# addrs[i]
	lw	$a1, ($s2)			# lengths[i]
	jal	prtList

# -----
#  call splitArray() fucntion to determine if given
#  array can be split into two sets, each set totaling
#  the same sum.
#	Note, returns true or false.
#	HLL Call: boolAns = splitArray(array, currentIndex, sum1,
#					sum2, arraySize)

	lw	$a0, ($s1)			# array (starting address)
	li	$a1, 0				# initially, current index = 0
	li	$a2, 0				# initially, sum1 = 0
	li	$a3, 0				# initially, sum2 = 0
	subu	$sp, $sp, 4
	lw	$t0, ($s2)
	sw	$t0, ($sp)
	jal	splitArray
	add	$sp, $sp, 4

	beq	$v0, TRUE, sayYes

	la	$a0, noMsg
	j	prtMsg
sayYes:
	la	$a0, yesMsg
prtMsg:
	li	$v0, 4
	syscall

# -----
#  Check next array...

	add	$s1, $s1, 4
	add	$s2, $s2, 4
	sub	$s0, $s0, 1
	bgtz	$s0, doNext

# -----
#  Done, terminate program.

	li	$v0, 4
	la	$a0, endMsg
	syscall

	li	$v0, 10
	syscall					# all done...
.end main

#####################################################################
#  MIPS assembly language procedure, prtList, to display
#	a list of numbers and return the sum.
#	The numbers should be printed 5 per line.
#  Note, due to the system calls, the saved registers must
#	be used.  As such, push/pop saved registers altered.

# -----
#    Arguments:
#	$a0 - starting address of the list
#	$a1 - list length

#    Returns:
#	N/A

.globl prtList
.ent prtList
prtList:

move $t0, $a0
move $t1, $a1
li $t2,0 #index
li $t3,0 #rowsize

prtlp:

beq $t2,$t1,endprtlp #end if index= length

lw $t4,($t0) #get num

bne $t3,5, prtcont
li $t3,0

li $v0, 4
la $a0, newLine
syscall

prtcont:

li $v0, 1
move $a0, $t4
syscall

li $v0, 4
la $a0, tab
syscall

add $t2,$t2,1
add $t0,$t0,4
add $t3,$t3,1

b prtlp

endprtlp:

jr $ra

.end prtList

#####################################################################
#  Procedure to recursivly determine if a given target sum
#	can be computed from the numbers in a given array.
#	Returns boolean, TRUE is yes and FALSE if no

#	public boolean splitArray(int[] nums) {
#	private boolean helper(int start, int[] nums, int sum1, int sum2) {
#
#	    if (start >= nums.length) return sum1 == sum2;
#
#	    return helper(0, nums, 0, 0);
#	}
 
#	    return helper(start + 1, nums, sum1 + nums[start], sum2)
#	            || helper(start + 1, nums, sum1, sum2 + nums[start]);
#	}

# -----
#  Arguments:
#	$a0 - array address
#	$a1 - current index
#	$a2 - sum1 so far
#	$a3 - sum2 so far
#	($fp) - array size
#  Returns:
#	true or false (in $v0)

.globl splitArray
.ent splitArray
splitArray:

sub $sp,$sp,44 #push operations 
sw $ra,($sp)
sw $fp,4($sp)
sw $a0,8($sp)
sw $a1,12($sp)
sw $a2,16($sp)
sw $a3,20($sp)sdf
sw $s1,24($sp)
sw $s2,28($sp)
sw $s3,32($sp)
sw $s4,36($sp)
sw $s5,40($sp)
add $fp,$sp,44

lw $t4,($fp) #array size

#----------------------Base Case-------
bne $a1,$t4, gotofuncs

move $t2,$a2
move $t3,$a3

beq $t2,$t3,istrue

isfalse:
la $v0, FALSE
b funcout

istrue:
la $v0, TRUE
b funcout

gotofuncs:

#---------------------------
move $t0,$a0 #array (not subject to change)
move $s3,$a1 #index (subject to change)
move $s4,$a2 #sum1 (subject to change)
move $s5,$a3 #sum2 (subject to change)

mul $t5,$s3,4 #convert to datasize
add $t0,$t0,$t5 #address of number
lw $t6,($t0) #get number 

add $s1,$s4,$t6 #sum1 + num
add $s2,$s5,$t6 #sum2 + num

add $t1,$s3,1 #increment index

move $a1,$t1 #place arguments
move $a2,$s1
move $a3,$s5
sub $sp, $sp, 4
lw $t4,($fp)
sw $t4,($sp)
jal splitArray
move $t7, $v0
add $sp,$sp,4

beq $t7, TRUE, funcout

add $t1,$s3,1 #increment index


move $a1,$t1 #place arguments
move $a2,$s4
move $a3,$s2
sub $sp, $sp, 4
lw $t4,($fp)
sw $t4,($sp)
jal splitArray
move $t8, $v0
add $sp,$sp,4

beq $t8, TRUE, funcout

firstcheck:
bne $t7,TRUE, secondcheck
move $v0,$t7
b funcout

secondcheck:
bne $t8,TRUE, itsafalse
move $v0,$t8
b funcout


itsafalse:
move $v0,$t8
b funcout

funcout:

lw $a3,20($sp) #pop operations
lw $a2,16($sp)
lw $a1,12($sp)
lw $a0,8($sp)
lw $fp,4($sp)
lw $ra,($sp)
lw $s1,24($sp)
lw $s2,28($sp)
lw $s3,32($sp)
lw $s4,36($sp)
lw $s5,40($sp)
add $sp,$sp,44

jr $ra

.end splitArray












