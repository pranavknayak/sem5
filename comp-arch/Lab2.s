.data
.dword 6

.text
    lui x3, 0x10000
    lui x4, 0x10000
    addi x4, x4, 0x100
    #li x4, 0x10000100
    li x6, 1
    ld x5, 0(x3)
    addi x5, x5, -2
    sd x6, 0(x4) 
    addi x13, x3, 0x10
    li x14, 1
    loop_start:    
    add x7, x0, x6
    addi x6, x6, 1
    ld x10, 0(x4)
    add x7, x7, x7
    addi x7, x7, 1
    add x10, x10, x7
    addi x4, x4, 8
    sd x10, 0(x4)
    add x14, x14, x10
    
    addi x5, x5, -1
    bge x5, x0, loop_start
    loop_end:
    sd x14, 0(x13)
