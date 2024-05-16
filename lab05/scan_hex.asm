.386
PUBLIC scan_hex

EXTRN scanc: near
EXTRN printc: near
EXTRN prints: near

EXTRN CR: near
EXTRN LF: near

EXTRN SCAN_PROMPT: byte


CodeS SEGMENT USE16 PARA PUBLIC 'CODE'
	assume CS:CodeS

scan_hex proc near
	pusha
	mov bp, sp

	mov bx, dx
	mov word ptr [bx], 0

	mov dx, OFFSET SCAN_PROMPT
	call prints

	mov cx, 0
scan_loop:
	call scanc

	cmp al, 'A'
	jl manage_number

	sub al, 'A'
	add al, 10
	jmp save_digit
manage_number:
	sub al, '0'
save_digit:
	mov ah, 0
	or word ptr [bx], ax

	cmp cl, 3
	je exit_loop

	rol word ptr [bx], 4

	inc cx
	jmp scan_loop
exit_loop:
	call CR 
	call LF

	mov sp, bp
	popa
	ret
scan_hex endp

CodeS ENDS
END
