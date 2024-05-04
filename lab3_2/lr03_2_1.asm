STK SEGMENT para STACK 'STACK'
	db 100 dup(0)
STK ENDS

SD1 SEGMENT para common 'DATA'
; 0011 0100 0100 0100
; 52 68
; 4 D
; little endian
	W dw 3444h
SD1 ENDS
END
