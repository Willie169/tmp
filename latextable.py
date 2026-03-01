#!/usr/bin/env python3
import sys
import re

def transpose_latex_table(table: str) -> str:
    # Remove \hline commands
    table = re.sub(r'\\hline', '', table)

    # Split on LaTeX row separators (\\)
    rows = re.split(r'\\\\', table.strip())
    rows = [row.strip() for row in rows if row.strip()]

    # Parse cells
    matrix = [
        [cell.strip() for cell in row.split('&')]
        for row in rows
    ]

    # Validate rectangular matrix
    if len({len(row) for row in matrix}) != 1:
        raise ValueError("Table rows have different numbers of columns")

    # Transpose
    transposed = zip(*matrix)

    # Reconstruct
    return '\n'.join(
        ' & '.join(row) + r' \\\hline'
        for row in transposed
    )


if __name__ == "__main__":
    print(transpose_latex_table(sys.stdin.read()))