#  CS 218, MIPS Assignment #3
#  MIPS assembly language main program and procedures:

#  * MIPS assembly language function, prtHeaders() to 
#    display some headers as per assignment format example.

#  * MIPS assembly language function, calcAreas(), 
#    to calculate the area for each pentagon in a
#    series of pentagons.

#  * MIPS assembly language function, insertionSort(), to
#    sort the areas array (small to large).

#  * MIPS assembly language function, areasStats(),
#    that will find the sum, minimum, maximum, median, and
#    integer average, and float average of the areas array.
#    NOTE: this function must call the findSum(), iAverage(),
#    fVerage(), and insertionSort() function.

#  * MIPS assembly language function, printAreas(), to
#    display the areas array statistical information:
#    sum, minimum, maximum, median, integer average, and
#    float average in the format shown in the example.
#    The numbers should be printed 8 per line (see example).

#Rehum Mikaelo Padua
#Section 1001
#Mips Assignment 3


#####################################################################
#  data segment

.data

# -----
#  Data declarations for main.

sides1:		.word	 34,  32,  31,  35,  34,  33,  32,  37,  38,  39
		.word	 32,  30,  36,  38,  30,  44,  42,  41,  45,  44
		.word	 43,  42,  47,  48,  49,  42,  40,  46,  48,  40
heights1:	.word	119, 117, 115, 113, 111, 119, 117, 115, 113, 111
		.word	112, 114, 116, 118, 110, 129, 127, 125, 123, 121
		.word	129, 127, 125, 123, 121, 122, 124, 126, 128, 120
areas1:		.space	120
len1:		.word	30
min1:		.word	0
med1:		.word	0
max1:		.word	0
sum1:		.word	0
iAve1:		.word	0
fAve1:		.float	0.0

sides2:		.word	 42,  71,  76,  57,  45,  50,  41,  53,  42,  45
		.word	 44,  52,  44,  76,  57,  44,  46,  40,  46,  53
		.word	 52,  53,  42,  69,  44,  51,  61,  78,  46,  47
		.word	 53,  45,  51,  69,  48,  59,  62,  74,  50,  51
		.word	 40,  44,  46,  57,  54,  55,  46,  49,  48,  52
		.word	 41,  43,  44,  56,  50,  56,  75,  57,  50,  56
		.word	 42,  55,  57,  42,  47,  47,  67,  79,  48,  44
		.word	 50,  41,  43,  42,  45,  60,  51,  53,  52,  55
		.word	 52,  81,  86,  67,  55,  61,  52,  63,  52,  55
		.word	 54,  62,  54,  86,  67,  54,  56,  50,  56,  63
		.word	 62,  63,  52,  79,  54,  61,  71,  88,  56,  57
		.word	 63,  55,  61,  79,  58,  69,  72,  84,  60,  61
		.word	 50,  54,  56,  67,  64,  65,  56,  59,  58,  62
		.word	 51,  53,  54,  66,  60,  66,  85,  67,  60,  66
		.word	 52,  75,  77,  62,  57,  57,  77,  89,  58,  54
heights2:	.word	145, 155, 143, 154, 168, 159, 142, 156, 149, 141
		.word	147, 141, 157, 141, 157, 147, 147, 151, 151, 149
		.word	142, 149, 145, 149, 143, 145, 141, 142, 144, 149
		.word	146, 142, 142, 141, 146, 150, 154, 148, 158, 152
		.word	157, 147, 159, 144, 143, 144, 145, 146, 145, 144
		.word	151, 153, 146, 159, 151, 142, 150, 158, 141, 149
		.word	159, 144, 147, 149, 152, 154, 146, 148, 152, 153
		.word	142, 151, 156, 157, 146, 152, 161, 166, 167, 156
		.word	155, 165, 153, 164, 178, 169, 152, 166, 159, 151
		.word	157, 151, 167, 151, 167, 157, 157, 161, 161, 159
		.word	152, 159, 155, 159, 153, 155, 151, 152, 154, 159
		.word	156, 152, 152, 151, 156, 160, 164, 158, 168, 162
		.word	167, 157, 169, 154, 153, 154, 155, 156, 155, 154
		.word	161, 163, 156, 169, 161, 152, 160, 168, 151, 159
		.word	169, 164, 167, 169, 162, 164, 156, 168, 162, 163
areas2:		.space	600
len2:		.word	150
min2:		.word	0
med2:		.word	0
max2:		.word	0
sum2:		.word	0
iAve2:		.word	0
fAve2:		.float	0.0

