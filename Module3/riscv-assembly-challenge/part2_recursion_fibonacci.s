.data
cache:    .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0    
n:        .word 20                                                               
result_m: .string "fib(n) of given number(n=20) is: "

.text
.globl main

main:
    lw    a0, n                 # a0 = n = 20
    call  fib_memo              # gives a0 = fib(20)
    mv    a2, a0                # a2 = result from a0

    la    a1, result_m          # printing result message
    li    a0, 4
    ecall

    mv    a1, a2                # restoring result to a1
    li    a0, 1
    ecall                       # prints 6765

    li    a0, 11                # printing newline
    li    a1, 10
    ecall

    li    a0, 10                # exiting
    ecall

# fib_memo(n) stores in a0
# Uses cache array to avoid recomputation
fib_memo:
    addi  sp, sp, -16           # allocate 16-byte frame
    sw    ra, 12(sp)            # save return address
    sw    s0, 8(sp)             # save n (original)
    sw    s1, 4(sp)             # save fib(n-1)

    # Check base cases
    li    t0, 0                 # t0 = 0
    beq   a0, t0, return_0      # if n == 0, return 0

    li    t0, 1                 # t0 = 1
    beq   a0, t0, return_1      # if n == 1, return 1

    # Check cache[n]
    la    t0, cache             # t0 = base address of cache
    slli  t1, a0, 2             # t1 = n * 4
    add   t1, t0, t1            # t1 = &cache[n]
    lw    t2, 0(t1)             # t2 = cache[n]
    bnez  t2, cache_hit         # if cache[n] != 0, return cached value

    # Compute fib(n) = fib(n-1) + fib(n-2)
    mv    s0, a0                # s0 = n (preserving for later use)
    addi  a0, s0, -1            # a0 = n - 1
    call  fib_memo              # a0 = fib(n-1)
    mv    s1, a0                # s1 = fib(n-1) (safe in callee-saved reg)

    addi  a0, s0, -2            # a0 = n - 2
    call  fib_memo              # a0 = fib(n-2)
    
    add   a0, s1, a0            # a0 = fib(n-1) + fib(n-2)

    # Store result in cache[n]
    la    t0, cache             # t0 = base address of cache
    slli  t1, s0, 2             # t1 = n * 4
    add   t1, t0, t1            # t1 = &cache[n]
    sw    a0, 0(t1)             # cache[n] = fib(n)

    j     epilogue              # skiping base case returns

return_0:
    li    a0, 0                 # returns 0
    j     epilogue

return_1:
    li    a0, 1                 # returns 1
    j     epilogue              

cache_hit:
    mv    a0, t2                # return cached value (already in t2)

epilogue:
    lw    s1, 4(sp)             # restore s1
    lw    s0, 8(sp)             # restore s0
    lw    ra, 12(sp)            # restore ra
    addi  sp, sp, 16            # deallocate frame
    ret