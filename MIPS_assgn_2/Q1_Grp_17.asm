# MIPS ASSIGNMENT 2
# Question 1
# Semester 5
# Group No. 17
# Krish Khimasia - 21CS10037
# Tanishq Prasad - 21CS30054

.data                                                               # data segment
prompt1:                                                            # prompt user to enter x
  .asciiz "Enter the number of cycles : "                                           
prompt2:                                                            # message to be displayed followed by sum  
  .asciiz "Enter cycle : "                     
prompt3:                                                            # message to be displayed followed by number of iterations
  .asciiz "Product permutation cycle "
prompt4:                                                            # message to be displayed followed by number of iterations
  .asciiz " is : "     
prompt5:                                                            # message to be displayed followed by sum  
  .asciiz "Enter the number of elements in the cycle : "                   
prompt6:                                                            # message to be displayed followed by sum  
  .asciiz "The required permutation is : "                   
errprompt:                                                            # message to be displayed followed by sum  
  .asciiz "Error: Permutation invalid."                   
newline:                                                            # newline
  .asciiz "\n"

list1:  .word 10,10,10,10,10,10,10,10,10,10
list2:  .word 10,10,10,10,10,10,10,10,10,10
final:  .word 10,10,10,10,10,10,10,10,10,10

.text
.globl main
main:

la $a0, prompt1                     # Prompt the user to enter the number of cycles
li $v0, 4                           # Printing the prompt
syscall

#cycle 1

li $v0, 5                           # Taking number of cycles
syscall

move $s0,$v0                        # $s0 = no. of cycles
# b loop1

li $k0,0

b countlp1

countlp1:
    beq $k0,$s0,print1
    addi $k0,$k0,1
    b loop1

loop1:          # taking in info about cycle

    la $a0, prompt5                     # Prompt the user to enter no. of elements in current cycle
    li $v0, 4                           # Printing the prompt
    syscall

    li $v0, 5                           # Taking no. of elements in current cycle
    syscall

    move $s1,$v0                        # $s1 = no. of elements in current cycle

    la $a0, prompt2                     # Prompt the user to enter the cycle
    li $v0, 4                           # Printing the prompt
    syscall

    li $s2,1                            # counter

    li $v0, 5                           # first element
    syscall

    bgt $v0,9,err
    blt $v0,0,err

    move $s6,$v0
    move $s7,$v0

    b loop2

loop2:          # taking in elements of cycle
    beq $s2,$s1,end1
    li $v0, 5                           # element
    syscall

    bgt $v0,9,err
    blt $v0,0,err
    move $s3,$v0                    # s3 is the element

    #  check if s6 location doesnt have 10
    mul $t0,$s6,4
    la $s4,list1
    add $s4,$s4,$t0
    lw $s5,($s4)
    # lw $s5,$t0(list1)

    bne $s5,10,err
    sw $s3,($s4)

    move $s6,$s3
    add $s2,$s2,1
    b loop2
    

end1:
    mul $t0,$s6,4           #s4 holds the address where we will put current val
    la $s4,list1
    add $s4,$s4,$t0
    lw $s5,($s4)
    bne $s5,10,err
    sw $s7,($s4)
    
    b countlp1
    # b print

print1:
    li $s1,0
    la $s2,list1
    b printloop

print2:
    li $s1,0
    la $s2,list2
    b printloop2

printloop:
    beq $s1,10,ip2
    lw $t0,($s2)
    beq $t0,10,correct
    lw $a0,($s2)
    li $v0,1
    syscall
    addi $s1,$s1,1
    addi $s2,$s2,4
    b printloop

correct:
    sw $s1,($s2)
    lw $a0,($s2)
    li $v0,1
    syscall
    addi $s1,$s1,1
    addi $s2,$s2,4
    b printloop

printloop2:
    beq $s1,10,nw
    lw $t0,($s2)
    beq $t0,10,correct2
    lw $a0,($s2)
    li $v0,1
    syscall
    addi $s1,$s1,1
    addi $s2,$s2,4
    b printloop2

correct2:
    sw $s1,($s2)
    lw $a0,($s2)
    li $v0,1
    syscall
    addi $s1,$s1,1
    addi $s2,$s2,4
    b printloop2

