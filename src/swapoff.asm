section .text
        global _start

_start:
        pop rax
        cmp rax, 1
        jle _errend
        pop rdi         ;discard argv[0]
        pop rdi         ;argv[1]

        mov rax, 168    ;sys_swapoff
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
