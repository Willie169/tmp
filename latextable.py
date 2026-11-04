#!/usr/bin/env python3
import sys

def transpose_latex_table(table: str) -> str:
    # Split into rows
    rows = [
        row.strip()
        for row in table.strip().split(r"\\")
        if row.strip()
    ]

    # Parse cells
    matrix = [
        [cell.strip() for cell in row.replace(r"\hline", "").split("&")]
        for row in rows
    ]

    # Transpose
    transposed = zip(*matrix)

    # Reconstruct LaTeX
    return "\n".join(
        " & ".join(row) + r" \\\hline"
        for row in transposed
    )


if __name__ == "__main__":
    table = sys.stdin.read()
    print(transpose_latex_table(table))
