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
        push rax
        xor rdx, rdx

        _strloop:
        cmp byte [rax + rdx], 0
        je _strend
        inc rdx
        jmp _strloop

        _strend:
        inc rdx

        mov rax, 1
        pop rsi
        syscall
        ret

_end:
        mov rax, newline
        call _printstr

        mov rax, 60
        xor rdi, rdi
        syscall
