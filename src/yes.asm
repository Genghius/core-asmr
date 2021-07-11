section .data
        yes times 4096 db "y", 10       ;big buffer page-aligned, allows faster writing
        yeslen equ $ - yes

section .text
        global _start

_start:
        mov rdi, 1
        mov rsi, yes
        mov rdx, yeslen
        _loop:
        mov rax, 1
        syscall
        jmp _loop
