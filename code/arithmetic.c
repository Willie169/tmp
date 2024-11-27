#include <stdio.h>

int add(int a, int b) {
    int carry;
    while (b != 0) {
        carry = a & b;     
        a = a ^ b;         
        b = carry << 1;    
    }
    return a;
}

int negate(int x) {
    return add(~x, 1); 
}

int subtract(int a, int b) {
    return add(a, negate(b)); 
}

int multiply(int a, int b) {
    int result = 0;
    while (b != 0) {
        if (b & 1) {
            result = add(result, a); 
        }
        a <<= 1; 
        b >>= 1; 
    }
    return result;
}

int divide(int a, int b) {
    int quotient = 0;
    int remainder = a;
    while (remainder >= b) {
        int temp = b;
        int multiple = 1;
        while ((temp << 1) <= remainder) {
            temp <<= 1;
            multiple <<= 1;
        }
        remainder = subtract(remainder, temp);
        quotient = add(quotient, multiple);
    }
    return quotient;
}
