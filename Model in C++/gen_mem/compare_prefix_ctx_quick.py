#!/usr/bin/env python3
"""
Terminal-only prefix context compare.

After running TB_CNN_1D_Core_prefix_debug.v:
  1) Set RUN_CTX_COUNT = N in TB.
  2) Run simulation, which writes output.txt.
  3) Run:
       python compare_prefix_ctx_quick.py --ctx N --dir "D:/HOC_TAP/KLTN/My_Proj/Advance_ECG/Model in C++/gen_mem"

This script:
  - reads golden_manifest.csv
  - finds the correct Golden_ctxNN_*_hex.txt
  - reads output.txt
  - prints comparison/statistics directly to terminal
  - DOES NOT write report/csv files
"""

from __future__ import annotations

import argparse
import csv
import math
import re
from pathlib import Path
from typing import Dict, List, Optional, Tuple

HEX_RE = re.compile(r"([0-9a-fA-F]{4})\s*$")


def parse_hex16(line: str) -> Optional[int]:
    line = line.strip()
    if not line:
        return None
    m = HEX_RE.search(line)   # accepts both "0321" and "0000_0321"
    if not m:
        return None
    return int(m.group(1), 16) & 0xFFFF


def read_hex_file(path: Path) -> List[int]:
    if not path.exists():
        raise FileNotFoundError(f"Missing file: {path}")
    out: List[int] = []
    with path.open("r", encoding="utf-8", errors="ignore") as f:
        for line in f:
            v = parse_hex16(line)
            if v is not None:
                out.append(v)
    return out


def u16_to_i16(v: int) -> int:
    v &= 0xFFFF
    return v - 0x10000 if (v & 0x8000) else v


def h4(v: int) -> str:
    return f"{v & 0xFFFF:04x}"


def load_manifest(gen_dir: Path) -> Dict[int, Dict[str, str]]:
    manifest = gen_dir / "golden_manifest.csv"
    if not manifest.exists():
        raise FileNotFoundError(f"Missing manifest: {manifest}")

    rows: Dict[int, Dict[str, str]] = {}
    with manifest.open("r", encoding="utf-8", errors="ignore", newline="") as f:
        reader = csv.DictReader(f)
        for row in reader:
            if not row.get("ctx"):
                continue
            rows[int(row["ctx"])] = row
    return rows


def vector_stats(vals: List[int], frac_bits: int):
    if not vals:
        return dict(min=0, max=0, mean=0.0, zero=0, neg=0)

    signed = [u16_to_i16(v) for v in vals]
    return dict(
        min=min(signed),
        max=max(signed),
        mean=sum(signed) / len(signed),
        zero=sum(1 for x in signed if x == 0),
        neg=sum(1 for x in signed if x < 0),
        min_float=min(signed) / float(1 << frac_bits),
        max_float=max(signed) / float(1 << frac_bits),
        mean_float=(sum(signed) / len(signed)) / float(1 << frac_bits),
    )


def compare(rtl: List[int], golden: List[int], frac_bits: int, tol_lsb: int):
    n = min(len(rtl), len(golden))
    exact_mismatch = 0
    tol_mismatch = 0
    abs_sum = 0
    signed_sum = 0
    sq_sum = 0
    max_abs = 0
    max_idx = -1
    first_mismatches: List[Tuple[int, int, int, int, int]] = []

    for i in range(n):
        r = u16_to_i16(rtl[i])
        g = u16_to_i16(golden[i])
        err = r - g
        abs_err = abs(err)

        abs_sum += abs_err
        signed_sum += err
        sq_sum += err * err

        if abs_err > max_abs:
            max_abs = abs_err
            max_idx = i

        if abs_err != 0:
            exact_mismatch += 1

        if abs_err > tol_lsb:
            tol_mismatch += 1
            if len(first_mismatches) < 20:
                first_mismatches.append((i, rtl[i], golden[i], err, abs_err))

    missing = abs(len(rtl) - len(golden))
    exact_mismatch += missing
    tol_mismatch += missing

    if n == 0:
        mae = mse = rmse = mean_signed = 0.0
    else:
        mae = abs_sum / n
        mean_signed = signed_sum / n
        rmse = math.sqrt(sq_sum / n)

    scale = float(1 << frac_bits)
    return {
        "n": n,
        "missing": missing,
        "exact_mismatch": exact_mismatch,
        "tol_mismatch": tol_mismatch,
        "within_tol": n - (tol_mismatch - missing),
        "mae_lsb": mae,
        "mae_float": mae / scale,
        "mean_signed_lsb": mean_signed,
        "mean_signed_float": mean_signed / scale,
        "rmse_lsb": rmse,
        "rmse_float": rmse / scale,
        "max_abs_lsb": max_abs,
        "max_abs_float": max_abs / scale,
        "max_idx": max_idx,
        "first_mismatches": first_mismatches,
    }


