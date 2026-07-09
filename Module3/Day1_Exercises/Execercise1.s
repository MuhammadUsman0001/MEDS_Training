 .data 
 my_array: .word 42, 58
 .text 
 main: 
     la   t0, my_array     
     lw   a0, 0(t0)       
     lw   a1, 4(t0)            
     add  a2, a0, a1
     addi a0,zero,1
     mv a1,a2
     ecall
     addi a0,zero,10
     ecall