section .bss
        buff resb 1

section .text
        global _start

_start:
        pop rax
        push 1
        cmp rax, 1      ;check if there is an argument
        jle _noarg      ;leave write file as stdout if none

        pop rdi
        pop rdi

        mov rax, 2      ;sys_open
        pop rdi
        mov rsi, 65
        mov rdx, 0644o
        syscall

        cmp rax, -1     ;check for errors
        je _errend

        push rax

        _noarg:
        mov rsi, buff
        mov rdx, 1

        _loop:
        xor rax, rax    ;sys_read (0)
        xor rdi, rdi
        syscall

        cmp rax, 0
        je _end

        mov rax, 1      ;sys_write
        pop rdi
        syscall
        push rdi

        jmp _loop

_errend:
        mov rax, 60
        mov rdi, 1
        syscall

_end:
        mov rax, 3      ;sys_close
        pop rdi         ;stdin is a file so we can close it without errors
        syscall         ;it also does not matter here as the program finished

        mov rax, 60
        xor rdi, rdi
        syscall
