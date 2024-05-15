#include "matrix.hpp"
#include <iostream>

int scan_matrix(matrix_t matrix, size_t n_rows, size_t n_cols)
{
    for (size_t i = 0; i < n_rows; ++i)
        for (size_t j = 0; j < n_cols; ++j)
            std::cin >> matrix[i][j];

    return 1;
}

void print_matrix(matrix_t matrix, size_t n_rows, size_t n_cols)
{
    for (size_t i = 0; i < n_rows; ++i) {
        for (size_t j = 0; j < n_cols; ++j)
            std::cout << matrix[i][j] << "\t";

        matrix[i][n_cols] = 0;
        std::cout << std::endl;
    }
}

matrix_t alloc_matrix(size_t n_rows, size_t n_cols)
{
    matrix_t res = new double*[n_rows];
    for (size_t i = 0; i < n_rows; ++i)
        res[i] = new double[n_cols + 1];

    return res;
}

matrix_t transpose(matrix_t matrix, size_t n_rows, size_t n_cols)
{
    matrix_t res = alloc_matrix(n_cols, n_rows);

    for (size_t i = 0; i < n_rows; ++i)
        for (size_t j = 0; j < n_cols; ++j)
            res[j][i] = matrix[i][j];

    return res;
}

matrix_t mul_matrices(matrix_t mtx1, matrix_t mtx2, size_t n_rows1, size_t n_middle, size_t n_cols2)
{
    matrix_t res = alloc_matrix(n_rows1, n_cols2);
    matrix_t transposed_mtx2 = transpose(mtx2, n_middle, n_cols2);

    for (size_t i = 0; i < n_rows1; ++i)
        for (size_t j = 0; j < n_cols2; ++j)
            res[i][j] = mul_cells(&mtx1[i][0], &transposed_mtx2[j][0], n_middle);

    return res;
}

double mul_cells(double *mtx1, double *mtx2, size_t n)
{
    __float128 *p1 = (__float128 *)(mtx1);
    __float128 *p2 = (__float128 *)(mtx2);
    size_t step = sizeof(__float128) / sizeof(double);
    double res = 0;
    double tmp = 0;

    for (size_t i = 0; i < n; i += step, ++p1, ++p2) {
        __asm__ __volatile__ (
            "movapd xmm0, %1\n\t"
            "movapd xmm1, %2\n\t"
            "mulpd  xmm0, xmm1\n\t"
            "haddpd xmm0, xmm0\n\t"
            "movsd  %0, xmm0\n\t"
            : "=m"(tmp)
            : "m"(*p1), "m"(*p2)
            : "xmm0", "xmm1"
        );

        res += tmp;
    }

    return res;
}
