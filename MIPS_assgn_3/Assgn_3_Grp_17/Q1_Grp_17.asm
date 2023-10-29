# MIPS ASSIGNMENT 3
# Question 1
# Semester 5
# Group No. 17
# Krish Khimasia - 21CS10037
# Tanishq Prasad - 21CS30054

.data                                                               # data segment
prompt1:                                                            # prompt user to enter x
  .asciiz "Enter N: "                                           
prompt2:                                                            # message to be displayed followed by sum  
  .asciiz "Enter the array elements (separated by new lines) :- \n"                     
res:                                                                # message to be displayed followed by number of iterations
  .asciiz "The max circular subarray sum is "                 
newline:                                                            # newline
  .asciiz "\n"

.align  4
arr: .space 404         # assuming a maximum of 100 elements, using 1 based indexing for arrays
.align  4
preff: .space 404

.text


inputloop:
    li $v0, 5           # syscall code 5 for reading an integer
    syscall
    move $t0, $v0       # Move the result to $t0
    sw $t0,($s1)        # storing arr[i]
    lw $t1,-4($s2)      
    add $t0,$t0,$t1     # pref[i]=arr[i]+pref[i-1]
    sw $t0,($s2)
    addi $s4,$s4,1
    addi $s1,$s1,4
    addi $s2,$s2,4
    beq $s4,$s0,compute
    b inputloop
    

takeInputArray:
    la $a0, prompt2                     # Prompt the user to enter the array elements
    li $v0, 4                           # Printing the prompt
    syscall
    
    la $s1,arr                          # s1 = arr
    la $s2,preff                        # s2 = preff
    li $t0,0
    sw $t0,($s1)
    sw $t0,($s2)
    addi $s1,$s1,4                      # s1 = arr+4
    addi $s2,$s2,4                      # s2 = preff+4
    li $s4,0
    
    b inputloop

compute:
  lw $s6,-4($s2)                        #s6 is total sum
  li $s4,0                              # s4=i
  la $s1,preff                          # s1 = preff
  b outer_loop

outer_loop:
  beq $s4,$s0,print_result              # outer loop exited when i==n
  move $s5,$s4
  addi $s5,$s5,1                        # s5=j=i+1
  b inner_loop

inner_loop:
  bgt $s5,$s0,inc_out                   # inner loop exited when j>n
  mul $t1,$s4,4
  mul $t2,$s5,4
  la $t3,preff
  la $t4,preff
  add $t3,$t3,$t1
  add $t4,$t4,$t2
  lw $t5,($t3)        # t5 <-- pref[i]
  lw $t6,($t4)        # t6 <-- pref[j]
  sub $t7,$t6,$t5     # t7 <-- pref[j]-pref[i]
  sub $t8,$s6,$t7     # t8 <-- totalsum-(pref[j]-pref[i])
  blt $t7,$t8,swap
  blt $s7,$t7,assgn
  b inc_in

swap:
  move $t7,$t8
  blt $s7,$t7,assgn
  b inc_in

assgn:          # updating s7 (the result)
  move $s7,$t7
  b inc_in

inc_in:
  addi $s5,$s5,1
  b inner_loop

inc_out:
  addi $s4,$s4,1
  b outer_loop

nxt:
  jal print_result                      # calling function to print result
  b exit

print_result:
    la $a0, res                         # Printing the result
    li $v0, 4                 
    syscall

    move $a0,$s7
    li $v0,1
    syscall
    jr $ra


.globl main
main:
    li $s7,-1000000000
    la $a0, prompt1                     # Prompt the user to enter N
    li $v0, 4                           # Printing the prompt
    syscall

    li $v0, 5                           # syscall code 5 for reading an integer
    syscall
    move $t0, $v0                       # Move the result to $t0

    move $s0,$t0                        # $s0 = N

    b takeInputArray



exit:                                   
    li $v0,10                       # Exit
    syscall



