# MIPS ASSIGNMENT 4
# Question 1
# Semester 5
# Group No. 17
# Krish Khimasia - 21CS10037
# Tanishq Prasad - 21CS30054

.data                                                               # data segment
prompt1:                                                            # prompt user to enter x
  .asciiz "Enter N: "                   
res:                                                                # message to be displayed followed by number of iterations
  .asciiz "The sum of the series is "                 
newline:                                                            # newline
  .asciiz "\n"

.align  4
arr: .space 404         # assuming a maximum of 100 elements, using 1 based indexing for arrays
.align  4
preff: .space 404

.text
sum:
    # base case -- still in parent's stack segment
    # adjust stack pointer to store return address and argument (8 bytes needed)
    
    addi    $sp, $sp, -8
    
    # save $s0 and $ra
    sw      $s0, 4($sp)
    sw      $ra, 0($sp)
    bne     $a0, 0, else
    addi    $v0, $zero, 0   # return 0
    j sum_return

else:
    # backup $a0
    move    $s0, $a0
    addi    $a0, $a0, -1 # x -= 1
    jal     sum
   
    # when we get here, we already have sum(x-1) store in $v0
    li $s7,1
    move $s6,$s0        # s6=i
    j loop

loop:         # for calculation i^i
    mul $s7,$s7,$s0
    addi $s6,$s6,-1
    bne   $s6,$zero,loop
    add $v0,$v0,$s7
    


sum_return:
    lw      $s0, 4($sp)
    lw      $ra, 0($sp)
    addi    $sp, $sp, 8
    jr      $ra

.globl main
main:
    # show prompt
    li        $v0, 4
    la        $a0, prompt1
    syscall
    # read x
    li        $v0, 5
    syscall
    # function call
    move      $a0, $v0
    jal       sum             # jump sum and save position to $ra
    move      $t0, $v0        # $t0 = $v0
    # show prompt
    li        $v0, 4
    la        $a0, res
    syscall
    # print the result
    li        $v0, 1        # system call #1 - print int
    move      $a0, $t0        # $a0 = $t0
    syscall                # execute
    # return 0
    li        $v0, 10        # $v0 = 10
    syscall


