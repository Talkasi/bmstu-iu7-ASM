.386
PUBLIC find_multiple_pow2
EXTRN scanc: near
EXTRN printc: near
EXTRN prints: near

EXTRN CR: near
EXTRN LF: near

EXTRN POW2_STR: byte

CodeS SEGMENT USE16 PARA PUBLIC 'CODE'
	assume CS:CodeS

find_multiple_pow2 proc near
	pusha
	mov bp, sp

	mov bx, dx

	mov dx, OFFSET POW2_STR
	call prints

	cmp word ptr [bx], 0
	jne normal_life
	mov dl, '0' 
	call printc
	jmp pow_found
normal_life:
	bsf ax, word ptr [bx]

	cmp al, 10
	jl one_symbol
	mov dl, '1' 
	call printc

	sub al, 10
one_symbol:
	mov dl, al
	add dl, '0'
	call printc

pow_found:
	call CR 
	call LF 

	mov sp, bp
	popa
	ret
find_multiple_pow2 endp

CodeS ENDS
END