def print_stats_block(name: str, stats):
    print(f"{name:<8} min={stats['min']:>7} ({stats['min_float']:>10.6f}) | "
          f"max={stats['max']:>7} ({stats['max_float']:>10.6f}) | "
          f"mean={stats['mean']:>10.3f} ({stats['mean_float']:>10.6f}) | "
          f"zero={stats['zero']:>4} | neg={stats['neg']:>4}")


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--dir", default=".", help="Folder containing output.txt and golden_manifest.csv")
    ap.add_argument("--ctx", type=int, required=True, help="Context number, same as RUN_CTX_COUNT in TB")
    ap.add_argument("--rtl", default="output.txt", help="RTL output dump file, default output.txt")
    ap.add_argument("--tol-lsb", type=int, default=0, help="Allowed absolute error in LSB, default 0")
    ap.add_argument("--fractional-bits", type=int, default=6, help="Fixed-point fractional bits, default 6")
    args = ap.parse_args()

    gen_dir = Path(args.dir).expanduser().resolve()
    rows = load_manifest(gen_dir)

    if args.ctx not in rows:
        raise SystemExit(f"ERROR: ctx {args.ctx} not found in golden_manifest.csv")

    row = rows[args.ctx]
    golden_file = row["hex_file"]
    rtl_path = gen_dir / args.rtl
    golden_path = gen_dir / golden_file

    rtl = read_hex_file(rtl_path)
    golden = read_hex_file(golden_path)
    s = compare(rtl, golden, args.fractional_bits, args.tol_lsb)

    status = "PASS" if s["tol_mismatch"] == 0 else "FAIL"

    print("=" * 72)
    print(f"PREFIX CTX COMPARE | ctx={args.ctx:02d} | {row.get('function','')}")
    print("=" * 72)
    print(f"CRAM      : {row.get('cram_hex','')}")
    print(f"RTL file  : {rtl_path}")
    print(f"Golden    : {golden_path}")
    print(f"Length    : rtl={len(rtl)} | golden={len(golden)} | compared={s['n']} | missing={s['missing']}")
    print(f"Tol       : {args.tol_lsb} LSB | fractional_bits={args.fractional_bits}")
    print("-" * 72)
    print(f"STATUS    : {status}")
    print(f"Mismatch  : exact={s['exact_mismatch']} | over_tol={s['tol_mismatch']} | within_tol={s['within_tol']}/{s['n']}")
    print(f"MEA/MAE   : {s['mae_lsb']:.6f} LSB | {s['mae_float']:.9f}")
    print(f"Signed ME : {s['mean_signed_lsb']:.6f} LSB | {s['mean_signed_float']:.9f}")
    print(f"RMSE      : {s['rmse_lsb']:.6f} LSB | {s['rmse_float']:.9f}")
    print(f"Max Abs   : {s['max_abs_lsb']} LSB | {s['max_abs_float']:.9f} | idx={s['max_idx']}")
    print("-" * 72)
    print("Vector stats: raw_i16 (float)")
    print_stats_block("RTL", vector_stats(rtl, args.fractional_bits))
    print_stats_block("Golden", vector_stats(golden, args.fractional_bits))

    if s["first_mismatches"]:
        print("-" * 72)
        print("First mismatches over tolerance:")
        print("idx     rtl_hex golden_hex   rtl_i16 golden_i16   err_lsb   err_float")
        for idx, r_u16, g_u16, err, abs_err in s["first_mismatches"]:
            print(f"{idx:<7} {h4(r_u16):>7} {h4(g_u16):>10} "
                  f"{u16_to_i16(r_u16):>9} {u16_to_i16(g_u16):>10} "
                  f"{err:>9} {err / float(1 << args.fractional_bits):>11.6f}")
    print("=" * 72)

    return 0 if status == "PASS" else 1


if __name__ == "__main__":
    raise SystemExit(main())
