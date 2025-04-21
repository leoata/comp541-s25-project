#!/usr/bin/env python3
"""
generate_bmem.py

Scans the current directory for files named with a leading index,
e.g., "0_A.txt", "1_S.txt", etc. Sorts them by that numeric index
and concatenates their contents (the 256-line bitmaps) into a single
master file called "bmem.mem".
"""

import os

def main():
    # Gather all .txt files in the directory
    txt_files = [fn for fn in os.listdir('.') if fn.endswith('.txt')]

    # Extract (index, filename) pairs based on the part before the underscore
    indexed_files = []
    for fn in txt_files:
        parts = fn.split('_', 1)
        if len(parts) != 2:
            continue
        idx_str, _ = parts
        try:
            idx = int(idx_str)
        except ValueError:
            continue
        indexed_files.append((idx, fn))

    # Sort by the numeric index
    indexed_files.sort(key=lambda x: x[0])

    # Create or overwrite the master bmem.mem
    with open('bmem.mem', 'w') as out:
        for idx, fn in indexed_files:
            with open(fn, 'r') as src:
                txt = src.read()
                if not txt.endswith('\n'):
                    txt+='\n'
                out.write(txt)

    print(f"Wrote {len(indexed_files)} bitmaps to bmem.mem")

if __name__ == '__main__':
    main()

