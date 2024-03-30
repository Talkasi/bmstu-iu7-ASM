.386
PUBLIC prints
PUBLIC printc
PUBLIC scans
PUBLIC scanc
PUBLIC CR
PUBLIC LF


CodeS SEGMENT USE16 PARA PUBLIC 'CODE'
	assume CS:CodeS

CR proc near
	push ax

	mov ah, 02h
	mov dx, 13
	int 21h

	pop ax
	ret
CR endp

LF proc near
	push ax

	mov ah, 02h
	mov dx, 10
	int 21h

	pop ax
	ret
LF endp

prints proc near
	push ax

	mov ah, 09h
	int 21h

	pop ax
	ret
prints endp

printc proc near
	push ax

	mov ah, 02h
	int 21h

	pop ax
	ret
printc endp

scans proc near
	push ax
	push bx

	mov ah, 0Ah
	int 21h

	mov bx, dx
	mov ah, 0
	mov al, byte ptr [bx + 1]
	add bx, ax
	add bx, 2
	mov byte ptr [bx], '$'

	pop bx
	pop ax
	ret
scans endp

scanc proc near
	mov ah, 01h
	int 21h
	ret
scanc endp

CodeS ENDS
END
