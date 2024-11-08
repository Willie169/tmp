import numpy as np
import matplotlib.pyplot as plt
from math import floor, log

# Define the function f(x)
def f(x):
    summation = sum(1/i for i in range(1, floor(x) + 1))  # Sum of sequence
    return summation - log(x)  # Subtract ln(x)

# Generate x values and corresponding f(x) values
x_vals = np.linspace(1, 100, 1000000)  # Start from 1 to avoid log(0)
y_vals = [f(x) for x in x_vals]

# Plotting the function
plt.figure(figsize=(8, 6))
plt.plot(x_vals, y_vals, label=r'$f(x)=\sum_{i=1}^{\lfloor x \rfloor} \frac{1}{i} - \ln(x)$')
plt.xlabel('x')
plt.ylabel('f(x)')
plt.title('Plot of f(x)')
plt.legend()
plt.grid(True)
plt.show()