.section .text
 .globl _start;


_start:
        la x1, _x
        lw x2, 0(x1)
        lw x3, 4(x1)
        lw x4, 8(x1)
        lw x5, 12(x1)
        lw x6, 16(x1)
        lw x7, 20(x1)
        lw x8, 24(x1)
        lw x9, 28(x1)
        addi x31, x31, x2
        addi x31, x31, x3
        addi x31, x31, x4
        addi x31, x31, x5
        addi x31, x31, x6
        addi x31, x31, x7
        addi x31, x31, x8
        addi x31, x31, x9
        addi x31, x31, 1
lp2: j lp2

        .section .data
_x:     .4byte 0x1
        .4byte 0x2
        .4byte 0x3
        .4byte 0x4
        .4byte 0x5
        .4byte 0x6
        .4byte 0x7
        .4byte 0x8
