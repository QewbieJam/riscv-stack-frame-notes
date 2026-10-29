# =============================================================================
#  binary_ops.s —— RISC-V 二元操作演示（可直接粘贴进 Ripes）
#
#  操作数：  a = 0x00C0FFEE      b = 0x0F0F00FF
#
#  做三件事：
#    1. 对 a、b 依次做 11 个二元运算，结果写进 results[]
#    2. 在 Ripes 的 Memory 视图里可以看到 results 数组逐个被填上
#    3. 循环把 results 里的 11 个数以十六进制打印到 Console
#
#  建议设置：RV32（Ripes 默认）、单步（F10）执行，边看 t3 和内存边理解
# =============================================================================

        .data
results:
        .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

        .text
        .globl _start
_start:
main:
        li    t0, 0x00C0FFEE        # t0 = a
        li    t1, 0x0F0F00FF        # t1 = b
        la    t2, results           # t2 = 结果数组首地址

# ---------------------------- 算术 ----------------------------
        add   t3, t0, t1            # ① t3 = a + b
        sw    t3, 0(t2)             #    results[0] = t3

        sub   t3, t0, t1            # ② t3 = a - b（结果为负，在补码里看）
        sw    t3, 4(t2)             #    results[1] = t3

# ---------------------------- 逻辑 ----------------------------
        and   t3, t0, t1            # ③ t3 = a & b（同为 1 的位才保留）
        sw    t3, 8(t2)             #    results[2] = t3

        or    t3, t0, t1            # ④ t3 = a | b（任一为 1 即置 1）
        sw    t3, 12(t2)            #    results[3] = t3

        xor   t3, t0, t1            # ⑤ t3 = a ^ b（相异为 1）
        sw    t3, 16(t2)            #    results[4] = t3

# ---------------------------- 移位 ----------------------------
        slli  t3, t0, 4             # ⑥ t3 = a << 4，低位补 0
        sw    t3, 20(t2)            #    results[5] = t3

        srli  t3, t0, 4             # ⑦ t3 = a >> 4，高位补 0（逻辑右移）
        sw    t3, 24(t2)            #    results[6] = t3

        li    t4, -16               # t4 = 0xFFFFFFF0，符号位为 1
        srai  t3, t4, 4             # ⑧ 算术右移：高位补符号位 1 → 全 1
        sw    t3, 28(t2)            #    results[7] = 0xFFFFFFFF

        srli  t3, t4, 4             # ⑨ 逻辑右移：高位补 0
        sw    t3, 32(t2)            #    results[8] = 0x0FFFFFFF

# ------------------ 有符号 / 无符号比较 ------------------
        slt   t3, t4, t0            # ⑩ 有符号：-16 < 0x00C0FFEE → 1
        sw    t3, 36(t2)            #    results[9] = 1

        sltu  t3, t4, t0            # ⑪ 无符号：0xFFFFFFF0 < 0x00C0FFEE → 0
        sw    t3, 40(t2)            #    results[10] = 0

# ------------------------- 打印结果 -------------------------
# Ripes ecall：a7=34 打印十六进制，a7=11 打印字符
        li    t5, 0                 # t5 = i（循环变量）
        li    t6, 11                # t6 = 元素个数
print_loop:
        slli  t3, t5, 2             # t3 = i * 4（字偏移）
        add   t3, t2, t3            # t3 = &results[i]
        lw    a0, 0(t3)             # a0 = results[i]
        li    a7, 34                # print_hex
        ecall
        li    a0, 32                # 空格
        li    a7, 11                # print_char
        ecall
        addi  t5, t5, 1
        blt   t5, t6, print_loop    # i < 11 则继续

# --------------------------- 退出 ---------------------------
        li    a7, 10                # exit
        ecall