sides3:		.word	 71,  48,  55,  43,  52,  40,  58,  71,  54,  52
		.word	 35,  62,  76,  52,  53,  59,  56,  42,  58,  41
		.word	 72,  45,  46,  47,  45,  34,  46,  30,  56,  53
		.word	 53,  42,  31,  31,  51,  34,  42,  46,  58,  53
		.word	 52,  59,  45,  39,  51,  45,  39,  42,  44,  49
		.word	 50,  44,  46,  77,  54,  25,  26,  29,  48,  62
		.word	 41,  43,  46,  49,  51,  52,  54,  58,  41,  65
		.word	 69,  74,  39,  52,  77,  44,  46,  51,  52,  53
		.word	 41,  53,  34,  36,  40,  56,  85,  47,  40,  46
		.word	 81,  58,  65,  53,  62,  50,  68,  81,  64,  62
		.word	 45,  72,  86,  62,  63,  69,  66,  52,  68,  51
		.word	 82,  55,  56,  57,  55,  44,  56,  40,  66,  63
		.word	 63,  52,  41,  41,  61,  44,  52,  56,  68,  63
		.word	 62,  69,  55,  49,  64,  55,  49,  52,  54,  59
		.word	 60,  54,  56,  87,  64,  35,  36,  39,  58,  72
		.word	 51,  53,  56,  59,  61,  72,  74,  68,  51,  75
		.word	 79,  84,  49,  62,  87,  74,  66,  61,  62,  63
		.word	 51,  63,  44,  46,  61,  66, 105,  57,  50,  56
heights3:	.word	143, 142, 141, 141, 141, 144, 142, 146, 158, 143
		.word	142, 149, 145, 149, 141, 155, 149, 142, 144, 149
		.word	140, 144, 146, 157, 144, 135, 146, 129, 148, 142
		.word	141, 143, 146, 149, 151, 152, 154, 158, 161, 165
		.word	169, 174, 127, 179, 152, 141, 144, 156, 142, 133
		.word	141, 153, 154, 146, 140, 156, 175, 167, 150, 146
		.word	154, 155, 145, 162, 152, 141, 142, 156, 156, 143
		.word	168, 159, 151, 142, 153, 141, 176, 151, 149, 156
		.word	146, 179, 149, 137, 146, 154, 154, 156, 164, 142
		.word	153, 152, 151, 151, 151, 154, 152, 156, 168, 153
		.word	152, 159, 155, 159, 151, 165, 159, 152, 154, 159
		.word	150, 154, 156, 167, 154, 145, 156, 139, 158, 152
		.word	151, 153, 156, 159, 161, 162, 164, 168, 171, 175
		.word	179, 184, 137, 189, 162, 151, 154, 166, 152, 143
		.word	151, 163, 164, 156, 150, 166, 185, 177, 160, 156
		.word	164, 165, 155, 172, 162, 161, 163, 166, 166, 153
		.word	178, 169, 161, 152, 163, 163, 196, 161, 159, 166
		.word	156, 189, 159, 147, 176, 164, 164, 166, 174, 152
areas3:		.space	720
len3:		.word	180
min3:		.word	0
med3:		.word	0
max3:		.word	0
sum3:		.word	0
iAve3:		.word	0
fAve3:		.float	0.0

sides4:		.word	 53,  52,  46,  76,  50,  56,  64,  65,  55,  56
		.word	 71,  47,  50,  27,  74,  65,  51,  67,  61,  59
		.word	 53,  52,  46,  56,  50,  56,  64,  56,  55,  52
		.word	 51,  63,  53,  50,  55,  59,  55,  58,  53,  55
		.word	 64,  41,  42,  53,  66,  54,  46,  53,  56,  63
		.word	 27,  64,  50,  72,  54,  55,  56,  62,  58,  62
		.word	 51,  53,  53,  50,  57,  51,  55,  58,  53,  55
		.word	 57,  26,  62,  57,  57,  67,  69,  77,  75,  54
		.word	 53,  54,  52,  43,  76,  54,  56,  52,  56,  63
		.word	 54,  59,  52,  53,  50,  61,  52,  59,  59,  52
		.word	 55,  56,  62,  57,  57,  57,  59,  77,  75,  44
		.word	 79,  53,  56,  40,  55,  52,  54,  58,  53,  52
		.word	 61,  72,  51,  53,  56,  69,  54,  52,  55,  51
		.word	 64,  54,  54,  43,  76,  54,  56,  52,  56,  63
		.word	 49,  44,  54,  54,  67,  43,  59,  61,  65,  56
		.word	 63,  62,  56,  86,  60,  66,  74,  75,  65,  66
		.word	 81,  57,  60,  37,  84,  75,  61,  77,  71,  69
		.word	 63,  62,  56,  66,  60,  66,  74,  66,  65,  62
		.word	 61,  73,  63,  60,  65,  69,  65,  68,  63,  65
		.word	 74,  51,  52,  63,  76,  64,  56,  63,  66,  73
		.word	 37,  74,  60,  82,  64,  65,  66,  72,  68,  72
		.word	 61,  63,  63,  60,  67,  61,  65,  68,  63,  65
		.word	 67,  36,  72,  67,  67,  77,  79,  87,  85,  64
		.word	 63,  64,  62,  53,  86,  64,  66,  62,  66,  73
		.word	 64,  69,  62,  63,  60,  71,  62,  69,  69,  62
		.word	 65,  66,  72,  67,  67,  67,  69,  87,  85,  54
		.word	 89,  63,  66,  50,  65,  62,  64,  68,  63,  62
		.word	 71,  82,  61,  63,  66,  79,  64,  62,  65,  61
		.word	 74,  64,  64,  53,  86,  64,  66,  62,  66,  73
		.word	 59,  54,  64,  64,  77,  53,  69,  71,  75,  66
