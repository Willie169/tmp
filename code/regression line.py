import numpy as np

def calculate_regression_line(x, y):
    n = len(x)
    x_mean = np.mean(x)
    y_mean = np.mean(y)
    
    # Calculate the numerator and denominator for the slope (m)
    numerator = np.sum((x - x_mean) * (y - y_mean))
    denominator = np.sum((x - x_mean) ** 2)
    
    # Calculate slope (m) and intercept (b)
    slope = numerator / denominator
    intercept = y_mean - slope * x_mean
    
    return slope, intercept

# Example usage
x = np.array([1, 2, 3, 4, 5])
y = np.array([2, 4, 5, 4, 5])

slope, intercept = calculate_regression_line(x, y)
equation = f"y = {slope}x + {intercept}"
print(f"Equation of the regression line: {equation}")