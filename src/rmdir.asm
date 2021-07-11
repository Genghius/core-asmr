section .text
        global _start

_start:
        pop rax
        cmp rax, 1      ;check atleast 1 dir
        jle _errend

        pop rdi         ;ignore argv[0]

        _rmloop:
        dec rax

        pop rdi         ;dirname
        push rax
        mov rax, 84     ;sys_rmdir (dir must be empty)
        syscall

        cmp rax, 0      ;check for errors
        jne _errend

        pop rax
        cmp rax, 1      ;"delete" every dir
        jg _rmloop

        jmp _end

_errend:
        mov rax, 60
        mov rdi, 1
        syscall

_end:
        mov rax, 60
        mov rdi, 0
        syscall
