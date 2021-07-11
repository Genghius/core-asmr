section .bss
        buff resb 1
        buffsize equ $ - buff

section .text
        global _start

_start:
        pop rax                 ;discard argv[0]
        pop rdi                 ;|
        cmp rax, 1              ;check atleast 1 arg
        jg _open
        push 1                  ;stdin if no arg
        jmp _readwriteloop

_open:
        pop rdi                 ;first arg
        dec rax                 ;decrease argc
        push rax

        mov rax, 2              ;open file
        mov rsi, 0
        mov rdx, 0666o
        syscall

        cmp rax, 0
        jl _errend

        push rax

_readwriteloop:
        mov rax, 0              ;read()
        pop rdi
        mov rsi, buff
        mov rdx, buffsize
        syscall

        push rdi                ;file descriptor
        push rax                ;read() return val

        mov rax, 1              ;write
        mov rdi, 1
        mov rsi, buff
        mov rdx, buffsize
        syscall

        pop rax

        cmp rax, 0              ;check for EOF
        jne _readwriteloop      ;loop until EOF
        
        mov rax, 3              ;close file
        pop rdi
        syscall

        pop rax
        cmp rax, 1
        jg _open

        jmp _end

_errend:
        mov rax, 60
        mov rdi, 1
        syscall

_end:
        mov rax, 60
        mov rdi, 0
        syscall
