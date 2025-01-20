#ifndef MATRIX_H
#define MATRIX_H

#include <iostream>
#include <vector>
#include <cassert>
#include <functional>
#include <cmath>
#include <algorithm>

using namespace std;

class matrix {
public:
    int rows;
    int cols;
    vector<double> vals;

    matrix(int _rows, int _cols) {
        rows = _rows;
        cols = _cols;
        vals.resize(cols * rows, 0);
    }

    matrix() {
        rows = 0;
        cols = 0;
        vals = {};
    }

    matrix dot(matrix a) {
        assert(cols == a.rows);
        if (cols != a.rows) cout << "dot error" << endl;
        matrix temp(rows, a.cols);
        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < a.cols; j++) {
                for (int k = 0; k < a.rows; k++) {
                    double mult = vals[i * cols + k] * a.vals[k * a.cols + j];
                    temp.vals[i * a.cols + j] += mult;
                }
            }
        }
        return temp;
    }

    matrix transpose() {
        matrix temp(cols, rows);
        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < cols; j++) {
                temp.vals[j * rows + i] = vals[i * cols + j];
            }
        }
        return temp;
    }

    matrix add(matrix a) {
        assert(a.rows == rows && a.cols == cols);
        matrix temp(rows, cols);
        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < cols; j++) {
                temp.vals[i * cols + j] = vals[i * cols + j] + a.vals[i * cols + j];
            }
        }
        return temp;
    }

    matrix minus(matrix a) {
        assert(a.rows == rows && a.cols == cols);
        matrix temp(rows, cols);
        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < cols; j++) {
                temp.vals[i * cols + j] = vals[i * cols + j] - a.vals[i * cols + j];
            }
        }
        return temp;
    }

    matrix multiply_scalar(double x) {
        matrix temp(rows, cols);
        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < cols; j++) {
                temp.vals[i * cols + j] = vals[i * cols + j] * x;
            }
        }
        return temp;
    }

    matrix element_add(double x) {
        matrix temp(rows, cols);
        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < cols; j++) {
                temp.vals[i * cols + j] = vals[i * cols + j] + x;
            }
        }
        return temp;
    }

    matrix multiply_element(matrix a) {
        assert(a.rows == rows && a.cols == cols);
        matrix temp(rows, cols);
        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < cols; j++) {
                temp.vals[i * cols + j] = vals[i * cols + j] * a.vals[i * cols + j];
            }
        }
        return temp;
    }

    matrix negative() {
        matrix temp(rows, cols);
        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < cols; j++) {
                temp.vals[i * cols + j] = -vals[i * cols + j];
            }
        }
        return temp;
    }

    matrix apply_func(function<double(const double&)> func) {
        matrix temp(rows, cols);
        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < cols; j++) {
                temp.vals[i * cols + j] = func(vals[i * cols + j]);
            }
        }
        return temp;
    }

    double mean() const {
        double sum = 0.0;
        int num = rows * cols;
        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < cols; j++) {
                sum += vals[i * cols + j];
            }
        }
        return sum / (double)num;
    }
};

#endif