heights4:	.word	145, 144, 143, 157, 153, 154, 154, 156, 164, 142
		.word	166, 152, 152, 151, 146, 150, 154, 178, 178, 192
		.word	182, 195, 157, 152, 157, 147, 167, 179, 188, 194
		.word	154, 152, 174, 186, 197, 154, 156, 150, 156, 153
		.word	152, 151, 156, 187, 190, 150, 151, 153, 152, 145
		.word	157, 187, 199, 151, 153, 154, 155, 156, 175, 194
		.word	149, 156, 162, 151, 157, 177, 199, 197, 175, 154
		.word	164, 141, 142, 153, 166, 154, 146, 153, 156, 163
		.word	151, 158, 177, 143, 178, 152, 151, 150, 155, 150
		.word	157, 144, 150, 172, 154, 155, 156, 162, 158, 192
		.word	153, 152, 146, 176, 151, 156, 164, 165, 195, 156
		.word	157, 153, 153, 140, 155, 151, 154, 158, 153, 152
		.word	169, 156, 162, 127, 157, 157, 159, 177, 175, 154
		.word	181, 155, 155, 152, 157, 155, 150, 159, 152, 154
		.word	161, 152, 151, 152, 171, 159, 154, 152, 155, 151
		.word	155, 154, 153, 167, 163, 164, 164, 166, 174, 152
		.word	176, 162, 162, 161, 156, 160, 164, 188, 188, 202
		.word	192, 205, 167, 162, 167, 157, 177, 189, 198, 204
		.word	164, 162, 184, 196, 207, 164, 166, 160, 166, 163
		.word	162, 161, 166, 197, 204, 160, 161, 163, 162, 155
		.word	167, 197, 209, 161, 163, 164, 165, 166, 185, 204
		.word	159, 166, 172, 161, 167, 187, 207, 203, 185, 164
		.word	174, 151, 152, 163, 176, 164, 156, 163, 166, 173
		.word	161, 168, 187, 153, 188, 162, 161, 160, 165, 160
		.word	167, 154, 160, 182, 164, 165, 166, 172, 168, 202
		.word	163, 162, 156, 186, 161, 166, 174, 175, 205, 166
		.word	167, 163, 163, 150, 165, 161, 164, 168, 163, 162
		.word	179, 166, 172, 137, 167, 167, 169, 187, 185, 164
		.word	191, 165, 165, 162, 167, 165, 160, 169, 162, 164
		.word	171, 162, 161, 162, 181, 169, 164, 162, 165, 161
len4:		.word	300
areas4:		.space	1200
min4:		.word	0
med4:		.word	0
max4:		.word	0
sum4:		.word	0
iAve4:		.word	0
fAve4:		.float	0.0

sides5:		.word	 99,  74,  77,  79,  72,  64,  66,  68,  62,  73
		.word	 50,  54,  56,  57,  54,  55,  56,  59,  48,  72
		.word	 45,  75,  55,  52,  57,  55,  50,  59,  52,  54
		.word	 50,  51,  54,  59,  40,  55,  61,  64,  58,  73
		.word	 51,  53,  54,  56,  40,  56,  65,  67,  70,  76
		.word	 44,  54,  54,  43,  76,  54,  56,  52,  56,  63
		.word	 54,  52,  57,  66,  77,  54,  56,  50,  36,  53
		.word	 69,  74,  77,  79,  82,  64,  66,  68,  72,  73
		.word	 55,  52,  56,  55,  40,  57,  63,  79,  52,  74
		.word	 56,  52,  52,  51,  46,  50,  54,  78,  58,  72
		.word	 57,  57,  57,  57,  47,  57,  67,  77,  57,  77
		.word	 57,  67,  59,  51,  53,  54,  55,  56,  75,  74
		.word	 54,  52,  74   66,  67,  54,  56,  50,  36,  53
		.word	 62,  65,  57,  52,  57,  47,  67,  59,  58,  73
		.word	 85,  82,  96,  95,  60,  87,  23,  69,  42,  84
		.word	 90,  90,  90,  90,  90,  90,  90,  90,  90,  90
		.word	 90,  90,  90,  90,  90,  90,  90,  90,  90,  90
		.word	 82,  64,  65,  67,  51,  68,  73,  76,  86,  91
		.word	 81,  63,  74,  96,  90,  26,  95,  97,  99,  96
		.word	 59,  51,  59,  31,  49,  51,  69,  71,  79,  71
		.word	 41,  43,  46,  49,  51,  23,  78,  82,  21,  87
		.word	103,  84,  87,  89,  82,  74,  76,  78,  72,  83
		.word	 60,  64,  66,  67,  64,  65,  66,  69,  58,  82
		.word	 55,  85,  65,  62,  67,  65,  60,  69,  62,  64
		.word	 60,  61,  69,  69,  50,  65,  71,  74,  68,  83
		.word	 61,  63,  63,  66,  55,  66,  75,  77,  81,  86
		.word	 54,  64,  64,  53,  86,  64,  66,  62,  66,  73
		.word	 64,  62,  67,  76,  87,  64,  66,  60,  46,  63
		.word	 79,  84,  87,  89,  92,  74,  76,  78,  82,  83
		.word	 65,  62,  66,  65,  50,  67,  73,  89,  62,  84
		.word	 66,  62,  62,  61,  56,  60,  64,  88,  68,  82
		.word	 67,  67,  67,  67,  57,  67,  77,  87,  67,  87
		.word	 67,  77,  69,  61,  63,  64,  65,  66,  85,  84
		.word	 64,  62,  84   76,  77,  64,  66,  60,  46,  63
		.word	 72,  75,  67,  62,  67,  57,  77,  69,  68,  83
		.word	 95,  92, 106, 105,  70,  97,  33,  79,  52,  94
		.word	 99, 100, 101, 102,  99, 101, 110, 104, 102, 100
		.word	 93, 102, 102, 109, 100, 107, 111, 105, 108, 101
		.word	 92,  74,  75,  77,  61,  78,  83,  86,  96, 103
		.word	 91,  73,  84, 106, 110,  36, 105, 107, 109, 106
		.word	 69,  61,  69,  41,  59,  61,  79,  81,  89,  81
		.word	 51,  53,  56,  59,  61,  33,  88,  92,  31,  97
