;Program to delete the column whith the biggest number of zero elements in matrix of digits.

SSTK SEGMENT para STACK 'STACK'
	db 100 dup(0)
SSTK ENDS

SD SEGMENT para public 'DATA'

		  I db 2, 0, 3 dup('$')
		  J db 2, 0, 3 dup('$')
		 EL db 2, 0, 3 dup('$')

	 MATRIX db 9*9 dup(0)

   PROMPT_I db "Enter number of rows in the matrix: $"
   PROMPT_J db "Enter number of columns in the matrix: $"

PROMPT_EL_S db "Enter element [$"
PROMPT_EL_M db "; $"
PROMPT_EL_E db "]: $"

SD ENDS

SC SEGMENT para public 'CODE'
	assume SS:SSTK, CS:SC, DS:SD
main:
	mov ax, SD
	mov ds, ax

	mov dx, OFFSET PROMPT_I
	call prints
	mov dx, OFFSET I
	call scans
	call LF

	mov dx, OFFSET PROMPT_J
	call prints
	mov dx, OFFSET J
	call scans 
	call LF

	mov cx, 0
	mov bx, 0
scan_loop:
	call print_el_prompt
	call scan_el
	cmp cx, 9*9
	jne scan_loop
	
	; mov dx, OFFSET (I + 2)
	; call prints
	; call LF
	; mov dx, OFFSET (J + 2) 
	; call prints

	mov ax, 4c00h
	int 21h

LF proc near
	mov ah, 02h
	mov dx, 10
	int 21h
	ret
LF endp

CR proc near
	mov ah, 02h
	mov dx, 13
	int 21h
	ret
CR endp

prints proc near
	mov ah, 09h
	int 21h
	ret
prints endp

printc proc near
	mov ah, 02h
	int 21h
	ret
printc endp

scanc proc near
	mov ah, 01h
	int 21h
	ret
scanc endp

scans proc near
	mov ah, 0Ah
	int 21h

	mov bx, dx
	mov ah, 0
	mov al, byte ptr [bx + 1]
	add bx, ax
	add bx, 2
	mov byte ptr [bx], '$'

	ret
scans endp

print_el_prompt proc near
	mov dx, OFFSET PROMPT_EL_S
	call prints 

	mov dl, bh
	add dl, '0'
	call printc

	mov dx, OFFSET PROMPT_EL_M 
	call prints

	mov dl, bl
	add dl, '0'
	call printc

	mov dx, OFFSET PROMPT_EL_E
	call prints
	ret
print_el_prompt endp

scan_el proc near
	mov dx, OFFSET EL
	call scans 
	ret
scan_el endp
SC ENDS

END main


