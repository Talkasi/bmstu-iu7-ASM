PUBLIC print_i

SC2 SEGMENT para public 'CODE'
	assume CS:SC2
print_i proc far
	mov ah, 0
	add bx, ax
	mov dl, byte ptr [bx]
	mov ah, 2
	int 21h
	retf
print_i endp
SC2 ENDS
END
