.data
    .dword 6
    
.text
    lui x3, 0x10000
    ld t4, 0(x3)
    add t3, x0, t4
    li t5, 1
    loop_start2:
    beq t4, t5, loop_end2
        add t1, x0, t3
        addi t4, t4, -1
        add t2, x0, t4
        jal x1, multiply
        add t3, x0, t0
        li t0, 0
        bne t4, t5, loop_start2
        beq t4, t5, loop_end2

    
    
multiply: 
    loop_start:
    beq t2, x0, loop_end
    add t0, t0, t1    
    addi t2, t2, -1
    bne t2, x0, loop_start
    loop_end:
    li t1, 0
    li t2, 0
    jalr x0, (x1)0
    
    loop_end2:
        li t6, 0x10000010
        sd t3, 0(t6)