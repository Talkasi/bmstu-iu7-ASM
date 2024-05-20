#include <math.h>
#include "secant_method.h"
#include "stdio.h"

double f_asm(double x) {
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

extern double result;
bool secant_method(double *res, double x_prev, double x_curr, double e, double max_iter)
{
    printf("%lf %lf %lf %lf\n", x_prev, x_curr, e, max_iter);

    double x_next = 0;
    double tmp;
    int iter = 0;
 
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

        ++iter;
        printf("%d ", iter);
        if (iter >= max_iter) {
            printf("\n");
            return 0;
        }

    } while (fabs(x_next - x_curr) > e);
    
    *res = x_next;
    result = *res;
    printf("\n\n%lf\n", *res);

    return 1;
}