heights5:	.word	852, 159, 155, 159, 151, 155, 159, 152, 144, 149
		.word	162, 165, 157, 152, 157, 147, 167, 159, 168, 174
		.word	159, 154, 156, 157, 154, 155, 156, 159, 148, 172
		.word	141, 143, 146, 149, 151, 152, 154, 158, 161, 165
		.word	159, 153, 154, 156, 140, 156, 175, 187, 155, 156
		.word	152, 151, 176, 187, 170, 150, 151, 153, 152, 145
		.word	147, 153, 153, 140, 165, 151, 154, 158, 153, 152
		.word	151, 153, 154, 156, 140, 156, 175, 187, 160, 196
		.word	134, 152, 174, 186, 167, 154, 156, 150, 156, 153
		.word	182, 165, 157, 152, 157, 147, 167, 179, 168, 194
		.word	159, 151, 159, 151, 149, 151, 169, 171, 169, 191
		.word	153, 153, 153, 150, 155, 159, 143, 148, 153, 155
		.word	151, 155, 157, 163, 166, 168, 171, 177, 164, 176
		.word	152, 159, 155, 159, 151, 155, 159, 142, 144, 149
		.word	441, 443, 446, 449, 451, 452, 454, 458, 461, 465
		.word	352, 352, 352, 352, 352, 352, 352, 352, 352, 352
		.word	352, 352, 352, 352, 352, 352, 352, 352, 352, 352
		.word	262, 265, 257, 252, 257, 247, 267, 259, 268, 274
		.word	152, 159, 155, 159, 151, 155, 159, 152, 154, 159
		.word	152, 154, 158, 161, 165, 121, 232, 567, 211, 121
		.word	141, 143, 146, 149, 151, 152, 154, 158, 161, 265
		.word	862, 169, 165, 169, 171, 165, 189, 172, 154, 159
		.word	172, 175, 167, 162, 177, 157, 187, 179, 178, 184
		.word	169, 164, 166, 167, 174, 165, 186, 179, 158, 192
		.word	151, 153, 156, 169, 161, 162, 184, 178, 171, 185
		.word	169, 163, 164, 166, 160, 166, 185, 197, 175, 196
		.word	162, 161, 186, 197, 190, 160, 181, 193, 172, 185
		.word	157, 163, 163, 160, 175, 161, 184, 198, 173, 182
		.word	161, 163, 164, 166, 170, 166, 185, 197, 180, 206
		.word	144, 162, 184, 196, 187, 164, 186, 160, 186, 173
		.word	192, 175, 167, 162, 167, 167, 187, 199, 188, 204
		.word	169, 161, 169, 161, 169, 161, 189, 191, 189, 201
		.word	163, 163, 163, 160, 165, 169, 183, 198, 183, 175
		.word	161, 165, 167, 173, 176, 178, 181, 197, 194, 176
		.word	162, 169, 165, 179, 161, 175, 189, 192, 194, 179
		.word	451, 453, 466, 459, 461, 472, 484, 478, 491, 485
		.word	362, 362, 362, 362, 362, 372, 382, 372, 392, 382
		.word	362, 362, 362, 362, 372, 372, 382, 372, 362, 382
		.word	272, 275, 267, 262, 277, 277, 287, 279, 288, 284
		.word	162, 169, 165, 169, 171, 175, 189, 172, 174, 199
		.word	162, 164, 168, 171, 175, 171, 282, 577, 271, 191
		.word	151, 153, 166, 159, 181, 172, 184, 178, 171, 275
areas5:		.space	1680
len5:		.word	420
min5:		.word	0
med5:		.word	0
max5:		.word	0
sum5:		.word	0
iAve5:		.word	0
fAve5:		.float	0.0

# -----
#  Variables for main.

asstHeader:	.ascii	"\nMIPS Assignment #3\n"
		.asciiz	"Pentagon Areas Program\n\n"

# -----
#  Local variables/constants for prtHeaders() function.

hdrTitle:	.ascii	"\n**********************************"
		.ascii	"**********************************"
		.asciiz	"\nPentagon Data Set #"
hdrLength:	.asciiz	"\nLength: "

hdrStats:	.asciiz	"\nAreas - Stats: \n"
hdrAreas:	.asciiz	"\n\nAreas - Values: \n"

