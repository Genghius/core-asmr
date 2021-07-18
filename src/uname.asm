section .data
        newline db 10, 0

section .bss
        uname resq 6

section .text
        global _start

_start:
        mov rax, 63     ;sys_uname
        mov rdi, uname
        syscall

        cmp rax, 0      ;check error
        jne _errend

        mov rax, uname  ;this struct contains much more than just the osname.
        mov rdi, 1      ;However, i do not care enough. so im just printing this.
        call _printstr

        mov rax, newline
        call _printstr

        jmp _end

_errend:
        mov rax, 60
        mov rdi, 1
        syscall

_end:
        mov rax, 60
        xor rdi, rdi
        syscall

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
