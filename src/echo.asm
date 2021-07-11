section .data
        padding db " ", 0       ;" \0"
        newline db 10, 0        ;"\n\0"

section .text
        global _start

_start:
        pop rdi
        pop rax
        _argloop:
        cmp rdi, 1              ;check argcount
        jle _end
        dec rdi

        pop rax
        push rdi
        mov rdi, 1
        call _printstr
        mov rax, padding
        call _printstr
        pop rdi
        
        jmp _argloop



_printstr:
        push rdi
        push rax
        xor rdi, rdi            ;set to 0

        _cntloop:
        inc rax
        inc rdi
        mov cl, [rax]
        cmp cl, 0
        jne _cntloop

        mov rax, 1
        mov rdx, rdi
        pop rsi
        pop rdi
        syscall
        ret

_end:
        mov rax, newline
        call _printstr

        mov rax, 60
        mov rdi, 0
        syscall