# -----
#  Local variables/constants for printResults() function.

NUMS_PER_ROW = 8

spc:		.asciiz	"     "
newLine:	.asciiz	"\n"

str1:		.asciiz	"   sum  = "
str2:		.asciiz	"\n   min  = "
str3:		.asciiz	"\n   max  = "
str4:		.asciiz	"\n   med  = "
str5:		.asciiz	"\n   int ave = "
str6:		.asciiz	"\n   flt ave = "


#####################################################################
#  text/code segment

# -----
#  Basic flow:
#	for each data set:
#	  * display headers
#	  * calculate diagonals, including sort
#	  * calculate diagonals stats (min, max, med, sum, iAve, and fAve)
#	  * display diagonals and diagonals stats

.text
.globl	main
.ent main
main:

# --------------------------------------------------------
#  Display Program Header.

	la	$a0, asstHeader
	li	$v0, 4
	syscall					# print header
	li	$s0, 1				# counter, data set number

# --------------------------------------------------------
#  Data Set #1

	move	$a0, $s0
	lw	$a1, len1
	jal	prtHeaders
	add	$s0, $s0, 1

# -----
#  Pentagon areas calculation function
#	calcAreas(sides, heights, len, areas)

	la	$a0, sides1
	la	$a1, heights1
	lw	$a2, len1
	la	$a3, areas1
	jal	calcAreas

#  Generate areas stats.
#  Note, function also calls the findSum(), iAverage(), and fAverage()
#	functions.  Also calls the insertionSort() function.
#	areasStats(diags, len, sum, min, max, med, iAve, fAve)

	la	$a0, areas1			# arg 1
	lw	$a1, len1			# arg 2
	la	$a2, sum1			# arg 3
	la	$a3, min1			# arg 4
	subu	$sp, $sp, 16
	la	$t0, max1
	sw	$t0, ($sp)			# arg 5, on stack
	la	$t0, med1
	sw	$t0, 4($sp)			# arg 6, on stack
	la	$t0, iAve1
	sw	$t0, 8($sp)			# arg 7, on stack
	la	$t6, fAve1
	sw	$t6, 12($sp)			# arg 8, on stack
	jal	areasStats
	addu	$sp, $sp, 16			# clear stack

#  Show final areas array stats.
#	printResults(areas, len, sum, min, max, med, iAve, fAve)

	la	$a0, areas1			# arg 1
	lw	$a1, len1			# arg 2
	lw	$a2, sum1			# arg 3
	lw	$a3, min1			# arg 4
	subu	$sp, $sp, 16
	lw	$t0, max1
	sw	$t0, ($sp)			# arg 5, on stack
	lw	$t0, med1
	sw	$t0, 4($sp)			# arg 6, on stack
	lw	$t0, iAve1
	sw	$t0, 8($sp)			# arg 7, on stack
	l.s	$f6, fAve1
	s.s	$f6, 12($sp)			# arg 8, on stack
	jal	printResults
	addu	$sp, $sp, 16			# clear stack

# --------------------------------------------------------
#  Data Set #2

	move	$a0, $s0
	lw	$a1, len2
	jal	prtHeaders
	add	$s0, $s0, 1

# -----
#  Pentagon areas calculation function
#	calcAreas(sides, heights, len, areas)

	la	$a0, sides2
	la	$a1, heights2
	lw	$a2, len2
	la	$a3, areas2
	jal	calcAreas

#  Generate areas stats.
#  Note, function also calls the findSum(), iAverage(), and fAverage()
#	functions.  Also calls the insertionSort() function.
#	areasStats(diags, len, sum, min, max, med, iAve, fAve)

	la	$a0, areas2			# arg 1
	lw	$a1, len2			# arg 2
	la	$a2, sum2			# arg 3
	la	$a3, min2			# arg 4
	subu	$sp, $sp, 16
	la	$t0, max2
	sw	$t0, ($sp)			# arg 5, on stack
	la	$t0, med2
	sw	$t0, 4($sp)			# arg 6, on stack
	la	$t0, iAve2
	sw	$t0, 8($sp)			# arg 7, on stack
	la	$t6, fAve2
	sw	$t6, 12($sp)			# arg 8, on stack
	jal	areasStats
	addu	$sp, $sp, 16			# clear stack

#  Show final areas array stats.
#	printResults(areas, len, sum, min, max, med, iAve, fAve)

	la	$a0, areas2			# arg 1
	lw	$a1, len2			# arg 2
	lw	$a2, sum2			# arg 3
	lw	$a3, min2			# arg 4
	subu	$sp, $sp, 16
	lw	$t0, max2
	sw	$t0, ($sp)			# arg 5, on stack
	lw	$t0, med2
	sw	$t0, 4($sp)			# arg 6, on stack
	lw	$t0, iAve2
	sw	$t0, 8($sp)			# arg 7, on stack
	l.s	$f6, fAve2
	s.s	$f6, 12($sp)			# arg 8, on stack
	jal	printResults
	addu	$sp, $sp, 16			# clear stack

# --------------------------------------------------------
#  Data Set #3

	move	$a0, $s0
	lw	$a1, len3
	jal	prtHeaders
	add	$s0, $s0, 1

