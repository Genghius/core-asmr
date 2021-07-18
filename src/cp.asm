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
        pop rax
        cmp rax, 3
        jne _errend
        pop rax

        mov rax, 4      ;sys_stat
        pop rdi
        mov rsi, stat
        syscall

        cmp rax, 0      ;error check
        jne _errend

	mov rax, 2      ;sys_open
	mov rsi, 64
	mov rdx, 0644o
	syscall

        cmp rax, 0      ;error check
        jl _errend

        pop rdi
	push rax

	mov rax, 2      ;sys_open
	mov rsi, 65
	syscall
	push rax

        cmp rax, 0      ;error check
        jl _errend

	mov rax, 40     ;sys_sendfile
	pop rdi
	pop rsi
	mov rdx, 0
	mov r10, [stat + STAT.st_size]
	syscall

        cmp rax, 0      ;error check
        jl _errend

        mov rax, 3      ;sys_close
        syscall

        mov rax, 3      ;sys_close
        mov rdi, rsi
        syscall

        jmp _end

_errend:
	mov rax, 60
	mov rdi, 1
	syscall

_end:
	mov rax, 60
	xor rdi, rdi
	syscall

