    .text
    .globl _start
_start:
    li   a0, 5            # n = 5
    call sum_to           # a0 = sum_to(5) = 15
    li   a7, 93           # exit 系统调用
    ecall

# long sum_to(long n) { return n == 0 ? 0 : n + sum_to(n - 1); }
sum_to:
    addi sp, sp, -16      # ① 开栈帧（16 字节）
    sd   ra, 8(sp)        # ② 保存返回地址到 [sp+8, sp+16)
    sd   s0, 0(sp)        # ③ 保存 s0 到 [sp+0, sp+8)
    mv   s0, a0           # s0 = n（s0 跨 call 存活）
    beqz a0, .Lbase       # n == 0 则走基准情形
    addi a0, a0, -1       # a0 = n - 1
    call sum_to           # a0 = sum_to(n-1)
    add  a0, a0, s0       # a0 = n + sum_to(n-1)
.Lbase:
    ld   s0, 0(sp)        # ④ 恢复 s0
    ld   ra, 8(sp)        # ⑤ 恢复 ra
    addi sp, sp, 16       # ⑥ 收栈帧
    ret
