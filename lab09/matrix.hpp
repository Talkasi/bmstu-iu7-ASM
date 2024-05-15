#ifndef MATRIX_HPP
#define MATRIX_HPP
#include <cstdlib>
#include <memory>

using matrix_t = double **;

int scan_matrix(matrix_t matrix, size_t n_rows, size_t n_cols);
void print_matrix(matrix_t matrix, size_t n_rows, size_t n_cols);

matrix_t alloc_matrix(size_t n_rows, size_t n_cols);
matrix_t transpose_matrix(matrix_t matrix, size_t n_rows, size_t n_cols);

matrix_t mul_matrices(matrix_t mtx1, matrix_t mtx2, size_t n_rows1, size_t n_middle, size_t n_cols2);
double mul_cells(double *mtx1, double *mtx2, size_t n);

#endif // MATRIX_HPP
