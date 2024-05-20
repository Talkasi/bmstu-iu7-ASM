bits 64
global main

%define GTK_WIN_POS_CENTER 1
%define GTK_WIN_WIDTH 400
%define GTK_WIN_HEIGHT 50
%define GTK_ORIENTATION_VERTICAL 1
%define GTK_ORIENTATION_HORIZONTAL 2

extern exit
extern gtk_init
extern gtk_main
extern g_object_set
extern gtk_main_quit
extern gtk_window_new
extern gtk_widget_show_all
extern g_signal_connect
extern gtk_window_set_title
extern g_signal_connect_data
extern gtk_window_set_position
extern gtk_settings_get_default
extern gtk_window_set_default_size
extern gtk_box_new
extern gtk_entry_new
extern gtk_box_pack_start
extern gtk_entry_set_text
extern gtk_container_add
extern gtk_button_new_with_label
extern gtk_label_new
extern gtk_box_pack_end

extern gtk_entry_get_text
extern strtod
extern strtoull
extern printf
extern write
extern sprintf

extern gtk_grid_new
extern gtk_grid_attach
extern gtk_label_set_text
extern gtk_widget_set_hexpand
extern gtk_widget_set_vexpand

extern gtk_message_dialog_new
extern gtk_message_dialog_format_secondary_text
extern gtk_dialog_add_button
extern gtk_widget_show
extern gtk_dialog_run
extern gtk_window_present
extern gtk_widget_destroy

extern secant_method
extern printf

global result
section .bss
    window: resq 1
    vbox: resq 1
    grid: resq 1

    lable_x0: resq 1
    lable_x1: resq 1
    lable_n_steps: resq 1

    entry_x0: resq 1
    entry_x1: resq 1
    entry_iter: resq 1

    button: resq 1
    dialog: resq 1

    x_0: resq 1
    x_1: resq 1
    iter: resq 1

    ptr_result: resq 1
    success: resb 1

section .data
    result: dq 0
section .rodata
    signal:
.destroy:   db "destroy", 0
.clicked:   db "clicked", 0

title:      db "Lab_10", 0

text_label_x0: db "X start: ", 0
text_label_x1: db "X end: ", 0
text_label_iter: db "N steps: ", 0

button_label: db "Calculate", 0
success_message: db "Result: %.5f", 0
failure_message: db "Root not found with %.0f steps", 0
ok_button_text: db "ok", 0

eps: dq 0.00001
const_100: dq 0x4059000000000000  ; 100.0 в формате IEEE 754

section .equ
    GTK_BUTTONS_OK equ 1

section .text
_destroy_window:
    jmp gtk_main_quit
    
_button_clicked:
    ; x_0
    mov rdi, [rel entry_x0]
    call gtk_entry_get_text
    mov rdi, rax            ; Загрузить строку в rdi
    xor rsi, rsi            ; Установить endptr в 0
    call strtod
    movsd [rel x_0], xmm0   ; Переместить результат в x_0

    ; x_end
    mov rdi, [rel entry_x1]
    call gtk_entry_get_text
    mov rdi, rax            ; Загрузить строку в rdi
    xor rsi, rsi            ; Установить endptr в 0
    call strtod
    movsd [rel x_1], xmm0   ; Переместить результат в x_1

    ; n_steps
    mov rdi, [rel entry_iter]
    call gtk_entry_get_text
    mov rdi, rax            ; Загрузить строку в rdi
    xor rsi, rsi            ; Установить endptr в 0
    call strtod
    movsd [rel iter], xmm0  ; Переместить результат в x_1


    movsd xmm3, [rel iter]  ; max_iter
    movq rax, xmm3
    push rax

    movsd xmm2, [rel eps]   ; eps
    movq rax, xmm2
    push rax

    movsd xmm1, [rel x_1]   ; x1
    movq rax, xmm1
    push rax

    movsd xmm0, [rel x_0]   ; x0
    movq rax, xmm0
    push rax

    mov rax, [rel ptr_result]
    push rax

    ; Вызвать secant_method
    call secant_method
    add rsp, 0x28

    ; Сохранить возвращаемое значение (bool)
    mov [rel success], al
    ; Вызов функции show_result_dialog
    call show_result_dialog

    ret

