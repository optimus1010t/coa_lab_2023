# MIPS ASSIGNMENT 1
# Question 1
# Semester 5
# Group No. 17
# Krish Khimasia - 21CS10037
# Tanishq Prasad - 21CS30054

.data                                                               # data segment
prompt1:                                                            # prompt user to enter x
  .asciiz "Enter x : "                                           
prompt2:                                                            # message to be displayed followed by sum  
  .asciiz "The sum of series is : "                     
prompt3:                                                            # message to be displayed followed by number of iterations
  .asciiz "The number of iteration(s) is : "                        
newline:                                                            # newline
  .asciiz "\n"

.text
.globl main

main:

la $a0, prompt1                     # Prompt the user to enter x
li $v0, 4                           # Printing the prompt
syscall

li $v0, 5                           # Taking the input for x
syscall

move $s1,$v0                        # s1 stores x

move $s2,$v0                        # s2 stores x^i, initially i is 1 before entering the loop

li $s3,1                            # s3 stores the no. of iterations (i)

li $s4,1                            # stores the factorial for current iteration before updating i in the loop

li $s5,1                            # stores the sum of the series

loop:
    div $s2, $s4                    # to calculate ((x^i)/i!) 
    mflo $t0                        # stores quotient of ((x^i)/i!)

    beq $t0,0,exit_loop             # exits loop if intermediate sum does not change i.e. the value for the quotient of ((x^i)/i!) is zero

    addu $s5,$s5,$t0                # add the calculated quotient of ((x^i)/i!) to the sum

    addi $s3,$s3,1                  # incrementing i by 1
    mul  $s4,$s4,$s3                # calculating i! for the next iteration
    mul $s2,$s2,$s1                 # calculating x^i for the next iteration
    b loop                          # return to the start of the loop

exit_loop:
    la $a0, prompt2                 # Prints the message for the sum
    li $v0, 4        
    syscall

    move $a0,$s5                    # Output sum
    li $v0,1
    syscall
    
    la $a0,newline                  # Output newline
    li $v0,4
    syscall

    la $a0, prompt3                 # Prints the message for the number of iterations
    li $v0, 4
    syscall

    move $a0,$s3                    # Output the number of iterations
    li $v0,1
    syscall

    b exit                          # Unconditional jump to exit                       

exit:                                   
    li $v0,10                       # Exit
    syscall



