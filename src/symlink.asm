section .text
        global _start

_start:
        pop rax
        cmp rax, 3      ;check file 1 and 2 exist
        jne _errend

        pop rax         ;ignore argv[0]

        pop rdi         ;filename
        pop rsi         ;linkname
        mov rax, 88     ;sys_symlink
        syscall

        cmp rax, 0      ;check for errors
        jne _errend

        jmp _end

_errend:
        mov rax, 60
        mov rdi, 1
        syscall

_end:
        mov rax, 60
        xor rdi, rdi
        syscall
