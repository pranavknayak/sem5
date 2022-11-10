.section .data
# (instead of .data in Ripes)
L1: .word 100000
#delay count to be loaded from memory

.section .text
.global main
# (add this to indicate main is a global function, need not be there in Ripes)
main:
la x3, L1
#YOUR CODE FOLLOWS HERE. The address of the data segment is available in x3
li x4, 0x10012004
li x5, 0x10012008
li x6, 0x1001200C
# control the light
li x8, 0x00000000
li x9, 0x00000020
lw x10, 0(x3)
lw x12, 0(x3)
addi x11, x0, 0
add x7, x0, x0
sw x8, 0(x4)
# store 0x00000000 at the memory location of x4
sw x9, 0(x5)
# store 0x00000020 at the memory location of x5

Loop: beq x7, x10, label
addi x11, x0, 0
# reset x11
sw x8, 0(x6)
lw x15, 0(x6)
# store 0x00000000 at the memory location of x6. Turns the light bulb off. It remains off till delay.
addi x7, x7, 1
beq x0, x0, Loop

label: beq x11, x12, Loop
addi x7, x0, 0
# reset x7
addi x11, x11, 1
sw x9, 0(x6)
# store 0x00000000 at the memory location of x6. Turns the light bulb on.
beq x0, x0, label

