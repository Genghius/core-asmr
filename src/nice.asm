section .text
        global _start

_start:
        pop rax
        pop rdi         ;discard argv[0]
        cmp rax, 1      ;argument count checking
        jle _errend
        cmp rax, 2
        mov rax, 10     ;default nice val
        je _default

        pop rdi
        call _parseint

        _default:
        pop rdi
        push rax
        call _parseint
        push rax

        mov rax, 141    ;sys_setpriority
        xor rdi, rdi    ;PRIO_PROCESS = 0
        pop rsi
        pop rdx
        syscall

        ;error checking needed

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
       mov rsi, 1

       _intloop:
       mov dl, [rdi]
       inc rdi

       cmp dl, 0
       jne _continue

       mul rsi          ;apply sign

       ret

       _continue:
       cmp dl, '-'
       je _negative
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

       _negative:
       mov rsi, -1      ;store sign

       jmp _intloop
