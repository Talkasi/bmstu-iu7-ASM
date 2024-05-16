#include <stdio.h>


int main() {
	unsigned n = 0x80;
	signed int new_n = (char)n;

	printf("%d", new_n);
}