# -----
#  Pentagon areas calculation function
#	calcAreas(sides, heights, len, areas)

	la	$a0, sides3
	la	$a1, heights3
	lw	$a2, len3
	la	$a3, areas3
	jal	calcAreas

#  Generate areas stats.
#  Note, function also calls the findSum(), iAverage(), and fAverage()
#	functions.  Also calls the insertionSort() function.
#	areasStats(diags, len, sum, min, max, med, iAve, fAve)

	la	$a0, areas3			# arg 1
	lw	$a1, len3			# arg 2
	la	$a2, sum3			# arg 3
	la	$a3, min3			# arg 4
	subu	$sp, $sp, 16
	la	$t0, max3
	sw	$t0, ($sp)			# arg 5, on stack
	la	$t0, med3
	sw	$t0, 4($sp)			# arg 6, on stack
	la	$t0, iAve3
	sw	$t0, 8($sp)			# arg 7, on stack
	la	$t6, fAve3
	sw	$t6, 12($sp)			# arg 8, on stack
	jal	areasStats
	addu	$sp, $sp, 16			# clear stack

#  Show final areas array stats.
#	printResults(areas, len, sum, min, max, med, iAve, fAve)

	la	$a0, areas3			# arg 1
	lw	$a1, len3			# arg 2
	lw	$a2, sum3			# arg 3
	lw	$a3, min3			# arg 4
	subu	$sp, $sp, 16
	lw	$t0, max3
	sw	$t0, ($sp)			# arg 5, on stack
	lw	$t0, med3
	sw	$t0, 4($sp)			# arg 6, on stack
	lw	$t0, iAve3
	sw	$t0, 8($sp)			# arg 7, on stack
	l.s	$f6, fAve3
	s.s	$f6, 12($sp)			# arg 8, on stack
	jal	printResults
	addu	$sp, $sp, 16			# clear stack

# --------------------------------------------------------
#  Data Set #4

	move	$a0, $s0
	lw	$a1, len4
	jal	prtHeaders
	add	$s0, $s0, 1

# -----
#  Pentagon areas calculation function
#	calcAreas(sides, heights, len, areas)

	la	$a0, sides4
	la	$a1, heights4
	lw	$a2, len4
	la	$a3, areas4
	jal	calcAreas

#  Generate areas stats.
#  Note, function also calls the findSum(), iAverage(), and fAverage()
#	functions.  Also calls the insertionSort() function.
#	areasStats(diags, len, sum, min, max, med, iAve, fAve)

	la	$a0, areas4			# arg 1
	lw	$a1, len4			# arg 2
	la	$a2, sum4			# arg 3
	la	$a3, min4			# arg 4
	subu	$sp, $sp, 16
	la	$t0, max4
	sw	$t0, ($sp)			# arg 5, on stack
	la	$t0, med4
	sw	$t0, 4($sp)			# arg 6, on stack
	la	$t0, iAve4
	sw	$t0, 8($sp)			# arg 7, on stack
	la	$t6, fAve4
	sw	$t6, 12($sp)			# arg 8, on stack
	jal	areasStats
	addu	$sp, $sp, 16			# clear stack

#  Show final areas array stats.
#	printResults(areas, len, sum, min, max, med, iAve, fAve)

	la	$a0, areas4			# arg 1
	lw	$a1, len4			# arg 2
	lw	$a2, sum4			# arg 3
	lw	$a3, min4			# arg 4
	subu	$sp, $sp, 16
	lw	$t0, max1
	sw	$t0, ($sp)			# arg 5, on stack
	lw	$t0, med4
	sw	$t0, 4($sp)			# arg 6, on stack
	lw	$t0, iAve4
	sw	$t0, 8($sp)			# arg 7, on stack
	l.s	$f6, fAve4
	s.s	$f6, 12($sp)			# arg 8, on stack
	jal	printResults
	addu	$sp, $sp, 16			# clear stack

# --------------------------------------------------------
#  Data Set #5

	move	$a0, $s0
	lw	$a1, len5
	jal	prtHeaders
	add	$s0, $s0, 1

# -----
#  Pentagon areas calculation function
#	calcAreas(sides, heights, len, areas)

	la	$a0, sides5
	la	$a1, heights5
	lw	$a2, len5
	la	$a3, areas5
	jal	calcAreas

#  Generate areas stats.
#  Note, function also calls the findSum(), iAverage(), and fAverage()
#	functions.  Also calls the insertionSort() function.
#	areasStats(diags, len, sum, min, max, med, iAve, fAve)

	la	$a0, areas5			# arg 1
	lw	$a1, len5			# arg 2
	la	$a2, sum5			# arg 3
	la	$a3, min5			# arg 4
	subu	$sp, $sp, 16
	la	$t0, max5
	sw	$t0, ($sp)			# arg 5, on stack
	la	$t0, med5
	sw	$t0, 4($sp)			# arg 6, on stack
	la	$t0, iAve5
	sw	$t0, 8($sp)			# arg 7, on stack
	la	$t6, fAve5
	sw	$t6, 12($sp)			# arg 8, on stack
	jal	areasStats
	addu	$sp, $sp, 16			# clear stack

