.MODEL TINY
.DOSSEG

.DATA
MSG 	db "Hello, World!", 0Dh, 0Ah, '$'

.CODE
.STARTUP
	mov ah, 09h
	mov dx, OFFSET MSG
	int 21h

	mov ah, 4Ch
	int 21h
END