show_result_dialog:
    ; Создание диалогового окна
    mov rdi, 0                  ; parent window (NULL)
    mov rsi, 0                  ; flags (GTK_DIALOG_DESTROY_WITH_PARENT)
    mov rdx, 0                  ; message_type (GTK_MESSAGE_INFO)
    mov rcx, 1                  ; buttons (GTK_BUTTONS_OK)
    mov r8, 0                   ; message_format (NULL)
    call gtk_message_dialog_new
    mov rbx, rax

    ; Проверка значения success
    cmp byte [rel success], 1
    je success_msg          ; Если success == 1, перейти к success_message
    ; Иначе вывести другое сообщение
    mov rdi, rbx
    mov rsi, failure_message
    ; movsd [rel iter], 100
    movsd xmm0, [rel iter]    ; Значение result
    call gtk_message_dialog_format_secondary_text

    jmp failure_msg

success_msg:
    ; mov rax, 1
    mov rdi, rbx
    mov rsi, success_message     ; Строка форматирования
    ; mov rdx, [rel result]
    movsd xmm0, [rel result]   ; Значение result
    ; movsd xmm0, [rel const_100]
    call gtk_message_dialog_format_secondary_text

failure_msg:
    ; Отображение диалогового окна
    mov rdi, rbx
    call gtk_window_present

    ; Ждать закрытия диалогового окна
    mov rdi, rbx
    call gtk_dialog_run
    mov rdi, rbx
    call gtk_widget_destroy

    ret