#  Show final areas array stats.
#	printResults(areas, len, sum, min, max, med, iAve, fAve)

	la	$a0, areas5			# arg 1
	lw	$a1, len5			# arg 2
	lw	$a2, sum5			# arg 3
	lw	$a3, min5			# arg 4
	subu	$sp, $sp, 16
	lw	$t0, max5
	sw	$t0, ($sp)			# arg 5, on stack
	lw	$t0, med5
	sw	$t0, 4($sp)			# arg 6, on stack
	lw	$t0, iAve5
	sw	$t0, 8($sp)			# arg 7, on stack
	l.s	$f6, fAve5
	s.s	$f6, 12($sp)			# arg 8, on stack
	jal	printResults
	addu	$sp, $sp, 16			# clear stack

# --------------------------------------------------------
#  Done, terminate program.

	li	$v0, 10
	syscall					# au revoir...
.end

#####################################################################
#  Display headers.

.globl	prtHeaders
.ent	prtHeaders
prtHeaders:
	sub	$sp, $sp, 8
	sw	$s0, ($sp)
	sw	$s1, 4($sp)

	move	$s0, $a0
	move	$s1, $a1

	la	$a0, hdrTitle
	li	$v0, 4
	syscall

	move	$a0, $s0
	li	$v0, 1
	syscall

	la	$a0, hdrLength
	li	$v0, 4
	syscall

	move	$a0, $s1
	li	$v0, 1
	syscall

	lw	$s0, ($sp)
	lw	$s1, 4($sp)
	add	$sp, $sp, 8

	jr	$ra
.end	prtHeaders

#####################################################################
#  MIPS assembly language function to calculate the
#  diagonal for each trapezoid in a series of trapezoids.

# -----
#  HLL Call:
#	calcAreas(sides, heights, len, areas)

#    Arguments:
#	$a0	- starting address of the sides array
#	$a1	- starting address of the heights array
#	$a2	- starting address of the length
#	$a3	- starting address of the areas array

#    Returns:
#	areas[] areas array via passed address

.globl	calcAreas
calcAreas:


move $t0, $a0
move $t1, $a1
move $t2, $a2 #length
move $t3, $a3

calcinglp:

beqz $t2, calcinglpend

lw $s0,($t0) #sides
lw $s1,($t1) #heights

mul $s0,$s1,$s0 #heights * sides
mul $s0,$s0,5	#heights * sides * 5
div $s0,$s0,2   #(sides*heights*5)/2

sw $s0,($t3)

add $t0, $t0, 4
add $t1, $t1, 4
add $t3, $t3, 4

sub $t2, $t2, 1

b calcinglp

calcinglpend:



jr $ra

.end calcAreas

#####################################################################
#  Sort a list of numbers using insertion sort algorithm.


# -----
#    Arguments:
#	$a0 - starting address of the list
#	$a1 - list length

#    Returns:
#	sorted list (via reference)

.globl insertionSort
.ent insertionSort
insertionSort:

move $t0, $a0
move $t1,$a1
move $t5, $t0
sub $t1,$t1,1 #lenght-1
add $t0,$t0,4 #i=1

sortlp:

beq $t1,1, sortlpend

lw $t2,($t0) 	#value
sub $t3,$t0,4 #t3 is j = i-1

whilelp:

blt $t3, $t5, sortcontlp #j > 0 keep going

lw $t4,($t3) #arr[j]
ble $t4,$t2, sortcontlp #arr[j] > value, replace Arr[j+1] with Arr[j]

sw $t4,4($t3)
sub $t3,$t3,4

b whilelp

sortcontlp:
sw $t2,4($t3)
add $t0,$t0,4
sub $t1,$t1,1
b sortlp

sortlpend:


jr $ra
.end insertionSort

#####################################################################
#  Find sum function.
#	Find sum of passed array.

#    Arguments:
#	$a0   - integer
#	$a1   - len

#    Returns:
#	$v0   - sum

.globl	findSum
.ent	findSum
findSum:

move $t0,$a0 # integer array
move   $t1,$a1 #length
li 	 $t3, 0 #sum
sumilp:

beqz $t1, sumilpend
lw $t2,($t0) 
add $t3,$t3,$t2
add $t0,$t0,4
sub $t1,$t1,1
b sumilp

sumilpend:
move $v0, $t3

jr $ra

.end	findSum

#####################################################################
#  Find floating point average function.
#  Includes performing the required type conversions.
#  Note, must call findSum() function.

#    Arguments:
#	$a0   - integer
#	$a1   - len

#    Returns:
#	$v0   - sum

.globl	fAverage
.ent	fAverage
fAverage:

sub $sp, $sp, 4
sw $ra, 0($sp)

jal findSum

move $t0,$v0
move $t1,$a1
mtc1 $t0,$f1
cvt.s.w $f1,$f1
mtc1 $t1, $f2
cvt.s.w $f2,$f2

div.s $f0,$f1,$f2

lw $ra, ($sp)
add $sp,$sp,4
jr $ra


.end	fAverage

#####################################################################
#  Find integer average function.
#  Includes performing the required type conversions.
#  Note, must call findSum() function.

#    Arguments:
#	$a0   - integer
#	$a1   - len

#    Returns:
#	$v0   - sum

