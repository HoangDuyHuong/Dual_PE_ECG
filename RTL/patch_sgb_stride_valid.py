from pathlib import Path
import re
import sys

sgb_path = Path(sys.argv[1] if len(sys.argv) >= 2 else "SGB.v")

text = sgb_path.read_text()

if "stride_mac_shared_p0_valid_bus" in text:
    print("SGB already patched. Stop.")
    sys.exit(0)

p0_bus = ",\n    ".join(
    f"PEA0_PE{i}_Pixel_0_valid_in" for i in range(39, -1, -1)
)

p1_bus = ",\n    ".join(
    f"PEA0_PE{i}_Pixel_1_valid_in" for i in range(39, -1, -1)
)

insert_block = f"""
// ===================== PATCH: stride MAC Pixel_0 valid follows data mux =====================
// Lý do: Khi Stride_in=1 và CFG=EXE_MAC, data path chọn Pixel_0/Pixel_1 theo stride.
// Nếu valid không đi cùng data, MAC term có thể bị bỏ qua, đặc biệt khi đọc sang LDM row kế tiếp.
wire [39:0] stride_p0_valid_bus = {{
    {p0_bus}
}};

wire [39:0] stride_p1_valid_bus = {{
    {p1_bus}
}};

wire [39:0] stride_mac_pe_to_mux_valid_bus;
wire [39:0] stride_mac_shared_p0_valid_bus;

genvar stride_valid_gv;
generate
    for (stride_valid_gv = 0; stride_valid_gv < 40; stride_valid_gv = stride_valid_gv + 1) begin : GEN_STRIDE_MAC_VALID
        if (stride_valid_gv < 20) begin : GEN_STRIDE_VALID_LOW
            assign stride_mac_pe_to_mux_valid_bus[stride_valid_gv] =
                (Parity_PE_Selection_rg == 1'b0) ? stride_p0_valid_bus[2*stride_valid_gv] :
                                                    stride_p0_valid_bus[2*stride_valid_gv + 1];
        end
        else begin : GEN_STRIDE_VALID_HIGH
            assign stride_mac_pe_to_mux_valid_bus[stride_valid_gv] =
                (Parity_PE_Selection_rg == 1'b0) ? stride_p1_valid_bus[2*stride_valid_gv - 40] :
                                                    stride_p1_valid_bus[2*stride_valid_gv - 39];
        end

        wire [5:0] stride_valid_sel_idx;
        assign stride_valid_sel_idx = stride_valid_gv + MUX_Selection_in;

        assign stride_mac_shared_p0_valid_bus[stride_valid_gv] =
            stride_mac_pe_to_mux_valid_bus[
                (stride_valid_sel_idx >= 6'd40) ? (stride_valid_sel_idx - 6'd40) : stride_valid_sel_idx
            ];
    end
endgenerate
// =================== END PATCH: stride MAC Pixel_0 valid follows data mux ===================

"""

marker = "assign Shared_PE0_Pixel_0_valid_out_wr"
pos = text.find(marker)
if pos < 0:
    raise RuntimeError("Cannot find Shared_PE0_Pixel_0_valid_out_wr assignment block.")

text = text[:pos] + insert_block + text[pos:]

pattern = re.compile(r"assign Shared_PE(\d+)_Pixel_0_valid_out_wr\s*=\s*([^;]+);")

def repl(m):
    pe = int(m.group(1))
    old_rhs = m.group(2).strip()
    return (
        f"assign Shared_PE{pe}_Pixel_0_valid_out_wr = "
        f"((Stride_in == 1) & (CFG_in == `EXE_MAC)) ? "
        f"stride_mac_shared_p0_valid_bus[{pe}] : ({old_rhs});"
    )

text_new = pattern.sub(repl, text)

backup_path = sgb_path.with_suffix(sgb_path.suffix + ".bak")
backup_path.write_text(sgb_path.read_text())
sgb_path.write_text(text_new)

print(f"Patched {sgb_path}")
print(f"Backup saved to {backup_path}")