main:
    push rbp
    mov rbp, rsp
    xor rdi, rdi
    xor rsi, rsi
    call gtk_init

    movq xmm0, [result]
    movq [ptr_result], xmm0

    xor rdi, rdi
    call gtk_window_new
    mov qword [rel window], rax     ;rel - адрес vbox будет вычислен относительно текущего положения инструкции
    mov rdi, rax
    mov rsi, title
    call gtk_window_set_title

    mov rdi, qword [rel window]
    mov rsi, GTK_WIN_WIDTH
    mov rdx, GTK_WIN_HEIGHT
    call gtk_window_set_default_size

    mov rdi, qword [rel window]
    mov rsi, GTK_WIN_POS_CENTER
    call gtk_window_set_position

    ; Создание вертикального контейнера
    mov rdi, GTK_ORIENTATION_VERTICAL
    call gtk_box_new
    mov qword [rel vbox], rax


    ; Создание grid
    mov rdi, 3  ; n_rows
    mov rsi, 2  ; n_columns
    call gtk_grid_new
    mov qword [rel grid], rax

    mov rdi, qword[rel grid]
    mov rsi, 1  ; TRUE (заполнить по горизонтали)
    call gtk_widget_set_vexpand

    ; Добавление элементов в grid
    ; Строка 1
    call gtk_label_new
    mov qword [rel lable_x0], rax  ; Сохраняем адрес label в переменной

    mov rdi, qword[rel lable_x0]
    mov rsi, 1  ; TRUE (заполнить по горизонтали)
    call gtk_widget_set_hexpand

    mov rdi, qword[rel lable_x0]
    mov rsi, text_label_x0
    call gtk_label_set_text

    mov rdi, qword [rel grid]
    mov rsi, qword [rel lable_x0]  ; Используем сохраненный адрес
    mov rdx, 0  ; column
    mov rcx, 0  ; row
    mov r8, 1       ; r8 = width (ширина в колонках)
    mov r9, 1       ; r9 = height (высота в строках)
    call gtk_grid_attach


    call gtk_entry_new
    mov qword [rel entry_x0], rax  ; Сохраняем адрес label в переменной

    mov rdi, qword[rel entry_x0]
    mov rsi, 1  ; TRUE (заполнить по горизонтали)
    call gtk_widget_set_hexpand
    
    mov rdi, qword [rel grid]
    mov rsi, qword [rel entry_x0]  ; Используем сохраненный адрес
    mov rdx, 1  ; column
    mov rcx, 0  ; row
    mov r8, 1       ; r8 = width (ширина в колонках)
    mov r9, 1       ; r9 = height (высота в строках)
    call gtk_grid_attach

    ; Строка 2
    call gtk_label_new
    mov qword [rel lable_x1], rax  ; Сохраняем адрес label в переменной

    mov rdi, qword[rel lable_x1]
    mov rsi, 1  ; TRUE (заполнить по горизонтали)
    call gtk_widget_set_hexpand

    mov rdi, qword[rel lable_x1]
    mov rsi, text_label_x1
    call gtk_label_set_text

    mov rdi, qword [rel grid]
    mov rsi, qword [rel lable_x1]  ; Используем сохраненный адрес
    mov rdx, 0  ; column
    mov rcx, 1  ; row
    mov r8, 1       ; r8 = width (ширина в колонках)
    mov r9, 1       ; r9 = height (высота в строках)
    call gtk_grid_attach


    call gtk_entry_new
    mov qword [rel entry_x1], rax  ; Сохраняем адрес label в переменной

    mov rdi, qword[rel entry_x1]
    mov rsi, 1  ; TRUE (заполнить по горизонтали)
    call gtk_widget_set_hexpand

    mov rdi, qword [rel grid]
    mov rsi, qword [rel entry_x1]  ; Используем сохраненный адрес
    mov rdx, 1  ; column
    mov rcx, 1  ; row
    mov r8, 1       ; r8 = width (ширина в колонках)
    mov r9, 1       ; r9 = height (высота в строках)
    call gtk_grid_attach

    ; Строка 3
    call gtk_label_new
    mov qword [rel lable_n_steps], rax  ; Сохраняем адрес label в переменной

    mov rdi, qword[rel lable_n_steps]
    mov rsi, 1  ; TRUE (заполнить по горизонтали)
    call gtk_widget_set_hexpand

    mov rdi, qword[rel lable_n_steps]
    mov rsi, text_label_iter
    call gtk_label_set_text
    
    mov rdi, qword [rel grid]
    mov rsi, qword [rel lable_n_steps]  ; Используем сохраненный адрес
    mov rdx, 0  ; column
    mov rcx, 2  ; row
    mov r8, 1       ; r8 = width (ширина в колонках)
    mov r9, 1       ; r9 = height (высота в строках)
    call gtk_grid_attach


    call gtk_entry_new
    mov qword [rel entry_iter], rax  ; Сохраняем адрес label в переменной

    mov rdi, qword[rel entry_iter]
    mov rsi, 1  ; TRUE (заполнить по горизонтали)
    call gtk_widget_set_hexpand

    mov rdi, qword [rel grid]
    mov rsi, qword [rel entry_iter]  ; Используем сохраненный адрес
    mov rdx, 1  ; column
    mov rcx, 2  ; row
    mov r8, 1       ; r8 = width (ширина в колонках)
    mov r9, 1       ; r9 = height (высота в строках)
    call gtk_grid_attach

    ; Добавление grid в вертикальный контейнер
    mov rdi, qword [rel vbox]
    mov rsi, qword [rel grid]
    call gtk_container_add

    ; Создание кнопки
    mov rdi, button_label
    call gtk_button_new_with_label
    mov qword [rel button], rax  ; Сохраняем адрес label в переменной

    ; Подключение сигнала "clicked" к функции _button_clicked
    mov rdi, qword [rel button]
    mov rsi, signal.clicked
    mov rdx, _button_clicked
    mov rcx, 0
    call g_signal_connect_data

    mov rdi, qword [rel vbox]
    mov rsi, qword [rel button]  ; Используем сохраненный адрес
    call gtk_container_add

    ; Добавление вертикального контейнера в окно
    mov rdi, qword [rel window]
    mov rsi, qword [rel vbox]
    call gtk_container_add

    ; --------------------------------------------
    mov rdi, qword [rel window]
    mov rsi, signal.destroy
    mov rdx, _destroy_window
    xor rcx, rcx
    xor r8d, r8d
    xor r9d, r9d
    call g_signal_connect_data

    mov rdi, qword [rel window]
    call gtk_widget_show_all
    call gtk_main

    pop rbp
    ret
