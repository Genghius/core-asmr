section .data
        file db "File: ", 0
        size db 10, "Size: ", 0
        blks db 9, "Blocks: ", 0
        bksz db 9, "IO Block: ", 0
        dvce db 10, "Device: ", 0
        inod db 9, "Inode: ", 0
        lnks db 9, "Links: ", 0
        gid  db 10, "Gid: ", 0
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
        push rdi
        mov rax, file
        call _printstr

        pop rdi
        pop rax
        push rdi

        call _printstr

        mov rdi, rsi

        mov rax, 4      ;sys_stat
        mov rsi, stat
        syscall
                        ;here we start printing shit.
        mov rax, size
        call _printstr
        mov rax, [stat + STAT.st_size]
        call _printint

        mov rax, blks
        call _printstr
        mov rax, [stat + STAT.st_blocks]
        call _printint

        mov rax, bksz
        call _printstr
        mov rax, [stat + STAT.st_blksize]
        call _printint

        mov rax, dvce
        call _printstr
        mov rax, [stat + STAT.st_dev]
        call _printint

        mov rax, inod
        call _printstr
        mov rax, [stat + STAT.st_ino]
        call _printint

        mov rax, lnks
        call _printstr
        mov rax, [stat + STAT.st_nlink]
        call _printint

        mov rax, gid
        call _printstr
        mov rax, [stat + STAT.st_gid]
        call _printint

        mov rax, newline
        call _printstr
                        ;here we stop printing shit.

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
