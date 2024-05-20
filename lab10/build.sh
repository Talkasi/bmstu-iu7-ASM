#!/bin/bash

nasm -f elf64 -o main.o main.asm
gcc -masm=intel -c secant_method.c
# nasm -f elf64 main.asm && gcc -o app main.o -lgtk-3 -lgdk-3 -lpangocairo-1.0 -lpango-1.0 -lharfbuzz -latk-1.0 -lcairo-gobject -lcairo -lgdk_pixbuf-2.0 -lgio-2.0 -lgobject-2.0 -lglib-2.0 -lgtksourceview-3.0

gcc main.o secant_method.o -lgtk-3 -lgdk-3 -lpangocairo-1.0 -lpango-1.0 -lharfbuzz -latk-1.0 -lcairo-gobject -lcairo -lgdk_pixbuf-2.0 -lgio-2.0 -lgobject-2.0 -lglib-2.0 $(pkg-config --cflags --libs gtk+-3.0) -o app.exe -no-pie
