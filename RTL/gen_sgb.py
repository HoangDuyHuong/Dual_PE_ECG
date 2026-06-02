import os

def generate_sgb():
    NUM_PE = 40
    filename = "SGB.v"
    
    with open(filename, "w") as f:
        # 1. Header và khai báo Module
        f.write("`timescale 1ns/1ns\n")
        f.write("`include \"common.vh\"\n\n")
        f.write("module SGB\n(\n")
        f.write("\tinput  wire CLK,\n")
        f.write("\tinput  wire RST,\n\n")
        
        # 2. Khai báo Ngõ vào (PEA0_...)
        for i in range(NUM_PE):
            f.write(f"\tinput wire signed [`WORD_BITS-1:0] PEA0_PE{i}_Pixel_0_in,\n")
            f.write(f"\tinput wire PEA0_PE{i}_Pixel_0_valid_in,\n")
            f.write(f"\tinput wire signed [`WORD_BITS-1:0] PEA0_PE{i}_Pixel_1_in,\n")
            f.write(f"\tinput wire PEA0_PE{i}_Pixel_1_valid_in,\n\n")
            
        f.write("\t///*** From the Controller ***///\n")
        f.write("\tinput  wire En_in,\n")
        f.write("\tinput  wire [`ALU_CFG_BITS-2:0] CFG_in,\n")
        f.write("\tinput  wire [`PE_NUM_BITS-1:0] MUX_Selection_in,\n")
        f.write("\tinput  wire Parity_PE_Selection_in,\n")
        f.write("\tinput  wire Stride_in,\n")
        f.write("\tinput  wire MP_Padding_in,\n")
        f.write("\tinput  wire MP_Padding_2_in,\n")
        f.write("\tinput  wire MP_Padding_3_in,\n\n")

        # 3. Khai báo Ngõ ra (Shared_...)
        f.write("\t//-----------------------------------------------------//\n")
        f.write("\t//          \t\t\tOutput Signals                 //\n")
        f.write("\t//-----------------------------------------------------//\n")
        for i in range(NUM_PE):
            f.write(f"\toutput reg signed [`WORD_BITS-1:0] Shared_PE{i}_Pixel_0_out,\n")
            f.write(f"\toutput reg Shared_PE{i}_Pixel_0_valid_out,\n")
            f.write(f"\toutput reg signed [`WORD_BITS-1:0] Shared_PE{i}_Pixel_1_out,\n")
            f.write(f"\toutput reg Shared_PE{i}_Pixel_1_valid_out,\n")
            f.write(f"\toutput reg signed [`WORD_BITS-1:0] Shared_PE{i}_Pixel_2_out,\n")
            end_char = "," if i < NUM_PE - 1 else "\n"
            f.write(f"\toutput reg Shared_PE{i}_Pixel_2_valid_out{end_char}\n\n")
        f.write(");\n\n")

        # 4. Khai báo Internal Wires
        f.write("\t// *************** Wire signals *************** //\n")
        for i in range(NUM_PE):
            f.write(f"\twire signed [`WORD_BITS-1:0] PE{i}_Pixel_to_MUX_wr;\n")
        f.write("\n")
        for i in range(NUM_PE):
            f.write(f"\twire signed [`WORD_BITS-1:0] Shared_PE{i}_Pixel_0_out_wr;\n")
            f.write(f"\twire Shared_PE{i}_Pixel_0_valid_out_wr;\n")
            f.write(f"\twire signed [`WORD_BITS-1:0] Shared_PE{i}_Pixel_1_out_wr;\n")
            f.write(f"\twire Shared_PE{i}_Pixel_1_valid_out_wr;\n")
            f.write(f"\twire signed [`WORD_BITS-1:0] Shared_PE{i}_Pixel_2_out_wr;\n")
            f.write(f"\twire Shared_PE{i}_Pixel_2_valid_out_wr;\n")
            
        f.write("\n\t// *************** Register signals *************** //\n")
        f.write("\treg Parity_PE_Selection_rg;\n\n")

        # 5. Logic cho Pixel_to_MUX_wr (Stride logic)
        for i in range(NUM_PE):
            if i < 20:
                p0 = f"PEA0_PE{i*2}_Pixel_0_in"
                p1 = f"PEA0_PE{i*2+1}_Pixel_0_in"
            else:
                p0 = f"PEA0_PE{(i-20)*2}_Pixel_1_in"
                p1 = f"PEA0_PE{(i-20)*2+1}_Pixel_1_in"
            
            pd = f"PEA0_PE{i}_Pixel_0_in"
            
            f.write(f"\tassign PE{i}_Pixel_to_MUX_wr = ((Stride_in == 1) & (CFG_in == `EXE_MAC) && (Parity_PE_Selection_rg == 0)) ? {p0} :\n")
            f.write(f"\t\t\t\t\t\t\t\t ((Stride_in == 1) & (CFG_in == `EXE_MAC) && (Parity_PE_Selection_rg == 1)) ? {p1} : {pd};\n")
        f.write("\n")

        # 6. Khởi tạo MUX_40_1
        for i in range(NUM_PE):
            f.write(f"\tMUX_40_1 PE{i}_Pixel_0(\n")
            for j in range(NUM_PE):
                idx = (i + j) % NUM_PE
                f.write(f"\t\t.data{j}_in(PE{idx}_Pixel_to_MUX_wr),\n")
            f.write(f"\t\t.sel_in(MUX_Selection_in),\n")
            f.write(f"\t\t.mux_40_1_out(Shared_PE{i}_Pixel_0_out_wr)\n")
            f.write("\t);\n\n")

        # 7. Logic cho MP_Padding (Pixel 1, 2 out_wr)
        for i in range(NUM_PE - 2):
            f.write(f"\tassign Shared_PE{i}_Pixel_1_out_wr = (MP_Padding_in) ? PEA0_PE{i}_Pixel_0_in : PEA0_PE{i+1}_Pixel_0_in;\n")
            f.write(f"\tassign Shared_PE{i}_Pixel_2_out_wr = (MP_Padding_in) ? PEA0_PE{i+1}_Pixel_0_in : PEA0_PE{i+2}_Pixel_0_in;\n")
        
        # Xử lý đặc biệt cho PE 38, 39
        f.write("\tassign Shared_PE38_Pixel_1_out_wr = (MP_Padding_in) ? PEA0_PE38_Pixel_0_in : PEA0_PE39_Pixel_0_in;\n")
        f.write("\tassign Shared_PE38_Pixel_2_out_wr = (MP_Padding_3_in) ? 0 : (MP_Padding_in) ? PEA0_PE39_Pixel_1_in : PEA0_PE0_Pixel_1_in;\n")
        f.write("\tassign Shared_PE39_Pixel_1_out_wr = (MP_Padding_3_in) ? 0 : (MP_Padding_in) ? PEA0_PE39_Pixel_1_in : PEA0_PE0_Pixel_1_in;\n")
        f.write("\tassign Shared_PE39_Pixel_2_out_wr = (MP_Padding_3_in) ? 0 : (MP_Padding_2_in) ? 0 : (MP_Padding_in) ? PEA0_PE0_Pixel_1_in : PEA0_PE1_Pixel_1_in;\n\n")

        # 8. Logic Valid signals
        for i in range(NUM_PE):
            pair_idx = i ^ 1 # Phép XOR 1 để bắt cặp (0-1, 2-3, 4-5)
            f.write(f"\tassign Shared_PE{i}_Pixel_0_valid_out_wr = PEA0_PE{i}_Pixel_0_valid_in | PEA0_PE{pair_idx}_Pixel_0_valid_in;\n")
            f.write(f"\tassign Shared_PE{i}_Pixel_1_valid_out_wr = PEA0_PE{i}_Pixel_0_valid_in | PEA0_PE{pair_idx}_Pixel_0_valid_in;\n")
            f.write(f"\tassign Shared_PE{i}_Pixel_2_valid_out_wr = PEA0_PE{i}_Pixel_0_valid_in | PEA0_PE{pair_idx}_Pixel_0_valid_in;\n\n")

        # 9. Khối Sequential (Always block)
        f.write("\talways @(posedge CLK or negedge RST) begin\n")
        f.write("\t\tif (~RST) begin\n")
        for i in range(NUM_PE):
            f.write(f"\t\t\tShared_PE{i}_Pixel_0_out <= 0;\n")
            f.write(f"\t\t\tShared_PE{i}_Pixel_0_valid_out <= 0;\n")
            f.write(f"\t\t\tShared_PE{i}_Pixel_1_out <= 0;\n")
            f.write(f"\t\t\tShared_PE{i}_Pixel_1_valid_out <= 0;\n")
            f.write(f"\t\t\tShared_PE{i}_Pixel_2_out <= 0;\n")
            f.write(f"\t\t\tShared_PE{i}_Pixel_2_valid_out <= 0;\n")
        f.write("\t\t\tParity_PE_Selection_rg <= 0;\n")
        f.write("\t\tend\n")
        f.write("\t\telse begin\n")
        f.write("\t\t\tif(En_in) begin\n")
        for i in range(NUM_PE):
            f.write(f"\t\t\t\tShared_PE{i}_Pixel_0_out <= Shared_PE{i}_Pixel_0_out_wr;\n")
            f.write(f"\t\t\t\tShared_PE{i}_Pixel_0_valid_out <= Shared_PE{i}_Pixel_0_valid_out_wr;\n")
            f.write(f"\t\t\t\tShared_PE{i}_Pixel_1_out <= Shared_PE{i}_Pixel_1_out_wr;\n")
            f.write(f"\t\t\t\tShared_PE{i}_Pixel_1_valid_out <= Shared_PE{i}_Pixel_1_valid_out_wr;\n")
            f.write(f"\t\t\t\tShared_PE{i}_Pixel_2_out <= Shared_PE{i}_Pixel_2_out_wr;\n")
            f.write(f"\t\t\t\tShared_PE{i}_Pixel_2_valid_out <= Shared_PE{i}_Pixel_2_valid_out_wr;\n")
        f.write("\t\t\tend\n")
        f.write("\t\t\telse begin\n")
        for i in range(NUM_PE):
            f.write(f"\t\t\t\tShared_PE{i}_Pixel_0_out <= 0;\n")
            f.write(f"\t\t\t\tShared_PE{i}_Pixel_0_valid_out <= 0;\n")
            f.write(f"\t\t\t\tShared_PE{i}_Pixel_1_out <= 0;\n")
            f.write(f"\t\t\t\tShared_PE{i}_Pixel_1_valid_out <= 0;\n")
            f.write(f"\t\t\t\tShared_PE{i}_Pixel_2_out <= 0;\n")
            f.write(f"\t\t\t\tShared_PE{i}_Pixel_2_valid_out <= 0;\n")
        f.write("\t\t\tend\n")
        f.write("\t\t\tParity_PE_Selection_rg <= Parity_PE_Selection_in;\n")
        f.write("\t\tend\n")
        f.write("\tend\n")
        f.write("endmodule\n\n")

        # 10. Khai báo các module phụ trợ (MUX_4_1, MUX_8_1, MUX_40_1)
        f.write('''module MUX_4_1 (
    input [`WORD_BITS-1:0] data0_in, data1_in, data2_in, data3_in,
    input [1:0] sel_in,
    output reg [`WORD_BITS-1:0] mux_4_1_out
);
always @*
    case(sel_in)
        2'b00: mux_4_1_out = data0_in;
        2'b01: mux_4_1_out = data1_in;
        2'b10: mux_4_1_out = data2_in;
        2'b11: mux_4_1_out = data3_in;
        default: mux_4_1_out = data0_in;
    endcase
endmodule

module MUX_8_1 (
    input [`WORD_BITS-1:0] data0_in, data1_in, data2_in, data3_in,
    input [`WORD_BITS-1:0] data4_in, data5_in, data6_in, data7_in,
    input [2:0] sel_in,
    output reg [`WORD_BITS-1:0] mux_8_1_out
);
wire [`WORD_BITS-1:0] mux_0, mux_1;
    MUX_4_1 mux0(.data0_in(data0_in), .data1_in(data1_in), .data2_in(data2_in), .data3_in(data3_in), .sel_in(sel_in[1:0]), .mux_4_1_out(mux_0));
    MUX_4_1 mux1(.data0_in(data4_in), .data1_in(data5_in), .data2_in(data6_in), .data3_in(data7_in), .sel_in(sel_in[1:0]), .mux_4_1_out(mux_1));
always @*
    case(sel_in[2:2])
        1'b0: mux_8_1_out = mux_0;
        1'b1: mux_8_1_out = mux_1;
        default: mux_8_1_out = mux_0;
    endcase
endmodule

module MUX_40_1 (
    input [`WORD_BITS-1:0] data0_in, data1_in, data2_in, data3_in, data4_in, data5_in, data6_in, data7_in,
    input [`WORD_BITS-1:0] data8_in, data9_in, data10_in, data11_in, data12_in, data13_in, data14_in, data15_in,
    input [`WORD_BITS-1:0] data16_in, data17_in, data18_in, data19_in, data20_in, data21_in, data22_in, data23_in,
    input [`WORD_BITS-1:0] data24_in, data25_in, data26_in, data27_in, data28_in, data29_in, data30_in, data31_in,
    input [`WORD_BITS-1:0] data32_in, data33_in, data34_in, data35_in, data36_in, data37_in, data38_in, data39_in,
    input [5:0] sel_in,
    output reg [`WORD_BITS-1:0] mux_40_1_out
);
wire [`WORD_BITS-1:0] mux_0, mux_1, mux_2, mux_3, mux_4;

    MUX_8_1 m0(.data0_in(data0_in), .data1_in(data1_in), .data2_in(data2_in), .data3_in(data3_in), .data4_in(data4_in), .data5_in(data5_in), .data6_in(data6_in), .data7_in(data7_in), .sel_in(sel_in[2:0]), .mux_8_1_out(mux_0));
    MUX_8_1 m1(.data0_in(data8_in), .data1_in(data9_in), .data2_in(data10_in), .data3_in(data11_in), .data4_in(data12_in), .data5_in(data13_in), .data6_in(data14_in), .data7_in(data15_in), .sel_in(sel_in[2:0]), .mux_8_1_out(mux_1));
    MUX_8_1 m2(.data0_in(data16_in), .data1_in(data17_in), .data2_in(data18_in), .data3_in(data19_in), .data4_in(data20_in), .data5_in(data21_in), .data6_in(data22_in), .data7_in(data23_in), .sel_in(sel_in[2:0]), .mux_8_1_out(mux_2));
    MUX_8_1 m3(.data0_in(data24_in), .data1_in(data25_in), .data2_in(data26_in), .data3_in(data27_in), .data4_in(data28_in), .data5_in(data29_in), .data6_in(data30_in), .data7_in(data31_in), .sel_in(sel_in[2:0]), .mux_8_1_out(mux_3));
    MUX_8_1 m4(.data0_in(data32_in), .data1_in(data33_in), .data2_in(data34_in), .data3_in(data35_in), .data4_in(data36_in), .data5_in(data37_in), .data6_in(data38_in), .data7_in(data39_in), .sel_in(sel_in[2:0]), .mux_8_1_out(mux_4));
always @* begin
        case(sel_in[5:3])
            3'b000: mux_40_1_out = mux_0;
            3'b001: mux_40_1_out = mux_1;
            3'b010: mux_40_1_out = mux_2;
            3'b011: mux_40_1_out = mux_3;
            3'b100: mux_40_1_out = mux_4;
            default: mux_40_1_out = mux_0;
        endcase
    end
endmodule
''')

    print(f"Đã tạo thành công file {filename}!")

if __name__ == "__main__":
    generate_sgb()