## ditto.asm
##
## See homework for instructions

###########################
## Text Section          ##  
###########################
		.text
		.globl main
main:							# Entry point	
		la 	$a0, buf
		li 	$a1, 640
		li 	$a2, 80
		jal	hexdump

exit:
		li 	$v0, 10				# Exit Syscall
		syscall	

hexdump:
		# prologue
		sub  $sp, $sp, 20
		sw 	 $a0, 0($sp)
		sw 	 $a1, 4($sp)
		sw 	 $a2, 8($sp)
		sw 	 $ra, 12($sp)
		sw	 $fp, 16($sp)
		move $fp, $sp

		# Load args from memory	
		lw 	 $t0, 0($fp)
		lw	 $t8, 4($fp)
		lw	 $t9, 8($fp)
		li 	 $t1, 0
loop_text:
		li 	 $v0, 11
		lb 	 $a0, ($t0)	
		sub  $t2, $a0, 32
		bgez $t2, loop_char
		li	 $a0, 46					# ASCII for . (Period)		

loop_char:
		syscall

		add  $t1, $t1, 1
		add  $t0, $t0, 1
		bne  $t1, $t9, loop_text

		# Print newline (\n, 0x0A)
		li 	 $v0, 4
		la 	 $a0, endl
		syscall
	
#		lw	 $t0, 0($fp)
#		li 	 $t1, 0
#loop_upper:
#		li	 $v0, 1
#		lb 	 $a0, ($t0) 
#		syscall

#		add  $t1, $t1, 1
#		add  $t0, $t0, 1
#		bne  $t1, $a2 loop_upper

		# Print newline (\n, 0x0A)
#		li 	 $v0, 4
#		la 	 $a0, endl
#		syscall

		li 	 $t1, 0
		li	 $t2, 0
		li 	 $t3, 0
		li	 $t4, 4
loop_guide:
		bne	 $t2, $t4, guide_period	
		
		# If multiple of 5
		li	 $t2, 0						# Set t2 back to 1 for next count
		add	 $t1, $t1, 1			    # Add an additional 1 for taking 2 spaces
		li	 $v0, 1					    # Load 1 into v0 to print int
		add	 $t3, $t3, 5			    # Add 5 to t3 to get current interval
		move $a0, $t3				    # Move that val into a0
		j	 guide_print			

guide_period:
		li	 $v0, 11					# Load 11 into v0 to print char
		li	 $a0, 46					# ASCII for . (Period)		

guide_print:
		syscall							# Perform print

		add	 $t1, $t1, 1				# Add 1 to t1
		add	 $t2, $t2, 1				# Add 1 to t2
		sub  $t5, $t1, $t9				# Subtract linesz from current pos
		bltz $t5, loop_guide			# If result is < 0, keep going

		# Print newline (\n, 0x0A)
		li 	 $v0, 4
		la 	 $a0, endl
		syscall

		# epilogue
		move $sp, $fp
		lw	 $a0, 0($sp)
		lw	 $a1, 4($sp)
		lw	 $a2, 8($sp)
		lw	 $ra, 12($sp)
		lw	 $fp, 16($sp)
		add	 $sp, $sp, 16

		jr	$ra 

###########################
## Data Section          ##  
###########################
		.data
