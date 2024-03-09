EXTRN print_i: far

; Program to print the Ith symbol of a string, where i is a digit.

SSTK SEGMENT para STACK 'STACK'
			db 100 dup(0)
SSTK ENDS

SD1 SEGMENT para public 'DATA'
 PROMPT_STR db 13, "Enter line: $"
 RESULT_STR db 13, 10, "th symbol: $"
   PROMPT_I db 13, 10, "Enter digit: $"

  INPUT_STR db 11, 0, 12 dup ('$')
	INPUT_I db 2, 0, 3 dup ('$')
SD1 ENDS

SC1 SEGMENT para public 'CODE'
	assume SS:SSTK, CS:SC1, DS:SD1
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

print proc near
	mov ah, 09h
	int 21h
	ret
print endp

scan proc near
	mov ah, 0Ah
	int 21h

	mov bx, dx
	mov ah, 0
	mov al, byte ptr [bx + 1]
	add bx, ax
	add bx, 2
	mov byte ptr [bx], '$'

	ret
scan endp
main:
	mov ax, SD1
	mov ds, ax

	mov dx, OFFSET PROMPT_STR
	call print

	mov dx, OFFSET INPUT_STR
	call scan

	mov dx, OFFSET PROMPT_I
	call print

	mov dx, OFFSET INPUT_I
	call scan
	call CR
	call LF

	mov dx, OFFSET (INPUT_I + 2)
	call print
	mov dx, OFFSET (RESULT_STR + 2)
	call print

	mov bx, OFFSET (INPUT_STR + 2)
	mov al, byte ptr [INPUT_I + 2]
	sub al, '0'
	call print_i

	mov ax, 4c00h
	int 21h
SC1 ENDS
END main


