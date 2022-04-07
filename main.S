#
# Author: Logan Bowers
# Description: THis program contains the assembled code
#   for the function call p = power(x,y). It computes x^yth power.
# Register Usage:
#   rax gets the value of x^y once the subroutine is finished
#   rbx has x in power subroutine
#   rcx has y in power subroutine
#   rdi used and i in power subroutine for loop
#   rbp used to point to power subroutine's stack frame
#

.data
    x: .quad 0
    y: .quad 0
    p: .quad 0
.text
.global main
main:
    cmp $0, x   # here checking x and y > 0? 
    jl exit
    cmp $0, y   # If < 0, jump to end of program
    jl exit
    
    pushq x # push x and y onto the stack
    pushq y
    call power  # call function 
    addq $16, %rsp  # take Parameters x and y off stack
    movq %rax, p    # p = value in rax
exit:
    movq $1, %rax
    movq $0, %rbx
    int $0x80
    retq
    
# power: computes x^y
# Parameters
#   two ints
# Returns x^y in rax 
# Register usage:
#   rax holds x^y, return value
#   rbx holds value of x
#   rcx holds value of y
#   rdi used as "i" to control for loop
#   rbp used to point to this subroutine's stack frame

.type power, @function
power:
    pushq %rbp          # establish stack frame
    movq %rsp, %rbp     # rbp -> rsp
    pushq %rbx
    pushq %rcx
    pushq %rdi
    pushfq              # push used registers
    movq 24(%rbp), %rbx # rbx has x 
    movq 16(%rbp), %rcx # rcx has y
    
    # computing x^y here
    movq $1, %rax   # rax = 1
    movq $1, %rdi   # rdi = 1
forLoop: cmp %rcx, %rdi
    jg endLoop  # jump to endLoop if i > y 
    imulq %rbx, %rax    # multiply by x each iteration
    incq %rdi   # i++
    jmp forLoop
endLoop:
    popfq
    popq %rdi   # pop values in opp. order as pushed above
    popq %rcx
    popq %rbx        
    popq %rbp
    retq    # Return value put in %rax