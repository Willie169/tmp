import numpy as np
import math
import matplotlib.pyplot as plt

def york_fit(x, y, ux, uy, r=None, tol=1e-12, max_iter=1000):
    x = np.asarray(x, dtype=float)
    y = np.asarray(y, dtype=float)
    ux = np.asarray(ux, dtype=float)
    uy = np.asarray(uy, dtype=float)

    if not (len(x) == len(y) == len(ux) == len(uy)):
        raise ValueError("x, y, ux, uy must have the same length.")
    if np.any(ux <= 0) or np.any(uy <= 0):
        raise ValueError("All uncertainties must be strictly positive.")

    n = len(x)

    if r is None:
        r = np.zeros(n, dtype=float)
    else:
        r = np.asarray(r, dtype=float)
        if len(r) != n:
            raise ValueError("r must have the same length as x, y, ux, uy.")
        if np.any(np.abs(r) > 1):
            raise ValueError("Each correlation coefficient must satisfy |r| <= 1.")

    m = np.polyfit(x, y, 1)[0]

    for _ in range(max_iter):
        wx = 1.0 / ux**2
        wy = 1.0 / uy**2
        alpha = np.sqrt(wx * wy)

        W = wx * wy / (wx + m**2 * wy - 2.0 * m * r * alpha)

        x_bar = np.sum(W * x) / np.sum(W)
        y_bar = np.sum(W * y) / np.sum(W)

        U = x - x_bar
        V = y - y_bar

        beta = W * (
            U / wy
            + m * V / wx
            - (m * U + V) * r / alpha
        )

        denom = np.sum(W * beta * U)
        if denom == 0:
            raise ZeroDivisionError("York iteration failed: denominator became zero.")

        m_new = np.sum(W * beta * V) / denom

        if np.abs(m_new - m) < tol:
            m = m_new
            break
        m = m_new
    else:
        raise RuntimeError("York regression did not converge within max_iter.")

    wx = 1.0 / ux**2
    wy = 1.0 / uy**2
    alpha = np.sqrt(wx * wy)
    W = wx * wy / (wx + m**2 * wy - 2.0 * m * r * alpha)

    x_bar = np.sum(W * x) / np.sum(W)
    y_bar = np.sum(W * y) / np.sum(W)
    b = y_bar - m * x_bar

    residuals = y - (m * x + b)
    chi2 = np.sum(W * residuals**2)
    red_chi2 = chi2 / (n - 2) if n > 2 else np.nan

    U = x - x_bar
    sigma_m = np.sqrt(1.0 / np.sum(W * U**2))
    sigma_b = np.sqrt(1.0 / np.sum(W) + x_bar**2 * sigma_m**2)
    cov_mb = -x_bar * sigma_m**2

    x_std = np.std(x, ddof=1)
    y_std = np.std(y, ddof=1)
    if x_std == 0 or y_std == 0:
        pearson = np.nan
    else:
        pearson = np.corrcoef(x, y)[0, 1]

    return {
        "m": m,
        "b": b,
        "um": sigma_m,
        "ub": sigma_b,
        "cov_mb": cov_mb,
        "chi2": chi2,
        "red_chi2": red_chi2,
        "r_xy": pearson
    }


def plot_york_fit(x, y, ux, uy, title, file, dpi_=300):
    x = np.asarray(x)
    y = np.asarray(y)
    res = york_fit(x, y, ux, uy)
    plt.errorbar(
        x, y,
        xerr=ux, yerr=uy,
        fmt='o', capsize=3,
        label="data"
    )
    x_line = np.linspace(np.min(x), np.max(x), 200)
    y_line = res["m"] * x_line + res["b"]
    plt.plot(x_line, y_line, '-', label="fit")
    plt.xlabel("x")
    plt.ylabel("y")
    plt.title(title)
    plt.grid(True, alpha=0.3)
    plt.legend()
    plt.tight_layout()
    plt.savefig(file, dpi=dpi_)
    plt.close()
    return res


def fuprint(i, a, b, digits=6):
    e = 0 if (a == 0) else int(math.ceil(math.log10(abs(a))))
    scale = 10 ** e
    fmt = f"{{:.{digits}f}}e{{:+02d}}"
    print(i + " = " + fmt.format(a / scale, e) + " ± " + fmt.format(b / scale, e))


def vprint(i, a, digits=6):
    e = 0 if (a == 0) else int(math.ceil(math.log10(abs(a)))-1)
    scale = 10 ** e
    fmt = f"{{:.{digits}f}}e{{:+02d}}"
    print(i + " = " + fmt.format(a / scale, e))


def compute(j, uj, x, y, ux, uy, title, file, scale=0.001, dpi_=300):
    res = plot_york_fit(x * scale, y * scale, ux * scale, uy * scale, title, file, dpi_)
    m, um = res["m"], res["um"]
    k = 0.005
    q = 1.6e-19
    R = m / (k * j)
    dR_dm = 1 / (k * j)
    dR_dj = -m / (k * j**2)
    uR = np.sqrt((dR_dm * um)**2 + (dR_dj * uj)**2)
    n = 1 / (q * abs(R))
    dn_dR = -1 / (q * R**2)
    un = np.abs(dn_dR) * uR
    res["R"], res["uR"], res["n"], res["un"] = R, uR, n, un
    print(title)
    fuprint("m", res["m"], res["um"])
    fuprint("b", res["b"], res["ub"])
    vprint("cov_mb", res["cov_mb"])
    vprint("chi2", res["chi2"])
    vprint("reduced_chi2", res["red_chi2"])
    print(f"r_xy = {res["r_xy"]:.6f}")
    fuprint("R_H", res["R"], res["uR"])
    fuprint("n", res["n"], res["un"])


compute(2004.4, 0.058, np.array([3.4429, 5.1473, 6.8518, 8.5562]), np.array([-0.46, -0.69, -0.92, -1.15]), np.array([0.0099, 0.0099, 0.0099, 0.0099]), np.array([0.0021, 0.0021, 0.0021, 0.0021]), "N semiconductor 10.022 mA", "N_semiconductor_10.022_mA_V_H_-_B_plot.png")
compute(4004, 0.058, np.array([3.4429, 5.1473, 6.8518, 8.5221]), np.array([-0.95, -1.38, -1.82, -2.255]), np.array([0.0099, 0.0099, 0.0099, 0.0099]), np.array([0.0021, 0.0021, 0.0021, 0.0021]), "N semiconductor 20.002 mA", "N_semiconductor_20.002_mA_V_H_-_B_plot.png")
compute(1991.8, 0.058, np.array([3.4429, 5.1133, 6.8518, 8.5562]), np.array([0.36, 0.545, 0.715, 0.895]), np.array([0.0099, 0.0099, 0.0099, 0.0099]), np.array([0.0021, 0.0021, 0.0021, 0.0021]), "P semiconductor 9.959 mA", "P_semiconductor_9.959_mA_V_H_-_B_plot.png")
compute(3995, 0.058, np.array([3.4429, 5.1133, 6.8518, 8.5562]), np.array([0.735, 1.085, 1.45, 1.805]), np.array([0.0099, 0.0099, 0.0099, 0.0099]), np.array([0.0021, 0.0021, 0.0021, 0.0021]), "P semiconductor 19.975 mA", "P_semiconductor_19.975_mA_V_H_-_B_plot.png")
