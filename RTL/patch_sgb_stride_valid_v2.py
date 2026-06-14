from pathlib import Path
import re
import sys
import shutil

sgb_path = Path(sys.argv[1] if len(sys.argv) >= 2 else "SGB.v")

if not sgb_path.exists():
    raise FileNotFoundError(sgb_path)

raw = sgb_path.read_bytes()
try:
    text = raw.decode("utf-8")
except UnicodeDecodeError:
    text = raw.decode("latin-1")

if "stride_mac_shared_p0_valid_bus" in text:
    print("SGB already patched. Stop.")
    sys.exit(0)

marker = "assign Shared_PE0_Pixel_0_valid_out_wr"
pos = text.find(marker)
if pos < 0:
    raise RuntimeError(
        "Cannot find Shared_PE0_Pixel_0_valid_out_wr. "
        "Your SGB.v may be corrupted. Restore it from SGB.v.bak first."
    )

def build_patch_block():
    p0_bus = ",\n    ".join(
        f"PEA0_PE{i}_Pixel_0_valid_in" for i in range(39, -1, -1)
    )
    p1_bus = ",\n    ".join(
        f"PEA0_PE{i}_Pixel_1_valid_in" for i in range(39, -1, -1)
    )

    lines = []
    lines.append("// ===================== PATCH: stride MAC Pixel_0 valid follows data mux =====================")
    lines.append("wire [39:0] stride_p0_valid_bus = {")
    lines.append("    " + p0_bus)
    lines.append("};")
    lines.append("")
    lines.append("wire [39:0] stride_p1_valid_bus = {")
    lines.append("    " + p1_bus)
    lines.append("};")
    lines.append("")
    lines.append("wire [39:0] stride_mac_pe_to_mux_valid_bus;")
    lines.append("wire [39:0] stride_mac_shared_p0_valid_bus;")
    lines.append("")

    for i in range(40):
        if i < 20:
            a = 2 * i
            b = 2 * i + 1
            bus = "stride_p0_valid_bus"
        else:
            a = 2 * i - 40
            b = 2 * i - 39
            bus = "stride_p1_valid_bus"

        lines.append(
            f"assign stride_mac_pe_to_mux_valid_bus[{i}] = "
            f"(Parity_PE_Selection_rg == 1'b0) ? {bus}[{a}] : {bus}[{b}];"
        )

    lines.append("")

    for i in range(40):
        lines.append(
            f"assign stride_mac_shared_p0_valid_bus[{i}] = "
            f"((6'd{i} + MUX_Selection_in) >= 6'd40) ? "
            f"stride_mac_pe_to_mux_valid_bus[(6'd{i} + MUX_Selection_in - 6'd40)] : "
            f"stride_mac_pe_to_mux_valid_bus[(6'd{i} + MUX_Selection_in)];"
        )

    lines.append("// =================== END PATCH: stride MAC Pixel_0 valid follows data mux ===================")
    lines.append("")
    return "\n".join(lines)

patch_block = build_patch_block()
text = text[:pos] + patch_block + "\n" + text[pos:]

pattern = re.compile(r"assign Shared_PE(\d+)_Pixel_0_valid_out_wr\s*=\s*([^;]+);")

def repl(m):
    pe = int(m.group(1))
    old_rhs = m.group(2).strip()
    return (
        f"assign Shared_PE{pe}_Pixel_0_valid_out_wr = "
        f"((Stride_in == 1) & (CFG_in == `EXE_MAC)) ? "
        f"stride_mac_shared_p0_valid_bus[{pe}] : ({old_rhs});"
    )

text_new, n = pattern.subn(repl, text)

if n != 40:
    raise RuntimeError(f"Expected to patch 40 Pixel_0 valid assignments, patched {n}.")

backup_path = sgb_path.with_suffix(sgb_path.suffix + ".pre_stride_valid_patch.bak")
if not backup_path.exists():
    backup_path.write_bytes(raw)

tmp_path = sgb_path.with_suffix(sgb_path.suffix + ".tmp")
tmp_path.write_text(text_new, encoding="utf-8", newline="")
tmp_path.replace(sgb_path)

print(f"Patched {sgb_path}")
print(f"Patched assignments: {n}")
print(f"Backup saved to {backup_path}")
