section .text
        global _start

_start:
        pop rax
        cmp rax, 1
        jle _errend

_mkdirloop:
        pop rdi
        dec rax
        push rax

        mov rax, 83
        mov rsi, 0755o
        syscall

        pop rdi
        cmp rdi, 0      ;check for failure to create dir
        push rdi
        jg _noerr
        jle _end
        cmp rax, 0      ;or for end of arguments
        jne _errend
        _noerr:

        pop rax
        jmp _mkdirloop

_errend:
        mov rax, 60
        mov rdi, 1
        syscall

_end:
        mov rax, 60
        xor rdi, rdi
        syscall
