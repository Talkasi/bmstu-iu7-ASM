.386
EXTRN printc: near
EXTRN prints: near
EXTRN scans: near
EXTRN CR: near
EXTRN LF: near

EXTRN scan_hex: near
EXTRN print_unsigned_bin: near
EXTRN print_short_signed_dec: near
EXTRN find_multiple_pow2: near

PUBLIC SCAN_PROMPT
PUBLIC PRINT_UNSIGNED_BIN_STR
PUBLIC POW2_STR
PUBLIC PRINT_SIGNED_DEC_STR

; Использование команд процессора 80386 в MASM
; Команды побитовых операций в архитектуре x86 появились, начиная с 386-го
; процессора. Для того, чтобы указать компилятору на необходимость их поддержки,
; нужно в начале модуля указать директиву .386. Однако при использовании этой
; директивы компилятор начнёт формировать файлы для 32-разрядных архитектур,
; поэтому в описании сегментов потребуется указывать параметр USE16.
; Также отладчик AFD не всегда корректно распознаёт подобные команды, поэтому
; может возникнуть необходимость использования других отладчиков, например, MS
; CodeView.
;
; Задание
; Требуется составить программу, которая будет осуществлять:
; 		● ввод 16-разрядного числа;
; 		● вывод его в знаковом либо беззнаковом представлении в системе счисления по
; варианту;
; 		● усечённое до 8 разрядов значение (аналогично приведению типа int к char в
; языке C) в знаковом либо беззнаковом представлении в системе счисления по
; варианту;
; 		● задание на применение команд побитовой обработки: степень
; двойки, которой кратно введённое число; 
;
; Взаимодействие с пользователем должно строиться на основе меню. Программа
; должна содержать не менее пяти модулей. Главный модуль должен обеспечивать
; вывод меню, а также содержать массив указателей на подпрограммы, выполняющие
; действия, соответствующие пунктам меню. Обработчики действий должны быть
; оформлены в виде подпрограмм, находящихся каждая в отдельном модуле. Вызов
; необходимой функции требуется осуществлять с помощью адресации по массиву
; индексом выбранного пункта меню.

; ввод: 				   вывод 1:				   вывод 2: 			 найти:
; беззнаковое в 16 с/с     беззнаковое в 2 с/с     знаковое в 10 с/с     1-й вариант

StackS SEGMENT USE16 PARA STACK 'STACK'
	db 1000 dup(0)
StackS ENDS

DataS SEGMENT USE16 PARA PUBLIC 'DATA'
GIVEN_HEX_NUMBER  dw 0
	 COMMAND       db 2, 0, 3 dup('$')

MAX_N_DIGITS	   db 4

FUNC_MANAGER      dw 4 dup(0)

   START_MENU     db "Menu: ", 10
   				   db "0 - Quit", 10
	 		         db "1 - Enter unsigned hex number", 10, "$"

EXTENDED_MENU     db "2 - Print given number as ubin", 10
			    	   db "3 - Print given number as shortened to 8 digits dec", 10
			         db "4 - Find the power of two that is a multiple of the given number", 10, "$"

  MENU_PROMPT     db "> Enter number of the command to execute: $"
WRONG_COMMAND	   db "> ERROR! Entered number of the command is wrong ", 2, 10, "$"

SCAN_PROMPT			db "> Enter unsigned hex number: $"
PRINT_UNSIGNED_BIN_STR db "> Unsinged bin: $"
POW2_STR				db "> The power of two that is a multiple of the given number: $"
PRINT_SIGNED_DEC_STR db "> Singed dec: $"

DataS ENDS

CodeS SEGMENT USE16 PUBLIC 'CODE'
	assume SS:StackS, CS:CodeS, DS:DataS
main:
	mov ax, DataS
	mov ds, ax

	mov FUNC_MANAGER[0], scan_hex
	mov FUNC_MANAGER[2], print_unsigned_bin
	mov FUNC_MANAGER[4], print_short_signed_dec
	mov FUNC_MANAGER[6], find_multiple_pow2

	mov cx, 0
main_loop:
	; Print beginner menu
	mov dx, offset START_MENU
	call prints

	; Check if extended menu is also needed
	cmp cx, 0
	je skip_extended_menu

	; Print extended menu if needed
	mov dx, offset EXTENDED_MENU
	call prints
skip_extended_menu:
	; Print command prompt
	mov dx, offset MENU_PROMPT
	call prints

	; Scan command
	mov dx, offset COMMAND
	call scans

	; TODO(Talkasi): Check command number

	; Make command usable for further comparasions
	mov ah, 0
	mov al, byte ptr [COMMAND + 2]
	sub al, '0' 
	mov byte ptr [COMMAND + 2], al

	; Check if command is to QUIT
	cmp al, 0
	je end_program

	; Call corresponding function
	; call CR 
	; call LF
	; mov dl, ah
	; add dl, '0'
	; call printc
	; mov dl, al
	; add dl, '0'
	; call printc
	call CR 
	call LF

	mov bx, ax
	dec bx

	mov  ax, 2
	mul  bx
	mov bx, ax
	
	mov dx, OFFSET GIVEN_HEX_NUMBER
	call FUNC_MANAGER[bx]

	cmp cx, 0
	jne main_loop
	inc cx
	jmp main_loop

end_program:
	mov ax, 4c00h
	int 21h
CodeS ENDS

END main
