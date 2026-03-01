import numpy as np
import pandas as pd
from typing import Tuple, List, Dict
import math
import csv

def ceil_to(x, digits=0):
    factor = 10 ** digits
    return math.ceil(x * factor) / factor

def round_to_uncertainty(value: float, uncertainty: float) -> float:
    if uncertainty <= 0 or not np.isfinite(uncertainty):
        return value

    exponent = int(np.floor(np.log10(abs(uncertainty))))
    first_digit = int(abs(uncertainty) / 10**exponent)
    sig = 2 if first_digit in (1, 2) else 1
    digits = sig - 1 - exponent
    return round(value, ndigits)

def ceil_to_uncertainty(value: float, uncertainty: float) -> float:
    if uncertainty <= 0 or not np.isfinite(uncertainty):
        return value

    exponent = int(np.floor(np.log10(abs(uncertainty))))
    first_digit = int(abs(uncertainty) / 10**exponent)
    sig = 2 if first_digit in (1, 2) else 1
    digits = sig - 1 - exponent
    return ceil_to(value, digits)

def calculate_type_a_uncertainty(measurements: np.ndarray) -> Tuple[float, float]:
    n = len(measurements)
    mean = np.mean(measurements)

    if n >= 2:
        s_y = np.std(measurements, ddof=1)
        u_A = s_y / np.sqrt(n)
    else:
        u_A = 0.0

    return mean, u_A

def combine_uncertainties(u_A: float, u_B: float) -> float:
    return np.sqrt(u_A * u_A + u_B * u_B)

def weighted_linear_regression(
    x: np.ndarray,
    y: np.ndarray,
    u: np.ndarray
) -> Dict[str, float]:
    w = 1.0 / (u * u)

    S = np.sum(w)
    Sx = np.sum(w * x)
    Sy = np.sum(w * y)
    Sxx = np.sum(w * x * x)
    Sxy = np.sum(w * x * y)

    delta = S * Sxx - Sx ** 2

    if np.abs(delta) < 1e-15:
        raise ValueError(
            f"Degenerate fit: delta = {delta:.2e}. "
            "Check for duplicate x-values with zero uncertainty or insufficient data points."
        )

    slope = (S * Sxy - Sx * Sy) / delta
    intercept = (Sxx * Sy - Sx * Sxy) / delta

    slope_unc = np.sqrt(S / delta)
    intercept_unc = np.sqrt(Sxx / delta)

    return {
        'slope': slope,
        'intercept': intercept,
        'slope_unc': slope_unc,
        'intercept_unc': intercept_unc,
        'delta': delta
    }

def calculate_goodness_of_fit(
    x: np.ndarray,
    y: np.ndarray,
    u: np.ndarray,
    slope: float,
    intercept: float
) -> Dict[str, float]:
    w = 1.0 / (u ** 2)
    y_pred = slope * x + intercept

    residuals = y - y_pred

    y_mean = np.sum(w * y) / np.sum(w)

    ss_tot = np.sum(w * (y - y_mean) ** 2)

    ss_res = np.sum(w * residuals ** 2)

    r2 = 1 - (ss_res / ss_tot) if ss_tot > 0 else 0.0

    x_mean = np.sum(w * x) / np.sum(w)
    cov_xy = np.sum(w * (x - x_mean) * (y - y_mean))
    var_x = np.sum(w * (x - x_mean) ** 2)
    var_y = np.sum(w * (y - y_mean) ** 2)

    pcc = cov_xy / np.sqrt(var_x * var_y) if var_x > 0 and var_y > 0 else 0.0

    chi2 = np.sum((residuals / u) ** 2)
    n_points = len(x)
    n_params = 2

    dof = n_points - n_params

    reduced_chi2 = chi2 / dof if dof > 0 else np.inf

    return {
        'r2': r2,
        'pcc': pcc,
        'chi2': chi2,
        'reduced_chi2': reduced_chi2,
        'dof': dof
    }