.globl	iAverage
.ent	iAverage
iAverage:


sub $sp, $sp, 4
sw $ra,0($sp)

jal findSum

move $t0,$a1

div $v0,$v0,$t0

lw $ra,0($sp)
add $sp,$sp,4
jr $ra

.end	iAverage

#####################################################################
#  MIPS assembly language procedure, areasStats() to find the
#    sum, minimum, maximum, median, integer average, and
#    floating point average of the array.

#  Note, must call the findSum(), iAverage(), fAverage(), and
#	insertionSort() functions.

# -----
#  HLL Call:
#	areasStats(areas, len, sum, min, max, med, iAve, fAve)

# -----
#    Arguments:
#	$a0	- starting address of the areas array
#	$a1	- list length
#	$a2	- addr of sum
#	$a3	- addr of min
#	($fp)	- addr of max
#	4($fp)	- addr of med
#	8($fp)	- addr of iAve
#	12($fp)	- addr of fAve

#    Returns (via reference):
#	sum, min, max, med, iAve, fAve

.globl areasStats
.ent areasStats
areasStats:


sub $sp,$sp, 8
sw $ra,0($sp)
sw $fp,4($sp)
add $fp,$sp,8

jal insertionSort



jal findSum

move $t0,$a0

sw $v0,($a2)     #min
lw $t1,($t0)
sw $t1,($a3)
move $t1,$a1

sub $t1,$t1,2    #max
mul $t1,$t1,4
move $t3,$t0
add $t3,$t3,$t1
lw $t1,($t3)
lw $t4,($fp)
sw $t1,($t4)

move $t1,$a1     #median
div $t1,$t1,2
sub $t1,$t1,1
mul $t1,$t1,4
move $t3,$t0
add $t3,$t3,$t1
lw $t1,($t3)
lw $t4,4($fp)
sw $t1,($t4)

jal iAverage     #iaverage

lw $t4,8($fp)
sw $v0,($t4)

jal fAverage     #faverage

lw $t4,12($fp)
s.s $f0,($t4)

lw $ra, ($sp)
lw $fp,4($sp)
add $sp,$sp,8
jr $ra

.end areasStats

#####################################################################
#  MIPS assembly language procedure, printResults(), to display
#    the statistical information to console.

#  Note, due to the system calls, the saved registers must be used.
#	As such, push/pop saved registers altered.

# HLL Call
#	printResults(areas, sum, len, min, max, med, iAve, fAve)

# -----
#    Arguments:
#	$a0	- starting address of diags[]
#	$a1	- length
#	$a2	- sum
#	$a3	- min
#	($fp)	- max
#	4($fp)	- med
#	8($fp)	- iAve
#	12($fp)	- fAve

#    Returns:
#	N/A

.globl	printResults
.ent	printResults
printResults:

	sub $sp,$sp,8
	sw $fp,($sp)
	sw $ra,4($sp)
	add $fp,$sp,8
	
	move $t0,$a0
	move $t1,$a1
	move $t2,$a2
	move $t3,$a3
	lw $t4,($fp)
	lw $t5,4($fp)
	lw $t6,8($fp)
	lw $t7,12($fp)
	
	move $s1,$t1 #length
	li $s2,8
	
	la $a0, newLine
	li $v0, 4
	syscall
	
	listprintlp:
	lw $s0 ($t0)
	beqz $s1 statprint
	
	
	
	move $a0, $s0
	li 	 $v0, 1
	syscall
	
	la $a0, spc
	li $v0,4
	syscall
	
	bnez $s2,listprintlp2
	
	la 	$a0, newLine
	li	$v0, 4
	syscall
	
	li $s2,8
	listprintlp2:
	
	sub $s1, $s1, 1
	sub $s2, $s2, 1
	add $t0,$t0, 4

	b listprintlp
	
	statprint:
	
	la 	$a0, newLine
	li	$v0, 4
	syscall
	
	la	$a0, str1
	li	$v0, 4
	syscall
	
	move $a0,$t2
	li $v0,1
	syscall
	
	
	la	$a0, newLine		# print a newline
	li	$v0, 4
	syscall
	
	la	$a0, str2
	li	$v0, 4
	syscall 
	
	move $a0,$t3
	li $v0, 1
	syscall
	
	
	la $a0, newLine
	li $v0, 4
	syscall 
	
	la	$a0, str3
	li	$v0, 4
	syscall
	
	move $a0, $t4
	li	$v0, 1
	syscall
	
	
	la	$a0, newLine
	li	$v0, 4
	syscall
	
	la	$a0, str4
	li	$v0, 4
	syscall
	
	move $a0, $t5
	li	$v0, 1
	syscall
	
	
	la	$a0, newLine
	li	$v0, 4
	syscall
	
	la	$a0, str5
	li	$v0, 4
	syscall

	move $a0, $t6
	li	$v0, 1
	syscall
	
	
	la	$a0, newLine
	li	$v0, 4
	syscall

	la	$a0, str6
	li	$v0, 4
	syscall
	
	move $a0, $t7
	li	$v0, 1
	syscall
	
	lw $fp,($sp)
	lw $ra,4($sp)
	add $sp,$sp,8
	
	jr $ra
	
.end printResults

#####################################################################

