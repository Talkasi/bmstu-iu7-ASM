.386
PUBLIC print_unsigned_bin
EXTRN printc: near
EXTRN prints: near
EXTRN scans: near
EXTRN CR: near
EXTRN LF: near

EXTRN PRINT_UNSIGNED_BIN_STR: byte

CodeS SEGMENT USE16 PARA PUBLIC 'CODE'
	assume CS:CodeS

print_unsigned_bin proc near
	pusha
	mov bp, sp

	; dx - the number is here
	mov bx, dx
	mov dx, OFFSET PRINT_UNSIGNED_BIN_STR
	call prints

	mov cx, 0
print_ubin_loop:
	mov ax, 8000h
	and ax, word ptr[bx]

	cmp ax, 0
	jne print_1
	mov dl, '0'
	jmp print_bit
print_1:
	mov dl, '1'
print_bit:
	call printc
	
	rol word ptr[bx], 1

	inc cx
	cmp cx, 16
	jne print_ubin_loop

exit_print_ubin_loop:
	call CR 
	call LF

	mov sp, bp
	popa
	ret
print_unsigned_bin endp

CodeS ENDS
END
