section .data
        newline db 10        ;'\n'

section .bss
        buff resb 4096          ;MAX PATHLEN is 4096
        buffsize equ $ - buff

section .text
        global _start

_start:
        mov rax, 79             ;sys_getcwd
        mov rdi, buff
        mov rsi, buffsize
        syscall

        mov rdx, rax            ;print the path to stdout
        mov rax, 1
        mov rdi, 1
        mov rsi, buff
        syscall
        mov rax, 1              ;print newline
        mov rsi, newline
        mov rdx, 1
        syscall

_end:
        mov rax, 60
        mov rdi, 0
        syscall
