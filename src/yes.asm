;movsb -> move byte at [rsi] to [rdi] and increase both registers
section .data
        buffsiz equ 8192
        yes db "y", 10                  ;"y\n"
        space db " "

section .bss
        buff resb 8192                  ;big buffer page-aligned, allows faster writing

section .text
        global _start

_start:
        pop rax
        pop rdi                         ;discard argv[0]
        mov rdi, buff                   ;let rdi point to buffer
        xor rbx, rbx                    ;zero rbx for counting
        cmp rax, 1                      ;check if there are args
        jle _yes

        _argloop:
        pop rsi
        cmp rax, 1                      ;check if there still are args
        dec rax
        jle _main

        call _strlen
        add rbx, rcx                    ;rbx counts total string lenght
        rep movsb

        mov rsi, space
        movsb
        inc rbx

        jmp _argloop

_yes:
        mov rbx, 2

        mov rsi, yes                    ;load "y" if no argument given
        movsb

_main:
        mov rsi, yes + 1                ;load "\n" at the end of string
        movsb

        mov rcx, buffsiz
        sub rcx, rbx
        add rdi, rbx

        mov rsi, buff

        rep movsb                       ;fill buffer with string

        mov rdi, 1
        mov rsi, buff
        mov rdx, buffsiz
        _yesloop:
        mov rax, 1                      ;sys_write
        syscall
        jmp _yesloop

_strlen:
        xor rcx, rcx

        _strloop:
        cmp byte [rsi + rcx], 0
        je _strend
        inc rcx
        jmp _strloop

        _strend:
        ret
