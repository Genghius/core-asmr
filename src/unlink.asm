section .text
        global _start

_start:
        pop rax
        cmp rax, 1      ;check atleast 1 file
        jle _errend

        pop rdi         ;ignore argv[0]

        _ulnkloop:
        dec rax

        pop rdi         ;linkname
        push rax
        mov rax, 87     ;sys_unlink
        syscall

        cmp rax, 0      ;check for errors
        jne _errend

        pop rax
        cmp rax, 1      ;unlink every file
        jg _ulnkloop

        jmp _end

_errend:
        mov rax, 60
        mov rdi, 1
        syscall

_end:
        mov rax, 60
        xor rdi, rdi
        syscall