ip2:
    la $a0, newline                     # Prompt the user to enter no. of elements in current cycle
    li $v0, 4                              # Printing the prompt
    syscall  
    
    la $a0, prompt1                     # Prompt the user to enter the number of cycles
    li $v0, 4                           # Printing the prompt
    syscall

    #cycle 1

    li $v0, 5                           # Taking number of cycles
    syscall

    move $s0,$v0                        # $s0 = no. of cycles
    # b loop1
    li $k0,0
    b countlp2

countlp2:
    beq $k0,$s0,print2
    addi $k0,$k0,1
    b loop3

loop3:          # taking in info about cycle

   
    la $a0, prompt5                     # Prompt the user to enter no. of elements in current cycle
    li $v0, 4                           # Printing the prompt
    syscall

    li $v0, 5                           # Taking no. of elements in current cycle
    syscall

    move $s1,$v0                        # $s1 = no. of elements in current cycle

    la $a0, prompt2                     # Prompt the user to enter the cycle
    li $v0, 4                           # Printing the prompt
    syscall

    li $s2,1                            # counter

    li $v0, 5                           # first element
    syscall

    bgt $v0,9,err
    blt $v0,0,err

    move $s6,$v0
    move $s7,$v0

    b loop4

loop4:          # taking in elements of cycle
    beq $s2,$s1,end2
    li $v0, 5                           # element
    syscall

    bgt $v0,9,err
    blt $v0,0,err
    move $s3,$v0                    # s3 is the element

    #  check if s6 location doesnt have 10
    mul $t0,$s6,4
    la $s4,list2
    add $s4,$s4,$t0
    lw $s5,($s4)
    # lw $s5,$t0(list1)

    bne $s5,10,err
    sw $s3,($s4)

    move $s6,$s3
    add $s2,$s2,1

    b loop4
    

end2:
    mul $t0,$s6,4           #s4 holds the address where we will put current val
    la $s4,list2
    add $s4,$s4,$t0
    lw $s5,($s4)
    bne $s5,10,err
    sw $s7,($s4)
    b countlp2
    

nw:
    la $s0,final
    la $s1,list1
    la $s2,list2

    li $s7,0

    b finalloop

finalloop:
    beq $s7,10,print3
    la $s1,list1
    mul $t0,$s7,4
    add $s1,$s1,$t0
    lw $t1,($s1)
    mul $t0,$t1,4
    la $s2, list2
    add $s2,$s2,$t0
    lw $t2,($s2)
    sw $t2,($s0)
    addi $s0,$s0,4
    addi $s7,$s7,1
    b finalloop

    

    # mul $t0,$s6,4           #s4 holds the address where we will put current val
    # la $s4,list2
    # add $s4,$s4,$t0
    # lw $s5,($s4)
    # bne $s5,10,err
    # sw $s7,($s4)
    # b countlp2
print3:
    li $s1,0
    la $s2,final
    la $a0, newline                     # Prompt the user to enter no. of elements in current cycle
    li $v0, 4                              # Printing the prompt
    syscall  
    la $a0, prompt6                   # Prompt the user to enter no. of elements in current cycle
    li $v0, 4                              # Printing the prompt
    syscall  
    b printloop3

printloop3:
    beq $s1,10,exit
    lw $t0,($s2)
    beq $t0,10,correct3
    lw $a0,($s2)
    li $v0,1
    syscall
    addi $s1,$s1,1
    addi $s2,$s2,4
    b printloop3

correct3:
    sw $s1,($s2)
    lw $a0,($s2)
    li $v0,1
    syscall
    addi $s1,$s1,1
    addi $s2,$s2,4
    b printloop3

initloop:
    li $s0,0
    la $s1,final
    b anotherloop

err: 
    la $a0, newline                     # Prompt the user to enter no. of elements in current cycle
    li $v0, 4                              # Printing the prompt
    syscall  
    la $a0, errprompt                     # Prompt the user to enter no. of elements in current cycle
    li $v0, 4                              # Printing the prompt
    syscall   
    b exit                

exit:                                   
    li $v0,10                       # Exit
    syscall