ans:	.asciiz "answer = "
endl:	.asciiz "\n"
buf:    .byte 0x3c,0x21,0x44,0x4f,0x43,0x54,0x59,0x50
        .byte 0x45,0x20,0x48,0x54,0x4d,0x4c,0x20,0x50
        .byte 0x55,0x42,0x4c,0x49,0x43,0x20,0x22,0x2d
        .byte 0x2f,0x2f,0x57,0x33,0x43,0x2f,0x2f,0x44
        .byte 0x54,0x44,0x20,0x48,0x54,0x4d,0x4c,0x20
        .byte 0x34,0x2e,0x30,0x31,0x20,0x54,0x72,0x61
        .byte 0x6e,0x73,0x69,0x74,0x69,0x6f,0x6e,0x61
        .byte 0x6c,0x2f,0x2f,0x45,0x4e,0x22,0x3e,0x0a
        .byte 0x3c,0x68,0x74,0x6d,0x6c,0x3e,0x0a,0x20
        .byte 0x20,0x3c,0x68,0x65,0x61,0x64,0x3e,0x0a
        .byte 0x20,0x20,0x20,0x20,0x3c,0x6d,0x65,0x74
        .byte 0x61,0x20,0x68,0x74,0x74,0x70,0x2d,0x65
        .byte 0x71,0x75,0x69,0x76,0x3d,0x22,0x43,0x6f
        .byte 0x6e,0x74,0x65,0x6e,0x74,0x2d,0x54,0x79
        .byte 0x70,0x65,0x22,0x20,0x63,0x6f,0x6e,0x74
        .byte 0x65,0x6e,0x74,0x3d,0x22,0x74,0x65,0x78
        .byte 0x74,0x2f,0x68,0x74,0x6d,0x6c,0x3b,0x20
        .byte 0x63,0x68,0x61,0x72,0x73,0x65,0x74,0x3d
        .byte 0x69,0x73,0x6f,0x2d,0x38,0x38,0x35,0x39
        .byte 0x2d,0x31,0x22,0x3e,0x20,0x0a,0x20,0x20
        .byte 0x20,0x20,0x3c,0x74,0x69,0x74,0x6c,0x65
        .byte 0x3e,0x0a,0x20,0x20,0x20,0x20,0x20,0x20
        .byte 0x43,0x50,0x53,0x43,0x49,0x20,0x32,0x34
        .byte 0x30,0x20,0x2d,0x20,0x43,0x6f,0x6d,0x70
        .byte 0x75,0x74,0x65,0x72,0x20,0x4f,0x72,0x67
        .byte 0x61,0x6e,0x69,0x7a,0x61,0x74,0x69,0x6f
        .byte 0x6e,0x20,0x61,0x6e,0x64,0x20,0x41,0x73
        .byte 0x73,0x65,0x6d,0x62,0x6c,0x79,0x20,0x4c
        .byte 0x61,0x6e,0x67,0x75,0x61,0x67,0x65,0x20
        .byte 0x2d,0x20,0x48,0x6f,0x6d,0x65,0x77,0x6f
        .byte 0x72,0x6b,0x20,0x23,0x37,0x0a,0x20,0x20
        .byte 0x20,0x20,0x3c,0x2f,0x74,0x69,0x74,0x6c
        .byte 0x65,0x3e,0x0a,0x20,0x20,0x20,0x20,0x3c
        .byte 0x6c,0x69,0x6e,0x6b,0x20,0x72,0x65,0x6c
        .byte 0x3d,0x22,0x73,0x74,0x79,0x6c,0x65,0x73
        .byte 0x68,0x65,0x65,0x74,0x22,0x20,0x74,0x79
        .byte 0x70,0x65,0x3d,0x22,0x74,0x65,0x78,0x74
        .byte 0x2f,0x63,0x73,0x73,0x22,0x20,0x68,0x72
        .byte 0x65,0x66,0x3d,0x22,0x63,0x70,0x73,0x63
        .byte 0x69,0x32,0x34,0x30,0x2e,0x63,0x73,0x73
        .byte 0x7f,0x45,0x4c,0x46,0x01,0x01,0x01,0x00
        .byte 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
        .byte 0x02,0x00,0x03,0x00,0x01,0x00,0x00,0x00
        .byte 0xb0,0x84,0x04,0x08,0x34,0x00,0x00,0x00
        .byte 0x28,0x14,0x00,0x00,0x00,0x00,0x00,0x00
        .byte 0x34,0x00,0x20,0x00,0x07,0x00,0x28,0x00
        .byte 0x1c,0x00,0x19,0x00,0x06,0x00,0x00,0x00
        .byte 0x34,0x00,0x00,0x00,0x34,0x80,0x04,0x08
        .byte 0x34,0x80,0x04,0x08,0xe0,0x00,0x00,0x00
        .byte 0xe0,0x00,0x00,0x00,0x05,0x00,0x00,0x00
        .byte 0x04,0x00,0x00,0x00,0x03,0x00,0x00,0x00
        .byte 0x14,0x01,0x00,0x00,0x14,0x81,0x04,0x08
        .byte 0x14,0x81,0x04,0x08,0x13,0x00,0x00,0x00
        .byte 0x13,0x00,0x00,0x00,0x04,0x00,0x00,0x00
        .byte 0x01,0x00,0x00,0x00,0x01,0x00,0x00,0x00
        .byte 0x00,0x00,0x00,0x00,0x00,0x80,0x04,0x08
        .byte 0x00,0x80,0x04,0x08,0x1c,0x0b,0x00,0x00
        .byte 0x1c,0x0b,0x00,0x00,0x05,0x00,0x00,0x00
        .byte 0x00,0x10,0x00,0x00,0x01,0x00,0x00,0x00
        .byte 0x00,0x10,0x00,0x00,0x00,0x90,0x04,0x08
        .byte 0x00,0x90,0x04,0x08,0x40,0x02,0x00,0x00
        .byte 0x5c,0x08,0x00,0x00,0x06,0x00,0x00,0x00
        .byte 0x00,0x10,0x00,0x00,0x02,0x00,0x00,0x00
        .byte 0x14,0x10,0x00,0x00,0x14,0x90,0x04,0x08
        .byte 0x14,0x90,0x04,0x08,0xc8,0x00,0x00,0x00
        .byte 0xc8,0x00,0x00,0x00,0x06,0x00,0x00,0x00
        .byte 0x04,0x00,0x00,0x00,0x04,0x00,0x00,0x00
        .byte 0x28,0x01,0x00,0x00,0x28,0x81,0x04,0x08
        .byte 0x28,0x81,0x04,0x08,0x20,0x00,0x00,0x00
        .byte 0x20,0x00,0x00,0x00,0x04,0x00,0x00,0x00
        .byte 0x04,0x00,0x00,0x00,0x51,0xe5,0x74,0x64
        .byte 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
        .byte 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
        .byte 0x00,0x00,0x00,0x00,0x06,0x00,0x00,0x00
        .byte 0x04,0x00,0x00,0x00,0x2f,0x6c,0x69,0x62
        .byte 0x2f,0x6c,0x64,0x2d,0x6c,0x69,0x6e,0x75
        .byte 0x78,0x2e,0x73,0x6f,0x2e,0x32,0x00,0x00
        .byte 0x04,0x00,0x00,0x00,0x10,0x00,0x00,0x00
        .byte 0x01,0x00,0x00,0x00,0x47,0x4e,0x55,0x00
        .byte 0x00,0x00,0x00,0x00,0x02,0x00,0x00,0x00
