.data
array: .word 10,-10,20,-20,30,-30,40,-40,50,-50

.text
main:
    la s0,array         # base address
    lw t0,0(s0)         # current max is at index one
    li s1,10            # array size
    li t1,1             # start from second element to comapare for max
loop:
    bge t1,s1,done      # if t0 >= size, exit
    slli t2,t1,2        # t1 = i*4
    add t3,s0,t2        # t2 = &array[i]
    lw t4,0(t3)         # t3 = array[i] 
    ble t4,t0,skip      # if current > max
    mv t0,t4            # setting new max
    
skip:
    addi t1,t1,1        # just increament and new iteration through loop
    j loop
done:
    li a0,1
    mv a1,t0    # Expected:80
    ecall
    li a0,10
    ecall