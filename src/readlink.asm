section .data
        newline db 10           ;'\n'

section .bss
        buff resb 4096          ;MAX PATHLEN is 4096
        buffsize equ $ - buff

section .text
        global _start

_start:
        pop rax                 ;check atleast 1 arg
        cmp rax, 1
        jle _errend

        pop rdi                 ;discard argv[0]

        _rlnkloop:
        pop rdi
        push rax
        mov rax, 89             ;sys_readlink
        mov rsi, buff
        mov rdx, buffsize
        syscall

        cmp rax, -1             ;check for error
        jle _errend

        mov rdx, rax
        mov rsi, buff
        call _printstr          ;pwd to thingy

        mov rdx, 1
        mov rsi, newline
        call _printstr          ;newline

        pop rax
        dec rax
        cmp rax, 1
        jg _rlnkloop            ;loop for every link

        jmp _end

_printstr:
        mov rax, 1
        mov rdi, 1
        syscall
        ret

_errend:
        mov rax, 60
        mov rdi, 1
        syscall

_end:
        mov rax, 60
        mov rdi, 0
        syscall
