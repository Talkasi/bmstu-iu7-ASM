#include <stdio.h>
#include <math.h>

#define KNRM  "\x1B[0m"
#define KGRN  "\x1B[32m"
#define KWHT  "\x1B[37m"

#define MY_SIMPLE_PI 3.14
#define MY_SMART_PI  3.141596

double sin_pi();
double sin_half_pi();

int main()
{
    printf(KWHT "\nTesting PI: \n" KNRM);
    printf("LIB sin(%lf) = " KGRN "%23.20f" KNRM "\n", MY_SIMPLE_PI, sin(MY_SIMPLE_PI));
    printf("LIB sin(%lf) = " KGRN "%23.20f" KNRM "\n", MY_SMART_PI, sin(MY_SMART_PI));
    printf("LIB sin(M_PI) = " KGRN "%27.20f" KNRM "\n", sin(M_PI));
    printf("FPU sin(PI) = " KGRN "%29.20f" KNRM "\n", sin_pi());
    
    printf(KWHT "\nTesting PI / 2: \n" KNRM);
    printf("LIB sin(%lf / 2) = " KGRN "%23.20f" KNRM "\n", MY_SIMPLE_PI, sin(MY_SIMPLE_PI / 2));
    printf("LIB sin(%lf / 2) = " KGRN "%23.20f" KNRM "\n", MY_SMART_PI, sin(MY_SMART_PI / 2));
    printf("LIB sin(M_PI / 2) = " KGRN "%27.20f" KNRM "\n", sin(M_PI / 2));
    printf("FPU sin(PI / 2) = " KGRN "%29.20f" KNRM "\n", sin_half_pi());
    
    return 0;
}

double sin_pi()
{
    double res;

    __asm__("fldpi\n\t"
            "fsin\n\t"
            "fstp %0\n\t"
            : "=m" (res)
            );

    return res;
}

double sin_half_pi()
{
    double res;
    int divisor = 2;
    
    __asm__("fldpi\n\t"
            "fild %1\n\t"
            "fdivp\n\t"
            "fsin\n\t"
            "fstp %0\n\t"
            : "=m" (res)
            : "m" (divisor)
            );

    return res;
}
