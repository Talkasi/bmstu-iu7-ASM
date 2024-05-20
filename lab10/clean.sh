#!/bin/bash

junk_files="./*.exe *.o *.gcno *.gcda *.gcov"
# Проверить, существует ли файл
for el in $junk_files;
do
    if [[ -f $el ]]; then
        rm "$el"
    fi
done