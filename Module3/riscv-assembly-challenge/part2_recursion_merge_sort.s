# Recursive Merge Sort
.data
array:  .word 3,2,1,0,-1,-2,-3
size:   .word 7
temp:   .space 400                 # temporary array for merging where we initially store the sorted array
sorted_m: .string "Sorted array is: "

.text
.globl main

main:
    la    a0, array               # load array address
    lw    a1, size                # load size
    addi  a2, a1, -1              # a2 = right index = size - 1
    li    a1, 0                   # a1 = left index = 0
    call  merge_sort              # calling recursive sort

    la    a1, sorted_m            # prints message for sorted array
    li    a0, 4
    ecall

    # Printing sorted array
    la    t0, array               # t0 = array base
    lw    t1, size                # t1 = size
    li    t2, 0                   # t2 = i = 0

print_loop:
    bge   t2, t1, exit            # if i >= size, exit

    slli  t3, t2, 2               # t3 = i * 4
    add   t4, t0, t3              # t4 = &array[i]
    lw    a1, 0(t4)               # a1 = array[i]
    li    a0, 1
    ecall                         # print number

    addi  t5, t2, 1               # checking if it's last element
    bge   t5, t1, skip_comma

    li    a0, 11                  # prints comma and space
    li    a1, 44
    ecall
    li    a0, 11
    li    a1, 32
    ecall

skip_comma:
    addi  t2, t2, 1               # i++
    j     print_loop

exit:
    li    a0, 11                  # print newline
    li    a1, 10
    ecall
    # exiting
    li    a0, 10
    ecall

# merge_sort(a0=arr, a1=left, a2=right)
# Recursively divides the array
merge_sort:
    bge   a1, a2, merge_sort_done   # if left >= right, return

    addi  sp, sp, -16               # 16-byte aligned frame (multiple of 16)
    sw    ra, 12(sp)                # save return address
    sw    s0, 8(sp)                 # save left
    sw    s1, 4(sp)                 # save right
    sw    s2, 0(sp)                 # save mid

    mv    s0, a1                    # s0 = left
    mv    s1, a2                    # s1 = right

    add   t0, a1, a2                # t0 = left + right
    srli  s2, t0, 1                 # s2 = mid (saved in callee-saved reg)

    # Sort left half: (left, mid)
    mv    a1, s0                    # a1 = left
    mv    a2, s2                    # a2 = mid
    call  merge_sort

    # Sort right half: (mid+1, right)
    addi  a1, s2, 1                 # a1 = mid + 1
    mv    a2, s1                    # a2 = right
    call  merge_sort

    # Merge the two sorted halves: (left, mid, right)
    mv    a1, s0                    # a1 = left
    mv    a2, s2                    # a2 = mid
    mv    a3, s1                    # a3 = right
    call  merge

    lw    s2, 0(sp)                 # restore mid
    lw    s1, 4(sp)                 # restore right
    lw    s0, 8(sp)                 # restore left
    lw    ra, 12(sp)                # restore return address
    addi  sp, sp, 16                # deallocate

merge_sort_done:
    ret

# merge(a0=arr, a1=left, a2=mid, a3=right)
# Merges two sorted halves into temp and copies back
merge:
    addi  sp, sp, -32             # 32-byte aligned frame
    sw    s0, 28(sp)              # save left
    sw    s1, 24(sp)              # save mid
    sw    s2, 20(sp)              # save right
    sw    s3, 16(sp)              # save i
    sw    s4, 12(sp)              # save j
    sw    s5, 8(sp)               # save k

    mv    s0, a1                  # s0 = left
    mv    s1, a2                  # s1 = mid
    mv    s2, a3                  # s2 = right
    mv    s3, a1                  # i = left
    addi  s4, s1, 1               # j = mid + 1
    mv    s5, a1                  # k = left for temp array

merge_loop:
    bgt   s3, s1, copy_right      # if i > mid   → left exhausted  → copy remaining right
    bgt   s4, s2, copy_left       # if j > right → right exhausted → copy remaining left

    # Load array[i]
    slli  t0, s3, 2
    add   t1, a0, t0
    lw    t2, 0(t1)               # t2 = arr[i]

    # Load array[j]
    slli  t0, s4, 2
    add   t3, a0, t0
    lw    t4, 0(t3)               # t4 = arr[j]

    ble   t2, t4, use_left        # if arr[i] <= arr[j], take left


    # Take right
    la    t5, temp
    slli  t0, s5, 2
    add   t6, t5, t0
    sw    t4, 0(t6)               # temp[k] = arr[j]
    addi  s4, s4, 1               # j++
    addi  s5, s5, 1               # k++
    j     merge_loop

use_left:
    la    t5, temp
    slli  t0, s5, 2
    add   t6, t5, t0
    sw    t2, 0(t6)               # temp[k] = arr[i]
    addi  s3, s3, 1               # i++
    addi  s5, s5, 1               # k++
    j     merge_loop

# Copy remaining left half
# Called when right half is exhausted (j > right).
# Copies arr[i .. mid] directly into temp[k ..]

copy_left:
    bgt   s3, s1, copy_back       # if i > mid, done copying left

    # temp[k] = arr[i]
    slli  t0, s3, 2               # t0 = i * 4 (byte offset for arr)
    add   t1, a0, t0              # t1 = &arr[i]
    lw    t2, 0(t1)               # t2 = arr[i]

    la    t3, temp                # t3 = base address of temp
    slli  t0, s5, 2               # t0 = k * 4 (byte offset for temp)
    add   t4, t3, t0              # t4 = &temp[k]
    sw    t2, 0(t4)               # temp[k] = arr[i]

    addi  s3, s3, 1               # i++ (move to next element in left half)
    addi  s5, s5, 1               # k++ (move to next slot in temp)
    j     copy_left

# Copy remaining right half
# Called when left half is exhausted (i > mid).
# Copies arr[j .. right] directly into temp[k ..]

copy_right:
    bgt   s4, s2, copy_back       # if j > right, done copying right

    # temp[k] = arr[j]
    slli  t0, s4, 2               # t0 = j * 4 (byte offset for arr)
    add   t1, a0, t0              # t1 = &arr[j]
    lw    t2, 0(t1)               # t2 = arr[j]

    la    t3, temp                # t3 = base address of temp
    slli  t0, s5, 2               # t0 = k * 4 (byte offset for temp)
    add   t4, t3, t0              # t4 = &temp[k]
    sw    t2, 0(t4)               # temp[k] = arr[j]

    addi  s4, s4, 1               # j++ (move to next element in right half)
    addi  s5, s5, 1               # k++ (move to next slot in temp)
    j     copy_right

# Copy back from temp to array
copy_back:
    mv    t0, s0                  # t0 = left (preserve s0)

copy_loop:
    bgt   t0, s2, merge_done      # if t0 > right, done

    la    t5, temp
    slli  t1, t0, 2
    add   t2, t5, t1
    lw    t3, 0(t2)               # t3 = temp[t0]

    slli  t1, t0, 2
    add   t2, a0, t1
    sw    t3, 0(t2)               # arr[t0] = temp[t0]

    addi  t0, t0, 1
    j     copy_loop

merge_done:
    lw    s5, 8(sp)               # restore k
    lw    s4, 12(sp)              # restore j
    lw    s3, 16(sp)              # restore i
    lw    s2, 20(sp)              # restore right
    lw    s1, 24(sp)              # restore mid
    lw    s0, 28(sp)              # restore left
    addi  sp, sp, 32
    ret