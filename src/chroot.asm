section .text
        global _start

_start:
        pop rax
        cmp rax, 2
        jne _errend     ;Error if argv does not just have path
        pop rax         ;discard argv[0]

        mov rax, 161    ;sys_chroot
        pop rdi
        syscall

        cmp rax, 0      ;check for errors
        je _end

_errend:
        mov rax, 60
        mov rdi, 1
        syscall

_end:
        mov rax, 60
        xor rdi, rdi
        syscall
