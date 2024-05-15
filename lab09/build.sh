#!/bin/bash

g++ -std=c++11 -O0 -g3 -Wall -Wextra -Werror -masm=intel -m64 -fPIE -fno-inline *.cpp -o app.exe
./app.exe