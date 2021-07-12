section .text
        global _start

_start:
        pop rax
        pop rdi         ;discard argv[0]
        cmp rax, 1      ;check atleast 1 arg
        jle _errend

_mkdirloop:
        pop rdi
        dec rax
        push rax

        mov rax, 2      ;sys_open
        mov rsi, 64     ;O_CREATE flag
        mov rdx, 0644o
        syscall

        cmp rax, -1     ;check failure to open
        je _errend

        mov rdi, rax
        mov rax, 3      ;sys_close
        syscall

        pop rax

        cmp rax, 1      ;check end of arguments
        jle _end

        jmp _mkdirloop

_errend:
        mov rax, 60
        mov rdi, 1
        syscall

_end:
        mov rax, 60
        xor rdi, rdi
        syscall
