# -m80387 - заставляет компилятор генерировать инструкции для операций с плавающей запятой
# -mno-80387 - заставляет компилятор генерировать инструкции, использующие библиотечные вызовы для операций с плавающей запятой

_MAKE_OUT_DIR_ := $(shell mkdir -p out)
_MAKE_ASM_DIR_ := $(shell mkdir -p assembly)
_MAKE_DISASM_DIR_ := $(shell mkdir -p disassembly)

.PHONY: mno_80387 m_80387 asm types sin clarification run assembly disassembly clean

mno_80387:
	gcc types.c -masm=intel -mno-80387 -O0 -o mno_80387.exe
	./mno_80387.exe

m_80387:
	gcc types.c -masm=intel -m80387 -O0 -o m_80387.exe
	./m_80387.exe

asm:
	@echo "ASM: "
	gcc types.c -masm=intel -O0 -o asm.exe
	./asm.exe

types: mno_80387 m_80387 asm

sin:
	gcc sin.c -masm=intel -o sin.exe
	./sin.exe

clarification:
	gcc root_clarification.c -masm=intel -O0 -o clarification.exe -lm
	./clarification.exe

run: types sin clarification

assembly:
	gcc -S types.c -mno-80387 -O0 -o assembly/mno_80387.s
	gcc -S types.c -m80387 -O0 -o assembly/m_80387.s
	gcc -S types.c -masm=intel -O0 -o assembly/asm.s
	gcc -S sin.c -masm=intel -o assembly/sin.s
	gcc -S root_clarification.c -madm=intel -O0 -o assembly/clarification.s

disassembly:
	gcc -c types.c -mno-80387 -O0 -o out/mno_80387.o
	gcc -c types.c -m80387 -O0 -o out/m_80387.o
	gcc -c types.c -masm=intel -O0 -o out/asm.o
	gcc -c sin.c -masm=intel -o out/sin.o
	gcc -c root_clarification.c -masm=intel -o out/clarification.o

	objdump -M intel-mnemonic -d out/mno_80387.o  > disassembly/mno_80387.s
	objdump -M intel-mnemonic -d out/m_80387.o  > disassembly/m_80387.s
	objdump -M intel-mnemonic -d out/asm.o  > disassembly/asm.s
	objdump -M intel-mnemonic -d out/sin.o  > disassembly/sin.s
	objdump -M intel-mnemonic -d out/clarification.o  > disassembly/clarification.s

clean:
	rm -rf out/* assembly/* disassembly/* *.exe