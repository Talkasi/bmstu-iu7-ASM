.386
PUBLIC print_short_signed_dec

EXTRN scanc: near
EXTRN printc: near
EXTRN prints: near

EXTRN CR: near
EXTRN LF: near

EXTRN PRINT_SIGNED_DEC_STR: byte

CodeS SEGMENT USE16 PARA PUBLIC 'CODE'
	assume CS:CodeS

; 	mov ah, 0
; 	mov al, byte ptr [bx]
; 	neg al
; digit_loop:
; 	mov bl, 10
; 	div bl

; 	mov dl, ah 
; 	add dl, '0'
; 	call printc

; 	mov ah, 0
; 	cmp ax, 0
; 	jne digit_loop

print_short_signed_dec proc near
	pusha
	mov bp, sp

	; dx - the number is here
	mov bx, dx
	mov dx, OFFSET PRINT_SIGNED_DEC_STR
	call prints

	mov ax, 80h
	and ax, word ptr [bx]
	jz skip_sign
	mov dl, '-'
	call printc 
skip_sign:

	mov ah, 0
	mov al, byte ptr [bx]

	; cmp al, 80h
	; jb skip_neg
	
	test al, 80h 
	jz skip_neg
	; mov dl, al
	; and dl, 80h
	; cmp dl, 0
	; je skip_neg
	neg al
skip_neg:
	mov bl, 100

	mov cx, 0
digit_loop:
	div bl

	; al - div
	; ah - mod
	mov dl, al
	add dl, '0'
	call printc

	mov al, ah
	mov ah, 0

	push ax
	mov al, bl
	mov bl, 10
	div bl
	; al - div
	; ah - mod
	mov bl, al
	pop ax

	mov ah, 0
	inc cx
	cmp cx, 3
	jne digit_loop


	call CR 
	call LF

	mov sp, bp
	popa
	ret
print_short_signed_dec endp

CodeS ENDS
END
