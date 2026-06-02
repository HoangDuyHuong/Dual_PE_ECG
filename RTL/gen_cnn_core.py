import os

def generate_cnn_core():
    filename = "CNN_1D_Core.v"
    with open(filename, "w", encoding="utf-8") as f:
        # 1. Header & Ports (Giữ nguyên giao tiếp AXI)
        f.write("""`timescale 1ns/1ns
`include "common.vh"

module CNN_1D_Core
(
\t//-----------------------------------------------------//
\t//          \t\t\tInput Signals                  // 
\t//-----------------------------------------------------//
\t///*** From AXI Mapper ***///\t\t\t\t
\tinput  wire                                 \tCLK,
\tinput  wire                                 \tRST,
\tinput  wire [`PE_NUM_BITS+`LDM_NUM_BITS+`LDM_ADDR_BITS-1:0] AXI_LDM_addra_in,
\tinput  wire signed [`WORD_BITS-1:0]          \tAXI_LDM_dina_in,
\tinput  wire \t\t\t\t\t              \tAXI_LDM_ena_in,
\tinput  wire \t\t\t\t\t              \tAXI_LDM_wea_in,
\tinput  wire [`CRAM_ADDR_BITS-1:0] \t\t\t\tAXI_CRAM_addra_in,
\tinput  wire signed [`CTX_BITS-1:0]          \tAXI_CRAM_dina_in,
\tinput  wire \t\t\t\t\t              \tAXI_CRAM_ena_in,
\tinput  wire \t\t\t\t\t              \tAXI_CRAM_wea_in,
\tinput  wire [`WRAM_ADDR_BITS-1:0]   \t\t\tAXI_WRAM_addra_in,
\tinput  wire [`WORD_BITS-1:0]              \t\tAXI_WRAM_dina_in,
\tinput  wire \t\t\t\t\t              \tAXI_WRAM_ena_in,
\tinput  wire \t\t\t\t\t              \tAXI_WRAM_wea_in,
\tinput  wire [`BRAM_ADDR_BITS-1:0]   \t\t\tAXI_BRAM_addra_in,
\tinput  wire [`WORD_BITS-1:0]              \t\tAXI_BRAM_dina_in,
\tinput  wire \t\t\t\t\t              \tAXI_BRAM_ena_in,
\tinput  wire \t\t\t\t\t              \tAXI_BRAM_wea_in,
\tinput  wire \t\t\t\t\t              \tstart_in,

\t//-----------------------------------------------------//
\t//          \t\t\tOutput Signals                 // 
\t//-----------------------------------------------------// 
\t///*** To  AXI Mapper  ***///
\toutput wire signed [`WORD_BITS-1:0]          \tAXI_LDM_douta_out,
\toutput wire \t\t\t\t\t\t       \t\tcomplete_out  
);

// *************** Wire signals *************** //
\twire [`CTX_BITS-1:0]             \t\t\t\tCTX_wr;
\twire [`CRAM_ADDR_BITS-1:0] \t\t\t\t\t\tCTRL_CRAM_addrb_wr;
\twire \t\t\t\t\t              \t\t\tCTRL_CRAM_enb_wr;
\twire \t\t\t\t\t              \t\t\tCTRL_CRAM_web_wr;

\twire [`WRAM_ADDR_BITS-1:0] \t\t\t\t\t\tCTRL_WRAM_addrb_0_wr, CTRL_WRAM_addrb_1_wr;
\twire \t\t\t\t\t              \t\t\tCTRL_WRAM_enb_0_wr, CTRL_WRAM_enb_1_wr;
\twire \t\t\t\t\t              \t\t\tCTRL_WRAM_web_0_wr, CTRL_WRAM_web_1_wr;
\twire signed [`WORD_BITS-1:0]             \t\tWeight_0_wr, Weight_1_wr;

\twire [`BRAM_ADDR_BITS-1:0] \t\t\t\t\t\tCTRL_BRAM_addrb_0_wr, CTRL_BRAM_addrb_1_wr;
\twire \t\t\t\t\t              \t\t\tCTRL_BRAM_enb_0_wr, CTRL_BRAM_enb_1_wr;
\twire \t\t\t\t\t              \t\t\tCTRL_BRAM_web_0_wr, CTRL_BRAM_web_1_wr;
\twire signed [`WORD_BITS-1:0]             \t\tBias_0_wr, Bias_1_wr;

\twire [`ALU_CFG_BITS-1:0]      \t\t\t\t\tCFG_wr;
\twire [`PE_NUM_BITS-1:0]  \t\t\t\t\t\tMUX_Selection_wr;
\twire \t\t\t\t\t              \t\t\tStride_wr;
\twire \t\t\t\t\t              \t\t\tMP_Padding_wr, MP_Padding_2_wr, MP_Padding_3_wr;
\twire \t\t\t\t\t              \t\t\tEn_wr, layer_done_wr, Parity_PE_Selection_wr;

\twire [`S_LDM_BITS+`LDM_ADDR_BITS-1:0] \t\t\tCTRL_LDM_addra_wr, CTRL_LDM_addrb_wr;
\twire \t\t\t\t\t              \t\t\tCTRL_LDM_ena_wr, CTRL_LDM_enb_wr;
\twire \t\t\t\t\t              \t\t\tCTRL_LDM_wea_wr, CTRL_LDM_web_wr;

\twire [`D_LDM_BITS+`SA_LDM_BITS-1:0] \t\t\tCTRL_LDM_Store_wr, CTRL_LDM_Store_1_wr;
\twire signed [`WORD_BITS-1:0]         \t\t\tAXI_LDM_douta_out_wr[`PE_NUM-1:0];
\twire\t\t\t\t\t\t\t\t\t\t\tOverarray_wr, complete_wr;
\twire\t[`PE_NUM-1:0]\t\t\t\t\t\t\tPadding_Read_wr, CTRL_LDM_addra_Incr_wr;

""")

        # 2. Arrays cho PEA 0, PEA 1 và SGB
        f.write("\t// Wires cho Pixel LDM xuất ra từ PEA 0\n")
        f.write("\twire signed [`WORD_BITS-1:0] Pixel_0_out_wr[`PE_NUM-1:0];\n")
        f.write("\twire Pixel_0_valid_out_wr[`PE_NUM-1:0];\n")
        f.write("\twire signed [`WORD_BITS-1:0] Pixel_1_out_wr[`PE_NUM-1:0];\n")
        f.write("\twire Pixel_1_valid_out_wr[`PE_NUM-1:0];\n\n")

        f.write("\t// Wires cho Shared Pixel phân phối từ SGB đến cả 2 PEA\n")
        f.write("\twire signed [`WORD_BITS-1:0] Shared_Pixel_0_in_wr[`PE_NUM-1:0];\n")
        f.write("\twire Shared_Pixel_0_valid_in_wr[`PE_NUM-1:0];\n")
        f.write("\twire signed [`WORD_BITS-1:0] Shared_Pixel_1_in_wr[`PE_NUM-1:0];\n")
        f.write("\twire Shared_Pixel_1_valid_in_wr[`PE_NUM-1:0];\n")
        f.write("\twire signed [`WORD_BITS-1:0] Shared_Pixel_2_in_wr[`PE_NUM-1:0];\n")
        f.write("\twire Shared_Pixel_2_valid_in_wr[`PE_NUM-1:0];\n\n")

        f.write("\t// Wires nối kết quả tính toán từ PEA 1 cắm thẳng vào LDM của PEA 0\n")
        f.write("\twire signed [`WORD_BITS-1:0] PE1_ALU_out_wr[`PE_NUM-1:0];\n")
        f.write("\twire PE1_ALU_valid_wr[`PE_NUM-1:0];\n")
        f.write("\twire [`D_LDM_BITS+`LDM_ADDR_BITS-1:0] PE1_ALU_addr_wr[`PE_NUM-1:0];\n")
        f.write("\twire PE1_ALU_en_wr[`PE_NUM-1:0];\n\n")

        # 3. Pipeline Registers cho RAM
        f.write("""\t// *************** Register signals *************** //\t\t
\treg \t\t\t\t\t            \t\t\tWeight_valid_1_0_rg, Weight_valid_1_1_rg;
\treg \t\t\t\t\t            \t\t\tBias_valid_1_0_rg, Bias_valid_1_1_rg;
\treg signed [`WORD_BITS-1:0]             \t\tWeight_0_rg, Weight_1_rg;
\treg signed [`WORD_BITS-1:0]             \t\tBias_0_rg, Bias_1_rg;
\treg \t\t\t\t\t            \t\t\tWeight_valid_2_0_rg, Weight_valid_2_1_rg;
\treg \t\t\t\t\t            \t\t\tBias_valid_2_0_rg, Bias_valid_2_1_rg;
\treg  [`CRAM_ADDR_BITS-1:0]\t          \t\t\tCTX_maxaddra_rg;
\treg [`PE_NUM_BITS-1:0]  \t\t\t\t\t\tMUX_Selection_rg;
\t
\tassign complete_out\t\t= complete_wr;

\t// LDM Output AXI chỉ cần lấy từ PEA 0
\tassign AXI_LDM_douta_out = """)
        for i in range(40):
            if i == 39:
                f.write(f"AXI_LDM_douta_out_wr[{i}];\n\n")
            else:
                f.write(f"AXI_LDM_douta_out_wr[{i}] | ")
                if i % 8 == 7: f.write("\n\t\t\t\t\t\t   ")
        
        f.write("""\talways @(posedge CLK or negedge RST) begin
\t\tif (~RST) begin
\t\t\tCTX_maxaddra_rg\t\t<= `CRAM_ADDR_BITS'h0;
\t\t\tWeight_valid_1_0_rg\t<= 0; Weight_valid_1_1_rg\t<= 0;
\t\t\tBias_valid_1_0_rg\t<= 0; Bias_valid_1_1_rg\t<= 0;
\t\t\tWeight_valid_2_0_rg\t<= 0; Weight_valid_2_1_rg\t<= 0;
\t\t\tBias_valid_2_0_rg\t<= 0; Bias_valid_2_1_rg\t<= 0;
\t\t\tWeight_0_rg\t\t\t<= 0; Weight_1_rg\t\t\t<= 0;
\t\t\tBias_0_rg\t\t\t<= 0; Bias_1_rg\t\t\t<= 0;
\t\t\tMUX_Selection_rg\t<= 0;
\t\tend
\t\telse begin
\t\t\tWeight_valid_1_0_rg\t<= CTRL_WRAM_enb_0_wr;
\t\t\tWeight_valid_1_1_rg\t<= CTRL_WRAM_enb_1_wr;
\t\t\tBias_valid_1_0_rg\t<= CTRL_BRAM_enb_0_wr;
\t\t\tBias_valid_1_1_rg\t<= CTRL_BRAM_enb_1_wr;
\t\t\t
\t\t\tWeight_valid_2_0_rg\t<= Weight_valid_1_0_rg;
\t\t\tWeight_valid_2_1_rg\t<= Weight_valid_1_1_rg;
\t\t\tBias_valid_2_0_rg\t<= Bias_valid_1_0_rg;
\t\t\tBias_valid_2_1_rg\t<= Bias_valid_1_1_rg;
\t\t\t
\t\t\tif(Weight_valid_1_0_rg) Weight_0_rg <= Weight_0_wr; else Weight_0_rg <= 0;
\t\t\tif(Weight_valid_1_1_rg) Weight_1_rg <= Weight_1_wr; else Weight_1_rg <= 0;
\t\t\tif(Bias_valid_1_0_rg)   Bias_0_rg   <= Bias_0_wr;   else Bias_0_rg   <= 0;
\t\t\tif(Bias_valid_1_1_rg)   Bias_1_rg   <= Bias_1_wr;   else Bias_1_rg   <= 0;
\t\t\t
\t\t\tMUX_Selection_rg\t<= MUX_Selection_wr;
\t\t\tif(AXI_CRAM_ena_in&AXI_CRAM_wea_in) CTX_maxaddra_rg <= AXI_CRAM_addra_in[`CRAM_ADDR_BITS-1:0];
\t\t\telse CTX_maxaddra_rg <= CTX_maxaddra_rg;
\t\tend
\tend\n\n""")

        # 4. RAM Instantiations
        f.write("""\tDual_Port_RAM #(.DWIDTH(`CTX_BITS), .AWIDTH(`CRAM_ADDR_BITS)) CRAM (
\t  .clka(CLK), .ena(AXI_CRAM_ena_in), .wea(AXI_CRAM_wea_in), .addra(AXI_CRAM_addra_in), .dina(AXI_CRAM_dina_in), .douta(),
\t  .clkb(CLK), .enb(CTRL_CRAM_enb_wr), .web(CTRL_CRAM_web_wr), .addrb(CTRL_CRAM_addrb_wr), .dinb(0), .doutb(CTX_wr)
\t);
\t
\tDual_Port_RAM_1W2R #(.DWIDTH(`WORD_BITS), .AWIDTH(`WRAM_ADDR_BITS)) WRAM (
\t  .clk(CLK), 
\t  .axi_we(AXI_WRAM_wea_in), .axi_addr(AXI_WRAM_addra_in), .axi_din(AXI_WRAM_dina_in),
\t  .compute_en(En_wr),
\t  .en_0(CTRL_WRAM_enb_0_wr), .addr_0(CTRL_WRAM_addrb_0_wr), .dout_0(Weight_0_wr),
\t  .en_1(CTRL_WRAM_enb_1_wr), .addr_1(CTRL_WRAM_addrb_1_wr), .dout_1(Weight_1_wr)
\t);

\tDual_Port_RAM_1W2R #(.DWIDTH(`WORD_BITS), .AWIDTH(`BRAM_ADDR_BITS)) BRAM (
\t  .clk(CLK), 
\t  .axi_we(AXI_BRAM_wea_in), .axi_addr(AXI_BRAM_addra_in), .axi_din(AXI_BRAM_dina_in),
\t  .compute_en(En_wr),
\t  .en_0(CTRL_BRAM_enb_0_wr), .addr_0(CTRL_BRAM_addrb_0_wr), .dout_0(Bias_0_wr),
\t  .en_1(CTRL_BRAM_enb_1_wr), .addr_1(CTRL_BRAM_addrb_1_wr), .dout_1(Bias_1_wr)
\t);\n\n""")

        # 5. Controller
        f.write("""\tController controller(
\t\t.CLK(CLK), .RST(RST), .start_in(start_in), .CTX_in(CTX_wr), .CTX_Max_addr_in(CTX_maxaddra_rg),    
\t\t.CTRL_CRAM_addrb_out(CTRL_CRAM_addrb_wr), .CTRL_CRAM_enb_out(CTRL_CRAM_enb_wr), .CTRL_CRAM_web_out(CTRL_CRAM_web_wr),
\t\t.CTRL_WRAM_addrb_0_out(CTRL_WRAM_addrb_0_wr), .CTRL_WRAM_addrb_1_out(CTRL_WRAM_addrb_1_wr),
\t\t.CTRL_WRAM_enb_0_out(CTRL_WRAM_enb_0_wr), .CTRL_WRAM_enb_1_out(CTRL_WRAM_enb_1_wr),
\t\t.CTRL_WRAM_web_0_out(CTRL_WRAM_web_0_wr), .CTRL_WRAM_web_1_out(CTRL_WRAM_web_1_wr),
\t\t.CTRL_BRAM_addrb_0_out(CTRL_BRAM_addrb_0_wr), .CTRL_BRAM_addrb_1_out(CTRL_BRAM_addrb_1_wr), 
\t\t.CTRL_BRAM_enb_0_out(CTRL_BRAM_enb_0_wr), .CTRL_BRAM_enb_1_out(CTRL_BRAM_enb_1_wr), 
\t\t.CTRL_BRAM_web_0_out(CTRL_BRAM_web_0_wr), .CTRL_BRAM_web_1_out(CTRL_BRAM_web_1_wr),
\t\t.CFG_out(CFG_wr), .MUX_Selection_out(MUX_Selection_wr), .Stride_out(Stride_wr), .Overarray_out(Overarray_wr),
\t\t.MP_Padding_out(MP_Padding_wr), .MP_Padding_2_out(MP_Padding_2_wr), .MP_Padding_3_out(MP_Padding_3_wr),
\t\t.En_out(En_wr), .layer_done_out(layer_done_wr), .Parity_PE_Selection_out(Parity_PE_Selection_wr),
\t\t.CTRL_LDM_addra_out(CTRL_LDM_addra_wr), .CTRL_LDM_ena_out(CTRL_LDM_ena_wr), .CTRL_LDM_wea_out(CTRL_LDM_wea_wr),
\t\t.CTRL_LDM_addrb_out(CTRL_LDM_addrb_wr), .CTRL_LDM_enb_out(CTRL_LDM_enb_wr), .CTRL_LDM_web_out(CTRL_LDM_web_wr),
\t\t.CTRL_LDM_Store_out(CTRL_LDM_Store_wr), .CTRL_LDM_Store_1_out(CTRL_LDM_Store_1_wr),
\t\t.Padding_Read_out(Padding_Read_wr), .CTRL_LDM_addra_Incr_out(CTRL_LDM_addra_Incr_wr),
\t\t.complete_out(complete_wr)
\t);\n\n""")

        # 6. Khởi tạo SGB (ĐÃ SỬA THÀNH SGB SGB_INST)
        f.write("\tSGB sgb_inst (\n\t\t.CLK(CLK),\n\t\t.RST(RST),\n")
        # SGB Inputs from PEA 0
        for i in range(40):
            f.write(f"\t\t.PEA0_PE{i}_Pixel_0_in(Pixel_0_out_wr[{i}]),\n")
            f.write(f"\t\t.PEA0_PE{i}_Pixel_0_valid_in(Pixel_0_valid_out_wr[{i}]),\n")
            f.write(f"\t\t.PEA0_PE{i}_Pixel_1_in(Pixel_1_out_wr[{i}]),\n")
            f.write(f"\t\t.PEA0_PE{i}_Pixel_1_valid_in(Pixel_1_valid_out_wr[{i}]),\n")
        
        # SGB Params
        f.write("""\n\t\t.En_in(En_wr),
\t\t.CFG_in(CFG_wr[`ALU_CFG_BITS-2:0]),
\t\t.MUX_Selection_in(MUX_Selection_rg),
\t\t.Parity_PE_Selection_in(Parity_PE_Selection_wr),
\t\t.Stride_in(Stride_wr),
\t\t.MP_Padding_in(MP_Padding_wr),
\t\t.MP_Padding_2_in(MP_Padding_2_wr),
\t\t.MP_Padding_3_in(MP_Padding_3_wr),\n\n""")
        
        # SGB Outputs (Shared)
        for i in range(40):
            f.write(f"\t\t.Shared_PE{i}_Pixel_0_out(Shared_Pixel_0_in_wr[{i}]),\n")
            f.write(f"\t\t.Shared_PE{i}_Pixel_0_valid_out(Shared_Pixel_0_valid_in_wr[{i}]),\n")
            f.write(f"\t\t.Shared_PE{i}_Pixel_1_out(Shared_Pixel_1_in_wr[{i}]),\n")
            f.write(f"\t\t.Shared_PE{i}_Pixel_1_valid_out(Shared_Pixel_1_valid_in_wr[{i}]),\n")
            f.write(f"\t\t.Shared_PE{i}_Pixel_2_out(Shared_Pixel_2_in_wr[{i}]),\n")
            end_char = "," if i < 39 else ""
            f.write(f"\t\t.Shared_PE{i}_Pixel_2_valid_out(Shared_Pixel_2_valid_in_wr[{i}]){end_char}\n")
        f.write("\t);\n\n")

        # 7. Khởi tạo PEA 0 (40 PEs)
        f.write("\t// ==================================================================\n")
        f.write("\t// PEA 0 (Processing Element Array 0) - Channel n (Includes LDM)\n")
        f.write("\t// ==================================================================\n")
        for i in range(40):
            module_name = "PE_RP" if i < 4 else "PE_LP_Last" if i == 39 else "PE_LP" if i > 36 else "PE"
            f.write(f"\t{module_name} #(.UNIT_NO({i})) pea0_{i} (\n")
            f.write("\t\t.CLK(CLK), .RST(RST),\n")
            f.write("\t\t.AXI_LDM_addra_in(AXI_LDM_addra_in), .AXI_LDM_dina_in(AXI_LDM_dina_in),\n")
            f.write("\t\t.AXI_LDM_ena_in(AXI_LDM_ena_in), .AXI_LDM_wea_in(AXI_LDM_wea_in),\n")
            f.write(f"\t\t.AXI_LDM_douta_out(AXI_LDM_douta_out_wr[{i}]),\n")
            f.write("\t\t.layer_done_in(layer_done_wr), .En_in(En_wr), .CFG_in(CFG_wr),\n")
            f.write("\t\t.Parity_PE_Selection_in(Parity_PE_Selection_wr),\n")
            f.write("\t\t.CTRL_LDM_addra_in(CTRL_LDM_addra_wr), .CTRL_LDM_ena_in(CTRL_LDM_ena_wr), .CTRL_LDM_wea_in(CTRL_LDM_wea_wr),\n")
            f.write("\t\t.CTRL_LDM_addrb_in(CTRL_LDM_addrb_wr), .CTRL_LDM_enb_in(CTRL_LDM_enb_wr), .CTRL_LDM_web_in(CTRL_LDM_web_wr),\n")
            f.write("\t\t.CTRL_LDM_Store_in(CTRL_LDM_Store_wr), .Stride_in(Stride_wr),\n")
            if i == 39:
                f.write("\t\t.Overarray_in(Overarray_wr),\n")
            f.write(f"\t\t.Padding_Read_in(Padding_Read_wr[{i}]),\n")
            f.write(f"\t\t.CTRL_LDM_addra_Incr_in(CTRL_LDM_addra_Incr_wr[{i}]),\n")
            
            # WRAM/BRAM (Branch 0)
            f.write("\t\t.Weight_valid_in(Weight_valid_2_0_rg), .Weight_in(Weight_0_rg),\n")
            f.write("\t\t.Bias_valid_in(Bias_valid_2_0_rg), .Bias_in(Bias_0_rg),\n")
            
            # Pixel Inputs (From SGB)
            f.write(f"\t\t.Pixel_0_valid_in(Shared_Pixel_0_valid_in_wr[{i}]), .Pixel_0_in(Shared_Pixel_0_in_wr[{i}]),\n")
            f.write(f"\t\t.Pixel_1_valid_in(Shared_Pixel_1_valid_in_wr[{i}]), .Pixel_1_in(Shared_Pixel_1_in_wr[{i}]),\n")
            f.write(f"\t\t.Pixel_2_valid_in(Shared_Pixel_2_valid_in_wr[{i}]), .Pixel_2_in(Shared_Pixel_2_in_wr[{i}]),\n")
            
            # Pixel Outputs (To SGB)
            f.write(f"\t\t.Pixel_0_out(Pixel_0_out_wr[{i}]), .Pixel_0_valid_out(Pixel_0_valid_out_wr[{i}]),\n")
            f.write(f"\t\t.Pixel_1_out(Pixel_1_out_wr[{i}]), .Pixel_1_valid_out(Pixel_1_valid_out_wr[{i}]),\n")

            # ALU Data from PEA 1 to write into PEA 0's LDM
            f.write(f"\t\t.PE1_ALU_out_in(PE1_ALU_out_wr[{i}]),\n")
            f.write(f"\t\t.PE1_ALU_valid_in(PE1_ALU_valid_wr[{i}]),\n")
            f.write(f"\t\t.PE1_ALU_addr_in(PE1_ALU_addr_wr[{i}]),\n")
            f.write(f"\t\t.PE1_ALU_en_in(PE1_ALU_en_wr[{i}])\n")
            f.write("\t);\n\n")

        # 8. Khởi tạo PEA 1 (40 PE_lite)
        f.write("\t// ==================================================================\n")
        f.write("\t// PEA 1 (Processing Element Array 1) - Channel n+1 (No LDM)\n")
        f.write("\t// ==================================================================\n")
        for i in range(40):
            f.write(f"\tPE_lite #(.UNIT_NO({i})) pea1_{i} (\n")
            f.write("\t\t.CLK(CLK), .RST(RST),\n")
            f.write("\t\t.En_in(En_wr), .layer_done_in(layer_done_wr), .CFG_in(CFG_wr),\n")
            
            # LDM Store control for PEA 1
            f.write("\t\t.CTRL_LDM_Store_in(CTRL_LDM_Store_1_wr),\n")
            
            # WRAM/BRAM (Branch 1)
            f.write("\t\t.Weight_valid_in(Weight_valid_2_1_rg), .Weight_in(Weight_1_rg),\n")
            f.write("\t\t.Bias_valid_in(Bias_valid_2_1_rg), .Bias_in(Bias_1_rg),\n")
            
            # Pixel Inputs (Shared from SGB)
            f.write(f"\t\t.Pixel_0_valid_in(Shared_Pixel_0_valid_in_wr[{i}]), .Pixel_0_in(Shared_Pixel_0_in_wr[{i}]),\n")
            
            # ALU Outputs (Routed directly to PEA 0's LDM)
            f.write(f"\t\t.ALU_out(PE1_ALU_out_wr[{i}]),\n")
            f.write(f"\t\t.ALU_valid_out(PE1_ALU_valid_wr[{i}]),\n")
            f.write(f"\t\t.ALU_addr_out(PE1_ALU_addr_wr[{i}]),\n")
            f.write(f"\t\t.ALU_en_out(PE1_ALU_en_wr[{i}])\n")
            f.write("\t);\n\n")

        f.write("endmodule\n")
    print(f"Đã tạo thành công file {filename}!")

if __name__ == "__main__":
    generate_cnn_core()