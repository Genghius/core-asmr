section .bss
        buff resb 8192  ;big boi buffer goes brrrrr
        buffsize equ $ - buff

section .text
        global _start

_start:
        pop rdi
        pop rsi         ;discard argv[0]
        cmp rdi, 2      ;check argc
        jl _errend
        je _stdin

        pop rsi
        pop rdi
        push rsi

        _stdin:
        pop rsi
        push rdi
        call _parseint  ;rbx will keep the val N of bytes to print

        pop rdi
        cmp rdi, 0      ;check if we need to open a file
        je _noopen

        mov rax, 2      ;sys_open
        xor rsi, rsi    ;O_RDONLY flag = 0
        mov rdx, 0666o  ;mode does not matter as we are only reading
        syscall

        cmp rax, 0
        jl _errend

        _noopen:

        mov rdi, rax    ;setup for calls to readwrite
        mov rsi, buff
        mov rdx, buffsize

        _readwriteloop:
        xor rax, rax    ;sys_read
        syscall

        cmp rbx, buffsize
        jl _writeless
        sub rbx, buffsize

        push rdi
        mov rax, 1      ;sys_write
        mov rdi, 1
        syscall
        pop rdi

        cmp rbx, buffsize      ;loop until n chars are printed
        jge _readwriteloop
        cmp rbx, 0
        jle _end

        _writeless:
        push rdi
        mov rax, 1      ;sys_write
        mov rdi, 1
        mov rdx, rbx
        syscall
        pop rdi

        jmp _end

_errend:
        mov rax, 60
        mov rdi, 1
        syscall

_end:
        mov rax, 3      ;sys_close
        syscall         ;stdin is also a file so we can close it

        mov rax, 60
        xor rdi, rdi
        syscall

_parseint:
        xor rax, rax

        _intloop:
        mov dl, [rsi]
        inc rsi

        cmp dl, 0
        jne _continue

        mov rbx, rax    ;store in rbx for later use

        ret

        _continue:
        cmp dl, '0'
        jl _errend
        cmp dl, '9'
        jg _errend

        sub dl, '0'
        push rdx
        mov rdx, 10
        mul rdx
        pop rdx
        add rax, rdx

        jmp _intloop
