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

    mov rcx, rdx
    std
    rep movsb

    jmp exit
less_case:
    cld
    mov rcx, rdx
    rep movsb

exit:
    ret
