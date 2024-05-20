#ifndef SECANT_METHOD
#define SECANT_METHOD

#include <stdlib.h>
#include <stdbool.h>

double func(double x);
double calc_new_border(double x0, double x1);
bool secant_method(double* x2, double x0, double x1, double eps, double max_iter);

#endif