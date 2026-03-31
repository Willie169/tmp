import numpy as np
import matplotlib.pyplot as plt

I_up = np.arange(0, 3.4, 0.2)  # 0 to 3.2
I_down = np.arange(3.0, -3.4, -0.2)  # 3.0 to -3.2
I_back = np.arange(-3.0, 3.2, 0.2)   # -3.0 to 0
I = np.concatenate([I_up, I_down, I_back])

# Theta array (degrees)
theta = np.array([0,12,23,32,41,48,52,57,60,63,65,68,70,71,72,73,74,73,73,73,72,71,70,
                  69,68,66,63,60,55,51,43,24,23,4,-18,-41,-56,-64,-69,-72,-75,-76,-78,
                  -79,-80,-82,-82,-82,-82,-82,-82,-81,-80,-80,-79,-78,-78,-77,-75,-73,
                  -70,-66,-59,-47,-26,-4,14,26,38,45,50,56,60,62,64,68,70,71,72,73])

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
plt.title('Scatter Plot of tan(theta) vs I(A) iron')
plt.grid(True)
plt.legend()
plt.tight_layout()

plt.savefig('Iron tan_theta_vs_I.png', dpi=300)