def process_data(
    input_file: str = 'raw_data.csv',
    output_file: str = 'processed_data.csv'
) -> pd.DataFrame:
    try:
        with open(input_file, 'r', newline='') as f:
            reader = csv.reader(f)
            rows = list(reader)
    except FileNotFoundError:
        raise FileNotFoundError(f"Input file '{input_file}' not found.")

    if not rows:
        raise ValueError("Input file is empty")

    y0 = float(rows[0][0])
    u_by = float(rows[0][1])

    data_rows = []
    computed_stats = []

    for row in rows[1:]:
        if not row or all(cell.strip() == '' for cell in row):
            continue

        x = float(row[0])

        y_values = [float(cell) for cell in row[1:] if cell.strip() != '']
        y_measurements = np.array(y_values)

        if len(y_measurements) == 0:
            continue

        y_bar, u_A = calculate_type_a_uncertainty(y_measurements)
        y_corrected = y_bar - y0

        u_combined = combine_uncertainties(u_A, u_by)

        if len(y_measurements) >= 2:
            s_y = np.std(y_measurements, ddof=1)
        else:
            s_y = 0.0

        data_rows.append({
            'x': x,
            'measurements': y_measurements,
            'n_repeats': len(y_measurements)
        })

        computed_stats.append({
            'y_bar': y_bar,
            'y_bar_minus_y0': y_corrected,
            's_y': s_y,
            'u_A': u_A,
            'u': u_combined
        })

    if len(data_rows) < 2:
        raise ValueError(
            f"Need at least two data points for linear regression, got {len(data_rows)}"
        )

    max_measurements = max(len(row['measurements']) for row in data_rows)

    x_vals = np.array([r['x'] for r in data_rows])
    y_vals = np.array([s['y_bar_minus_y0'] for s in computed_stats])
    u_vals = np.array([s['u'] for s in computed_stats])

    fit_results = weighted_linear_regression(x_vals, y_vals, u_vals)

    gof = calculate_goodness_of_fit(
        x_vals, y_vals, u_vals,
        fit_results['slope'], fit_results['intercept']
    )

    output_data = []
    for i, (row, stats) in enumerate(zip(data_rows, computed_stats)):

        y_bar_rounded = round_to_uncertainty(stats['y_bar'], stats['u'])
        y_corr_rounded = round_to_uncertainty(stats['y_bar_minus_y0'], stats['u'])
        s_y_rounded = ceil_to_uncertainty(stats['s_y'], stats['s_y']) if stats['s_y'] > 0 else 0
        u_A_rounded = ceil_to_uncertainty(stats['u_A'], stats['u_A']) if stats['u_A'] > 0 else 0
        u_rounded = ceil_to_uncertainty(stats['u'], stats['u'])

        out_row = {
            'x': row['x'],
            'measurements': [f"{v:.6g}" for v in row['measurements']] + [''] * (max_measurements - len(row['measurements'])),
            'n_repeats': row['n_repeats'],
            'y_bar': y_bar_rounded,
            'y_bar_minus_y0': y_corr_rounded,
            's_y': s_y_rounded,
            'u_A': u_A_rounded,
            'u_combined': u_rounded
        }
        output_data.append(out_row)

    results_df = pd.DataFrame(output_data)

    with open(output_file, 'w', newline='') as f:
        writer = csv.writer(f)

        writer.writerow([y0, u_by])

        for _, row in results_df.iterrows():
            writer.writerow([
                row['x'], *row['measurements'], row['n_repeats'],
                row['y_bar'], row['y_bar_minus_y0'],
                row['s_y'], row['u_A'], row['u_combined']
            ])

        writer.writerow([])

        m_rounded = round_to_uncertainty(fit_results['slope'], fit_results['slope_unc'])
        um_rounded = ceil_to_uncertainty(fit_results['slope_unc'], fit_results['slope_unc'])
        writer.writerow(['Slope', m_rounded, 'uncertainty', um_rounded])

        b_rounded = round_to_uncertainty(fit_results['intercept'], fit_results['intercept_unc'])
        ub_rounded = ceil_to_uncertainty(fit_results['intercept_unc'], fit_results['intercept_unc'])
        writer.writerow(['Intercept', b_rounded, 'uncertainty', ub_rounded])

        writer.writerow([])
        writer.writerow(['R2', gof['r2']])
        writer.writerow(['PCC', gof['pcc']])
        writer.writerow(['chi2', gof['chi2']])
        writer.writerow(['Reduced_chi2', gof['reduced_chi2']])
        writer.writerow(['Degrees_of_freedom', gof['dof']])

    with open(output_file, 'r') as g:
        print(g.read(), end = '')

    return results_df


if __name__ == '__main__':
    process_data('raw_data.csv', 'processed_data.csv')
