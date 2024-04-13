bits 64

section .text
global strncpyAsm
strncpyAsm:
	; rdi - char *dst
	; rsi - char *src
	; rdx - int len
    xor rcx, rcx
    inc rdx

    cmp rdi, rsi 
    jl less_case
greater_case:
    add rsi, rdx
    add rdi, rdx

    inc rdx
    std
greater_loop:
    movsb

    inc rcx
    cmp rcx, rdx
    jne greater_loop

    jmp exit
less_case:
    ; inc rcx

    cld
less_loop:
    movsb

    inc rcx
    cmp rcx, rdx
    jne less_loop

    jmp exit

exit:
    ret
