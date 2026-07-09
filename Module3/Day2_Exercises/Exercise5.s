.data
data: .word 0xDEADBEEF
.text
main:
    # load word
    la t0,data
    lw t1,0(t0)
    # printing at new line
    li a0,1
    mv a1,t1
    ecall
    li   a0, 11 # 11 for char printing and 10 in ASCII is new line  
    li   a1, 10          
    ecall
    
    # hald word at 0 offset
    lhu t1,0(t0)
    # printing at new linw
    li a0,1
    mv a1,t1
    ecall
    li   a0, 11 # 11 for char printing and 10 in ASCII is new line  
    li   a1, 10          
    ecall
   
    # hald word at 2 offset
    lhu t1,2(t0)
    # printing and exiting at new line
    li a0,1
    mv a1,t1
    ecall
    li   a0, 11 # 11 for char printing and 10 in ASCII is new line  
    li   a1, 10          
    ecall
    
    # lowest bytes
    lbu t1,0(t0)
    # printing at new line
    li a0,1
    mv a1,t1
    ecall
    li   a0, 11 # 11 for char printing and 10 in ASCII is new line  
    li   a1, 10          
    ecall
    
    # 2nd lowest bytes
    lbu t1,1(t0)
    # printing at new line
    li a0,1
    mv a1,t1
    ecall
    li   a0, 11 # 11 for char printing and 10 in ASCII is new line  
    li   a1, 10          
    ecall
    
    # 2nd largest bytes
    lbu t1,2(t0)
    # printing at new line
    li a0,1
    mv a1,t1
    ecall
    li   a0, 11 # 11 for char printing and 10 in ASCII is new line  
    li   a1, 10          
    ecall
    
    # largest bytes
    lbu t1,3(t0)
    # printing at new line
    li a0,1
    mv a1,t1
    ecall
    li   a0, 11 # 11 for char printing and 10 in ASCII is new line  
    li   a1, 10          
    ecall
    
    # Exiting
    li a0,10
    ecall
    
    
