#include "matrix.hpp"
#include <iostream>

using namespace std;

int main(void) {
    size_t n_rows1;
    size_t n_middle; 
    size_t n_cols2;

    cout << "Enter number of rows and cows for the first matrix: ";
    cin >> n_rows1 >> n_middle;

    cout << "Enter number of cols for the second matrix: ";
    cin >> n_cols2;

    matrix_t mtx1 = alloc_matrix(n_rows1, n_middle);
    matrix_t mtx2 = alloc_matrix(n_middle, n_cols2);

    cout << "Enter first matrix: " << endl;
    scan_matrix(mtx1, n_rows1, n_middle);
    
    cout << "Enter second matrix: " << endl;
    scan_matrix(mtx2, n_middle, n_cols2);

    matrix_t res = mul_matrices(mtx1, mtx2, n_rows1, n_middle, n_cols2);

    cout << "Result: " << endl;
    print_matrix(res, n_rows1, n_cols2);

    return 0;
}