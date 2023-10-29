# MIPS ASSIGNMENT 4
# Question 2
# Semester 5
# Group No. 17
# Krish Khimasia - 21CS10037
# Tanishq Prasad - 21CS30054

.data                                                               # data segment
prompt1:                                                            # prompt user to enter x
  .asciiz "Enter N: "                   
res:                                                                # message to be displayed followed by number of iterations
  .asciiz "The number of steps required to reach 1 from N in the Collatz sequence is "                 
newline:                                                            # newline
  .asciiz "\n"


.text
collatz:
    # base case -- still in parent's stack segment
    # adjust stack pointer to store return address (just 4 bytes needed)
    
    addi    $sp, $sp, -4
    
    # save $ra
    sw      $ra, 0($sp)
    bne     $a0, 1, else1
    li    $v0, 0    # return 0
    j collatz_return

else1:
    li $s2,2          # s2=2
    li $s3,3          # s3=3
    div $a0,$s2
    mfhi $s1          # s1=(a0%2)
    beqz $s1,even     # check if a0 is even
    mul $a0,$a0,$s3   # a0*=3
    addi $a0,$a0,1    # a0+=1
    b else2

even:
  div $a0,$s2
  mflo $a0            # a0=a0/2
  b else2

else2:
    jal     collatz
   
    # when we get here, we already have collatz(x/2) or collatz(3x+1) store in $v0
    addi   $v0,$v0,1 # return 1

collatz_return:
    lw      $ra, 0($sp)
    addi    $sp, $sp, 4
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
    jal      collatz       # jump collatz and save position to $ra
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



