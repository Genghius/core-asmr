;I know this is entirely retarded and a low effort
;copy of stat. But i sincerely do not give a fuck
;anymore. I JUST WANT TO SLEEP.

section .data
        tab     db  9, 0
        newline db 10, 0

section .bss
        stat resb 144
        buff resb 1

struc STAT
    .st_dev         resq 1
    .st_ino         resq 1
    .st_nlink       resq 1
    .st_mode        resd 1
    .st_uid         resd 1
    .st_gid         resd 1
    .pad0           resb 4
    .st_rdev        resq 1
    .st_size        resq 1
    .st_blksize     resq 1
    .st_blocks      resq 1
    .st_atime       resq 1
    .st_atime_nsec  resq 1
    .st_mtime       resq 1
    .st_mtime_nsec  resq 1
    .st_ctime       resq 1
    .st_ctime_nsec  resq 1
endstruc

section .text
        global _start

_start:
        pop rdi
        cmp rdi, 1
        jle _errend
        pop rax

        _argloop:
        pop rax
        push rdi

        mov rdi, rax
        push rax

        mov rax, 4      ;sys_stat
        mov rsi, stat
        syscall

        mov rax, [stat + STAT.st_size]
        call _printint

        mov rax, tab
        call _printstr

        pop rax
        call _printstr

        mov rax, newline
        call _printstr

        pop rdi
        dec rdi
        cmp rdi, 1
        jg _argloop
        
        jmp _end

_errend:
        mov rax, 60
        mov rdi, 1
        syscall

_end:
        mov rax, 60
        xor rdi, rdi
        syscall

_printint:
        xor r8, r8
        mov rsi, 10

        _loop:
        inc r8
        cmp rax, 1
        jl _continue

        xor rdx, rdx
        div rsi
        add rdx, '0'
        push rdx

        jmp _loop

        _continue:
        mov rdx, 1
        mov rsi, buff

        _printloop:
        dec r8
        mov rax, 1      ;sys_write
        pop rdi
        mov [rsi], rdi
        mov rdi, 1
        syscall

        cmp r8, 1
        jg _printloop

        ret

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

        mov rax, 1      ;sys_write
        mov rdi, 1
        pop rsi
        syscall
        ret
