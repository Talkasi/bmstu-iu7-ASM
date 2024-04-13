
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
greater_loop:
    mov al, byte [rsi]
    mov byte [rdi], al

    dec rdi
    dec rsi

    inc rcx
    cmp rcx, rdx
    jne greater_loop

    jmp exit
less_case:
    ; inc rcx

less_loop:
    mov al, byte [rsi]
    mov byte [rdi], al

    inc rdi 
    inc rsi 

    inc rcx
    cmp rcx, rdx
    jne less_loop

    jmp exit

exit:
    ret
