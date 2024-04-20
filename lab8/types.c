#include <stdio.h>
#include <inttypes.h>

#define KNRM  "\x1B[0m"
#define KGRN  "\x1B[32m"
#define KWHT  "\x1B[37m"

#define N_TESTS 1

uint64_t rdtsc();
void float_time_mesurement_c(int n_tests, float a, float b);
void float_time_mesurement_asm(int times, float a, float b);
void double_time_mesurement_c(int n_tests, double a, double b);
void double_time_mesurement_asm(int times, double a, double b);

int main()
{
    double a = -239999984.4352, b = 232999983.14234443;

    float_time_mesurement_c(N_TESTS, a, b);
    float_time_mesurement_asm(N_TESTS, a, b);
    double_time_mesurement_c(N_TESTS, a, b);
    double_time_mesurement_asm(N_TESTS, a, b);

    return 0;
}

/* Read timestamp counter */
uint64_t rdtsc()
{
   uint32_t hi, lo;
   __asm__ __volatile__ ("rdtsc" : "=a"(lo), "=d"(hi));
   return ((uint64_t)lo) | (((uint64_t)hi) << 32);
}

void float_time_mesurement_c(int n_tests, float a, float b)
{
    printf(KWHT "C Float time measurement:\n" KNRM);
    float res;

    uint64_t start;
    uint64_t time_sum = 0;
    for (size_t i = 0; i < n_tests; ++i) {
        start = rdtsc();
        res = a + b;
        time_sum += rdtsc() - start;
    }
    printf(KGRN "Float sum: %f\n" KNRM, res);

    uint64_t time_mul = 0;
    for (size_t i = 0; i < n_tests; ++i) {
        start = rdtsc();
        res = a * b;
        time_mul += rdtsc() - start;
    }
    printf(KGRN "Float mul: %f\n" KNRM, res);

    printf("Sum: %" PRIu64 "\n"
           "Mul: %" PRIu64 "\n", time_sum, time_mul);
}

void double_time_mesurement_c(int n_tests, double a, double b)
{
    printf(KWHT "C Double time measurement:\n" KNRM);
    double res;

    uint64_t start;
    uint64_t time_sum = 0;
    for (size_t i = 0; i < n_tests; ++i) {
        start = rdtsc();
        res = a + b;
        time_sum += rdtsc() - start;
    }
    printf(KGRN "Double sum: %lf\n" KNRM, res);

    uint64_t time_mul = 0;
    for (size_t i = 0; i < n_tests; ++i) {
        start = rdtsc();
        res = a * b;
        time_mul += rdtsc() - start;
    }
    printf(KGRN "Double mul: %lf\n" KNRM, res);

    printf("Sum: %" PRIu64 "\n"
           "Mul: %" PRIu64 "\n", time_sum, time_mul);
}


void float_time_mesurement_asm(int times, float a, float b)
{
    printf(KWHT "ASM Float time measurement:\n" KNRM);
    float res;

    uint64_t start;
    uint64_t time_sum = 0;
    for (size_t i = 0; i < times; ++i) {
        start = rdtsc();
        __asm__("fld %1\n"
                "fld %2\n"
                "faddp\n"
                "fstp %0\n"
                : "=m"(res)
                : "m"(a), "m"(b)
                );
        time_sum += rdtsc() - start;
    }
    printf(KGRN "Float sum: %f\n" KNRM, res);

    uint64_t time_mul = 0;
    for (size_t i = 0; i < times; ++i) {
        start = rdtsc();
        __asm__("fld %1\n"
                "fld %2\n"
                "fmulp\n"
                "fstp %0\n"
                : "=m"(res)
                : "m"(a), "m"(b)
                );
        time_mul += rdtsc() - start;
    }
    printf(KGRN "Float mul: %f\n" KNRM, res);

    printf("Sum: %" PRIu64 "\n"
           "Mul: %" PRIu64 "\n", time_sum, time_mul);
}

void double_time_mesurement_asm(int times, double a, double b)
{
    printf(KWHT "ASM Double time measurement:\n" KNRM);
    double res;

    uint64_t start;
    uint64_t time_sum = 0;
    for (size_t i = 0; i < times; ++i) {
        start = rdtsc();
        __asm__("fld %1\n"
                "fld %2\n"
                "faddp\n"
                "fstp %0\n"
                : "=m"(res)
                : "m"(a), "m"(b)
                );
        time_sum += rdtsc() - start;
    }
    printf(KGRN "Double sum: %lf\n" KNRM, res);

    uint64_t time_mul = 0;
    for (size_t i = 0; i < times; ++i) {
        start = rdtsc();
        __asm__("fld %1\n"
                "fld %2\n"
                "fmulp\n"
                "fstp %0\n"
                : "=m"(res)
                : "m"(a), "m"(b)
                );
        time_mul += rdtsc() - start;
    }
    printf(KGRN "Double mul: %lf\n" KNRM, res);

    printf("Sum: %" PRIu64 "\n"
           "Mul: %" PRIu64 "\n", time_sum, time_mul);
}
