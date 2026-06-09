#!/usr/bin/env python3
"""
Inspect whether ctx9 tail mismatches are inherited from ctx8 MaxPool tail.

Usage after running prefix TB with RUN_CTX_COUNT=8:
  python inspect_ctx8_to_ctx9_tail.py --dir "D:/HOC_TAP/KLTN/My_Proj/Advance_ECG/Model in C++/gen_mem"

It checks ctx8 output indices that feed ctx9 Conv1D_7 output idx 318/319:
  ctx9 input k=6, y=158/159 -> ctx8 output idx = 6*160 + 158/159 = 1118/1119

It does not write any files.
"""

from __future__ import annotations
import argparse
from pathlib import Path

def parse_hex16(line: str):
    line = line.strip()
    if not line:
        return None
    tok = line.split("_")[-1]
    try:
        v = int(tok, 16) & 0xFFFF
    except ValueError:
        return None
    return v - 0x10000 if (v & 0x8000) else v

def read_hex(path: Path):
    if not path.exists():
        raise FileNotFoundError(path)
    vals = []
    with path.open("r", encoding="utf-8", errors="ignore") as f:
        for line in f:
            v = parse_hex16(line)
            if v is not None:
                vals.append(v)
    return vals

def h4(x: int):
    return f"{x & 0xFFFF:04x}"

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--dir", default=".", help="gen_mem folder")
    ap.add_argument("--rtl", default="output.txt", help="ctx8 RTL dump after RUN_CTX_COUNT=8")
    ap.add_argument("--golden", default="Golden_ctx08_Max_Pool1D_1_hex.txt")
    args = ap.parse_args()

    d = Path(args.dir).resolve()
    rtl = read_hex(d / args.rtl)
    golden = read_hex(d / args.golden)

    print("=" * 78)
    print("CTX8 -> CTX9 TAIL DEPENDENCY INSPECT")
    print("=" * 78)
    print(f"RTL ctx8 file   : {d / args.rtl}")
    print(f"Golden ctx8 file: {d / args.golden}")
    print(f"length          : rtl={len(rtl)} golden={len(golden)}")
    print("-" * 78)

    # Critical indices for ctx9 output idx 318/319, channel 1, y=158/159,
    # contribution from k=6 input channel.
    critical = [6 * 160 + 158, 6 * 160 + 159]

    print("Critical ctx8 indices feeding ctx9 Conv1D_7 tail:")
    print("ctx8_idx,channel,y,rtl_hex,golden_hex,rtl_i16,golden_i16,err_lsb")
    for idx in critical:
        r = rtl[idx] if idx < len(rtl) else None
        g = golden[idx] if idx < len(golden) else None
        if r is None or g is None:
            print(f"{idx},6,{idx-6*160},MISSING")
        else:
            print(f"{idx},6,{idx-6*160},{h4(r)},{h4(g)},{r},{g},{r-g}")

    print("-" * 78)
    print("Channel 6 tail around y=150..159:")
    print("idx,y,rtl_hex,golden_hex,rtl_i16,golden_i16,err_lsb")
    for y in range(150, 160):
        idx = 6 * 160 + y
        r = rtl[idx] if idx < len(rtl) else None
        g = golden[idx] if idx < len(golden) else None
        if r is None or g is None:
            print(f"{idx},{y},MISSING")
        else:
            print(f"{idx},{y},{h4(r)},{h4(g)},{r},{g},{r-g}")

    print("-" * 78)
    print("How to interpret:")
    print("  If ctx8 idx 1118/1119 show RTL around 101 and Golden around 73/72,")
    print("  then ctx9 PE38/PE39 mismatch is inherited from ctx8 MaxPool/right-boundary,")
    print("  not caused by ctx9 Conv1D_7 or PE_lite writeback.")
    print("=" * 78)

if __name__ == "__main__":
    main()
