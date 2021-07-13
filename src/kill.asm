section .text
        global _start

_start:
        pop rax
        pop rdi         ;discard argv[0]
        cmp rax, 1      ;argument count checking
        jle _errend
        cmp rax, 2
        mov rax, 15     ;default SIGTERM
        je _default

        pop rdi
        call _parseint

        _default:
        pop rdi
        push rax
        call _parseint
        push rax

        mov rax, 62     ;sys_kill
        pop rdi
        pop rsi
        syscall

        cmp rax, 0      ;check for errors
        jne _errend

        jmp _end

_errend:
        mov rax, 60
        mov rdi, 1
        syscall

_end:
        mov rax, 60
        xor rdi, rdi
        syscall

_parseint:
       xor rax, rax

       _intloop:
       mov dl, [rdi]
       inc rdi

       cmp dl, 0
       jne _continue

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
