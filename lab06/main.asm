.model tiny

CSEG SEGMENT
    assume CS:CSEG
    org 100h        ; Program Segment Prefix offset.
main:
    jmp init

 DEFAULT_HANDLER_ADDR dd 0
      IS_RESIDENT_SET db 1
CURRENT_AUTOREP_SPEED db 1Fh
         CURRENT_TIME db 0

new_timer_interrupt_handler proc near
    push ax
    push cx			    
    push dx
    ; pushf

    mov ah, 02h ; 02h - read real time clock. CH: hours in BCD; CL: minutes in BCD; DH: seconds in BCD. BCD - binary coded decimal.
    int 1Ah     ; CLOCK interrupt.

    cmp dh, CURRENT_TIME
    je skip_speed_change

    mov CURRENT_TIME, dh
    dec CURRENT_AUTOREP_SPEED

    ; 11111b = 2  symbols per second.
    ;   ...
    ; 00000b = 30 symbols per second.
    cmp CURRENT_AUTOREP_SPEED, 1Fh
    jbe set_speed
    mov CURRENT_AUTOREP_SPEED, 1Fh
set_speed:
    ; 0F3h - set parameters for the auto repeat mode.
    ; 60h  - keyboard data port.
    ; out  - copies data from src to the IO port in dst.
    mov al, 0F3h
    out 60h, al                                             

    mov al, CURRENT_AUTOREP_SPEED
    out 60h, al
skip_speed_change:

    ; popf
    pop dx
    pop cx
    pop ax
    ; jmp to the default timer interrupt handler.
    ; jmp dword ptr cs:DEFAULT_HANDLER_ADDR
    jmp dword ptr DEFAULT_HANDLER_ADDR
new_timer_interrupt_handler endp

init:
                  ; 1CH - the number of the timer interrupt handler.
    mov ax, 351Ch ; Returns the value of the interrupt vector for INT (AL).
    int 21h       ; It loads BX with 0000:[AL*4], and ES with 0000:[(AL*4)+2].
                  ; In ES:BX now is the address of the interrupt handler.

    ; cmp byte ptr [IS_RESIDENT_SET], 0
    ; jne exit

    cmp es:IS_RESIDENT_SET, 1
    je exit

    ; Saving address of the default interrupt handler.
    mov word ptr DEFAULT_HANDLER_ADDR, bx
    mov word ptr DEFAULT_HANDLER_ADDR[2], es

    mov ax, 251Ch                               ; AH - set interrupt vector. AL - interrupt number.
    mov dx, offset new_timer_interrupt_handler  ; DS:DX = new vector to be used for specified interrupt.
    int 21h

    ; Print 'Interrupt is set' message.
    mov dx, offset RESIDENT_SET_MSG
    mov ah, 09h
    int 21h

    ; mov byte ptr [IS_RESIDENT_SET], 1

    ; Terminate but stay resident. CS - current program segment.
    mov dx, offset init          ; DX - last program byte + 1.
    int 27h

exit:
    ; Print 'Interrupt is reset' message.
    mov dx, offset RESIDENT_RESET_MSG
    mov ah, 09h
    int 21h

    mov al, 0F3h
    out 60h, al

    mov al, 0
    out 60h, al

    mov dx, word ptr es:DEFAULT_HANDLER_ADDR                       
    mov ds, word ptr es:DEFAULT_HANDLER_ADDR[2]
    mov ax, 251Ch   ; Set interrupt vector. DS:DX - new vector to be used for specified interrupt.
    int 21h

    mov ah, 49h
    int 21h

    ; End program.
    mov ax, 4c00h
    int 21h
	
  RESIDENT_SET_MSG db "New interrupt handler is set.$"
RESIDENT_RESET_MSG db "New interrupt handler is reset.$"
    
CSEG ENDS
END main