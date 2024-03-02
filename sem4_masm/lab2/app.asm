DataS SEGMENT WORD 'DATA'
HelloMessage db 13
		     db 10
			 db 'Hello, world!$'
DataS ENDS

Code SEGMENT WORD 'CODE'
DispMsg:
	mov ax, DataS
	mov ds, ax

	mov dx, OFFSET HelloMessage
	mov ah, 09h
	mov cx, 3
call_loop:
	int 21h
	loop call_loop

	mov ah, 07h
	int 21h

	mov ah,	4Ch
	int 21h
Code ENDS

END DispMsg