#include <stdio.h>
#include <math.h>

double f_c(double x);
double clarification_c(double x_prev, double x_curr, double e);

double f_asm(double x);
double clarification_asm(double x_prev, double x_curr, double e);

double findRoot_с(double a, double b, double epsilon);

int main()
{
    double x;
    double x0;
    double x1;
    double e;

    printf("Enter the first x: ");
    scanf("%lf", &x0);

    printf("Enter the second x: ");
    scanf("%lf", &x1);

    printf("Enter e: ");
    scanf("%lf", &e);

    // double x = clarification_c(x0, x1, e);
    // printf("С Answer: %lf\n", x);

    x = findRoot_с(x0, x1, e);
    printf("ASM Answer: %lf\n", x);

    // x = clarification_asm(x0, x1, e);
    // printf("ASM Answer: %lf\n", x);

    return 0;
}

double f_c(double x)
{
    // return 2 * sin(x * x - 5);
    return sin(x * x + 5 * x);
}

double findRoot_с(double a, double b, double epsilon)
{
    while(fabs(b - a) > epsilon) {
        a = a - (b - a) * f_c(a) / (f_c(b) - f_c(a));
        b = b - (a - b) * f_c(b) / (f_c(a) - f_c(b));
    }

    return b;
}

double clarification_c(double x_prev, double x_curr, double e)
{
    double x_next = 0;
    double tmp;
 
    do
    {
        tmp = x_next;
        x_next = x_curr - f_c(x_curr) * (x_prev - x_curr) / (f_c(x_prev) - f_c(x_curr));
        x_prev = x_curr;
        x_curr = tmp;
    } while (fabs(x_next - x_curr) > e);
 
    return x_next;
}

double f_asm(double x)
{
    double res;
    double five = 5;
    double two = 2;

    // 2 * sin(x * x - 5)
    __asm__("fld %1\n"
            "fld %1\n"
            "fmulp\n" // x * x

            "fld %2\n"
            "fsubp st(1), st(0)\n" // x * x - 5

            "fsin\n" // sin(x * x - 5)

            "fld %3\n"
            "fmulp st(1), st(0)\n" // 2 * sin(x * x - 5)

            "fstp %0\n"
            : "=m"(res)
            : "m"(x), "m"(five), "m"(two)
            );

    return res;
}

double clarification_asm(double x_prev, double x_curr, double e)
{
    double x_next = 0;
    double tmp;
 
    do
    {
        // tmp = x_next;
        // x_next = x_curr - f_asm(x_curr) * (x_prev - x_curr) / (f_asm(x_prev) - f_asm(x_curr));
        // x_prev = x_curr;
        // x_curr = tmp;
        double f_x_cur = f_asm(x_curr);
        double f_x_prev = f_asm(x_prev);

        __asm__("push %0\n"

                "fld %2\n"

                "fld %3\n"

                "fld %1\n"
                "fld %2\n"

                "fsubp\n"

                "fmulp\n"

                "fld %4\n"

                "fld %3\n"

                "fsubp\n"
                "fdivp\n"
                "fsubp\n"

                "fstp %0\n"

                "fld %2\n"
                "fstp %1\n"

                "pop %2\n"
                : "=m"(x_next), "=m"(x_prev), "=m"(x_curr)
                : "m"(f_x_cur), "m"(f_x_prev)
                );

    } while (fabs(x_next - x_curr) > e);
 
    return x_next;
}