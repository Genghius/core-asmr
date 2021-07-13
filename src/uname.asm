section .data
        ostype db "/proc/sys/kernel/ostype", 0
        bufsiz equ 64

section .bss
        buff resb 64

section .text
        global _start

_start:
        mov rax, 2              ;sys_open
        mov rdi, ostype
        mov rdx, 0666o          ;mode does not matter as we are only reading
        syscall

        cmp rax, 0              ;check if there was an error
        jl _errend

        push rax                ;store file descriptor

        xor rax, rax            ;sys_read (0)
        pop rdi
        mov rsi, buff
        mov rdx, bufsiz
        syscall

        push rdi                ;store file descriptor

        mov rsi, buff
        call _strlen            ;getlen

        mov rax, 1              ;sys_write
        mov rdi, 1
        mov rsi, buff
        syscall

        mov rax, 3              ;sys_close
        pop rdi
        syscall

        jmp _end

_errend:
        mov rax, 60
        mov rdi, 1
        syscall

_end:
        mov rax, 60
        xor rdi, rdi
        syscall

_strlen:
        _strloop:
        cmp byte [rsi + rdx], 0
        je _strend
        inc rdx
        jmp _strloop

        _strend:
        inc rdx
        ret
