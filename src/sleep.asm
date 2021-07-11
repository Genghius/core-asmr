section .data
        billion equ 1000000000
                        ;1 billion nanoseconds in a second

section .text
        global _start

_start:
        pop rax
        pop rdi         ;dispose of argv[0]
        cmp rax, 1      ;check for atleast 1 arg
        jle _errend

        pop rcx
        call _parsetime ;will return rdi as whole part and rax as fraction

        push rax
        mov rax, 1
        mov rcx, 10

        _decloop:       ;loop for every decimal place
        mul rcx
        dec rsi
        cmp rsi, 1
        jg _decloop

        mov rsi, rax
        pop rax
        push rsi

        mov rsi, billion
        mul rsi
        pop rsi
        div rsi

        push rax
        push rdi

        mov rax, 35     ;nanosleep call
        mov rdi, rsp
        xor rsi, rsi    ;we dont expect this to fail
        syscall

        jmp _end

_parsetime:
        xor rax, rax    ;set 0
        mov rdi, -1

        _intloop:
        mov dl, [rcx]
        inc rcx
        inc rsi         ;rsi will count decimal places

        cmp dl, 0       ;check end of string
        jne _continue

        cmp rdi, -1
        jne _ret

        mov rdi, rax
        xor rax, rax

        _ret:
        ret

        _continue:
        cmp dl, '.'     ;check for fractional part
        jne _nofrac

        xor rsi, rsi
        mov rdi, rax
        xor rax, rax

        jmp _intloop

        _nofrac:
        cmp dl, '0'     ;check for invalid chars
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


_errend:
        mov rax, 60
        mov rdi, 1
        syscall
        
_end:
        mov rax, 60
        xor rdi, rdi
        syscall
