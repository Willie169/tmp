import numpy as np
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
        "r_xy": pearson,
        "x_bar": x_bar,
        "y_bar": y_bar,
        "W": W,
        "residuals": residuals,
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
    print(title)
    print("m  =", res["m"])
    print("um =", res["um"])
    print("b  =", res["b"])
    print("ub =", res["ub"])
