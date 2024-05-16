#!/bin/bash
gcc -c -masm=intel -fPIE main.c -o main.o
nasm -f elf64 strncpy.s -o strncpy.o
gcc -fPIE -z noexecstack main.o strncpy.o -o app.exe
./app.exe
