#include <stdio.h>

#define MAX_STR_LEN 100

extern void strncpyAsm(char *dst, char *src, int len);

int main() {
	char dst[500] = "                This is a marve!";
	char *src = dst + 16;
	int shift = -7;

	int len = 0;

	__asm__ __volatile__ (  
		"lea %%rdi, [%1]\n\t"
		"mov %%ecx, 100\n\t"
		"xor %%eax, %%eax\n\t"
		"cld\n\t"
		"repne scasb\n\t"
		"mov %%eax, 99\n\t"
		"sub %%eax, %%ecx\n\t"
		"mov %0, %%eax\n\t"
		: "=r" (len) 
		: "r" (src)
		: "ecx", "eax", "rdi"
	);

	printf("Before the function:\n");
	printf("String length: %d\n", len);
	printf("Source string: %s\n", src);

	strncpyAsm(src + shift, src, len);

	printf("After the function:\n");
	printf("Source string: %s\n", src);
	printf("Destination string: %s\n", src + shift);

	return 0;
}
