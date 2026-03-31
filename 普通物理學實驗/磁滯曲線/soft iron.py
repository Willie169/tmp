import numpy as np
import matplotlib.pyplot as plt

I_up = np.arange(0, 3.4, 0.2)  # 0 to 3.2
I_down = np.arange(3.0, -3.4, -0.2)  # 3.0 to -3.2
I_back = np.arange(-3.0, 3.2, 0.2)   # -3.0 to 0
I = np.concatenate([I_up, I_down, I_back])

# Theta array (degrees)
theta = np.array([0,14,25,34,42,48,53,57,60,62,64,67,68,69,71,72,73,72,71,70,69,68,66,
                  64,62,58,54,50,46,38,30,19,6,-6,-22,-48,-59,-65,-69,-72,-74,-75,-77,
                  -79,-79,-80,-80,-81,-81,-81,-81,-80,-79,-78,-78,-77,-76,-73,-72,-68,
                  -64,-56,-42,-24,8,10,23,32,40,46,52,55,58,62,64,66,68,69,71,72])

assert len(I) == len(theta), "I and theta must have the same length"

theta_rad = np.radians(theta)

tan_theta = np.tan(theta_rad)
theta_err_deg = 2.0
theta_err_rad = np.radians(theta_err_deg)
tan_theta_err = theta_err_rad / np.cos(theta_rad)**2

I_err = 0.01 * np.ones_like(I)

plt.figure(figsize=(8,5))
plt.errorbar(tan_theta, I, xerr=tan_theta_err, yerr=I_err, fmt='o', ecolor='red', capsize=3, label='Data')
plt.xlabel('tan(theta)')
plt.ylabel('I (A)')
plt.title('Scatter Plot of tan(theta) vs I(A) of soft iron')
plt.grid(True)
plt.legend()
plt.tight_layout()

plt.savefig('Soft iron tan_theta_vs_I.png', dpi=300)
