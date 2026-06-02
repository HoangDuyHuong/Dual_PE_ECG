`timescale 1ns/1ns
`include "common.vh"

module CNN_1D_Core
(
	//-----------------------------------------------------//
	//          			Input Signals                  // 
	//-----------------------------------------------------//
	///*** From AXI Mapper ***///				
	input  wire                                 	CLK,
	input  wire                                 	RST,
	input  wire [`PE_NUM_BITS+`LDM_NUM_BITS+`LDM_ADDR_BITS-1:0] AXI_LDM_addra_in,
	input  wire signed [`WORD_BITS-1:0]          	AXI_LDM_dina_in,
	input  wire 					              	AXI_LDM_ena_in,
	input  wire 					              	AXI_LDM_wea_in,
	input  wire [`CRAM_ADDR_BITS-1:0] 				AXI_CRAM_addra_in,
	input  wire signed [`CTX_BITS-1:0]          	AXI_CRAM_dina_in,
	input  wire 					              	AXI_CRAM_ena_in,
	input  wire 					              	AXI_CRAM_wea_in,
	input  wire [`WRAM_ADDR_BITS-1:0]   			AXI_WRAM_addra_in,
	input  wire [`WORD_BITS-1:0]              		AXI_WRAM_dina_in,
	input  wire 					              	AXI_WRAM_ena_in,
	input  wire 					              	AXI_WRAM_wea_in,
	input  wire [`BRAM_ADDR_BITS-1:0]   			AXI_BRAM_addra_in,
	input  wire [`WORD_BITS-1:0]              		AXI_BRAM_dina_in,
	input  wire 					              	AXI_BRAM_ena_in,
	input  wire 					              	AXI_BRAM_wea_in,
	input  wire 					              	start_in,

	//-----------------------------------------------------//
	//          			Output Signals                 // 
	//-----------------------------------------------------// 
	///*** To  AXI Mapper  ***///
	output wire signed [`WORD_BITS-1:0]          	AXI_LDM_douta_out,
	output wire 						       		complete_out  
);

// *************** Wire signals *************** //
	wire [`CTX_BITS-1:0]             				CTX_wr;
	wire [`CRAM_ADDR_BITS-1:0] 						CTRL_CRAM_addrb_wr;
	wire 					              			CTRL_CRAM_enb_wr;
	wire 					              			CTRL_CRAM_web_wr;

	wire [`WRAM_ADDR_BITS-1:0] 						CTRL_WRAM_addrb_0_wr, CTRL_WRAM_addrb_1_wr;
	wire 					              			CTRL_WRAM_enb_0_wr, CTRL_WRAM_enb_1_wr;
	wire 					              			CTRL_WRAM_web_0_wr, CTRL_WRAM_web_1_wr;
	wire signed [`WORD_BITS-1:0]             		Weight_0_wr, Weight_1_wr;

	wire [`BRAM_ADDR_BITS-1:0] 						CTRL_BRAM_addrb_0_wr, CTRL_BRAM_addrb_1_wr;
	wire 					              			CTRL_BRAM_enb_0_wr, CTRL_BRAM_enb_1_wr;
	wire 					              			CTRL_BRAM_web_0_wr, CTRL_BRAM_web_1_wr;
	wire signed [`WORD_BITS-1:0]             		Bias_0_wr, Bias_1_wr;

	wire [`ALU_CFG_BITS-1:0]      					CFG_wr;
	wire [`PE_NUM_BITS-1:0]  						MUX_Selection_wr;
	wire 					              			Stride_wr;
	wire 					              			MP_Padding_wr, MP_Padding_2_wr, MP_Padding_3_wr;
	wire 					              			En_wr, layer_done_wr, Parity_PE_Selection_wr;

	wire [`S_LDM_BITS+`LDM_ADDR_BITS-1:0] 			CTRL_LDM_addra_wr, CTRL_LDM_addrb_wr;
	wire 					              			CTRL_LDM_ena_wr, CTRL_LDM_enb_wr;
	wire 					              			CTRL_LDM_wea_wr, CTRL_LDM_web_wr;

	wire [`D_LDM_BITS+`SA_LDM_BITS-1:0] 			CTRL_LDM_Store_wr, CTRL_LDM_Store_1_wr;
	wire signed [`WORD_BITS-1:0]         			AXI_LDM_douta_out_wr[`PE_NUM-1:0];
	wire											Overarray_wr, complete_wr;
	wire	[`PE_NUM-1:0]							Padding_Read_wr, CTRL_LDM_addra_Incr_wr;

	// Wires cho Pixel LDM xuất ra từ PEA 0
	wire signed [`WORD_BITS-1:0] Pixel_0_out_wr[`PE_NUM-1:0];
	wire Pixel_0_valid_out_wr[`PE_NUM-1:0];
	wire signed [`WORD_BITS-1:0] Pixel_1_out_wr[`PE_NUM-1:0];
	wire Pixel_1_valid_out_wr[`PE_NUM-1:0];

	// Wires cho Shared Pixel phân phối từ SGB đến cả 2 PEA
	wire signed [`WORD_BITS-1:0] Shared_Pixel_0_in_wr[`PE_NUM-1:0];
	wire Shared_Pixel_0_valid_in_wr[`PE_NUM-1:0];
	wire signed [`WORD_BITS-1:0] Shared_Pixel_1_in_wr[`PE_NUM-1:0];
	wire Shared_Pixel_1_valid_in_wr[`PE_NUM-1:0];
	wire signed [`WORD_BITS-1:0] Shared_Pixel_2_in_wr[`PE_NUM-1:0];
	wire Shared_Pixel_2_valid_in_wr[`PE_NUM-1:0];

	// Wires nối kết quả tính toán từ PEA 1 cắm thẳng vào LDM của PEA 0
	wire signed [`WORD_BITS-1:0] PE1_ALU_out_wr[`PE_NUM-1:0];
	wire PE1_ALU_valid_wr[`PE_NUM-1:0];
	wire [`D_LDM_BITS+`LDM_ADDR_BITS-1:0] PE1_ALU_addr_wr[`PE_NUM-1:0];
	wire PE1_ALU_en_wr[`PE_NUM-1:0];

	// *************** Register signals *************** //		
	reg 					            			Weight_valid_1_0_rg, Weight_valid_1_1_rg;
	reg 					            			Bias_valid_1_0_rg, Bias_valid_1_1_rg;
	reg signed [`WORD_BITS-1:0]             		Weight_0_rg, Weight_1_rg;
	reg signed [`WORD_BITS-1:0]             		Bias_0_rg, Bias_1_rg;
	reg 					            			Weight_valid_2_0_rg, Weight_valid_2_1_rg;
	reg 					            			Bias_valid_2_0_rg, Bias_valid_2_1_rg;
	reg  [`CRAM_ADDR_BITS-1:0]	          			CTX_maxaddra_rg;
	reg [`PE_NUM_BITS-1:0]  						MUX_Selection_rg;
	
	assign complete_out		= complete_wr;

	// LDM Output AXI chỉ cần lấy từ PEA 0
	assign AXI_LDM_douta_out = AXI_LDM_douta_out_wr[0] | AXI_LDM_douta_out_wr[1] | AXI_LDM_douta_out_wr[2] | AXI_LDM_douta_out_wr[3] | AXI_LDM_douta_out_wr[4] | AXI_LDM_douta_out_wr[5] | AXI_LDM_douta_out_wr[6] | AXI_LDM_douta_out_wr[7] | 
						   AXI_LDM_douta_out_wr[8] | AXI_LDM_douta_out_wr[9] | AXI_LDM_douta_out_wr[10] | AXI_LDM_douta_out_wr[11] | AXI_LDM_douta_out_wr[12] | AXI_LDM_douta_out_wr[13] | AXI_LDM_douta_out_wr[14] | AXI_LDM_douta_out_wr[15] | 
						   AXI_LDM_douta_out_wr[16] | AXI_LDM_douta_out_wr[17] | AXI_LDM_douta_out_wr[18] | AXI_LDM_douta_out_wr[19] | AXI_LDM_douta_out_wr[20] | AXI_LDM_douta_out_wr[21] | AXI_LDM_douta_out_wr[22] | AXI_LDM_douta_out_wr[23] | 
						   AXI_LDM_douta_out_wr[24] | AXI_LDM_douta_out_wr[25] | AXI_LDM_douta_out_wr[26] | AXI_LDM_douta_out_wr[27] | AXI_LDM_douta_out_wr[28] | AXI_LDM_douta_out_wr[29] | AXI_LDM_douta_out_wr[30] | AXI_LDM_douta_out_wr[31] | 
						   AXI_LDM_douta_out_wr[32] | AXI_LDM_douta_out_wr[33] | AXI_LDM_douta_out_wr[34] | AXI_LDM_douta_out_wr[35] | AXI_LDM_douta_out_wr[36] | AXI_LDM_douta_out_wr[37] | AXI_LDM_douta_out_wr[38] | AXI_LDM_douta_out_wr[39];

	always @(posedge CLK or negedge RST) begin
		if (~RST) begin
			CTX_maxaddra_rg		<= `CRAM_ADDR_BITS'h0;
			Weight_valid_1_0_rg	<= 0; Weight_valid_1_1_rg	<= 0;
			Bias_valid_1_0_rg	<= 0; Bias_valid_1_1_rg	<= 0;
			Weight_valid_2_0_rg	<= 0; Weight_valid_2_1_rg	<= 0;
			Bias_valid_2_0_rg	<= 0; Bias_valid_2_1_rg	<= 0;
			Weight_0_rg			<= 0; Weight_1_rg			<= 0;
			Bias_0_rg			<= 0; Bias_1_rg			<= 0;
			MUX_Selection_rg	<= 0;
		end
		else begin
			Weight_valid_1_0_rg	<= CTRL_WRAM_enb_0_wr;
			Weight_valid_1_1_rg	<= CTRL_WRAM_enb_1_wr;
			Bias_valid_1_0_rg	<= CTRL_BRAM_enb_0_wr;
			Bias_valid_1_1_rg	<= CTRL_BRAM_enb_1_wr;
			
			Weight_valid_2_0_rg	<= Weight_valid_1_0_rg;
			Weight_valid_2_1_rg	<= Weight_valid_1_1_rg;
			Bias_valid_2_0_rg	<= Bias_valid_1_0_rg;
			Bias_valid_2_1_rg	<= Bias_valid_1_1_rg;
			
			if(Weight_valid_1_0_rg) Weight_0_rg <= Weight_0_wr; else Weight_0_rg <= 0;
			if(Weight_valid_1_1_rg) Weight_1_rg <= Weight_1_wr; else Weight_1_rg <= 0;
			if(Bias_valid_1_0_rg)   Bias_0_rg   <= Bias_0_wr;   else Bias_0_rg   <= 0;
			if(Bias_valid_1_1_rg)   Bias_1_rg   <= Bias_1_wr;   else Bias_1_rg   <= 0;
			
			MUX_Selection_rg	<= MUX_Selection_wr;
			if(AXI_CRAM_ena_in&AXI_CRAM_wea_in) CTX_maxaddra_rg <= AXI_CRAM_addra_in[`CRAM_ADDR_BITS-1:0];
			else CTX_maxaddra_rg <= CTX_maxaddra_rg;
		end
	end

	Dual_Port_RAM #(.DWIDTH(`CTX_BITS), .AWIDTH(`CRAM_ADDR_BITS)) CRAM (
	  .clka(CLK), .ena(AXI_CRAM_ena_in), .wea(AXI_CRAM_wea_in), .addra(AXI_CRAM_addra_in), .dina(AXI_CRAM_dina_in), .douta(),
	  .clkb(CLK), .enb(CTRL_CRAM_enb_wr), .web(CTRL_CRAM_web_wr), .addrb(CTRL_CRAM_addrb_wr), .dinb(0), .doutb(CTX_wr)
	);
	
	Dual_Port_RAM_1W2R #(.DWIDTH(`WORD_BITS), .AWIDTH(`WRAM_ADDR_BITS)) WRAM (
	  .clk(CLK), 
	  .axi_we(AXI_WRAM_wea_in), .axi_addr(AXI_WRAM_addra_in), .axi_din(AXI_WRAM_dina_in),
	  .compute_en(En_wr),
	  .en_0(CTRL_WRAM_enb_0_wr), .addr_0(CTRL_WRAM_addrb_0_wr), .dout_0(Weight_0_wr),
	  .en_1(CTRL_WRAM_enb_1_wr), .addr_1(CTRL_WRAM_addrb_1_wr), .dout_1(Weight_1_wr)
	);

	Dual_Port_RAM_1W2R #(.DWIDTH(`WORD_BITS), .AWIDTH(`BRAM_ADDR_BITS)) BRAM (
	  .clk(CLK), 
	  .axi_we(AXI_BRAM_wea_in), .axi_addr(AXI_BRAM_addra_in), .axi_din(AXI_BRAM_dina_in),
	  .compute_en(En_wr),
	  .en_0(CTRL_BRAM_enb_0_wr), .addr_0(CTRL_BRAM_addrb_0_wr), .dout_0(Bias_0_wr),
	  .en_1(CTRL_BRAM_enb_1_wr), .addr_1(CTRL_BRAM_addrb_1_wr), .dout_1(Bias_1_wr)
	);

	Controller controller(
		.CLK(CLK), .RST(RST), .start_in(start_in), .CTX_in(CTX_wr), .CTX_Max_addr_in(CTX_maxaddra_rg),    
		.CTRL_CRAM_addrb_out(CTRL_CRAM_addrb_wr), .CTRL_CRAM_enb_out(CTRL_CRAM_enb_wr), .CTRL_CRAM_web_out(CTRL_CRAM_web_wr),
		.CTRL_WRAM_addrb_0_out(CTRL_WRAM_addrb_0_wr), .CTRL_WRAM_addrb_1_out(CTRL_WRAM_addrb_1_wr),
		.CTRL_WRAM_enb_0_out(CTRL_WRAM_enb_0_wr), .CTRL_WRAM_enb_1_out(CTRL_WRAM_enb_1_wr),
		.CTRL_WRAM_web_0_out(CTRL_WRAM_web_0_wr), .CTRL_WRAM_web_1_out(CTRL_WRAM_web_1_wr),
		.CTRL_BRAM_addrb_0_out(CTRL_BRAM_addrb_0_wr), .CTRL_BRAM_addrb_1_out(CTRL_BRAM_addrb_1_wr), 
		.CTRL_BRAM_enb_0_out(CTRL_BRAM_enb_0_wr), .CTRL_BRAM_enb_1_out(CTRL_BRAM_enb_1_wr), 
		.CTRL_BRAM_web_0_out(CTRL_BRAM_web_0_wr), .CTRL_BRAM_web_1_out(CTRL_BRAM_web_1_wr),
		.CFG_out(CFG_wr), .MUX_Selection_out(MUX_Selection_wr), .Stride_out(Stride_wr), .Overarray_out(Overarray_wr),
		.MP_Padding_out(MP_Padding_wr), .MP_Padding_2_out(MP_Padding_2_wr), .MP_Padding_3_out(MP_Padding_3_wr),
		.En_out(En_wr), .layer_done_out(layer_done_wr), .Parity_PE_Selection_out(Parity_PE_Selection_wr),
		.CTRL_LDM_addra_out(CTRL_LDM_addra_wr), .CTRL_LDM_ena_out(CTRL_LDM_ena_wr), .CTRL_LDM_wea_out(CTRL_LDM_wea_wr),
		.CTRL_LDM_addrb_out(CTRL_LDM_addrb_wr), .CTRL_LDM_enb_out(CTRL_LDM_enb_wr), .CTRL_LDM_web_out(CTRL_LDM_web_wr),
		.CTRL_LDM_Store_out(CTRL_LDM_Store_wr), .CTRL_LDM_Store_1_out(CTRL_LDM_Store_1_wr),
		.Padding_Read_out(Padding_Read_wr), .CTRL_LDM_addra_Incr_out(CTRL_LDM_addra_Incr_wr),
		.complete_out(complete_wr)
	);

	SGB sgb_inst (
		.CLK(CLK),
		.RST(RST),
		.PEA0_PE0_Pixel_0_in(Pixel_0_out_wr[0]),
		.PEA0_PE0_Pixel_0_valid_in(Pixel_0_valid_out_wr[0]),
		.PEA0_PE0_Pixel_1_in(Pixel_1_out_wr[0]),
		.PEA0_PE0_Pixel_1_valid_in(Pixel_1_valid_out_wr[0]),
		.PEA0_PE1_Pixel_0_in(Pixel_0_out_wr[1]),
		.PEA0_PE1_Pixel_0_valid_in(Pixel_0_valid_out_wr[1]),
		.PEA0_PE1_Pixel_1_in(Pixel_1_out_wr[1]),
		.PEA0_PE1_Pixel_1_valid_in(Pixel_1_valid_out_wr[1]),
		.PEA0_PE2_Pixel_0_in(Pixel_0_out_wr[2]),
		.PEA0_PE2_Pixel_0_valid_in(Pixel_0_valid_out_wr[2]),
		.PEA0_PE2_Pixel_1_in(Pixel_1_out_wr[2]),
		.PEA0_PE2_Pixel_1_valid_in(Pixel_1_valid_out_wr[2]),
		.PEA0_PE3_Pixel_0_in(Pixel_0_out_wr[3]),
		.PEA0_PE3_Pixel_0_valid_in(Pixel_0_valid_out_wr[3]),
		.PEA0_PE3_Pixel_1_in(Pixel_1_out_wr[3]),
		.PEA0_PE3_Pixel_1_valid_in(Pixel_1_valid_out_wr[3]),
		.PEA0_PE4_Pixel_0_in(Pixel_0_out_wr[4]),
		.PEA0_PE4_Pixel_0_valid_in(Pixel_0_valid_out_wr[4]),
		.PEA0_PE4_Pixel_1_in(Pixel_1_out_wr[4]),
		.PEA0_PE4_Pixel_1_valid_in(Pixel_1_valid_out_wr[4]),
		.PEA0_PE5_Pixel_0_in(Pixel_0_out_wr[5]),
		.PEA0_PE5_Pixel_0_valid_in(Pixel_0_valid_out_wr[5]),
		.PEA0_PE5_Pixel_1_in(Pixel_1_out_wr[5]),
		.PEA0_PE5_Pixel_1_valid_in(Pixel_1_valid_out_wr[5]),
		.PEA0_PE6_Pixel_0_in(Pixel_0_out_wr[6]),
		.PEA0_PE6_Pixel_0_valid_in(Pixel_0_valid_out_wr[6]),
		.PEA0_PE6_Pixel_1_in(Pixel_1_out_wr[6]),
		.PEA0_PE6_Pixel_1_valid_in(Pixel_1_valid_out_wr[6]),
		.PEA0_PE7_Pixel_0_in(Pixel_0_out_wr[7]),
		.PEA0_PE7_Pixel_0_valid_in(Pixel_0_valid_out_wr[7]),
		.PEA0_PE7_Pixel_1_in(Pixel_1_out_wr[7]),
		.PEA0_PE7_Pixel_1_valid_in(Pixel_1_valid_out_wr[7]),
		.PEA0_PE8_Pixel_0_in(Pixel_0_out_wr[8]),
		.PEA0_PE8_Pixel_0_valid_in(Pixel_0_valid_out_wr[8]),
		.PEA0_PE8_Pixel_1_in(Pixel_1_out_wr[8]),
		.PEA0_PE8_Pixel_1_valid_in(Pixel_1_valid_out_wr[8]),
		.PEA0_PE9_Pixel_0_in(Pixel_0_out_wr[9]),
		.PEA0_PE9_Pixel_0_valid_in(Pixel_0_valid_out_wr[9]),
		.PEA0_PE9_Pixel_1_in(Pixel_1_out_wr[9]),
		.PEA0_PE9_Pixel_1_valid_in(Pixel_1_valid_out_wr[9]),
		.PEA0_PE10_Pixel_0_in(Pixel_0_out_wr[10]),
		.PEA0_PE10_Pixel_0_valid_in(Pixel_0_valid_out_wr[10]),
		.PEA0_PE10_Pixel_1_in(Pixel_1_out_wr[10]),
		.PEA0_PE10_Pixel_1_valid_in(Pixel_1_valid_out_wr[10]),
		.PEA0_PE11_Pixel_0_in(Pixel_0_out_wr[11]),
		.PEA0_PE11_Pixel_0_valid_in(Pixel_0_valid_out_wr[11]),
		.PEA0_PE11_Pixel_1_in(Pixel_1_out_wr[11]),
		.PEA0_PE11_Pixel_1_valid_in(Pixel_1_valid_out_wr[11]),
		.PEA0_PE12_Pixel_0_in(Pixel_0_out_wr[12]),
		.PEA0_PE12_Pixel_0_valid_in(Pixel_0_valid_out_wr[12]),
		.PEA0_PE12_Pixel_1_in(Pixel_1_out_wr[12]),
		.PEA0_PE12_Pixel_1_valid_in(Pixel_1_valid_out_wr[12]),
		.PEA0_PE13_Pixel_0_in(Pixel_0_out_wr[13]),
		.PEA0_PE13_Pixel_0_valid_in(Pixel_0_valid_out_wr[13]),
		.PEA0_PE13_Pixel_1_in(Pixel_1_out_wr[13]),
		.PEA0_PE13_Pixel_1_valid_in(Pixel_1_valid_out_wr[13]),
		.PEA0_PE14_Pixel_0_in(Pixel_0_out_wr[14]),
		.PEA0_PE14_Pixel_0_valid_in(Pixel_0_valid_out_wr[14]),
		.PEA0_PE14_Pixel_1_in(Pixel_1_out_wr[14]),
		.PEA0_PE14_Pixel_1_valid_in(Pixel_1_valid_out_wr[14]),
		.PEA0_PE15_Pixel_0_in(Pixel_0_out_wr[15]),
		.PEA0_PE15_Pixel_0_valid_in(Pixel_0_valid_out_wr[15]),
		.PEA0_PE15_Pixel_1_in(Pixel_1_out_wr[15]),
		.PEA0_PE15_Pixel_1_valid_in(Pixel_1_valid_out_wr[15]),
		.PEA0_PE16_Pixel_0_in(Pixel_0_out_wr[16]),
		.PEA0_PE16_Pixel_0_valid_in(Pixel_0_valid_out_wr[16]),
		.PEA0_PE16_Pixel_1_in(Pixel_1_out_wr[16]),
		.PEA0_PE16_Pixel_1_valid_in(Pixel_1_valid_out_wr[16]),
		.PEA0_PE17_Pixel_0_in(Pixel_0_out_wr[17]),
		.PEA0_PE17_Pixel_0_valid_in(Pixel_0_valid_out_wr[17]),
		.PEA0_PE17_Pixel_1_in(Pixel_1_out_wr[17]),
		.PEA0_PE17_Pixel_1_valid_in(Pixel_1_valid_out_wr[17]),
		.PEA0_PE18_Pixel_0_in(Pixel_0_out_wr[18]),
		.PEA0_PE18_Pixel_0_valid_in(Pixel_0_valid_out_wr[18]),
		.PEA0_PE18_Pixel_1_in(Pixel_1_out_wr[18]),
		.PEA0_PE18_Pixel_1_valid_in(Pixel_1_valid_out_wr[18]),
		.PEA0_PE19_Pixel_0_in(Pixel_0_out_wr[19]),
		.PEA0_PE19_Pixel_0_valid_in(Pixel_0_valid_out_wr[19]),
		.PEA0_PE19_Pixel_1_in(Pixel_1_out_wr[19]),
		.PEA0_PE19_Pixel_1_valid_in(Pixel_1_valid_out_wr[19]),
		.PEA0_PE20_Pixel_0_in(Pixel_0_out_wr[20]),
		.PEA0_PE20_Pixel_0_valid_in(Pixel_0_valid_out_wr[20]),
		.PEA0_PE20_Pixel_1_in(Pixel_1_out_wr[20]),
		.PEA0_PE20_Pixel_1_valid_in(Pixel_1_valid_out_wr[20]),
		.PEA0_PE21_Pixel_0_in(Pixel_0_out_wr[21]),
		.PEA0_PE21_Pixel_0_valid_in(Pixel_0_valid_out_wr[21]),
		.PEA0_PE21_Pixel_1_in(Pixel_1_out_wr[21]),
		.PEA0_PE21_Pixel_1_valid_in(Pixel_1_valid_out_wr[21]),
		.PEA0_PE22_Pixel_0_in(Pixel_0_out_wr[22]),
		.PEA0_PE22_Pixel_0_valid_in(Pixel_0_valid_out_wr[22]),
		.PEA0_PE22_Pixel_1_in(Pixel_1_out_wr[22]),
		.PEA0_PE22_Pixel_1_valid_in(Pixel_1_valid_out_wr[22]),
		.PEA0_PE23_Pixel_0_in(Pixel_0_out_wr[23]),
		.PEA0_PE23_Pixel_0_valid_in(Pixel_0_valid_out_wr[23]),
		.PEA0_PE23_Pixel_1_in(Pixel_1_out_wr[23]),
		.PEA0_PE23_Pixel_1_valid_in(Pixel_1_valid_out_wr[23]),
		.PEA0_PE24_Pixel_0_in(Pixel_0_out_wr[24]),
		.PEA0_PE24_Pixel_0_valid_in(Pixel_0_valid_out_wr[24]),
		.PEA0_PE24_Pixel_1_in(Pixel_1_out_wr[24]),
		.PEA0_PE24_Pixel_1_valid_in(Pixel_1_valid_out_wr[24]),
		.PEA0_PE25_Pixel_0_in(Pixel_0_out_wr[25]),
		.PEA0_PE25_Pixel_0_valid_in(Pixel_0_valid_out_wr[25]),
		.PEA0_PE25_Pixel_1_in(Pixel_1_out_wr[25]),
		.PEA0_PE25_Pixel_1_valid_in(Pixel_1_valid_out_wr[25]),
		.PEA0_PE26_Pixel_0_in(Pixel_0_out_wr[26]),
		.PEA0_PE26_Pixel_0_valid_in(Pixel_0_valid_out_wr[26]),
		.PEA0_PE26_Pixel_1_in(Pixel_1_out_wr[26]),
		.PEA0_PE26_Pixel_1_valid_in(Pixel_1_valid_out_wr[26]),
		.PEA0_PE27_Pixel_0_in(Pixel_0_out_wr[27]),
		.PEA0_PE27_Pixel_0_valid_in(Pixel_0_valid_out_wr[27]),
		.PEA0_PE27_Pixel_1_in(Pixel_1_out_wr[27]),
		.PEA0_PE27_Pixel_1_valid_in(Pixel_1_valid_out_wr[27]),
		.PEA0_PE28_Pixel_0_in(Pixel_0_out_wr[28]),
		.PEA0_PE28_Pixel_0_valid_in(Pixel_0_valid_out_wr[28]),
		.PEA0_PE28_Pixel_1_in(Pixel_1_out_wr[28]),
		.PEA0_PE28_Pixel_1_valid_in(Pixel_1_valid_out_wr[28]),
		.PEA0_PE29_Pixel_0_in(Pixel_0_out_wr[29]),
		.PEA0_PE29_Pixel_0_valid_in(Pixel_0_valid_out_wr[29]),
		.PEA0_PE29_Pixel_1_in(Pixel_1_out_wr[29]),
		.PEA0_PE29_Pixel_1_valid_in(Pixel_1_valid_out_wr[29]),
		.PEA0_PE30_Pixel_0_in(Pixel_0_out_wr[30]),
		.PEA0_PE30_Pixel_0_valid_in(Pixel_0_valid_out_wr[30]),
		.PEA0_PE30_Pixel_1_in(Pixel_1_out_wr[30]),
		.PEA0_PE30_Pixel_1_valid_in(Pixel_1_valid_out_wr[30]),
		.PEA0_PE31_Pixel_0_in(Pixel_0_out_wr[31]),
		.PEA0_PE31_Pixel_0_valid_in(Pixel_0_valid_out_wr[31]),
		.PEA0_PE31_Pixel_1_in(Pixel_1_out_wr[31]),
		.PEA0_PE31_Pixel_1_valid_in(Pixel_1_valid_out_wr[31]),
		.PEA0_PE32_Pixel_0_in(Pixel_0_out_wr[32]),
		.PEA0_PE32_Pixel_0_valid_in(Pixel_0_valid_out_wr[32]),
		.PEA0_PE32_Pixel_1_in(Pixel_1_out_wr[32]),
		.PEA0_PE32_Pixel_1_valid_in(Pixel_1_valid_out_wr[32]),
		.PEA0_PE33_Pixel_0_in(Pixel_0_out_wr[33]),
		.PEA0_PE33_Pixel_0_valid_in(Pixel_0_valid_out_wr[33]),
		.PEA0_PE33_Pixel_1_in(Pixel_1_out_wr[33]),
		.PEA0_PE33_Pixel_1_valid_in(Pixel_1_valid_out_wr[33]),
		.PEA0_PE34_Pixel_0_in(Pixel_0_out_wr[34]),
		.PEA0_PE34_Pixel_0_valid_in(Pixel_0_valid_out_wr[34]),
		.PEA0_PE34_Pixel_1_in(Pixel_1_out_wr[34]),
		.PEA0_PE34_Pixel_1_valid_in(Pixel_1_valid_out_wr[34]),
		.PEA0_PE35_Pixel_0_in(Pixel_0_out_wr[35]),
		.PEA0_PE35_Pixel_0_valid_in(Pixel_0_valid_out_wr[35]),
		.PEA0_PE35_Pixel_1_in(Pixel_1_out_wr[35]),
		.PEA0_PE35_Pixel_1_valid_in(Pixel_1_valid_out_wr[35]),
		.PEA0_PE36_Pixel_0_in(Pixel_0_out_wr[36]),
		.PEA0_PE36_Pixel_0_valid_in(Pixel_0_valid_out_wr[36]),
		.PEA0_PE36_Pixel_1_in(Pixel_1_out_wr[36]),
		.PEA0_PE36_Pixel_1_valid_in(Pixel_1_valid_out_wr[36]),
		.PEA0_PE37_Pixel_0_in(Pixel_0_out_wr[37]),
		.PEA0_PE37_Pixel_0_valid_in(Pixel_0_valid_out_wr[37]),
		.PEA0_PE37_Pixel_1_in(Pixel_1_out_wr[37]),
		.PEA0_PE37_Pixel_1_valid_in(Pixel_1_valid_out_wr[37]),
		.PEA0_PE38_Pixel_0_in(Pixel_0_out_wr[38]),
		.PEA0_PE38_Pixel_0_valid_in(Pixel_0_valid_out_wr[38]),
		.PEA0_PE38_Pixel_1_in(Pixel_1_out_wr[38]),
		.PEA0_PE38_Pixel_1_valid_in(Pixel_1_valid_out_wr[38]),
		.PEA0_PE39_Pixel_0_in(Pixel_0_out_wr[39]),
		.PEA0_PE39_Pixel_0_valid_in(Pixel_0_valid_out_wr[39]),
		.PEA0_PE39_Pixel_1_in(Pixel_1_out_wr[39]),
		.PEA0_PE39_Pixel_1_valid_in(Pixel_1_valid_out_wr[39]),

		.En_in(En_wr),
		.CFG_in(CFG_wr[`ALU_CFG_BITS-2:0]),
		.MUX_Selection_in(MUX_Selection_rg),
		.Parity_PE_Selection_in(Parity_PE_Selection_wr),
		.Stride_in(Stride_wr),
		.MP_Padding_in(MP_Padding_wr),
		.MP_Padding_2_in(MP_Padding_2_wr),
		.MP_Padding_3_in(MP_Padding_3_wr),

		.Shared_PE0_Pixel_0_out(Shared_Pixel_0_in_wr[0]),
		.Shared_PE0_Pixel_0_valid_out(Shared_Pixel_0_valid_in_wr[0]),
		.Shared_PE0_Pixel_1_out(Shared_Pixel_1_in_wr[0]),
		.Shared_PE0_Pixel_1_valid_out(Shared_Pixel_1_valid_in_wr[0]),
		.Shared_PE0_Pixel_2_out(Shared_Pixel_2_in_wr[0]),
		.Shared_PE0_Pixel_2_valid_out(Shared_Pixel_2_valid_in_wr[0]),
		.Shared_PE1_Pixel_0_out(Shared_Pixel_0_in_wr[1]),
		.Shared_PE1_Pixel_0_valid_out(Shared_Pixel_0_valid_in_wr[1]),
		.Shared_PE1_Pixel_1_out(Shared_Pixel_1_in_wr[1]),
		.Shared_PE1_Pixel_1_valid_out(Shared_Pixel_1_valid_in_wr[1]),
		.Shared_PE1_Pixel_2_out(Shared_Pixel_2_in_wr[1]),
		.Shared_PE1_Pixel_2_valid_out(Shared_Pixel_2_valid_in_wr[1]),
		.Shared_PE2_Pixel_0_out(Shared_Pixel_0_in_wr[2]),
		.Shared_PE2_Pixel_0_valid_out(Shared_Pixel_0_valid_in_wr[2]),
		.Shared_PE2_Pixel_1_out(Shared_Pixel_1_in_wr[2]),
		.Shared_PE2_Pixel_1_valid_out(Shared_Pixel_1_valid_in_wr[2]),
		.Shared_PE2_Pixel_2_out(Shared_Pixel_2_in_wr[2]),
		.Shared_PE2_Pixel_2_valid_out(Shared_Pixel_2_valid_in_wr[2]),
		.Shared_PE3_Pixel_0_out(Shared_Pixel_0_in_wr[3]),
		.Shared_PE3_Pixel_0_valid_out(Shared_Pixel_0_valid_in_wr[3]),
		.Shared_PE3_Pixel_1_out(Shared_Pixel_1_in_wr[3]),
		.Shared_PE3_Pixel_1_valid_out(Shared_Pixel_1_valid_in_wr[3]),
		.Shared_PE3_Pixel_2_out(Shared_Pixel_2_in_wr[3]),
		.Shared_PE3_Pixel_2_valid_out(Shared_Pixel_2_valid_in_wr[3]),
		.Shared_PE4_Pixel_0_out(Shared_Pixel_0_in_wr[4]),
		.Shared_PE4_Pixel_0_valid_out(Shared_Pixel_0_valid_in_wr[4]),
		.Shared_PE4_Pixel_1_out(Shared_Pixel_1_in_wr[4]),
		.Shared_PE4_Pixel_1_valid_out(Shared_Pixel_1_valid_in_wr[4]),
		.Shared_PE4_Pixel_2_out(Shared_Pixel_2_in_wr[4]),
		.Shared_PE4_Pixel_2_valid_out(Shared_Pixel_2_valid_in_wr[4]),
		.Shared_PE5_Pixel_0_out(Shared_Pixel_0_in_wr[5]),
		.Shared_PE5_Pixel_0_valid_out(Shared_Pixel_0_valid_in_wr[5]),
		.Shared_PE5_Pixel_1_out(Shared_Pixel_1_in_wr[5]),
		.Shared_PE5_Pixel_1_valid_out(Shared_Pixel_1_valid_in_wr[5]),
		.Shared_PE5_Pixel_2_out(Shared_Pixel_2_in_wr[5]),
		.Shared_PE5_Pixel_2_valid_out(Shared_Pixel_2_valid_in_wr[5]),
		.Shared_PE6_Pixel_0_out(Shared_Pixel_0_in_wr[6]),
		.Shared_PE6_Pixel_0_valid_out(Shared_Pixel_0_valid_in_wr[6]),
		.Shared_PE6_Pixel_1_out(Shared_Pixel_1_in_wr[6]),
		.Shared_PE6_Pixel_1_valid_out(Shared_Pixel_1_valid_in_wr[6]),
		.Shared_PE6_Pixel_2_out(Shared_Pixel_2_in_wr[6]),
		.Shared_PE6_Pixel_2_valid_out(Shared_Pixel_2_valid_in_wr[6]),
		.Shared_PE7_Pixel_0_out(Shared_Pixel_0_in_wr[7]),
		.Shared_PE7_Pixel_0_valid_out(Shared_Pixel_0_valid_in_wr[7]),
		.Shared_PE7_Pixel_1_out(Shared_Pixel_1_in_wr[7]),
		.Shared_PE7_Pixel_1_valid_out(Shared_Pixel_1_valid_in_wr[7]),
		.Shared_PE7_Pixel_2_out(Shared_Pixel_2_in_wr[7]),
		.Shared_PE7_Pixel_2_valid_out(Shared_Pixel_2_valid_in_wr[7]),
		.Shared_PE8_Pixel_0_out(Shared_Pixel_0_in_wr[8]),
		.Shared_PE8_Pixel_0_valid_out(Shared_Pixel_0_valid_in_wr[8]),
		.Shared_PE8_Pixel_1_out(Shared_Pixel_1_in_wr[8]),
		.Shared_PE8_Pixel_1_valid_out(Shared_Pixel_1_valid_in_wr[8]),
		.Shared_PE8_Pixel_2_out(Shared_Pixel_2_in_wr[8]),
		.Shared_PE8_Pixel_2_valid_out(Shared_Pixel_2_valid_in_wr[8]),
		.Shared_PE9_Pixel_0_out(Shared_Pixel_0_in_wr[9]),
		.Shared_PE9_Pixel_0_valid_out(Shared_Pixel_0_valid_in_wr[9]),
		.Shared_PE9_Pixel_1_out(Shared_Pixel_1_in_wr[9]),
		.Shared_PE9_Pixel_1_valid_out(Shared_Pixel_1_valid_in_wr[9]),
		.Shared_PE9_Pixel_2_out(Shared_Pixel_2_in_wr[9]),
		.Shared_PE9_Pixel_2_valid_out(Shared_Pixel_2_valid_in_wr[9]),
		.Shared_PE10_Pixel_0_out(Shared_Pixel_0_in_wr[10]),
		.Shared_PE10_Pixel_0_valid_out(Shared_Pixel_0_valid_in_wr[10]),
		.Shared_PE10_Pixel_1_out(Shared_Pixel_1_in_wr[10]),
		.Shared_PE10_Pixel_1_valid_out(Shared_Pixel_1_valid_in_wr[10]),
		.Shared_PE10_Pixel_2_out(Shared_Pixel_2_in_wr[10]),
		.Shared_PE10_Pixel_2_valid_out(Shared_Pixel_2_valid_in_wr[10]),
		.Shared_PE11_Pixel_0_out(Shared_Pixel_0_in_wr[11]),
		.Shared_PE11_Pixel_0_valid_out(Shared_Pixel_0_valid_in_wr[11]),
		.Shared_PE11_Pixel_1_out(Shared_Pixel_1_in_wr[11]),
		.Shared_PE11_Pixel_1_valid_out(Shared_Pixel_1_valid_in_wr[11]),
		.Shared_PE11_Pixel_2_out(Shared_Pixel_2_in_wr[11]),
		.Shared_PE11_Pixel_2_valid_out(Shared_Pixel_2_valid_in_wr[11]),
		.Shared_PE12_Pixel_0_out(Shared_Pixel_0_in_wr[12]),
		.Shared_PE12_Pixel_0_valid_out(Shared_Pixel_0_valid_in_wr[12]),
		.Shared_PE12_Pixel_1_out(Shared_Pixel_1_in_wr[12]),
		.Shared_PE12_Pixel_1_valid_out(Shared_Pixel_1_valid_in_wr[12]),
		.Shared_PE12_Pixel_2_out(Shared_Pixel_2_in_wr[12]),
		.Shared_PE12_Pixel_2_valid_out(Shared_Pixel_2_valid_in_wr[12]),
		.Shared_PE13_Pixel_0_out(Shared_Pixel_0_in_wr[13]),
		.Shared_PE13_Pixel_0_valid_out(Shared_Pixel_0_valid_in_wr[13]),
		.Shared_PE13_Pixel_1_out(Shared_Pixel_1_in_wr[13]),
		.Shared_PE13_Pixel_1_valid_out(Shared_Pixel_1_valid_in_wr[13]),
		.Shared_PE13_Pixel_2_out(Shared_Pixel_2_in_wr[13]),
		.Shared_PE13_Pixel_2_valid_out(Shared_Pixel_2_valid_in_wr[13]),
		.Shared_PE14_Pixel_0_out(Shared_Pixel_0_in_wr[14]),
		.Shared_PE14_Pixel_0_valid_out(Shared_Pixel_0_valid_in_wr[14]),
		.Shared_PE14_Pixel_1_out(Shared_Pixel_1_in_wr[14]),
		.Shared_PE14_Pixel_1_valid_out(Shared_Pixel_1_valid_in_wr[14]),
		.Shared_PE14_Pixel_2_out(Shared_Pixel_2_in_wr[14]),
		.Shared_PE14_Pixel_2_valid_out(Shared_Pixel_2_valid_in_wr[14]),
		.Shared_PE15_Pixel_0_out(Shared_Pixel_0_in_wr[15]),
		.Shared_PE15_Pixel_0_valid_out(Shared_Pixel_0_valid_in_wr[15]),
		.Shared_PE15_Pixel_1_out(Shared_Pixel_1_in_wr[15]),
		.Shared_PE15_Pixel_1_valid_out(Shared_Pixel_1_valid_in_wr[15]),
		.Shared_PE15_Pixel_2_out(Shared_Pixel_2_in_wr[15]),
		.Shared_PE15_Pixel_2_valid_out(Shared_Pixel_2_valid_in_wr[15]),
		.Shared_PE16_Pixel_0_out(Shared_Pixel_0_in_wr[16]),
		.Shared_PE16_Pixel_0_valid_out(Shared_Pixel_0_valid_in_wr[16]),
		.Shared_PE16_Pixel_1_out(Shared_Pixel_1_in_wr[16]),
		.Shared_PE16_Pixel_1_valid_out(Shared_Pixel_1_valid_in_wr[16]),
		.Shared_PE16_Pixel_2_out(Shared_Pixel_2_in_wr[16]),
		.Shared_PE16_Pixel_2_valid_out(Shared_Pixel_2_valid_in_wr[16]),
		.Shared_PE17_Pixel_0_out(Shared_Pixel_0_in_wr[17]),
		.Shared_PE17_Pixel_0_valid_out(Shared_Pixel_0_valid_in_wr[17]),
		.Shared_PE17_Pixel_1_out(Shared_Pixel_1_in_wr[17]),
		.Shared_PE17_Pixel_1_valid_out(Shared_Pixel_1_valid_in_wr[17]),
		.Shared_PE17_Pixel_2_out(Shared_Pixel_2_in_wr[17]),
		.Shared_PE17_Pixel_2_valid_out(Shared_Pixel_2_valid_in_wr[17]),
		.Shared_PE18_Pixel_0_out(Shared_Pixel_0_in_wr[18]),
		.Shared_PE18_Pixel_0_valid_out(Shared_Pixel_0_valid_in_wr[18]),
		.Shared_PE18_Pixel_1_out(Shared_Pixel_1_in_wr[18]),
		.Shared_PE18_Pixel_1_valid_out(Shared_Pixel_1_valid_in_wr[18]),
		.Shared_PE18_Pixel_2_out(Shared_Pixel_2_in_wr[18]),
		.Shared_PE18_Pixel_2_valid_out(Shared_Pixel_2_valid_in_wr[18]),
		.Shared_PE19_Pixel_0_out(Shared_Pixel_0_in_wr[19]),
		.Shared_PE19_Pixel_0_valid_out(Shared_Pixel_0_valid_in_wr[19]),
		.Shared_PE19_Pixel_1_out(Shared_Pixel_1_in_wr[19]),
		.Shared_PE19_Pixel_1_valid_out(Shared_Pixel_1_valid_in_wr[19]),
		.Shared_PE19_Pixel_2_out(Shared_Pixel_2_in_wr[19]),
		.Shared_PE19_Pixel_2_valid_out(Shared_Pixel_2_valid_in_wr[19]),
		.Shared_PE20_Pixel_0_out(Shared_Pixel_0_in_wr[20]),
		.Shared_PE20_Pixel_0_valid_out(Shared_Pixel_0_valid_in_wr[20]),
		.Shared_PE20_Pixel_1_out(Shared_Pixel_1_in_wr[20]),
		.Shared_PE20_Pixel_1_valid_out(Shared_Pixel_1_valid_in_wr[20]),
		.Shared_PE20_Pixel_2_out(Shared_Pixel_2_in_wr[20]),
		.Shared_PE20_Pixel_2_valid_out(Shared_Pixel_2_valid_in_wr[20]),
		.Shared_PE21_Pixel_0_out(Shared_Pixel_0_in_wr[21]),
		.Shared_PE21_Pixel_0_valid_out(Shared_Pixel_0_valid_in_wr[21]),
		.Shared_PE21_Pixel_1_out(Shared_Pixel_1_in_wr[21]),
		.Shared_PE21_Pixel_1_valid_out(Shared_Pixel_1_valid_in_wr[21]),
		.Shared_PE21_Pixel_2_out(Shared_Pixel_2_in_wr[21]),
		.Shared_PE21_Pixel_2_valid_out(Shared_Pixel_2_valid_in_wr[21]),
		.Shared_PE22_Pixel_0_out(Shared_Pixel_0_in_wr[22]),
		.Shared_PE22_Pixel_0_valid_out(Shared_Pixel_0_valid_in_wr[22]),
		.Shared_PE22_Pixel_1_out(Shared_Pixel_1_in_wr[22]),
		.Shared_PE22_Pixel_1_valid_out(Shared_Pixel_1_valid_in_wr[22]),
		.Shared_PE22_Pixel_2_out(Shared_Pixel_2_in_wr[22]),
		.Shared_PE22_Pixel_2_valid_out(Shared_Pixel_2_valid_in_wr[22]),
		.Shared_PE23_Pixel_0_out(Shared_Pixel_0_in_wr[23]),
		.Shared_PE23_Pixel_0_valid_out(Shared_Pixel_0_valid_in_wr[23]),
		.Shared_PE23_Pixel_1_out(Shared_Pixel_1_in_wr[23]),
		.Shared_PE23_Pixel_1_valid_out(Shared_Pixel_1_valid_in_wr[23]),
		.Shared_PE23_Pixel_2_out(Shared_Pixel_2_in_wr[23]),
		.Shared_PE23_Pixel_2_valid_out(Shared_Pixel_2_valid_in_wr[23]),
		.Shared_PE24_Pixel_0_out(Shared_Pixel_0_in_wr[24]),
		.Shared_PE24_Pixel_0_valid_out(Shared_Pixel_0_valid_in_wr[24]),
		.Shared_PE24_Pixel_1_out(Shared_Pixel_1_in_wr[24]),
		.Shared_PE24_Pixel_1_valid_out(Shared_Pixel_1_valid_in_wr[24]),
		.Shared_PE24_Pixel_2_out(Shared_Pixel_2_in_wr[24]),
		.Shared_PE24_Pixel_2_valid_out(Shared_Pixel_2_valid_in_wr[24]),
		.Shared_PE25_Pixel_0_out(Shared_Pixel_0_in_wr[25]),
		.Shared_PE25_Pixel_0_valid_out(Shared_Pixel_0_valid_in_wr[25]),
		.Shared_PE25_Pixel_1_out(Shared_Pixel_1_in_wr[25]),
		.Shared_PE25_Pixel_1_valid_out(Shared_Pixel_1_valid_in_wr[25]),
		.Shared_PE25_Pixel_2_out(Shared_Pixel_2_in_wr[25]),
		.Shared_PE25_Pixel_2_valid_out(Shared_Pixel_2_valid_in_wr[25]),
		.Shared_PE26_Pixel_0_out(Shared_Pixel_0_in_wr[26]),
		.Shared_PE26_Pixel_0_valid_out(Shared_Pixel_0_valid_in_wr[26]),
		.Shared_PE26_Pixel_1_out(Shared_Pixel_1_in_wr[26]),
		.Shared_PE26_Pixel_1_valid_out(Shared_Pixel_1_valid_in_wr[26]),
		.Shared_PE26_Pixel_2_out(Shared_Pixel_2_in_wr[26]),
		.Shared_PE26_Pixel_2_valid_out(Shared_Pixel_2_valid_in_wr[26]),
		.Shared_PE27_Pixel_0_out(Shared_Pixel_0_in_wr[27]),
		.Shared_PE27_Pixel_0_valid_out(Shared_Pixel_0_valid_in_wr[27]),
		.Shared_PE27_Pixel_1_out(Shared_Pixel_1_in_wr[27]),
		.Shared_PE27_Pixel_1_valid_out(Shared_Pixel_1_valid_in_wr[27]),
		.Shared_PE27_Pixel_2_out(Shared_Pixel_2_in_wr[27]),
		.Shared_PE27_Pixel_2_valid_out(Shared_Pixel_2_valid_in_wr[27]),
		.Shared_PE28_Pixel_0_out(Shared_Pixel_0_in_wr[28]),
		.Shared_PE28_Pixel_0_valid_out(Shared_Pixel_0_valid_in_wr[28]),
		.Shared_PE28_Pixel_1_out(Shared_Pixel_1_in_wr[28]),
		.Shared_PE28_Pixel_1_valid_out(Shared_Pixel_1_valid_in_wr[28]),
		.Shared_PE28_Pixel_2_out(Shared_Pixel_2_in_wr[28]),
		.Shared_PE28_Pixel_2_valid_out(Shared_Pixel_2_valid_in_wr[28]),
		.Shared_PE29_Pixel_0_out(Shared_Pixel_0_in_wr[29]),
		.Shared_PE29_Pixel_0_valid_out(Shared_Pixel_0_valid_in_wr[29]),
		.Shared_PE29_Pixel_1_out(Shared_Pixel_1_in_wr[29]),
		.Shared_PE29_Pixel_1_valid_out(Shared_Pixel_1_valid_in_wr[29]),
		.Shared_PE29_Pixel_2_out(Shared_Pixel_2_in_wr[29]),
		.Shared_PE29_Pixel_2_valid_out(Shared_Pixel_2_valid_in_wr[29]),
		.Shared_PE30_Pixel_0_out(Shared_Pixel_0_in_wr[30]),
		.Shared_PE30_Pixel_0_valid_out(Shared_Pixel_0_valid_in_wr[30]),
		.Shared_PE30_Pixel_1_out(Shared_Pixel_1_in_wr[30]),
		.Shared_PE30_Pixel_1_valid_out(Shared_Pixel_1_valid_in_wr[30]),
		.Shared_PE30_Pixel_2_out(Shared_Pixel_2_in_wr[30]),
		.Shared_PE30_Pixel_2_valid_out(Shared_Pixel_2_valid_in_wr[30]),
		.Shared_PE31_Pixel_0_out(Shared_Pixel_0_in_wr[31]),
		.Shared_PE31_Pixel_0_valid_out(Shared_Pixel_0_valid_in_wr[31]),
		.Shared_PE31_Pixel_1_out(Shared_Pixel_1_in_wr[31]),
		.Shared_PE31_Pixel_1_valid_out(Shared_Pixel_1_valid_in_wr[31]),
		.Shared_PE31_Pixel_2_out(Shared_Pixel_2_in_wr[31]),
		.Shared_PE31_Pixel_2_valid_out(Shared_Pixel_2_valid_in_wr[31]),
		.Shared_PE32_Pixel_0_out(Shared_Pixel_0_in_wr[32]),
		.Shared_PE32_Pixel_0_valid_out(Shared_Pixel_0_valid_in_wr[32]),
		.Shared_PE32_Pixel_1_out(Shared_Pixel_1_in_wr[32]),
		.Shared_PE32_Pixel_1_valid_out(Shared_Pixel_1_valid_in_wr[32]),
		.Shared_PE32_Pixel_2_out(Shared_Pixel_2_in_wr[32]),
		.Shared_PE32_Pixel_2_valid_out(Shared_Pixel_2_valid_in_wr[32]),
		.Shared_PE33_Pixel_0_out(Shared_Pixel_0_in_wr[33]),
		.Shared_PE33_Pixel_0_valid_out(Shared_Pixel_0_valid_in_wr[33]),
		.Shared_PE33_Pixel_1_out(Shared_Pixel_1_in_wr[33]),
		.Shared_PE33_Pixel_1_valid_out(Shared_Pixel_1_valid_in_wr[33]),
		.Shared_PE33_Pixel_2_out(Shared_Pixel_2_in_wr[33]),
		.Shared_PE33_Pixel_2_valid_out(Shared_Pixel_2_valid_in_wr[33]),
		.Shared_PE34_Pixel_0_out(Shared_Pixel_0_in_wr[34]),
		.Shared_PE34_Pixel_0_valid_out(Shared_Pixel_0_valid_in_wr[34]),
		.Shared_PE34_Pixel_1_out(Shared_Pixel_1_in_wr[34]),
		.Shared_PE34_Pixel_1_valid_out(Shared_Pixel_1_valid_in_wr[34]),
		.Shared_PE34_Pixel_2_out(Shared_Pixel_2_in_wr[34]),
		.Shared_PE34_Pixel_2_valid_out(Shared_Pixel_2_valid_in_wr[34]),
		.Shared_PE35_Pixel_0_out(Shared_Pixel_0_in_wr[35]),
		.Shared_PE35_Pixel_0_valid_out(Shared_Pixel_0_valid_in_wr[35]),
		.Shared_PE35_Pixel_1_out(Shared_Pixel_1_in_wr[35]),
		.Shared_PE35_Pixel_1_valid_out(Shared_Pixel_1_valid_in_wr[35]),
		.Shared_PE35_Pixel_2_out(Shared_Pixel_2_in_wr[35]),
		.Shared_PE35_Pixel_2_valid_out(Shared_Pixel_2_valid_in_wr[35]),
		.Shared_PE36_Pixel_0_out(Shared_Pixel_0_in_wr[36]),
		.Shared_PE36_Pixel_0_valid_out(Shared_Pixel_0_valid_in_wr[36]),
		.Shared_PE36_Pixel_1_out(Shared_Pixel_1_in_wr[36]),
		.Shared_PE36_Pixel_1_valid_out(Shared_Pixel_1_valid_in_wr[36]),
		.Shared_PE36_Pixel_2_out(Shared_Pixel_2_in_wr[36]),
		.Shared_PE36_Pixel_2_valid_out(Shared_Pixel_2_valid_in_wr[36]),
		.Shared_PE37_Pixel_0_out(Shared_Pixel_0_in_wr[37]),
		.Shared_PE37_Pixel_0_valid_out(Shared_Pixel_0_valid_in_wr[37]),
		.Shared_PE37_Pixel_1_out(Shared_Pixel_1_in_wr[37]),
		.Shared_PE37_Pixel_1_valid_out(Shared_Pixel_1_valid_in_wr[37]),
		.Shared_PE37_Pixel_2_out(Shared_Pixel_2_in_wr[37]),
		.Shared_PE37_Pixel_2_valid_out(Shared_Pixel_2_valid_in_wr[37]),
		.Shared_PE38_Pixel_0_out(Shared_Pixel_0_in_wr[38]),
		.Shared_PE38_Pixel_0_valid_out(Shared_Pixel_0_valid_in_wr[38]),
		.Shared_PE38_Pixel_1_out(Shared_Pixel_1_in_wr[38]),
		.Shared_PE38_Pixel_1_valid_out(Shared_Pixel_1_valid_in_wr[38]),
		.Shared_PE38_Pixel_2_out(Shared_Pixel_2_in_wr[38]),
		.Shared_PE38_Pixel_2_valid_out(Shared_Pixel_2_valid_in_wr[38]),
		.Shared_PE39_Pixel_0_out(Shared_Pixel_0_in_wr[39]),
		.Shared_PE39_Pixel_0_valid_out(Shared_Pixel_0_valid_in_wr[39]),
		.Shared_PE39_Pixel_1_out(Shared_Pixel_1_in_wr[39]),
		.Shared_PE39_Pixel_1_valid_out(Shared_Pixel_1_valid_in_wr[39]),
		.Shared_PE39_Pixel_2_out(Shared_Pixel_2_in_wr[39]),
		.Shared_PE39_Pixel_2_valid_out(Shared_Pixel_2_valid_in_wr[39])
	);

	// ==================================================================
	// PEA 0 (Processing Element Array 0) - Channel n (Includes LDM)
	// ==================================================================
	PE_RP #(.UNIT_NO(0)) pea0_0 (
		.CLK(CLK), .RST(RST),
		.AXI_LDM_addra_in(AXI_LDM_addra_in), .AXI_LDM_dina_in(AXI_LDM_dina_in),
		.AXI_LDM_ena_in(AXI_LDM_ena_in), .AXI_LDM_wea_in(AXI_LDM_wea_in),
		.AXI_LDM_douta_out(AXI_LDM_douta_out_wr[0]),
		.layer_done_in(layer_done_wr), .En_in(En_wr), .CFG_in(CFG_wr),
		.Parity_PE_Selection_in(Parity_PE_Selection_wr),
		.CTRL_LDM_addra_in(CTRL_LDM_addra_wr), .CTRL_LDM_ena_in(CTRL_LDM_ena_wr), .CTRL_LDM_wea_in(CTRL_LDM_wea_wr),
		.CTRL_LDM_addrb_in(CTRL_LDM_addrb_wr), .CTRL_LDM_enb_in(CTRL_LDM_enb_wr), .CTRL_LDM_web_in(CTRL_LDM_web_wr),
		.CTRL_LDM_Store_in(CTRL_LDM_Store_wr), .Stride_in(Stride_wr),
		.Padding_Read_in(Padding_Read_wr[0]),
		.CTRL_LDM_addra_Incr_in(CTRL_LDM_addra_Incr_wr[0]),
		.Weight_valid_in(Weight_valid_2_0_rg), .Weight_in(Weight_0_rg),
		.Bias_valid_in(Bias_valid_2_0_rg), .Bias_in(Bias_0_rg),
		.Pixel_0_valid_in(Shared_Pixel_0_valid_in_wr[0]), .Pixel_0_in(Shared_Pixel_0_in_wr[0]),
		.Pixel_1_valid_in(Shared_Pixel_1_valid_in_wr[0]), .Pixel_1_in(Shared_Pixel_1_in_wr[0]),
		.Pixel_2_valid_in(Shared_Pixel_2_valid_in_wr[0]), .Pixel_2_in(Shared_Pixel_2_in_wr[0]),
		.Pixel_0_out(Pixel_0_out_wr[0]), .Pixel_0_valid_out(Pixel_0_valid_out_wr[0]),
		.Pixel_1_out(Pixel_1_out_wr[0]), .Pixel_1_valid_out(Pixel_1_valid_out_wr[0]),
		.PE1_ALU_out_in(PE1_ALU_out_wr[0]),
		.PE1_ALU_valid_in(PE1_ALU_valid_wr[0]),
		.PE1_ALU_addr_in(PE1_ALU_addr_wr[0]),
		.PE1_ALU_en_in(PE1_ALU_en_wr[0])
	);

	PE_RP #(.UNIT_NO(1)) pea0_1 (
		.CLK(CLK), .RST(RST),
		.AXI_LDM_addra_in(AXI_LDM_addra_in), .AXI_LDM_dina_in(AXI_LDM_dina_in),
		.AXI_LDM_ena_in(AXI_LDM_ena_in), .AXI_LDM_wea_in(AXI_LDM_wea_in),
		.AXI_LDM_douta_out(AXI_LDM_douta_out_wr[1]),
		.layer_done_in(layer_done_wr), .En_in(En_wr), .CFG_in(CFG_wr),
		.Parity_PE_Selection_in(Parity_PE_Selection_wr),
		.CTRL_LDM_addra_in(CTRL_LDM_addra_wr), .CTRL_LDM_ena_in(CTRL_LDM_ena_wr), .CTRL_LDM_wea_in(CTRL_LDM_wea_wr),
		.CTRL_LDM_addrb_in(CTRL_LDM_addrb_wr), .CTRL_LDM_enb_in(CTRL_LDM_enb_wr), .CTRL_LDM_web_in(CTRL_LDM_web_wr),
		.CTRL_LDM_Store_in(CTRL_LDM_Store_wr), .Stride_in(Stride_wr),
		.Padding_Read_in(Padding_Read_wr[1]),
		.CTRL_LDM_addra_Incr_in(CTRL_LDM_addra_Incr_wr[1]),
		.Weight_valid_in(Weight_valid_2_0_rg), .Weight_in(Weight_0_rg),
		.Bias_valid_in(Bias_valid_2_0_rg), .Bias_in(Bias_0_rg),
		.Pixel_0_valid_in(Shared_Pixel_0_valid_in_wr[1]), .Pixel_0_in(Shared_Pixel_0_in_wr[1]),
		.Pixel_1_valid_in(Shared_Pixel_1_valid_in_wr[1]), .Pixel_1_in(Shared_Pixel_1_in_wr[1]),
		.Pixel_2_valid_in(Shared_Pixel_2_valid_in_wr[1]), .Pixel_2_in(Shared_Pixel_2_in_wr[1]),
		.Pixel_0_out(Pixel_0_out_wr[1]), .Pixel_0_valid_out(Pixel_0_valid_out_wr[1]),
		.Pixel_1_out(Pixel_1_out_wr[1]), .Pixel_1_valid_out(Pixel_1_valid_out_wr[1]),
		.PE1_ALU_out_in(PE1_ALU_out_wr[1]),
		.PE1_ALU_valid_in(PE1_ALU_valid_wr[1]),
		.PE1_ALU_addr_in(PE1_ALU_addr_wr[1]),
		.PE1_ALU_en_in(PE1_ALU_en_wr[1])
	);

	PE_RP #(.UNIT_NO(2)) pea0_2 (
		.CLK(CLK), .RST(RST),
		.AXI_LDM_addra_in(AXI_LDM_addra_in), .AXI_LDM_dina_in(AXI_LDM_dina_in),
		.AXI_LDM_ena_in(AXI_LDM_ena_in), .AXI_LDM_wea_in(AXI_LDM_wea_in),
		.AXI_LDM_douta_out(AXI_LDM_douta_out_wr[2]),
		.layer_done_in(layer_done_wr), .En_in(En_wr), .CFG_in(CFG_wr),
		.Parity_PE_Selection_in(Parity_PE_Selection_wr),
		.CTRL_LDM_addra_in(CTRL_LDM_addra_wr), .CTRL_LDM_ena_in(CTRL_LDM_ena_wr), .CTRL_LDM_wea_in(CTRL_LDM_wea_wr),
		.CTRL_LDM_addrb_in(CTRL_LDM_addrb_wr), .CTRL_LDM_enb_in(CTRL_LDM_enb_wr), .CTRL_LDM_web_in(CTRL_LDM_web_wr),
		.CTRL_LDM_Store_in(CTRL_LDM_Store_wr), .Stride_in(Stride_wr),
		.Padding_Read_in(Padding_Read_wr[2]),
		.CTRL_LDM_addra_Incr_in(CTRL_LDM_addra_Incr_wr[2]),
		.Weight_valid_in(Weight_valid_2_0_rg), .Weight_in(Weight_0_rg),
		.Bias_valid_in(Bias_valid_2_0_rg), .Bias_in(Bias_0_rg),
		.Pixel_0_valid_in(Shared_Pixel_0_valid_in_wr[2]), .Pixel_0_in(Shared_Pixel_0_in_wr[2]),
		.Pixel_1_valid_in(Shared_Pixel_1_valid_in_wr[2]), .Pixel_1_in(Shared_Pixel_1_in_wr[2]),
		.Pixel_2_valid_in(Shared_Pixel_2_valid_in_wr[2]), .Pixel_2_in(Shared_Pixel_2_in_wr[2]),
		.Pixel_0_out(Pixel_0_out_wr[2]), .Pixel_0_valid_out(Pixel_0_valid_out_wr[2]),
		.Pixel_1_out(Pixel_1_out_wr[2]), .Pixel_1_valid_out(Pixel_1_valid_out_wr[2]),
		.PE1_ALU_out_in(PE1_ALU_out_wr[2]),
		.PE1_ALU_valid_in(PE1_ALU_valid_wr[2]),
		.PE1_ALU_addr_in(PE1_ALU_addr_wr[2]),
		.PE1_ALU_en_in(PE1_ALU_en_wr[2])
	);

	PE_RP #(.UNIT_NO(3)) pea0_3 (
		.CLK(CLK), .RST(RST),
		.AXI_LDM_addra_in(AXI_LDM_addra_in), .AXI_LDM_dina_in(AXI_LDM_dina_in),
		.AXI_LDM_ena_in(AXI_LDM_ena_in), .AXI_LDM_wea_in(AXI_LDM_wea_in),
		.AXI_LDM_douta_out(AXI_LDM_douta_out_wr[3]),
		.layer_done_in(layer_done_wr), .En_in(En_wr), .CFG_in(CFG_wr),
		.Parity_PE_Selection_in(Parity_PE_Selection_wr),
		.CTRL_LDM_addra_in(CTRL_LDM_addra_wr), .CTRL_LDM_ena_in(CTRL_LDM_ena_wr), .CTRL_LDM_wea_in(CTRL_LDM_wea_wr),
		.CTRL_LDM_addrb_in(CTRL_LDM_addrb_wr), .CTRL_LDM_enb_in(CTRL_LDM_enb_wr), .CTRL_LDM_web_in(CTRL_LDM_web_wr),
		.CTRL_LDM_Store_in(CTRL_LDM_Store_wr), .Stride_in(Stride_wr),
		.Padding_Read_in(Padding_Read_wr[3]),
		.CTRL_LDM_addra_Incr_in(CTRL_LDM_addra_Incr_wr[3]),
		.Weight_valid_in(Weight_valid_2_0_rg), .Weight_in(Weight_0_rg),
		.Bias_valid_in(Bias_valid_2_0_rg), .Bias_in(Bias_0_rg),
		.Pixel_0_valid_in(Shared_Pixel_0_valid_in_wr[3]), .Pixel_0_in(Shared_Pixel_0_in_wr[3]),
		.Pixel_1_valid_in(Shared_Pixel_1_valid_in_wr[3]), .Pixel_1_in(Shared_Pixel_1_in_wr[3]),
		.Pixel_2_valid_in(Shared_Pixel_2_valid_in_wr[3]), .Pixel_2_in(Shared_Pixel_2_in_wr[3]),
		.Pixel_0_out(Pixel_0_out_wr[3]), .Pixel_0_valid_out(Pixel_0_valid_out_wr[3]),
		.Pixel_1_out(Pixel_1_out_wr[3]), .Pixel_1_valid_out(Pixel_1_valid_out_wr[3]),
		.PE1_ALU_out_in(PE1_ALU_out_wr[3]),
		.PE1_ALU_valid_in(PE1_ALU_valid_wr[3]),
		.PE1_ALU_addr_in(PE1_ALU_addr_wr[3]),
		.PE1_ALU_en_in(PE1_ALU_en_wr[3])
	);

	PE #(.UNIT_NO(4)) pea0_4 (
		.CLK(CLK), .RST(RST),
		.AXI_LDM_addra_in(AXI_LDM_addra_in), .AXI_LDM_dina_in(AXI_LDM_dina_in),
		.AXI_LDM_ena_in(AXI_LDM_ena_in), .AXI_LDM_wea_in(AXI_LDM_wea_in),
		.AXI_LDM_douta_out(AXI_LDM_douta_out_wr[4]),
		.layer_done_in(layer_done_wr), .En_in(En_wr), .CFG_in(CFG_wr),
		.Parity_PE_Selection_in(Parity_PE_Selection_wr),
		.CTRL_LDM_addra_in(CTRL_LDM_addra_wr), .CTRL_LDM_ena_in(CTRL_LDM_ena_wr), .CTRL_LDM_wea_in(CTRL_LDM_wea_wr),
		.CTRL_LDM_addrb_in(CTRL_LDM_addrb_wr), .CTRL_LDM_enb_in(CTRL_LDM_enb_wr), .CTRL_LDM_web_in(CTRL_LDM_web_wr),
		.CTRL_LDM_Store_in(CTRL_LDM_Store_wr), .Stride_in(Stride_wr),
		.Padding_Read_in(Padding_Read_wr[4]),
		.CTRL_LDM_addra_Incr_in(CTRL_LDM_addra_Incr_wr[4]),
		.Weight_valid_in(Weight_valid_2_0_rg), .Weight_in(Weight_0_rg),
		.Bias_valid_in(Bias_valid_2_0_rg), .Bias_in(Bias_0_rg),
		.Pixel_0_valid_in(Shared_Pixel_0_valid_in_wr[4]), .Pixel_0_in(Shared_Pixel_0_in_wr[4]),
		.Pixel_1_valid_in(Shared_Pixel_1_valid_in_wr[4]), .Pixel_1_in(Shared_Pixel_1_in_wr[4]),
		.Pixel_2_valid_in(Shared_Pixel_2_valid_in_wr[4]), .Pixel_2_in(Shared_Pixel_2_in_wr[4]),
		.Pixel_0_out(Pixel_0_out_wr[4]), .Pixel_0_valid_out(Pixel_0_valid_out_wr[4]),
		.Pixel_1_out(Pixel_1_out_wr[4]), .Pixel_1_valid_out(Pixel_1_valid_out_wr[4]),
		.PE1_ALU_out_in(PE1_ALU_out_wr[4]),
		.PE1_ALU_valid_in(PE1_ALU_valid_wr[4]),
		.PE1_ALU_addr_in(PE1_ALU_addr_wr[4]),
		.PE1_ALU_en_in(PE1_ALU_en_wr[4])
	);

	PE #(.UNIT_NO(5)) pea0_5 (
		.CLK(CLK), .RST(RST),
		.AXI_LDM_addra_in(AXI_LDM_addra_in), .AXI_LDM_dina_in(AXI_LDM_dina_in),
		.AXI_LDM_ena_in(AXI_LDM_ena_in), .AXI_LDM_wea_in(AXI_LDM_wea_in),
		.AXI_LDM_douta_out(AXI_LDM_douta_out_wr[5]),
		.layer_done_in(layer_done_wr), .En_in(En_wr), .CFG_in(CFG_wr),
		.Parity_PE_Selection_in(Parity_PE_Selection_wr),
		.CTRL_LDM_addra_in(CTRL_LDM_addra_wr), .CTRL_LDM_ena_in(CTRL_LDM_ena_wr), .CTRL_LDM_wea_in(CTRL_LDM_wea_wr),
		.CTRL_LDM_addrb_in(CTRL_LDM_addrb_wr), .CTRL_LDM_enb_in(CTRL_LDM_enb_wr), .CTRL_LDM_web_in(CTRL_LDM_web_wr),
		.CTRL_LDM_Store_in(CTRL_LDM_Store_wr), .Stride_in(Stride_wr),
		.Padding_Read_in(Padding_Read_wr[5]),
		.CTRL_LDM_addra_Incr_in(CTRL_LDM_addra_Incr_wr[5]),
		.Weight_valid_in(Weight_valid_2_0_rg), .Weight_in(Weight_0_rg),
		.Bias_valid_in(Bias_valid_2_0_rg), .Bias_in(Bias_0_rg),
		.Pixel_0_valid_in(Shared_Pixel_0_valid_in_wr[5]), .Pixel_0_in(Shared_Pixel_0_in_wr[5]),
		.Pixel_1_valid_in(Shared_Pixel_1_valid_in_wr[5]), .Pixel_1_in(Shared_Pixel_1_in_wr[5]),
		.Pixel_2_valid_in(Shared_Pixel_2_valid_in_wr[5]), .Pixel_2_in(Shared_Pixel_2_in_wr[5]),
		.Pixel_0_out(Pixel_0_out_wr[5]), .Pixel_0_valid_out(Pixel_0_valid_out_wr[5]),
		.Pixel_1_out(Pixel_1_out_wr[5]), .Pixel_1_valid_out(Pixel_1_valid_out_wr[5]),
		.PE1_ALU_out_in(PE1_ALU_out_wr[5]),
		.PE1_ALU_valid_in(PE1_ALU_valid_wr[5]),
		.PE1_ALU_addr_in(PE1_ALU_addr_wr[5]),
		.PE1_ALU_en_in(PE1_ALU_en_wr[5])
	);

	PE #(.UNIT_NO(6)) pea0_6 (
		.CLK(CLK), .RST(RST),
		.AXI_LDM_addra_in(AXI_LDM_addra_in), .AXI_LDM_dina_in(AXI_LDM_dina_in),
		.AXI_LDM_ena_in(AXI_LDM_ena_in), .AXI_LDM_wea_in(AXI_LDM_wea_in),
		.AXI_LDM_douta_out(AXI_LDM_douta_out_wr[6]),
		.layer_done_in(layer_done_wr), .En_in(En_wr), .CFG_in(CFG_wr),
		.Parity_PE_Selection_in(Parity_PE_Selection_wr),
		.CTRL_LDM_addra_in(CTRL_LDM_addra_wr), .CTRL_LDM_ena_in(CTRL_LDM_ena_wr), .CTRL_LDM_wea_in(CTRL_LDM_wea_wr),
		.CTRL_LDM_addrb_in(CTRL_LDM_addrb_wr), .CTRL_LDM_enb_in(CTRL_LDM_enb_wr), .CTRL_LDM_web_in(CTRL_LDM_web_wr),
		.CTRL_LDM_Store_in(CTRL_LDM_Store_wr), .Stride_in(Stride_wr),
		.Padding_Read_in(Padding_Read_wr[6]),
		.CTRL_LDM_addra_Incr_in(CTRL_LDM_addra_Incr_wr[6]),
		.Weight_valid_in(Weight_valid_2_0_rg), .Weight_in(Weight_0_rg),
		.Bias_valid_in(Bias_valid_2_0_rg), .Bias_in(Bias_0_rg),
		.Pixel_0_valid_in(Shared_Pixel_0_valid_in_wr[6]), .Pixel_0_in(Shared_Pixel_0_in_wr[6]),
		.Pixel_1_valid_in(Shared_Pixel_1_valid_in_wr[6]), .Pixel_1_in(Shared_Pixel_1_in_wr[6]),
		.Pixel_2_valid_in(Shared_Pixel_2_valid_in_wr[6]), .Pixel_2_in(Shared_Pixel_2_in_wr[6]),
		.Pixel_0_out(Pixel_0_out_wr[6]), .Pixel_0_valid_out(Pixel_0_valid_out_wr[6]),
		.Pixel_1_out(Pixel_1_out_wr[6]), .Pixel_1_valid_out(Pixel_1_valid_out_wr[6]),
		.PE1_ALU_out_in(PE1_ALU_out_wr[6]),
		.PE1_ALU_valid_in(PE1_ALU_valid_wr[6]),
		.PE1_ALU_addr_in(PE1_ALU_addr_wr[6]),
		.PE1_ALU_en_in(PE1_ALU_en_wr[6])
	);

	PE #(.UNIT_NO(7)) pea0_7 (
		.CLK(CLK), .RST(RST),
		.AXI_LDM_addra_in(AXI_LDM_addra_in), .AXI_LDM_dina_in(AXI_LDM_dina_in),
		.AXI_LDM_ena_in(AXI_LDM_ena_in), .AXI_LDM_wea_in(AXI_LDM_wea_in),
		.AXI_LDM_douta_out(AXI_LDM_douta_out_wr[7]),
		.layer_done_in(layer_done_wr), .En_in(En_wr), .CFG_in(CFG_wr),
		.Parity_PE_Selection_in(Parity_PE_Selection_wr),
		.CTRL_LDM_addra_in(CTRL_LDM_addra_wr), .CTRL_LDM_ena_in(CTRL_LDM_ena_wr), .CTRL_LDM_wea_in(CTRL_LDM_wea_wr),
		.CTRL_LDM_addrb_in(CTRL_LDM_addrb_wr), .CTRL_LDM_enb_in(CTRL_LDM_enb_wr), .CTRL_LDM_web_in(CTRL_LDM_web_wr),
		.CTRL_LDM_Store_in(CTRL_LDM_Store_wr), .Stride_in(Stride_wr),
		.Padding_Read_in(Padding_Read_wr[7]),
		.CTRL_LDM_addra_Incr_in(CTRL_LDM_addra_Incr_wr[7]),
		.Weight_valid_in(Weight_valid_2_0_rg), .Weight_in(Weight_0_rg),
		.Bias_valid_in(Bias_valid_2_0_rg), .Bias_in(Bias_0_rg),
		.Pixel_0_valid_in(Shared_Pixel_0_valid_in_wr[7]), .Pixel_0_in(Shared_Pixel_0_in_wr[7]),
		.Pixel_1_valid_in(Shared_Pixel_1_valid_in_wr[7]), .Pixel_1_in(Shared_Pixel_1_in_wr[7]),
		.Pixel_2_valid_in(Shared_Pixel_2_valid_in_wr[7]), .Pixel_2_in(Shared_Pixel_2_in_wr[7]),
		.Pixel_0_out(Pixel_0_out_wr[7]), .Pixel_0_valid_out(Pixel_0_valid_out_wr[7]),
		.Pixel_1_out(Pixel_1_out_wr[7]), .Pixel_1_valid_out(Pixel_1_valid_out_wr[7]),
		.PE1_ALU_out_in(PE1_ALU_out_wr[7]),
		.PE1_ALU_valid_in(PE1_ALU_valid_wr[7]),
		.PE1_ALU_addr_in(PE1_ALU_addr_wr[7]),
		.PE1_ALU_en_in(PE1_ALU_en_wr[7])
	);

	PE #(.UNIT_NO(8)) pea0_8 (
		.CLK(CLK), .RST(RST),
		.AXI_LDM_addra_in(AXI_LDM_addra_in), .AXI_LDM_dina_in(AXI_LDM_dina_in),
		.AXI_LDM_ena_in(AXI_LDM_ena_in), .AXI_LDM_wea_in(AXI_LDM_wea_in),
		.AXI_LDM_douta_out(AXI_LDM_douta_out_wr[8]),
		.layer_done_in(layer_done_wr), .En_in(En_wr), .CFG_in(CFG_wr),
		.Parity_PE_Selection_in(Parity_PE_Selection_wr),
		.CTRL_LDM_addra_in(CTRL_LDM_addra_wr), .CTRL_LDM_ena_in(CTRL_LDM_ena_wr), .CTRL_LDM_wea_in(CTRL_LDM_wea_wr),
		.CTRL_LDM_addrb_in(CTRL_LDM_addrb_wr), .CTRL_LDM_enb_in(CTRL_LDM_enb_wr), .CTRL_LDM_web_in(CTRL_LDM_web_wr),
		.CTRL_LDM_Store_in(CTRL_LDM_Store_wr), .Stride_in(Stride_wr),
		.Padding_Read_in(Padding_Read_wr[8]),
		.CTRL_LDM_addra_Incr_in(CTRL_LDM_addra_Incr_wr[8]),
		.Weight_valid_in(Weight_valid_2_0_rg), .Weight_in(Weight_0_rg),
		.Bias_valid_in(Bias_valid_2_0_rg), .Bias_in(Bias_0_rg),
		.Pixel_0_valid_in(Shared_Pixel_0_valid_in_wr[8]), .Pixel_0_in(Shared_Pixel_0_in_wr[8]),
		.Pixel_1_valid_in(Shared_Pixel_1_valid_in_wr[8]), .Pixel_1_in(Shared_Pixel_1_in_wr[8]),
		.Pixel_2_valid_in(Shared_Pixel_2_valid_in_wr[8]), .Pixel_2_in(Shared_Pixel_2_in_wr[8]),
		.Pixel_0_out(Pixel_0_out_wr[8]), .Pixel_0_valid_out(Pixel_0_valid_out_wr[8]),
		.Pixel_1_out(Pixel_1_out_wr[8]), .Pixel_1_valid_out(Pixel_1_valid_out_wr[8]),
		.PE1_ALU_out_in(PE1_ALU_out_wr[8]),
		.PE1_ALU_valid_in(PE1_ALU_valid_wr[8]),
		.PE1_ALU_addr_in(PE1_ALU_addr_wr[8]),
		.PE1_ALU_en_in(PE1_ALU_en_wr[8])
	);

	PE #(.UNIT_NO(9)) pea0_9 (
		.CLK(CLK), .RST(RST),
		.AXI_LDM_addra_in(AXI_LDM_addra_in), .AXI_LDM_dina_in(AXI_LDM_dina_in),
		.AXI_LDM_ena_in(AXI_LDM_ena_in), .AXI_LDM_wea_in(AXI_LDM_wea_in),
		.AXI_LDM_douta_out(AXI_LDM_douta_out_wr[9]),
		.layer_done_in(layer_done_wr), .En_in(En_wr), .CFG_in(CFG_wr),
		.Parity_PE_Selection_in(Parity_PE_Selection_wr),
		.CTRL_LDM_addra_in(CTRL_LDM_addra_wr), .CTRL_LDM_ena_in(CTRL_LDM_ena_wr), .CTRL_LDM_wea_in(CTRL_LDM_wea_wr),
		.CTRL_LDM_addrb_in(CTRL_LDM_addrb_wr), .CTRL_LDM_enb_in(CTRL_LDM_enb_wr), .CTRL_LDM_web_in(CTRL_LDM_web_wr),
		.CTRL_LDM_Store_in(CTRL_LDM_Store_wr), .Stride_in(Stride_wr),
		.Padding_Read_in(Padding_Read_wr[9]),
		.CTRL_LDM_addra_Incr_in(CTRL_LDM_addra_Incr_wr[9]),
		.Weight_valid_in(Weight_valid_2_0_rg), .Weight_in(Weight_0_rg),
		.Bias_valid_in(Bias_valid_2_0_rg), .Bias_in(Bias_0_rg),
		.Pixel_0_valid_in(Shared_Pixel_0_valid_in_wr[9]), .Pixel_0_in(Shared_Pixel_0_in_wr[9]),
		.Pixel_1_valid_in(Shared_Pixel_1_valid_in_wr[9]), .Pixel_1_in(Shared_Pixel_1_in_wr[9]),
		.Pixel_2_valid_in(Shared_Pixel_2_valid_in_wr[9]), .Pixel_2_in(Shared_Pixel_2_in_wr[9]),
		.Pixel_0_out(Pixel_0_out_wr[9]), .Pixel_0_valid_out(Pixel_0_valid_out_wr[9]),
		.Pixel_1_out(Pixel_1_out_wr[9]), .Pixel_1_valid_out(Pixel_1_valid_out_wr[9]),
		.PE1_ALU_out_in(PE1_ALU_out_wr[9]),
		.PE1_ALU_valid_in(PE1_ALU_valid_wr[9]),
		.PE1_ALU_addr_in(PE1_ALU_addr_wr[9]),
		.PE1_ALU_en_in(PE1_ALU_en_wr[9])
	);

	PE #(.UNIT_NO(10)) pea0_10 (
		.CLK(CLK), .RST(RST),
		.AXI_LDM_addra_in(AXI_LDM_addra_in), .AXI_LDM_dina_in(AXI_LDM_dina_in),
		.AXI_LDM_ena_in(AXI_LDM_ena_in), .AXI_LDM_wea_in(AXI_LDM_wea_in),
		.AXI_LDM_douta_out(AXI_LDM_douta_out_wr[10]),
		.layer_done_in(layer_done_wr), .En_in(En_wr), .CFG_in(CFG_wr),
		.Parity_PE_Selection_in(Parity_PE_Selection_wr),
		.CTRL_LDM_addra_in(CTRL_LDM_addra_wr), .CTRL_LDM_ena_in(CTRL_LDM_ena_wr), .CTRL_LDM_wea_in(CTRL_LDM_wea_wr),
		.CTRL_LDM_addrb_in(CTRL_LDM_addrb_wr), .CTRL_LDM_enb_in(CTRL_LDM_enb_wr), .CTRL_LDM_web_in(CTRL_LDM_web_wr),
		.CTRL_LDM_Store_in(CTRL_LDM_Store_wr), .Stride_in(Stride_wr),
		.Padding_Read_in(Padding_Read_wr[10]),
		.CTRL_LDM_addra_Incr_in(CTRL_LDM_addra_Incr_wr[10]),
		.Weight_valid_in(Weight_valid_2_0_rg), .Weight_in(Weight_0_rg),
		.Bias_valid_in(Bias_valid_2_0_rg), .Bias_in(Bias_0_rg),
		.Pixel_0_valid_in(Shared_Pixel_0_valid_in_wr[10]), .Pixel_0_in(Shared_Pixel_0_in_wr[10]),
		.Pixel_1_valid_in(Shared_Pixel_1_valid_in_wr[10]), .Pixel_1_in(Shared_Pixel_1_in_wr[10]),
		.Pixel_2_valid_in(Shared_Pixel_2_valid_in_wr[10]), .Pixel_2_in(Shared_Pixel_2_in_wr[10]),
		.Pixel_0_out(Pixel_0_out_wr[10]), .Pixel_0_valid_out(Pixel_0_valid_out_wr[10]),
		.Pixel_1_out(Pixel_1_out_wr[10]), .Pixel_1_valid_out(Pixel_1_valid_out_wr[10]),
		.PE1_ALU_out_in(PE1_ALU_out_wr[10]),
		.PE1_ALU_valid_in(PE1_ALU_valid_wr[10]),
		.PE1_ALU_addr_in(PE1_ALU_addr_wr[10]),
		.PE1_ALU_en_in(PE1_ALU_en_wr[10])
	);

	PE #(.UNIT_NO(11)) pea0_11 (
		.CLK(CLK), .RST(RST),
		.AXI_LDM_addra_in(AXI_LDM_addra_in), .AXI_LDM_dina_in(AXI_LDM_dina_in),
		.AXI_LDM_ena_in(AXI_LDM_ena_in), .AXI_LDM_wea_in(AXI_LDM_wea_in),
		.AXI_LDM_douta_out(AXI_LDM_douta_out_wr[11]),
		.layer_done_in(layer_done_wr), .En_in(En_wr), .CFG_in(CFG_wr),
		.Parity_PE_Selection_in(Parity_PE_Selection_wr),
		.CTRL_LDM_addra_in(CTRL_LDM_addra_wr), .CTRL_LDM_ena_in(CTRL_LDM_ena_wr), .CTRL_LDM_wea_in(CTRL_LDM_wea_wr),
		.CTRL_LDM_addrb_in(CTRL_LDM_addrb_wr), .CTRL_LDM_enb_in(CTRL_LDM_enb_wr), .CTRL_LDM_web_in(CTRL_LDM_web_wr),
		.CTRL_LDM_Store_in(CTRL_LDM_Store_wr), .Stride_in(Stride_wr),
		.Padding_Read_in(Padding_Read_wr[11]),
		.CTRL_LDM_addra_Incr_in(CTRL_LDM_addra_Incr_wr[11]),
		.Weight_valid_in(Weight_valid_2_0_rg), .Weight_in(Weight_0_rg),
		.Bias_valid_in(Bias_valid_2_0_rg), .Bias_in(Bias_0_rg),
		.Pixel_0_valid_in(Shared_Pixel_0_valid_in_wr[11]), .Pixel_0_in(Shared_Pixel_0_in_wr[11]),
		.Pixel_1_valid_in(Shared_Pixel_1_valid_in_wr[11]), .Pixel_1_in(Shared_Pixel_1_in_wr[11]),
		.Pixel_2_valid_in(Shared_Pixel_2_valid_in_wr[11]), .Pixel_2_in(Shared_Pixel_2_in_wr[11]),
		.Pixel_0_out(Pixel_0_out_wr[11]), .Pixel_0_valid_out(Pixel_0_valid_out_wr[11]),
		.Pixel_1_out(Pixel_1_out_wr[11]), .Pixel_1_valid_out(Pixel_1_valid_out_wr[11]),
		.PE1_ALU_out_in(PE1_ALU_out_wr[11]),
		.PE1_ALU_valid_in(PE1_ALU_valid_wr[11]),
		.PE1_ALU_addr_in(PE1_ALU_addr_wr[11]),
		.PE1_ALU_en_in(PE1_ALU_en_wr[11])
	);

	PE #(.UNIT_NO(12)) pea0_12 (
		.CLK(CLK), .RST(RST),
		.AXI_LDM_addra_in(AXI_LDM_addra_in), .AXI_LDM_dina_in(AXI_LDM_dina_in),
		.AXI_LDM_ena_in(AXI_LDM_ena_in), .AXI_LDM_wea_in(AXI_LDM_wea_in),
		.AXI_LDM_douta_out(AXI_LDM_douta_out_wr[12]),
		.layer_done_in(layer_done_wr), .En_in(En_wr), .CFG_in(CFG_wr),
		.Parity_PE_Selection_in(Parity_PE_Selection_wr),
		.CTRL_LDM_addra_in(CTRL_LDM_addra_wr), .CTRL_LDM_ena_in(CTRL_LDM_ena_wr), .CTRL_LDM_wea_in(CTRL_LDM_wea_wr),
		.CTRL_LDM_addrb_in(CTRL_LDM_addrb_wr), .CTRL_LDM_enb_in(CTRL_LDM_enb_wr), .CTRL_LDM_web_in(CTRL_LDM_web_wr),
		.CTRL_LDM_Store_in(CTRL_LDM_Store_wr), .Stride_in(Stride_wr),
		.Padding_Read_in(Padding_Read_wr[12]),
		.CTRL_LDM_addra_Incr_in(CTRL_LDM_addra_Incr_wr[12]),
		.Weight_valid_in(Weight_valid_2_0_rg), .Weight_in(Weight_0_rg),
		.Bias_valid_in(Bias_valid_2_0_rg), .Bias_in(Bias_0_rg),
		.Pixel_0_valid_in(Shared_Pixel_0_valid_in_wr[12]), .Pixel_0_in(Shared_Pixel_0_in_wr[12]),
		.Pixel_1_valid_in(Shared_Pixel_1_valid_in_wr[12]), .Pixel_1_in(Shared_Pixel_1_in_wr[12]),
		.Pixel_2_valid_in(Shared_Pixel_2_valid_in_wr[12]), .Pixel_2_in(Shared_Pixel_2_in_wr[12]),
		.Pixel_0_out(Pixel_0_out_wr[12]), .Pixel_0_valid_out(Pixel_0_valid_out_wr[12]),
		.Pixel_1_out(Pixel_1_out_wr[12]), .Pixel_1_valid_out(Pixel_1_valid_out_wr[12]),
		.PE1_ALU_out_in(PE1_ALU_out_wr[12]),
		.PE1_ALU_valid_in(PE1_ALU_valid_wr[12]),
		.PE1_ALU_addr_in(PE1_ALU_addr_wr[12]),
		.PE1_ALU_en_in(PE1_ALU_en_wr[12])
	);

	PE #(.UNIT_NO(13)) pea0_13 (
		.CLK(CLK), .RST(RST),
		.AXI_LDM_addra_in(AXI_LDM_addra_in), .AXI_LDM_dina_in(AXI_LDM_dina_in),
		.AXI_LDM_ena_in(AXI_LDM_ena_in), .AXI_LDM_wea_in(AXI_LDM_wea_in),
		.AXI_LDM_douta_out(AXI_LDM_douta_out_wr[13]),
		.layer_done_in(layer_done_wr), .En_in(En_wr), .CFG_in(CFG_wr),
		.Parity_PE_Selection_in(Parity_PE_Selection_wr),
		.CTRL_LDM_addra_in(CTRL_LDM_addra_wr), .CTRL_LDM_ena_in(CTRL_LDM_ena_wr), .CTRL_LDM_wea_in(CTRL_LDM_wea_wr),
		.CTRL_LDM_addrb_in(CTRL_LDM_addrb_wr), .CTRL_LDM_enb_in(CTRL_LDM_enb_wr), .CTRL_LDM_web_in(CTRL_LDM_web_wr),
		.CTRL_LDM_Store_in(CTRL_LDM_Store_wr), .Stride_in(Stride_wr),
		.Padding_Read_in(Padding_Read_wr[13]),
		.CTRL_LDM_addra_Incr_in(CTRL_LDM_addra_Incr_wr[13]),
		.Weight_valid_in(Weight_valid_2_0_rg), .Weight_in(Weight_0_rg),
		.Bias_valid_in(Bias_valid_2_0_rg), .Bias_in(Bias_0_rg),
		.Pixel_0_valid_in(Shared_Pixel_0_valid_in_wr[13]), .Pixel_0_in(Shared_Pixel_0_in_wr[13]),
		.Pixel_1_valid_in(Shared_Pixel_1_valid_in_wr[13]), .Pixel_1_in(Shared_Pixel_1_in_wr[13]),
		.Pixel_2_valid_in(Shared_Pixel_2_valid_in_wr[13]), .Pixel_2_in(Shared_Pixel_2_in_wr[13]),
		.Pixel_0_out(Pixel_0_out_wr[13]), .Pixel_0_valid_out(Pixel_0_valid_out_wr[13]),
		.Pixel_1_out(Pixel_1_out_wr[13]), .Pixel_1_valid_out(Pixel_1_valid_out_wr[13]),
		.PE1_ALU_out_in(PE1_ALU_out_wr[13]),
		.PE1_ALU_valid_in(PE1_ALU_valid_wr[13]),
		.PE1_ALU_addr_in(PE1_ALU_addr_wr[13]),
		.PE1_ALU_en_in(PE1_ALU_en_wr[13])
	);

	PE #(.UNIT_NO(14)) pea0_14 (
		.CLK(CLK), .RST(RST),
		.AXI_LDM_addra_in(AXI_LDM_addra_in), .AXI_LDM_dina_in(AXI_LDM_dina_in),
		.AXI_LDM_ena_in(AXI_LDM_ena_in), .AXI_LDM_wea_in(AXI_LDM_wea_in),
		.AXI_LDM_douta_out(AXI_LDM_douta_out_wr[14]),
		.layer_done_in(layer_done_wr), .En_in(En_wr), .CFG_in(CFG_wr),
		.Parity_PE_Selection_in(Parity_PE_Selection_wr),
		.CTRL_LDM_addra_in(CTRL_LDM_addra_wr), .CTRL_LDM_ena_in(CTRL_LDM_ena_wr), .CTRL_LDM_wea_in(CTRL_LDM_wea_wr),
		.CTRL_LDM_addrb_in(CTRL_LDM_addrb_wr), .CTRL_LDM_enb_in(CTRL_LDM_enb_wr), .CTRL_LDM_web_in(CTRL_LDM_web_wr),
		.CTRL_LDM_Store_in(CTRL_LDM_Store_wr), .Stride_in(Stride_wr),
		.Padding_Read_in(Padding_Read_wr[14]),
		.CTRL_LDM_addra_Incr_in(CTRL_LDM_addra_Incr_wr[14]),
		.Weight_valid_in(Weight_valid_2_0_rg), .Weight_in(Weight_0_rg),
		.Bias_valid_in(Bias_valid_2_0_rg), .Bias_in(Bias_0_rg),
		.Pixel_0_valid_in(Shared_Pixel_0_valid_in_wr[14]), .Pixel_0_in(Shared_Pixel_0_in_wr[14]),
		.Pixel_1_valid_in(Shared_Pixel_1_valid_in_wr[14]), .Pixel_1_in(Shared_Pixel_1_in_wr[14]),
		.Pixel_2_valid_in(Shared_Pixel_2_valid_in_wr[14]), .Pixel_2_in(Shared_Pixel_2_in_wr[14]),
		.Pixel_0_out(Pixel_0_out_wr[14]), .Pixel_0_valid_out(Pixel_0_valid_out_wr[14]),
		.Pixel_1_out(Pixel_1_out_wr[14]), .Pixel_1_valid_out(Pixel_1_valid_out_wr[14]),
		.PE1_ALU_out_in(PE1_ALU_out_wr[14]),
		.PE1_ALU_valid_in(PE1_ALU_valid_wr[14]),
		.PE1_ALU_addr_in(PE1_ALU_addr_wr[14]),
		.PE1_ALU_en_in(PE1_ALU_en_wr[14])
	);

	PE #(.UNIT_NO(15)) pea0_15 (
		.CLK(CLK), .RST(RST),
		.AXI_LDM_addra_in(AXI_LDM_addra_in), .AXI_LDM_dina_in(AXI_LDM_dina_in),
		.AXI_LDM_ena_in(AXI_LDM_ena_in), .AXI_LDM_wea_in(AXI_LDM_wea_in),
		.AXI_LDM_douta_out(AXI_LDM_douta_out_wr[15]),
		.layer_done_in(layer_done_wr), .En_in(En_wr), .CFG_in(CFG_wr),
		.Parity_PE_Selection_in(Parity_PE_Selection_wr),
		.CTRL_LDM_addra_in(CTRL_LDM_addra_wr), .CTRL_LDM_ena_in(CTRL_LDM_ena_wr), .CTRL_LDM_wea_in(CTRL_LDM_wea_wr),
		.CTRL_LDM_addrb_in(CTRL_LDM_addrb_wr), .CTRL_LDM_enb_in(CTRL_LDM_enb_wr), .CTRL_LDM_web_in(CTRL_LDM_web_wr),
		.CTRL_LDM_Store_in(CTRL_LDM_Store_wr), .Stride_in(Stride_wr),
		.Padding_Read_in(Padding_Read_wr[15]),
		.CTRL_LDM_addra_Incr_in(CTRL_LDM_addra_Incr_wr[15]),
		.Weight_valid_in(Weight_valid_2_0_rg), .Weight_in(Weight_0_rg),
		.Bias_valid_in(Bias_valid_2_0_rg), .Bias_in(Bias_0_rg),
		.Pixel_0_valid_in(Shared_Pixel_0_valid_in_wr[15]), .Pixel_0_in(Shared_Pixel_0_in_wr[15]),
		.Pixel_1_valid_in(Shared_Pixel_1_valid_in_wr[15]), .Pixel_1_in(Shared_Pixel_1_in_wr[15]),
		.Pixel_2_valid_in(Shared_Pixel_2_valid_in_wr[15]), .Pixel_2_in(Shared_Pixel_2_in_wr[15]),
		.Pixel_0_out(Pixel_0_out_wr[15]), .Pixel_0_valid_out(Pixel_0_valid_out_wr[15]),
		.Pixel_1_out(Pixel_1_out_wr[15]), .Pixel_1_valid_out(Pixel_1_valid_out_wr[15]),
		.PE1_ALU_out_in(PE1_ALU_out_wr[15]),
		.PE1_ALU_valid_in(PE1_ALU_valid_wr[15]),
		.PE1_ALU_addr_in(PE1_ALU_addr_wr[15]),
		.PE1_ALU_en_in(PE1_ALU_en_wr[15])
	);

	PE #(.UNIT_NO(16)) pea0_16 (
		.CLK(CLK), .RST(RST),
		.AXI_LDM_addra_in(AXI_LDM_addra_in), .AXI_LDM_dina_in(AXI_LDM_dina_in),
		.AXI_LDM_ena_in(AXI_LDM_ena_in), .AXI_LDM_wea_in(AXI_LDM_wea_in),
		.AXI_LDM_douta_out(AXI_LDM_douta_out_wr[16]),
		.layer_done_in(layer_done_wr), .En_in(En_wr), .CFG_in(CFG_wr),
		.Parity_PE_Selection_in(Parity_PE_Selection_wr),
		.CTRL_LDM_addra_in(CTRL_LDM_addra_wr), .CTRL_LDM_ena_in(CTRL_LDM_ena_wr), .CTRL_LDM_wea_in(CTRL_LDM_wea_wr),
		.CTRL_LDM_addrb_in(CTRL_LDM_addrb_wr), .CTRL_LDM_enb_in(CTRL_LDM_enb_wr), .CTRL_LDM_web_in(CTRL_LDM_web_wr),
		.CTRL_LDM_Store_in(CTRL_LDM_Store_wr), .Stride_in(Stride_wr),
		.Padding_Read_in(Padding_Read_wr[16]),
		.CTRL_LDM_addra_Incr_in(CTRL_LDM_addra_Incr_wr[16]),
		.Weight_valid_in(Weight_valid_2_0_rg), .Weight_in(Weight_0_rg),
		.Bias_valid_in(Bias_valid_2_0_rg), .Bias_in(Bias_0_rg),
		.Pixel_0_valid_in(Shared_Pixel_0_valid_in_wr[16]), .Pixel_0_in(Shared_Pixel_0_in_wr[16]),
		.Pixel_1_valid_in(Shared_Pixel_1_valid_in_wr[16]), .Pixel_1_in(Shared_Pixel_1_in_wr[16]),
		.Pixel_2_valid_in(Shared_Pixel_2_valid_in_wr[16]), .Pixel_2_in(Shared_Pixel_2_in_wr[16]),
		.Pixel_0_out(Pixel_0_out_wr[16]), .Pixel_0_valid_out(Pixel_0_valid_out_wr[16]),
		.Pixel_1_out(Pixel_1_out_wr[16]), .Pixel_1_valid_out(Pixel_1_valid_out_wr[16]),
		.PE1_ALU_out_in(PE1_ALU_out_wr[16]),
		.PE1_ALU_valid_in(PE1_ALU_valid_wr[16]),
		.PE1_ALU_addr_in(PE1_ALU_addr_wr[16]),
		.PE1_ALU_en_in(PE1_ALU_en_wr[16])
	);

	PE #(.UNIT_NO(17)) pea0_17 (
		.CLK(CLK), .RST(RST),
		.AXI_LDM_addra_in(AXI_LDM_addra_in), .AXI_LDM_dina_in(AXI_LDM_dina_in),
		.AXI_LDM_ena_in(AXI_LDM_ena_in), .AXI_LDM_wea_in(AXI_LDM_wea_in),
		.AXI_LDM_douta_out(AXI_LDM_douta_out_wr[17]),
		.layer_done_in(layer_done_wr), .En_in(En_wr), .CFG_in(CFG_wr),
		.Parity_PE_Selection_in(Parity_PE_Selection_wr),
		.CTRL_LDM_addra_in(CTRL_LDM_addra_wr), .CTRL_LDM_ena_in(CTRL_LDM_ena_wr), .CTRL_LDM_wea_in(CTRL_LDM_wea_wr),
		.CTRL_LDM_addrb_in(CTRL_LDM_addrb_wr), .CTRL_LDM_enb_in(CTRL_LDM_enb_wr), .CTRL_LDM_web_in(CTRL_LDM_web_wr),
		.CTRL_LDM_Store_in(CTRL_LDM_Store_wr), .Stride_in(Stride_wr),
		.Padding_Read_in(Padding_Read_wr[17]),
		.CTRL_LDM_addra_Incr_in(CTRL_LDM_addra_Incr_wr[17]),
		.Weight_valid_in(Weight_valid_2_0_rg), .Weight_in(Weight_0_rg),
		.Bias_valid_in(Bias_valid_2_0_rg), .Bias_in(Bias_0_rg),
		.Pixel_0_valid_in(Shared_Pixel_0_valid_in_wr[17]), .Pixel_0_in(Shared_Pixel_0_in_wr[17]),
		.Pixel_1_valid_in(Shared_Pixel_1_valid_in_wr[17]), .Pixel_1_in(Shared_Pixel_1_in_wr[17]),
		.Pixel_2_valid_in(Shared_Pixel_2_valid_in_wr[17]), .Pixel_2_in(Shared_Pixel_2_in_wr[17]),
		.Pixel_0_out(Pixel_0_out_wr[17]), .Pixel_0_valid_out(Pixel_0_valid_out_wr[17]),
		.Pixel_1_out(Pixel_1_out_wr[17]), .Pixel_1_valid_out(Pixel_1_valid_out_wr[17]),
		.PE1_ALU_out_in(PE1_ALU_out_wr[17]),
		.PE1_ALU_valid_in(PE1_ALU_valid_wr[17]),
		.PE1_ALU_addr_in(PE1_ALU_addr_wr[17]),
		.PE1_ALU_en_in(PE1_ALU_en_wr[17])
	);

	PE #(.UNIT_NO(18)) pea0_18 (
		.CLK(CLK), .RST(RST),
		.AXI_LDM_addra_in(AXI_LDM_addra_in), .AXI_LDM_dina_in(AXI_LDM_dina_in),
		.AXI_LDM_ena_in(AXI_LDM_ena_in), .AXI_LDM_wea_in(AXI_LDM_wea_in),
		.AXI_LDM_douta_out(AXI_LDM_douta_out_wr[18]),
		.layer_done_in(layer_done_wr), .En_in(En_wr), .CFG_in(CFG_wr),
		.Parity_PE_Selection_in(Parity_PE_Selection_wr),
		.CTRL_LDM_addra_in(CTRL_LDM_addra_wr), .CTRL_LDM_ena_in(CTRL_LDM_ena_wr), .CTRL_LDM_wea_in(CTRL_LDM_wea_wr),
		.CTRL_LDM_addrb_in(CTRL_LDM_addrb_wr), .CTRL_LDM_enb_in(CTRL_LDM_enb_wr), .CTRL_LDM_web_in(CTRL_LDM_web_wr),
		.CTRL_LDM_Store_in(CTRL_LDM_Store_wr), .Stride_in(Stride_wr),
		.Padding_Read_in(Padding_Read_wr[18]),
		.CTRL_LDM_addra_Incr_in(CTRL_LDM_addra_Incr_wr[18]),
		.Weight_valid_in(Weight_valid_2_0_rg), .Weight_in(Weight_0_rg),
		.Bias_valid_in(Bias_valid_2_0_rg), .Bias_in(Bias_0_rg),
		.Pixel_0_valid_in(Shared_Pixel_0_valid_in_wr[18]), .Pixel_0_in(Shared_Pixel_0_in_wr[18]),
		.Pixel_1_valid_in(Shared_Pixel_1_valid_in_wr[18]), .Pixel_1_in(Shared_Pixel_1_in_wr[18]),
		.Pixel_2_valid_in(Shared_Pixel_2_valid_in_wr[18]), .Pixel_2_in(Shared_Pixel_2_in_wr[18]),
		.Pixel_0_out(Pixel_0_out_wr[18]), .Pixel_0_valid_out(Pixel_0_valid_out_wr[18]),
		.Pixel_1_out(Pixel_1_out_wr[18]), .Pixel_1_valid_out(Pixel_1_valid_out_wr[18]),
		.PE1_ALU_out_in(PE1_ALU_out_wr[18]),
		.PE1_ALU_valid_in(PE1_ALU_valid_wr[18]),
		.PE1_ALU_addr_in(PE1_ALU_addr_wr[18]),
		.PE1_ALU_en_in(PE1_ALU_en_wr[18])
	);

	PE #(.UNIT_NO(19)) pea0_19 (
		.CLK(CLK), .RST(RST),
		.AXI_LDM_addra_in(AXI_LDM_addra_in), .AXI_LDM_dina_in(AXI_LDM_dina_in),
		.AXI_LDM_ena_in(AXI_LDM_ena_in), .AXI_LDM_wea_in(AXI_LDM_wea_in),
		.AXI_LDM_douta_out(AXI_LDM_douta_out_wr[19]),
		.layer_done_in(layer_done_wr), .En_in(En_wr), .CFG_in(CFG_wr),
		.Parity_PE_Selection_in(Parity_PE_Selection_wr),
		.CTRL_LDM_addra_in(CTRL_LDM_addra_wr), .CTRL_LDM_ena_in(CTRL_LDM_ena_wr), .CTRL_LDM_wea_in(CTRL_LDM_wea_wr),
		.CTRL_LDM_addrb_in(CTRL_LDM_addrb_wr), .CTRL_LDM_enb_in(CTRL_LDM_enb_wr), .CTRL_LDM_web_in(CTRL_LDM_web_wr),
		.CTRL_LDM_Store_in(CTRL_LDM_Store_wr), .Stride_in(Stride_wr),
		.Padding_Read_in(Padding_Read_wr[19]),
		.CTRL_LDM_addra_Incr_in(CTRL_LDM_addra_Incr_wr[19]),
		.Weight_valid_in(Weight_valid_2_0_rg), .Weight_in(Weight_0_rg),
		.Bias_valid_in(Bias_valid_2_0_rg), .Bias_in(Bias_0_rg),
		.Pixel_0_valid_in(Shared_Pixel_0_valid_in_wr[19]), .Pixel_0_in(Shared_Pixel_0_in_wr[19]),
		.Pixel_1_valid_in(Shared_Pixel_1_valid_in_wr[19]), .Pixel_1_in(Shared_Pixel_1_in_wr[19]),
		.Pixel_2_valid_in(Shared_Pixel_2_valid_in_wr[19]), .Pixel_2_in(Shared_Pixel_2_in_wr[19]),
		.Pixel_0_out(Pixel_0_out_wr[19]), .Pixel_0_valid_out(Pixel_0_valid_out_wr[19]),
		.Pixel_1_out(Pixel_1_out_wr[19]), .Pixel_1_valid_out(Pixel_1_valid_out_wr[19]),
		.PE1_ALU_out_in(PE1_ALU_out_wr[19]),
		.PE1_ALU_valid_in(PE1_ALU_valid_wr[19]),
		.PE1_ALU_addr_in(PE1_ALU_addr_wr[19]),
		.PE1_ALU_en_in(PE1_ALU_en_wr[19])
	);

	PE #(.UNIT_NO(20)) pea0_20 (
		.CLK(CLK), .RST(RST),
		.AXI_LDM_addra_in(AXI_LDM_addra_in), .AXI_LDM_dina_in(AXI_LDM_dina_in),
		.AXI_LDM_ena_in(AXI_LDM_ena_in), .AXI_LDM_wea_in(AXI_LDM_wea_in),
		.AXI_LDM_douta_out(AXI_LDM_douta_out_wr[20]),
		.layer_done_in(layer_done_wr), .En_in(En_wr), .CFG_in(CFG_wr),
		.Parity_PE_Selection_in(Parity_PE_Selection_wr),
		.CTRL_LDM_addra_in(CTRL_LDM_addra_wr), .CTRL_LDM_ena_in(CTRL_LDM_ena_wr), .CTRL_LDM_wea_in(CTRL_LDM_wea_wr),
		.CTRL_LDM_addrb_in(CTRL_LDM_addrb_wr), .CTRL_LDM_enb_in(CTRL_LDM_enb_wr), .CTRL_LDM_web_in(CTRL_LDM_web_wr),
		.CTRL_LDM_Store_in(CTRL_LDM_Store_wr), .Stride_in(Stride_wr),
		.Padding_Read_in(Padding_Read_wr[20]),
		.CTRL_LDM_addra_Incr_in(CTRL_LDM_addra_Incr_wr[20]),
		.Weight_valid_in(Weight_valid_2_0_rg), .Weight_in(Weight_0_rg),
		.Bias_valid_in(Bias_valid_2_0_rg), .Bias_in(Bias_0_rg),
		.Pixel_0_valid_in(Shared_Pixel_0_valid_in_wr[20]), .Pixel_0_in(Shared_Pixel_0_in_wr[20]),
		.Pixel_1_valid_in(Shared_Pixel_1_valid_in_wr[20]), .Pixel_1_in(Shared_Pixel_1_in_wr[20]),
		.Pixel_2_valid_in(Shared_Pixel_2_valid_in_wr[20]), .Pixel_2_in(Shared_Pixel_2_in_wr[20]),
		.Pixel_0_out(Pixel_0_out_wr[20]), .Pixel_0_valid_out(Pixel_0_valid_out_wr[20]),
		.Pixel_1_out(Pixel_1_out_wr[20]), .Pixel_1_valid_out(Pixel_1_valid_out_wr[20]),
		.PE1_ALU_out_in(PE1_ALU_out_wr[20]),
		.PE1_ALU_valid_in(PE1_ALU_valid_wr[20]),
		.PE1_ALU_addr_in(PE1_ALU_addr_wr[20]),
		.PE1_ALU_en_in(PE1_ALU_en_wr[20])
	);

	PE #(.UNIT_NO(21)) pea0_21 (
		.CLK(CLK), .RST(RST),
		.AXI_LDM_addra_in(AXI_LDM_addra_in), .AXI_LDM_dina_in(AXI_LDM_dina_in),
		.AXI_LDM_ena_in(AXI_LDM_ena_in), .AXI_LDM_wea_in(AXI_LDM_wea_in),
		.AXI_LDM_douta_out(AXI_LDM_douta_out_wr[21]),
		.layer_done_in(layer_done_wr), .En_in(En_wr), .CFG_in(CFG_wr),
		.Parity_PE_Selection_in(Parity_PE_Selection_wr),
		.CTRL_LDM_addra_in(CTRL_LDM_addra_wr), .CTRL_LDM_ena_in(CTRL_LDM_ena_wr), .CTRL_LDM_wea_in(CTRL_LDM_wea_wr),
		.CTRL_LDM_addrb_in(CTRL_LDM_addrb_wr), .CTRL_LDM_enb_in(CTRL_LDM_enb_wr), .CTRL_LDM_web_in(CTRL_LDM_web_wr),
		.CTRL_LDM_Store_in(CTRL_LDM_Store_wr), .Stride_in(Stride_wr),
		.Padding_Read_in(Padding_Read_wr[21]),
		.CTRL_LDM_addra_Incr_in(CTRL_LDM_addra_Incr_wr[21]),
		.Weight_valid_in(Weight_valid_2_0_rg), .Weight_in(Weight_0_rg),
		.Bias_valid_in(Bias_valid_2_0_rg), .Bias_in(Bias_0_rg),
		.Pixel_0_valid_in(Shared_Pixel_0_valid_in_wr[21]), .Pixel_0_in(Shared_Pixel_0_in_wr[21]),
		.Pixel_1_valid_in(Shared_Pixel_1_valid_in_wr[21]), .Pixel_1_in(Shared_Pixel_1_in_wr[21]),
		.Pixel_2_valid_in(Shared_Pixel_2_valid_in_wr[21]), .Pixel_2_in(Shared_Pixel_2_in_wr[21]),
		.Pixel_0_out(Pixel_0_out_wr[21]), .Pixel_0_valid_out(Pixel_0_valid_out_wr[21]),
		.Pixel_1_out(Pixel_1_out_wr[21]), .Pixel_1_valid_out(Pixel_1_valid_out_wr[21]),
		.PE1_ALU_out_in(PE1_ALU_out_wr[21]),
		.PE1_ALU_valid_in(PE1_ALU_valid_wr[21]),
		.PE1_ALU_addr_in(PE1_ALU_addr_wr[21]),
		.PE1_ALU_en_in(PE1_ALU_en_wr[21])
	);

	PE #(.UNIT_NO(22)) pea0_22 (
		.CLK(CLK), .RST(RST),
		.AXI_LDM_addra_in(AXI_LDM_addra_in), .AXI_LDM_dina_in(AXI_LDM_dina_in),
		.AXI_LDM_ena_in(AXI_LDM_ena_in), .AXI_LDM_wea_in(AXI_LDM_wea_in),
		.AXI_LDM_douta_out(AXI_LDM_douta_out_wr[22]),
		.layer_done_in(layer_done_wr), .En_in(En_wr), .CFG_in(CFG_wr),
		.Parity_PE_Selection_in(Parity_PE_Selection_wr),
		.CTRL_LDM_addra_in(CTRL_LDM_addra_wr), .CTRL_LDM_ena_in(CTRL_LDM_ena_wr), .CTRL_LDM_wea_in(CTRL_LDM_wea_wr),
		.CTRL_LDM_addrb_in(CTRL_LDM_addrb_wr), .CTRL_LDM_enb_in(CTRL_LDM_enb_wr), .CTRL_LDM_web_in(CTRL_LDM_web_wr),
		.CTRL_LDM_Store_in(CTRL_LDM_Store_wr), .Stride_in(Stride_wr),
		.Padding_Read_in(Padding_Read_wr[22]),
		.CTRL_LDM_addra_Incr_in(CTRL_LDM_addra_Incr_wr[22]),
		.Weight_valid_in(Weight_valid_2_0_rg), .Weight_in(Weight_0_rg),
		.Bias_valid_in(Bias_valid_2_0_rg), .Bias_in(Bias_0_rg),
		.Pixel_0_valid_in(Shared_Pixel_0_valid_in_wr[22]), .Pixel_0_in(Shared_Pixel_0_in_wr[22]),
		.Pixel_1_valid_in(Shared_Pixel_1_valid_in_wr[22]), .Pixel_1_in(Shared_Pixel_1_in_wr[22]),
		.Pixel_2_valid_in(Shared_Pixel_2_valid_in_wr[22]), .Pixel_2_in(Shared_Pixel_2_in_wr[22]),
		.Pixel_0_out(Pixel_0_out_wr[22]), .Pixel_0_valid_out(Pixel_0_valid_out_wr[22]),
		.Pixel_1_out(Pixel_1_out_wr[22]), .Pixel_1_valid_out(Pixel_1_valid_out_wr[22]),
		.PE1_ALU_out_in(PE1_ALU_out_wr[22]),
		.PE1_ALU_valid_in(PE1_ALU_valid_wr[22]),
		.PE1_ALU_addr_in(PE1_ALU_addr_wr[22]),
		.PE1_ALU_en_in(PE1_ALU_en_wr[22])
	);

	PE #(.UNIT_NO(23)) pea0_23 (
		.CLK(CLK), .RST(RST),
		.AXI_LDM_addra_in(AXI_LDM_addra_in), .AXI_LDM_dina_in(AXI_LDM_dina_in),
		.AXI_LDM_ena_in(AXI_LDM_ena_in), .AXI_LDM_wea_in(AXI_LDM_wea_in),
		.AXI_LDM_douta_out(AXI_LDM_douta_out_wr[23]),
		.layer_done_in(layer_done_wr), .En_in(En_wr), .CFG_in(CFG_wr),
		.Parity_PE_Selection_in(Parity_PE_Selection_wr),
		.CTRL_LDM_addra_in(CTRL_LDM_addra_wr), .CTRL_LDM_ena_in(CTRL_LDM_ena_wr), .CTRL_LDM_wea_in(CTRL_LDM_wea_wr),
		.CTRL_LDM_addrb_in(CTRL_LDM_addrb_wr), .CTRL_LDM_enb_in(CTRL_LDM_enb_wr), .CTRL_LDM_web_in(CTRL_LDM_web_wr),
		.CTRL_LDM_Store_in(CTRL_LDM_Store_wr), .Stride_in(Stride_wr),
		.Padding_Read_in(Padding_Read_wr[23]),
		.CTRL_LDM_addra_Incr_in(CTRL_LDM_addra_Incr_wr[23]),
		.Weight_valid_in(Weight_valid_2_0_rg), .Weight_in(Weight_0_rg),
		.Bias_valid_in(Bias_valid_2_0_rg), .Bias_in(Bias_0_rg),
		.Pixel_0_valid_in(Shared_Pixel_0_valid_in_wr[23]), .Pixel_0_in(Shared_Pixel_0_in_wr[23]),
		.Pixel_1_valid_in(Shared_Pixel_1_valid_in_wr[23]), .Pixel_1_in(Shared_Pixel_1_in_wr[23]),
		.Pixel_2_valid_in(Shared_Pixel_2_valid_in_wr[23]), .Pixel_2_in(Shared_Pixel_2_in_wr[23]),
		.Pixel_0_out(Pixel_0_out_wr[23]), .Pixel_0_valid_out(Pixel_0_valid_out_wr[23]),
		.Pixel_1_out(Pixel_1_out_wr[23]), .Pixel_1_valid_out(Pixel_1_valid_out_wr[23]),
		.PE1_ALU_out_in(PE1_ALU_out_wr[23]),
		.PE1_ALU_valid_in(PE1_ALU_valid_wr[23]),
		.PE1_ALU_addr_in(PE1_ALU_addr_wr[23]),
		.PE1_ALU_en_in(PE1_ALU_en_wr[23])
	);

	PE #(.UNIT_NO(24)) pea0_24 (
		.CLK(CLK), .RST(RST),
		.AXI_LDM_addra_in(AXI_LDM_addra_in), .AXI_LDM_dina_in(AXI_LDM_dina_in),
		.AXI_LDM_ena_in(AXI_LDM_ena_in), .AXI_LDM_wea_in(AXI_LDM_wea_in),
		.AXI_LDM_douta_out(AXI_LDM_douta_out_wr[24]),
		.layer_done_in(layer_done_wr), .En_in(En_wr), .CFG_in(CFG_wr),
		.Parity_PE_Selection_in(Parity_PE_Selection_wr),
		.CTRL_LDM_addra_in(CTRL_LDM_addra_wr), .CTRL_LDM_ena_in(CTRL_LDM_ena_wr), .CTRL_LDM_wea_in(CTRL_LDM_wea_wr),
		.CTRL_LDM_addrb_in(CTRL_LDM_addrb_wr), .CTRL_LDM_enb_in(CTRL_LDM_enb_wr), .CTRL_LDM_web_in(CTRL_LDM_web_wr),
		.CTRL_LDM_Store_in(CTRL_LDM_Store_wr), .Stride_in(Stride_wr),
		.Padding_Read_in(Padding_Read_wr[24]),
		.CTRL_LDM_addra_Incr_in(CTRL_LDM_addra_Incr_wr[24]),
		.Weight_valid_in(Weight_valid_2_0_rg), .Weight_in(Weight_0_rg),
		.Bias_valid_in(Bias_valid_2_0_rg), .Bias_in(Bias_0_rg),
		.Pixel_0_valid_in(Shared_Pixel_0_valid_in_wr[24]), .Pixel_0_in(Shared_Pixel_0_in_wr[24]),
		.Pixel_1_valid_in(Shared_Pixel_1_valid_in_wr[24]), .Pixel_1_in(Shared_Pixel_1_in_wr[24]),
		.Pixel_2_valid_in(Shared_Pixel_2_valid_in_wr[24]), .Pixel_2_in(Shared_Pixel_2_in_wr[24]),
		.Pixel_0_out(Pixel_0_out_wr[24]), .Pixel_0_valid_out(Pixel_0_valid_out_wr[24]),
		.Pixel_1_out(Pixel_1_out_wr[24]), .Pixel_1_valid_out(Pixel_1_valid_out_wr[24]),
		.PE1_ALU_out_in(PE1_ALU_out_wr[24]),
		.PE1_ALU_valid_in(PE1_ALU_valid_wr[24]),
		.PE1_ALU_addr_in(PE1_ALU_addr_wr[24]),
		.PE1_ALU_en_in(PE1_ALU_en_wr[24])
	);

	PE #(.UNIT_NO(25)) pea0_25 (
		.CLK(CLK), .RST(RST),
		.AXI_LDM_addra_in(AXI_LDM_addra_in), .AXI_LDM_dina_in(AXI_LDM_dina_in),
		.AXI_LDM_ena_in(AXI_LDM_ena_in), .AXI_LDM_wea_in(AXI_LDM_wea_in),
		.AXI_LDM_douta_out(AXI_LDM_douta_out_wr[25]),
		.layer_done_in(layer_done_wr), .En_in(En_wr), .CFG_in(CFG_wr),
		.Parity_PE_Selection_in(Parity_PE_Selection_wr),
		.CTRL_LDM_addra_in(CTRL_LDM_addra_wr), .CTRL_LDM_ena_in(CTRL_LDM_ena_wr), .CTRL_LDM_wea_in(CTRL_LDM_wea_wr),
		.CTRL_LDM_addrb_in(CTRL_LDM_addrb_wr), .CTRL_LDM_enb_in(CTRL_LDM_enb_wr), .CTRL_LDM_web_in(CTRL_LDM_web_wr),
		.CTRL_LDM_Store_in(CTRL_LDM_Store_wr), .Stride_in(Stride_wr),
		.Padding_Read_in(Padding_Read_wr[25]),
		.CTRL_LDM_addra_Incr_in(CTRL_LDM_addra_Incr_wr[25]),
		.Weight_valid_in(Weight_valid_2_0_rg), .Weight_in(Weight_0_rg),
		.Bias_valid_in(Bias_valid_2_0_rg), .Bias_in(Bias_0_rg),
		.Pixel_0_valid_in(Shared_Pixel_0_valid_in_wr[25]), .Pixel_0_in(Shared_Pixel_0_in_wr[25]),
		.Pixel_1_valid_in(Shared_Pixel_1_valid_in_wr[25]), .Pixel_1_in(Shared_Pixel_1_in_wr[25]),
		.Pixel_2_valid_in(Shared_Pixel_2_valid_in_wr[25]), .Pixel_2_in(Shared_Pixel_2_in_wr[25]),
		.Pixel_0_out(Pixel_0_out_wr[25]), .Pixel_0_valid_out(Pixel_0_valid_out_wr[25]),
		.Pixel_1_out(Pixel_1_out_wr[25]), .Pixel_1_valid_out(Pixel_1_valid_out_wr[25]),
		.PE1_ALU_out_in(PE1_ALU_out_wr[25]),
		.PE1_ALU_valid_in(PE1_ALU_valid_wr[25]),
		.PE1_ALU_addr_in(PE1_ALU_addr_wr[25]),
		.PE1_ALU_en_in(PE1_ALU_en_wr[25])
	);

	PE #(.UNIT_NO(26)) pea0_26 (
		.CLK(CLK), .RST(RST),
		.AXI_LDM_addra_in(AXI_LDM_addra_in), .AXI_LDM_dina_in(AXI_LDM_dina_in),
		.AXI_LDM_ena_in(AXI_LDM_ena_in), .AXI_LDM_wea_in(AXI_LDM_wea_in),
		.AXI_LDM_douta_out(AXI_LDM_douta_out_wr[26]),
		.layer_done_in(layer_done_wr), .En_in(En_wr), .CFG_in(CFG_wr),
		.Parity_PE_Selection_in(Parity_PE_Selection_wr),
		.CTRL_LDM_addra_in(CTRL_LDM_addra_wr), .CTRL_LDM_ena_in(CTRL_LDM_ena_wr), .CTRL_LDM_wea_in(CTRL_LDM_wea_wr),
		.CTRL_LDM_addrb_in(CTRL_LDM_addrb_wr), .CTRL_LDM_enb_in(CTRL_LDM_enb_wr), .CTRL_LDM_web_in(CTRL_LDM_web_wr),
		.CTRL_LDM_Store_in(CTRL_LDM_Store_wr), .Stride_in(Stride_wr),
		.Padding_Read_in(Padding_Read_wr[26]),
		.CTRL_LDM_addra_Incr_in(CTRL_LDM_addra_Incr_wr[26]),
		.Weight_valid_in(Weight_valid_2_0_rg), .Weight_in(Weight_0_rg),
		.Bias_valid_in(Bias_valid_2_0_rg), .Bias_in(Bias_0_rg),
		.Pixel_0_valid_in(Shared_Pixel_0_valid_in_wr[26]), .Pixel_0_in(Shared_Pixel_0_in_wr[26]),
		.Pixel_1_valid_in(Shared_Pixel_1_valid_in_wr[26]), .Pixel_1_in(Shared_Pixel_1_in_wr[26]),
		.Pixel_2_valid_in(Shared_Pixel_2_valid_in_wr[26]), .Pixel_2_in(Shared_Pixel_2_in_wr[26]),
		.Pixel_0_out(Pixel_0_out_wr[26]), .Pixel_0_valid_out(Pixel_0_valid_out_wr[26]),
		.Pixel_1_out(Pixel_1_out_wr[26]), .Pixel_1_valid_out(Pixel_1_valid_out_wr[26]),
		.PE1_ALU_out_in(PE1_ALU_out_wr[26]),
		.PE1_ALU_valid_in(PE1_ALU_valid_wr[26]),
		.PE1_ALU_addr_in(PE1_ALU_addr_wr[26]),
		.PE1_ALU_en_in(PE1_ALU_en_wr[26])
	);

	PE #(.UNIT_NO(27)) pea0_27 (
		.CLK(CLK), .RST(RST),
		.AXI_LDM_addra_in(AXI_LDM_addra_in), .AXI_LDM_dina_in(AXI_LDM_dina_in),
		.AXI_LDM_ena_in(AXI_LDM_ena_in), .AXI_LDM_wea_in(AXI_LDM_wea_in),
		.AXI_LDM_douta_out(AXI_LDM_douta_out_wr[27]),
		.layer_done_in(layer_done_wr), .En_in(En_wr), .CFG_in(CFG_wr),
		.Parity_PE_Selection_in(Parity_PE_Selection_wr),
		.CTRL_LDM_addra_in(CTRL_LDM_addra_wr), .CTRL_LDM_ena_in(CTRL_LDM_ena_wr), .CTRL_LDM_wea_in(CTRL_LDM_wea_wr),
		.CTRL_LDM_addrb_in(CTRL_LDM_addrb_wr), .CTRL_LDM_enb_in(CTRL_LDM_enb_wr), .CTRL_LDM_web_in(CTRL_LDM_web_wr),
		.CTRL_LDM_Store_in(CTRL_LDM_Store_wr), .Stride_in(Stride_wr),
		.Padding_Read_in(Padding_Read_wr[27]),
		.CTRL_LDM_addra_Incr_in(CTRL_LDM_addra_Incr_wr[27]),
		.Weight_valid_in(Weight_valid_2_0_rg), .Weight_in(Weight_0_rg),
		.Bias_valid_in(Bias_valid_2_0_rg), .Bias_in(Bias_0_rg),
		.Pixel_0_valid_in(Shared_Pixel_0_valid_in_wr[27]), .Pixel_0_in(Shared_Pixel_0_in_wr[27]),
		.Pixel_1_valid_in(Shared_Pixel_1_valid_in_wr[27]), .Pixel_1_in(Shared_Pixel_1_in_wr[27]),
		.Pixel_2_valid_in(Shared_Pixel_2_valid_in_wr[27]), .Pixel_2_in(Shared_Pixel_2_in_wr[27]),
		.Pixel_0_out(Pixel_0_out_wr[27]), .Pixel_0_valid_out(Pixel_0_valid_out_wr[27]),
		.Pixel_1_out(Pixel_1_out_wr[27]), .Pixel_1_valid_out(Pixel_1_valid_out_wr[27]),
		.PE1_ALU_out_in(PE1_ALU_out_wr[27]),
		.PE1_ALU_valid_in(PE1_ALU_valid_wr[27]),
		.PE1_ALU_addr_in(PE1_ALU_addr_wr[27]),
		.PE1_ALU_en_in(PE1_ALU_en_wr[27])
	);

	PE #(.UNIT_NO(28)) pea0_28 (
		.CLK(CLK), .RST(RST),
		.AXI_LDM_addra_in(AXI_LDM_addra_in), .AXI_LDM_dina_in(AXI_LDM_dina_in),
		.AXI_LDM_ena_in(AXI_LDM_ena_in), .AXI_LDM_wea_in(AXI_LDM_wea_in),
		.AXI_LDM_douta_out(AXI_LDM_douta_out_wr[28]),
		.layer_done_in(layer_done_wr), .En_in(En_wr), .CFG_in(CFG_wr),
		.Parity_PE_Selection_in(Parity_PE_Selection_wr),
		.CTRL_LDM_addra_in(CTRL_LDM_addra_wr), .CTRL_LDM_ena_in(CTRL_LDM_ena_wr), .CTRL_LDM_wea_in(CTRL_LDM_wea_wr),
		.CTRL_LDM_addrb_in(CTRL_LDM_addrb_wr), .CTRL_LDM_enb_in(CTRL_LDM_enb_wr), .CTRL_LDM_web_in(CTRL_LDM_web_wr),
		.CTRL_LDM_Store_in(CTRL_LDM_Store_wr), .Stride_in(Stride_wr),
		.Padding_Read_in(Padding_Read_wr[28]),
		.CTRL_LDM_addra_Incr_in(CTRL_LDM_addra_Incr_wr[28]),
		.Weight_valid_in(Weight_valid_2_0_rg), .Weight_in(Weight_0_rg),
		.Bias_valid_in(Bias_valid_2_0_rg), .Bias_in(Bias_0_rg),
		.Pixel_0_valid_in(Shared_Pixel_0_valid_in_wr[28]), .Pixel_0_in(Shared_Pixel_0_in_wr[28]),
		.Pixel_1_valid_in(Shared_Pixel_1_valid_in_wr[28]), .Pixel_1_in(Shared_Pixel_1_in_wr[28]),
		.Pixel_2_valid_in(Shared_Pixel_2_valid_in_wr[28]), .Pixel_2_in(Shared_Pixel_2_in_wr[28]),
		.Pixel_0_out(Pixel_0_out_wr[28]), .Pixel_0_valid_out(Pixel_0_valid_out_wr[28]),
		.Pixel_1_out(Pixel_1_out_wr[28]), .Pixel_1_valid_out(Pixel_1_valid_out_wr[28]),
		.PE1_ALU_out_in(PE1_ALU_out_wr[28]),
		.PE1_ALU_valid_in(PE1_ALU_valid_wr[28]),
		.PE1_ALU_addr_in(PE1_ALU_addr_wr[28]),
		.PE1_ALU_en_in(PE1_ALU_en_wr[28])
	);

	PE #(.UNIT_NO(29)) pea0_29 (
		.CLK(CLK), .RST(RST),
		.AXI_LDM_addra_in(AXI_LDM_addra_in), .AXI_LDM_dina_in(AXI_LDM_dina_in),
		.AXI_LDM_ena_in(AXI_LDM_ena_in), .AXI_LDM_wea_in(AXI_LDM_wea_in),
		.AXI_LDM_douta_out(AXI_LDM_douta_out_wr[29]),
		.layer_done_in(layer_done_wr), .En_in(En_wr), .CFG_in(CFG_wr),
		.Parity_PE_Selection_in(Parity_PE_Selection_wr),
		.CTRL_LDM_addra_in(CTRL_LDM_addra_wr), .CTRL_LDM_ena_in(CTRL_LDM_ena_wr), .CTRL_LDM_wea_in(CTRL_LDM_wea_wr),
		.CTRL_LDM_addrb_in(CTRL_LDM_addrb_wr), .CTRL_LDM_enb_in(CTRL_LDM_enb_wr), .CTRL_LDM_web_in(CTRL_LDM_web_wr),
		.CTRL_LDM_Store_in(CTRL_LDM_Store_wr), .Stride_in(Stride_wr),
		.Padding_Read_in(Padding_Read_wr[29]),
		.CTRL_LDM_addra_Incr_in(CTRL_LDM_addra_Incr_wr[29]),
		.Weight_valid_in(Weight_valid_2_0_rg), .Weight_in(Weight_0_rg),
		.Bias_valid_in(Bias_valid_2_0_rg), .Bias_in(Bias_0_rg),
		.Pixel_0_valid_in(Shared_Pixel_0_valid_in_wr[29]), .Pixel_0_in(Shared_Pixel_0_in_wr[29]),
		.Pixel_1_valid_in(Shared_Pixel_1_valid_in_wr[29]), .Pixel_1_in(Shared_Pixel_1_in_wr[29]),
		.Pixel_2_valid_in(Shared_Pixel_2_valid_in_wr[29]), .Pixel_2_in(Shared_Pixel_2_in_wr[29]),
		.Pixel_0_out(Pixel_0_out_wr[29]), .Pixel_0_valid_out(Pixel_0_valid_out_wr[29]),
		.Pixel_1_out(Pixel_1_out_wr[29]), .Pixel_1_valid_out(Pixel_1_valid_out_wr[29]),
		.PE1_ALU_out_in(PE1_ALU_out_wr[29]),
		.PE1_ALU_valid_in(PE1_ALU_valid_wr[29]),
		.PE1_ALU_addr_in(PE1_ALU_addr_wr[29]),
		.PE1_ALU_en_in(PE1_ALU_en_wr[29])
	);

	PE #(.UNIT_NO(30)) pea0_30 (
		.CLK(CLK), .RST(RST),
		.AXI_LDM_addra_in(AXI_LDM_addra_in), .AXI_LDM_dina_in(AXI_LDM_dina_in),
		.AXI_LDM_ena_in(AXI_LDM_ena_in), .AXI_LDM_wea_in(AXI_LDM_wea_in),
		.AXI_LDM_douta_out(AXI_LDM_douta_out_wr[30]),
		.layer_done_in(layer_done_wr), .En_in(En_wr), .CFG_in(CFG_wr),
		.Parity_PE_Selection_in(Parity_PE_Selection_wr),
		.CTRL_LDM_addra_in(CTRL_LDM_addra_wr), .CTRL_LDM_ena_in(CTRL_LDM_ena_wr), .CTRL_LDM_wea_in(CTRL_LDM_wea_wr),
		.CTRL_LDM_addrb_in(CTRL_LDM_addrb_wr), .CTRL_LDM_enb_in(CTRL_LDM_enb_wr), .CTRL_LDM_web_in(CTRL_LDM_web_wr),
		.CTRL_LDM_Store_in(CTRL_LDM_Store_wr), .Stride_in(Stride_wr),
		.Padding_Read_in(Padding_Read_wr[30]),
		.CTRL_LDM_addra_Incr_in(CTRL_LDM_addra_Incr_wr[30]),
		.Weight_valid_in(Weight_valid_2_0_rg), .Weight_in(Weight_0_rg),
		.Bias_valid_in(Bias_valid_2_0_rg), .Bias_in(Bias_0_rg),
		.Pixel_0_valid_in(Shared_Pixel_0_valid_in_wr[30]), .Pixel_0_in(Shared_Pixel_0_in_wr[30]),
		.Pixel_1_valid_in(Shared_Pixel_1_valid_in_wr[30]), .Pixel_1_in(Shared_Pixel_1_in_wr[30]),
		.Pixel_2_valid_in(Shared_Pixel_2_valid_in_wr[30]), .Pixel_2_in(Shared_Pixel_2_in_wr[30]),
		.Pixel_0_out(Pixel_0_out_wr[30]), .Pixel_0_valid_out(Pixel_0_valid_out_wr[30]),
		.Pixel_1_out(Pixel_1_out_wr[30]), .Pixel_1_valid_out(Pixel_1_valid_out_wr[30]),
		.PE1_ALU_out_in(PE1_ALU_out_wr[30]),
		.PE1_ALU_valid_in(PE1_ALU_valid_wr[30]),
		.PE1_ALU_addr_in(PE1_ALU_addr_wr[30]),
		.PE1_ALU_en_in(PE1_ALU_en_wr[30])
	);

	PE #(.UNIT_NO(31)) pea0_31 (
		.CLK(CLK), .RST(RST),
		.AXI_LDM_addra_in(AXI_LDM_addra_in), .AXI_LDM_dina_in(AXI_LDM_dina_in),
		.AXI_LDM_ena_in(AXI_LDM_ena_in), .AXI_LDM_wea_in(AXI_LDM_wea_in),
		.AXI_LDM_douta_out(AXI_LDM_douta_out_wr[31]),
		.layer_done_in(layer_done_wr), .En_in(En_wr), .CFG_in(CFG_wr),
		.Parity_PE_Selection_in(Parity_PE_Selection_wr),
		.CTRL_LDM_addra_in(CTRL_LDM_addra_wr), .CTRL_LDM_ena_in(CTRL_LDM_ena_wr), .CTRL_LDM_wea_in(CTRL_LDM_wea_wr),
		.CTRL_LDM_addrb_in(CTRL_LDM_addrb_wr), .CTRL_LDM_enb_in(CTRL_LDM_enb_wr), .CTRL_LDM_web_in(CTRL_LDM_web_wr),
		.CTRL_LDM_Store_in(CTRL_LDM_Store_wr), .Stride_in(Stride_wr),
		.Padding_Read_in(Padding_Read_wr[31]),
		.CTRL_LDM_addra_Incr_in(CTRL_LDM_addra_Incr_wr[31]),
		.Weight_valid_in(Weight_valid_2_0_rg), .Weight_in(Weight_0_rg),
		.Bias_valid_in(Bias_valid_2_0_rg), .Bias_in(Bias_0_rg),
		.Pixel_0_valid_in(Shared_Pixel_0_valid_in_wr[31]), .Pixel_0_in(Shared_Pixel_0_in_wr[31]),
		.Pixel_1_valid_in(Shared_Pixel_1_valid_in_wr[31]), .Pixel_1_in(Shared_Pixel_1_in_wr[31]),
		.Pixel_2_valid_in(Shared_Pixel_2_valid_in_wr[31]), .Pixel_2_in(Shared_Pixel_2_in_wr[31]),
		.Pixel_0_out(Pixel_0_out_wr[31]), .Pixel_0_valid_out(Pixel_0_valid_out_wr[31]),
		.Pixel_1_out(Pixel_1_out_wr[31]), .Pixel_1_valid_out(Pixel_1_valid_out_wr[31]),
		.PE1_ALU_out_in(PE1_ALU_out_wr[31]),
		.PE1_ALU_valid_in(PE1_ALU_valid_wr[31]),
		.PE1_ALU_addr_in(PE1_ALU_addr_wr[31]),
		.PE1_ALU_en_in(PE1_ALU_en_wr[31])
	);

	PE #(.UNIT_NO(32)) pea0_32 (
		.CLK(CLK), .RST(RST),
		.AXI_LDM_addra_in(AXI_LDM_addra_in), .AXI_LDM_dina_in(AXI_LDM_dina_in),
		.AXI_LDM_ena_in(AXI_LDM_ena_in), .AXI_LDM_wea_in(AXI_LDM_wea_in),
		.AXI_LDM_douta_out(AXI_LDM_douta_out_wr[32]),
		.layer_done_in(layer_done_wr), .En_in(En_wr), .CFG_in(CFG_wr),
		.Parity_PE_Selection_in(Parity_PE_Selection_wr),
		.CTRL_LDM_addra_in(CTRL_LDM_addra_wr), .CTRL_LDM_ena_in(CTRL_LDM_ena_wr), .CTRL_LDM_wea_in(CTRL_LDM_wea_wr),
		.CTRL_LDM_addrb_in(CTRL_LDM_addrb_wr), .CTRL_LDM_enb_in(CTRL_LDM_enb_wr), .CTRL_LDM_web_in(CTRL_LDM_web_wr),
		.CTRL_LDM_Store_in(CTRL_LDM_Store_wr), .Stride_in(Stride_wr),
		.Padding_Read_in(Padding_Read_wr[32]),
		.CTRL_LDM_addra_Incr_in(CTRL_LDM_addra_Incr_wr[32]),
		.Weight_valid_in(Weight_valid_2_0_rg), .Weight_in(Weight_0_rg),
		.Bias_valid_in(Bias_valid_2_0_rg), .Bias_in(Bias_0_rg),
		.Pixel_0_valid_in(Shared_Pixel_0_valid_in_wr[32]), .Pixel_0_in(Shared_Pixel_0_in_wr[32]),
		.Pixel_1_valid_in(Shared_Pixel_1_valid_in_wr[32]), .Pixel_1_in(Shared_Pixel_1_in_wr[32]),
		.Pixel_2_valid_in(Shared_Pixel_2_valid_in_wr[32]), .Pixel_2_in(Shared_Pixel_2_in_wr[32]),
		.Pixel_0_out(Pixel_0_out_wr[32]), .Pixel_0_valid_out(Pixel_0_valid_out_wr[32]),
		.Pixel_1_out(Pixel_1_out_wr[32]), .Pixel_1_valid_out(Pixel_1_valid_out_wr[32]),
		.PE1_ALU_out_in(PE1_ALU_out_wr[32]),
		.PE1_ALU_valid_in(PE1_ALU_valid_wr[32]),
		.PE1_ALU_addr_in(PE1_ALU_addr_wr[32]),
		.PE1_ALU_en_in(PE1_ALU_en_wr[32])
	);

	PE #(.UNIT_NO(33)) pea0_33 (
		.CLK(CLK), .RST(RST),
		.AXI_LDM_addra_in(AXI_LDM_addra_in), .AXI_LDM_dina_in(AXI_LDM_dina_in),
		.AXI_LDM_ena_in(AXI_LDM_ena_in), .AXI_LDM_wea_in(AXI_LDM_wea_in),
		.AXI_LDM_douta_out(AXI_LDM_douta_out_wr[33]),
		.layer_done_in(layer_done_wr), .En_in(En_wr), .CFG_in(CFG_wr),
		.Parity_PE_Selection_in(Parity_PE_Selection_wr),
		.CTRL_LDM_addra_in(CTRL_LDM_addra_wr), .CTRL_LDM_ena_in(CTRL_LDM_ena_wr), .CTRL_LDM_wea_in(CTRL_LDM_wea_wr),
		.CTRL_LDM_addrb_in(CTRL_LDM_addrb_wr), .CTRL_LDM_enb_in(CTRL_LDM_enb_wr), .CTRL_LDM_web_in(CTRL_LDM_web_wr),
		.CTRL_LDM_Store_in(CTRL_LDM_Store_wr), .Stride_in(Stride_wr),
		.Padding_Read_in(Padding_Read_wr[33]),
		.CTRL_LDM_addra_Incr_in(CTRL_LDM_addra_Incr_wr[33]),
		.Weight_valid_in(Weight_valid_2_0_rg), .Weight_in(Weight_0_rg),
		.Bias_valid_in(Bias_valid_2_0_rg), .Bias_in(Bias_0_rg),
		.Pixel_0_valid_in(Shared_Pixel_0_valid_in_wr[33]), .Pixel_0_in(Shared_Pixel_0_in_wr[33]),
		.Pixel_1_valid_in(Shared_Pixel_1_valid_in_wr[33]), .Pixel_1_in(Shared_Pixel_1_in_wr[33]),
		.Pixel_2_valid_in(Shared_Pixel_2_valid_in_wr[33]), .Pixel_2_in(Shared_Pixel_2_in_wr[33]),
		.Pixel_0_out(Pixel_0_out_wr[33]), .Pixel_0_valid_out(Pixel_0_valid_out_wr[33]),
		.Pixel_1_out(Pixel_1_out_wr[33]), .Pixel_1_valid_out(Pixel_1_valid_out_wr[33]),
		.PE1_ALU_out_in(PE1_ALU_out_wr[33]),
		.PE1_ALU_valid_in(PE1_ALU_valid_wr[33]),
		.PE1_ALU_addr_in(PE1_ALU_addr_wr[33]),
		.PE1_ALU_en_in(PE1_ALU_en_wr[33])
	);

	PE #(.UNIT_NO(34)) pea0_34 (
		.CLK(CLK), .RST(RST),
		.AXI_LDM_addra_in(AXI_LDM_addra_in), .AXI_LDM_dina_in(AXI_LDM_dina_in),
		.AXI_LDM_ena_in(AXI_LDM_ena_in), .AXI_LDM_wea_in(AXI_LDM_wea_in),
		.AXI_LDM_douta_out(AXI_LDM_douta_out_wr[34]),
		.layer_done_in(layer_done_wr), .En_in(En_wr), .CFG_in(CFG_wr),
		.Parity_PE_Selection_in(Parity_PE_Selection_wr),
		.CTRL_LDM_addra_in(CTRL_LDM_addra_wr), .CTRL_LDM_ena_in(CTRL_LDM_ena_wr), .CTRL_LDM_wea_in(CTRL_LDM_wea_wr),
		.CTRL_LDM_addrb_in(CTRL_LDM_addrb_wr), .CTRL_LDM_enb_in(CTRL_LDM_enb_wr), .CTRL_LDM_web_in(CTRL_LDM_web_wr),
		.CTRL_LDM_Store_in(CTRL_LDM_Store_wr), .Stride_in(Stride_wr),
		.Padding_Read_in(Padding_Read_wr[34]),
		.CTRL_LDM_addra_Incr_in(CTRL_LDM_addra_Incr_wr[34]),
		.Weight_valid_in(Weight_valid_2_0_rg), .Weight_in(Weight_0_rg),
		.Bias_valid_in(Bias_valid_2_0_rg), .Bias_in(Bias_0_rg),
		.Pixel_0_valid_in(Shared_Pixel_0_valid_in_wr[34]), .Pixel_0_in(Shared_Pixel_0_in_wr[34]),
		.Pixel_1_valid_in(Shared_Pixel_1_valid_in_wr[34]), .Pixel_1_in(Shared_Pixel_1_in_wr[34]),
		.Pixel_2_valid_in(Shared_Pixel_2_valid_in_wr[34]), .Pixel_2_in(Shared_Pixel_2_in_wr[34]),
		.Pixel_0_out(Pixel_0_out_wr[34]), .Pixel_0_valid_out(Pixel_0_valid_out_wr[34]),
		.Pixel_1_out(Pixel_1_out_wr[34]), .Pixel_1_valid_out(Pixel_1_valid_out_wr[34]),
		.PE1_ALU_out_in(PE1_ALU_out_wr[34]),
		.PE1_ALU_valid_in(PE1_ALU_valid_wr[34]),
		.PE1_ALU_addr_in(PE1_ALU_addr_wr[34]),
		.PE1_ALU_en_in(PE1_ALU_en_wr[34])
	);

	PE #(.UNIT_NO(35)) pea0_35 (
		.CLK(CLK), .RST(RST),
		.AXI_LDM_addra_in(AXI_LDM_addra_in), .AXI_LDM_dina_in(AXI_LDM_dina_in),
		.AXI_LDM_ena_in(AXI_LDM_ena_in), .AXI_LDM_wea_in(AXI_LDM_wea_in),
		.AXI_LDM_douta_out(AXI_LDM_douta_out_wr[35]),
		.layer_done_in(layer_done_wr), .En_in(En_wr), .CFG_in(CFG_wr),
		.Parity_PE_Selection_in(Parity_PE_Selection_wr),
		.CTRL_LDM_addra_in(CTRL_LDM_addra_wr), .CTRL_LDM_ena_in(CTRL_LDM_ena_wr), .CTRL_LDM_wea_in(CTRL_LDM_wea_wr),
		.CTRL_LDM_addrb_in(CTRL_LDM_addrb_wr), .CTRL_LDM_enb_in(CTRL_LDM_enb_wr), .CTRL_LDM_web_in(CTRL_LDM_web_wr),
		.CTRL_LDM_Store_in(CTRL_LDM_Store_wr), .Stride_in(Stride_wr),
		.Padding_Read_in(Padding_Read_wr[35]),
		.CTRL_LDM_addra_Incr_in(CTRL_LDM_addra_Incr_wr[35]),
		.Weight_valid_in(Weight_valid_2_0_rg), .Weight_in(Weight_0_rg),
		.Bias_valid_in(Bias_valid_2_0_rg), .Bias_in(Bias_0_rg),
		.Pixel_0_valid_in(Shared_Pixel_0_valid_in_wr[35]), .Pixel_0_in(Shared_Pixel_0_in_wr[35]),
		.Pixel_1_valid_in(Shared_Pixel_1_valid_in_wr[35]), .Pixel_1_in(Shared_Pixel_1_in_wr[35]),
		.Pixel_2_valid_in(Shared_Pixel_2_valid_in_wr[35]), .Pixel_2_in(Shared_Pixel_2_in_wr[35]),
		.Pixel_0_out(Pixel_0_out_wr[35]), .Pixel_0_valid_out(Pixel_0_valid_out_wr[35]),
		.Pixel_1_out(Pixel_1_out_wr[35]), .Pixel_1_valid_out(Pixel_1_valid_out_wr[35]),
		.PE1_ALU_out_in(PE1_ALU_out_wr[35]),
		.PE1_ALU_valid_in(PE1_ALU_valid_wr[35]),
		.PE1_ALU_addr_in(PE1_ALU_addr_wr[35]),
		.PE1_ALU_en_in(PE1_ALU_en_wr[35])
	);

	PE #(.UNIT_NO(36)) pea0_36 (
		.CLK(CLK), .RST(RST),
		.AXI_LDM_addra_in(AXI_LDM_addra_in), .AXI_LDM_dina_in(AXI_LDM_dina_in),
		.AXI_LDM_ena_in(AXI_LDM_ena_in), .AXI_LDM_wea_in(AXI_LDM_wea_in),
		.AXI_LDM_douta_out(AXI_LDM_douta_out_wr[36]),
		.layer_done_in(layer_done_wr), .En_in(En_wr), .CFG_in(CFG_wr),
		.Parity_PE_Selection_in(Parity_PE_Selection_wr),
		.CTRL_LDM_addra_in(CTRL_LDM_addra_wr), .CTRL_LDM_ena_in(CTRL_LDM_ena_wr), .CTRL_LDM_wea_in(CTRL_LDM_wea_wr),
		.CTRL_LDM_addrb_in(CTRL_LDM_addrb_wr), .CTRL_LDM_enb_in(CTRL_LDM_enb_wr), .CTRL_LDM_web_in(CTRL_LDM_web_wr),
		.CTRL_LDM_Store_in(CTRL_LDM_Store_wr), .Stride_in(Stride_wr),
		.Padding_Read_in(Padding_Read_wr[36]),
		.CTRL_LDM_addra_Incr_in(CTRL_LDM_addra_Incr_wr[36]),
		.Weight_valid_in(Weight_valid_2_0_rg), .Weight_in(Weight_0_rg),
		.Bias_valid_in(Bias_valid_2_0_rg), .Bias_in(Bias_0_rg),
		.Pixel_0_valid_in(Shared_Pixel_0_valid_in_wr[36]), .Pixel_0_in(Shared_Pixel_0_in_wr[36]),
		.Pixel_1_valid_in(Shared_Pixel_1_valid_in_wr[36]), .Pixel_1_in(Shared_Pixel_1_in_wr[36]),
		.Pixel_2_valid_in(Shared_Pixel_2_valid_in_wr[36]), .Pixel_2_in(Shared_Pixel_2_in_wr[36]),
		.Pixel_0_out(Pixel_0_out_wr[36]), .Pixel_0_valid_out(Pixel_0_valid_out_wr[36]),
		.Pixel_1_out(Pixel_1_out_wr[36]), .Pixel_1_valid_out(Pixel_1_valid_out_wr[36]),
		.PE1_ALU_out_in(PE1_ALU_out_wr[36]),
		.PE1_ALU_valid_in(PE1_ALU_valid_wr[36]),
		.PE1_ALU_addr_in(PE1_ALU_addr_wr[36]),
		.PE1_ALU_en_in(PE1_ALU_en_wr[36])
	);

	PE_LP #(.UNIT_NO(37)) pea0_37 (
		.CLK(CLK), .RST(RST),
		.AXI_LDM_addra_in(AXI_LDM_addra_in), .AXI_LDM_dina_in(AXI_LDM_dina_in),
		.AXI_LDM_ena_in(AXI_LDM_ena_in), .AXI_LDM_wea_in(AXI_LDM_wea_in),
		.AXI_LDM_douta_out(AXI_LDM_douta_out_wr[37]),
		.layer_done_in(layer_done_wr), .En_in(En_wr), .CFG_in(CFG_wr),
		.Parity_PE_Selection_in(Parity_PE_Selection_wr),
		.CTRL_LDM_addra_in(CTRL_LDM_addra_wr), .CTRL_LDM_ena_in(CTRL_LDM_ena_wr), .CTRL_LDM_wea_in(CTRL_LDM_wea_wr),
		.CTRL_LDM_addrb_in(CTRL_LDM_addrb_wr), .CTRL_LDM_enb_in(CTRL_LDM_enb_wr), .CTRL_LDM_web_in(CTRL_LDM_web_wr),
		.CTRL_LDM_Store_in(CTRL_LDM_Store_wr), .Stride_in(Stride_wr),
		.Padding_Read_in(Padding_Read_wr[37]),
		.CTRL_LDM_addra_Incr_in(CTRL_LDM_addra_Incr_wr[37]),
		.Weight_valid_in(Weight_valid_2_0_rg), .Weight_in(Weight_0_rg),
		.Bias_valid_in(Bias_valid_2_0_rg), .Bias_in(Bias_0_rg),
		.Pixel_0_valid_in(Shared_Pixel_0_valid_in_wr[37]), .Pixel_0_in(Shared_Pixel_0_in_wr[37]),
		.Pixel_1_valid_in(Shared_Pixel_1_valid_in_wr[37]), .Pixel_1_in(Shared_Pixel_1_in_wr[37]),
		.Pixel_2_valid_in(Shared_Pixel_2_valid_in_wr[37]), .Pixel_2_in(Shared_Pixel_2_in_wr[37]),
		.Pixel_0_out(Pixel_0_out_wr[37]), .Pixel_0_valid_out(Pixel_0_valid_out_wr[37]),
		.Pixel_1_out(Pixel_1_out_wr[37]), .Pixel_1_valid_out(Pixel_1_valid_out_wr[37]),
		.PE1_ALU_out_in(PE1_ALU_out_wr[37]),
		.PE1_ALU_valid_in(PE1_ALU_valid_wr[37]),
		.PE1_ALU_addr_in(PE1_ALU_addr_wr[37]),
		.PE1_ALU_en_in(PE1_ALU_en_wr[37])
	);

	PE_LP #(.UNIT_NO(38)) pea0_38 (
		.CLK(CLK), .RST(RST),
		.AXI_LDM_addra_in(AXI_LDM_addra_in), .AXI_LDM_dina_in(AXI_LDM_dina_in),
		.AXI_LDM_ena_in(AXI_LDM_ena_in), .AXI_LDM_wea_in(AXI_LDM_wea_in),
		.AXI_LDM_douta_out(AXI_LDM_douta_out_wr[38]),
		.layer_done_in(layer_done_wr), .En_in(En_wr), .CFG_in(CFG_wr),
		.Parity_PE_Selection_in(Parity_PE_Selection_wr),
		.CTRL_LDM_addra_in(CTRL_LDM_addra_wr), .CTRL_LDM_ena_in(CTRL_LDM_ena_wr), .CTRL_LDM_wea_in(CTRL_LDM_wea_wr),
		.CTRL_LDM_addrb_in(CTRL_LDM_addrb_wr), .CTRL_LDM_enb_in(CTRL_LDM_enb_wr), .CTRL_LDM_web_in(CTRL_LDM_web_wr),
		.CTRL_LDM_Store_in(CTRL_LDM_Store_wr), .Stride_in(Stride_wr),
		.Padding_Read_in(Padding_Read_wr[38]),
		.CTRL_LDM_addra_Incr_in(CTRL_LDM_addra_Incr_wr[38]),
		.Weight_valid_in(Weight_valid_2_0_rg), .Weight_in(Weight_0_rg),
		.Bias_valid_in(Bias_valid_2_0_rg), .Bias_in(Bias_0_rg),
		.Pixel_0_valid_in(Shared_Pixel_0_valid_in_wr[38]), .Pixel_0_in(Shared_Pixel_0_in_wr[38]),
		.Pixel_1_valid_in(Shared_Pixel_1_valid_in_wr[38]), .Pixel_1_in(Shared_Pixel_1_in_wr[38]),
		.Pixel_2_valid_in(Shared_Pixel_2_valid_in_wr[38]), .Pixel_2_in(Shared_Pixel_2_in_wr[38]),
		.Pixel_0_out(Pixel_0_out_wr[38]), .Pixel_0_valid_out(Pixel_0_valid_out_wr[38]),
		.Pixel_1_out(Pixel_1_out_wr[38]), .Pixel_1_valid_out(Pixel_1_valid_out_wr[38]),
		.PE1_ALU_out_in(PE1_ALU_out_wr[38]),
		.PE1_ALU_valid_in(PE1_ALU_valid_wr[38]),
		.PE1_ALU_addr_in(PE1_ALU_addr_wr[38]),
		.PE1_ALU_en_in(PE1_ALU_en_wr[38])
	);

	PE_LP_Last #(.UNIT_NO(39)) pea0_39 (
		.CLK(CLK), .RST(RST),
		.AXI_LDM_addra_in(AXI_LDM_addra_in), .AXI_LDM_dina_in(AXI_LDM_dina_in),
		.AXI_LDM_ena_in(AXI_LDM_ena_in), .AXI_LDM_wea_in(AXI_LDM_wea_in),
		.AXI_LDM_douta_out(AXI_LDM_douta_out_wr[39]),
		.layer_done_in(layer_done_wr), .En_in(En_wr), .CFG_in(CFG_wr),
		.Parity_PE_Selection_in(Parity_PE_Selection_wr),
		.CTRL_LDM_addra_in(CTRL_LDM_addra_wr), .CTRL_LDM_ena_in(CTRL_LDM_ena_wr), .CTRL_LDM_wea_in(CTRL_LDM_wea_wr),
		.CTRL_LDM_addrb_in(CTRL_LDM_addrb_wr), .CTRL_LDM_enb_in(CTRL_LDM_enb_wr), .CTRL_LDM_web_in(CTRL_LDM_web_wr),
		.CTRL_LDM_Store_in(CTRL_LDM_Store_wr), .Stride_in(Stride_wr),
		.Overarray_in(Overarray_wr),
		.Padding_Read_in(Padding_Read_wr[39]),
		.CTRL_LDM_addra_Incr_in(CTRL_LDM_addra_Incr_wr[39]),
		.Weight_valid_in(Weight_valid_2_0_rg), .Weight_in(Weight_0_rg),
		.Bias_valid_in(Bias_valid_2_0_rg), .Bias_in(Bias_0_rg),
		.Pixel_0_valid_in(Shared_Pixel_0_valid_in_wr[39]), .Pixel_0_in(Shared_Pixel_0_in_wr[39]),
		.Pixel_1_valid_in(Shared_Pixel_1_valid_in_wr[39]), .Pixel_1_in(Shared_Pixel_1_in_wr[39]),
		.Pixel_2_valid_in(Shared_Pixel_2_valid_in_wr[39]), .Pixel_2_in(Shared_Pixel_2_in_wr[39]),
		.Pixel_0_out(Pixel_0_out_wr[39]), .Pixel_0_valid_out(Pixel_0_valid_out_wr[39]),
		.Pixel_1_out(Pixel_1_out_wr[39]), .Pixel_1_valid_out(Pixel_1_valid_out_wr[39]),
		.PE1_ALU_out_in(PE1_ALU_out_wr[39]),
		.PE1_ALU_valid_in(PE1_ALU_valid_wr[39]),
		.PE1_ALU_addr_in(PE1_ALU_addr_wr[39]),
		.PE1_ALU_en_in(PE1_ALU_en_wr[39])
	);

	// ==================================================================
	// PEA 1 (Processing Element Array 1) - Channel n+1 (No LDM)
	// ==================================================================
	PE_lite #(.UNIT_NO(0)) pea1_0 (
		.CLK(CLK), .RST(RST),
		.En_in(En_wr), .layer_done_in(layer_done_wr), .CFG_in(CFG_wr),
		.CTRL_LDM_Store_in(CTRL_LDM_Store_1_wr),
		.Weight_valid_in(Weight_valid_2_1_rg), .Weight_in(Weight_1_rg),
		.Bias_valid_in(Bias_valid_2_1_rg), .Bias_in(Bias_1_rg),
		.Pixel_0_valid_in(Shared_Pixel_0_valid_in_wr[0]), .Pixel_0_in(Shared_Pixel_0_in_wr[0]),
		.ALU_out(PE1_ALU_out_wr[0]),
		.ALU_valid_out(PE1_ALU_valid_wr[0]),
		.ALU_addr_out(PE1_ALU_addr_wr[0]),
		.ALU_en_out(PE1_ALU_en_wr[0])
	);

	PE_lite #(.UNIT_NO(1)) pea1_1 (
		.CLK(CLK), .RST(RST),
		.En_in(En_wr), .layer_done_in(layer_done_wr), .CFG_in(CFG_wr),
		.CTRL_LDM_Store_in(CTRL_LDM_Store_1_wr),
		.Weight_valid_in(Weight_valid_2_1_rg), .Weight_in(Weight_1_rg),
		.Bias_valid_in(Bias_valid_2_1_rg), .Bias_in(Bias_1_rg),
		.Pixel_0_valid_in(Shared_Pixel_0_valid_in_wr[1]), .Pixel_0_in(Shared_Pixel_0_in_wr[1]),
		.ALU_out(PE1_ALU_out_wr[1]),
		.ALU_valid_out(PE1_ALU_valid_wr[1]),
		.ALU_addr_out(PE1_ALU_addr_wr[1]),
		.ALU_en_out(PE1_ALU_en_wr[1])
	);

	PE_lite #(.UNIT_NO(2)) pea1_2 (
		.CLK(CLK), .RST(RST),
		.En_in(En_wr), .layer_done_in(layer_done_wr), .CFG_in(CFG_wr),
		.CTRL_LDM_Store_in(CTRL_LDM_Store_1_wr),
		.Weight_valid_in(Weight_valid_2_1_rg), .Weight_in(Weight_1_rg),
		.Bias_valid_in(Bias_valid_2_1_rg), .Bias_in(Bias_1_rg),
		.Pixel_0_valid_in(Shared_Pixel_0_valid_in_wr[2]), .Pixel_0_in(Shared_Pixel_0_in_wr[2]),
		.ALU_out(PE1_ALU_out_wr[2]),
		.ALU_valid_out(PE1_ALU_valid_wr[2]),
		.ALU_addr_out(PE1_ALU_addr_wr[2]),
		.ALU_en_out(PE1_ALU_en_wr[2])
	);

	PE_lite #(.UNIT_NO(3)) pea1_3 (
		.CLK(CLK), .RST(RST),
		.En_in(En_wr), .layer_done_in(layer_done_wr), .CFG_in(CFG_wr),
		.CTRL_LDM_Store_in(CTRL_LDM_Store_1_wr),
		.Weight_valid_in(Weight_valid_2_1_rg), .Weight_in(Weight_1_rg),
		.Bias_valid_in(Bias_valid_2_1_rg), .Bias_in(Bias_1_rg),
		.Pixel_0_valid_in(Shared_Pixel_0_valid_in_wr[3]), .Pixel_0_in(Shared_Pixel_0_in_wr[3]),
		.ALU_out(PE1_ALU_out_wr[3]),
		.ALU_valid_out(PE1_ALU_valid_wr[3]),
		.ALU_addr_out(PE1_ALU_addr_wr[3]),
		.ALU_en_out(PE1_ALU_en_wr[3])
	);

	PE_lite #(.UNIT_NO(4)) pea1_4 (
		.CLK(CLK), .RST(RST),
		.En_in(En_wr), .layer_done_in(layer_done_wr), .CFG_in(CFG_wr),
		.CTRL_LDM_Store_in(CTRL_LDM_Store_1_wr),
		.Weight_valid_in(Weight_valid_2_1_rg), .Weight_in(Weight_1_rg),
		.Bias_valid_in(Bias_valid_2_1_rg), .Bias_in(Bias_1_rg),
		.Pixel_0_valid_in(Shared_Pixel_0_valid_in_wr[4]), .Pixel_0_in(Shared_Pixel_0_in_wr[4]),
		.ALU_out(PE1_ALU_out_wr[4]),
		.ALU_valid_out(PE1_ALU_valid_wr[4]),
		.ALU_addr_out(PE1_ALU_addr_wr[4]),
		.ALU_en_out(PE1_ALU_en_wr[4])
	);

	PE_lite #(.UNIT_NO(5)) pea1_5 (
		.CLK(CLK), .RST(RST),
		.En_in(En_wr), .layer_done_in(layer_done_wr), .CFG_in(CFG_wr),
		.CTRL_LDM_Store_in(CTRL_LDM_Store_1_wr),
		.Weight_valid_in(Weight_valid_2_1_rg), .Weight_in(Weight_1_rg),
		.Bias_valid_in(Bias_valid_2_1_rg), .Bias_in(Bias_1_rg),
		.Pixel_0_valid_in(Shared_Pixel_0_valid_in_wr[5]), .Pixel_0_in(Shared_Pixel_0_in_wr[5]),
		.ALU_out(PE1_ALU_out_wr[5]),
		.ALU_valid_out(PE1_ALU_valid_wr[5]),
		.ALU_addr_out(PE1_ALU_addr_wr[5]),
		.ALU_en_out(PE1_ALU_en_wr[5])
	);

	PE_lite #(.UNIT_NO(6)) pea1_6 (
		.CLK(CLK), .RST(RST),
		.En_in(En_wr), .layer_done_in(layer_done_wr), .CFG_in(CFG_wr),
		.CTRL_LDM_Store_in(CTRL_LDM_Store_1_wr),
		.Weight_valid_in(Weight_valid_2_1_rg), .Weight_in(Weight_1_rg),
		.Bias_valid_in(Bias_valid_2_1_rg), .Bias_in(Bias_1_rg),
		.Pixel_0_valid_in(Shared_Pixel_0_valid_in_wr[6]), .Pixel_0_in(Shared_Pixel_0_in_wr[6]),
		.ALU_out(PE1_ALU_out_wr[6]),
		.ALU_valid_out(PE1_ALU_valid_wr[6]),
		.ALU_addr_out(PE1_ALU_addr_wr[6]),
		.ALU_en_out(PE1_ALU_en_wr[6])
	);

	PE_lite #(.UNIT_NO(7)) pea1_7 (
		.CLK(CLK), .RST(RST),
		.En_in(En_wr), .layer_done_in(layer_done_wr), .CFG_in(CFG_wr),
		.CTRL_LDM_Store_in(CTRL_LDM_Store_1_wr),
		.Weight_valid_in(Weight_valid_2_1_rg), .Weight_in(Weight_1_rg),
		.Bias_valid_in(Bias_valid_2_1_rg), .Bias_in(Bias_1_rg),
		.Pixel_0_valid_in(Shared_Pixel_0_valid_in_wr[7]), .Pixel_0_in(Shared_Pixel_0_in_wr[7]),
		.ALU_out(PE1_ALU_out_wr[7]),
		.ALU_valid_out(PE1_ALU_valid_wr[7]),
		.ALU_addr_out(PE1_ALU_addr_wr[7]),
		.ALU_en_out(PE1_ALU_en_wr[7])
	);

	PE_lite #(.UNIT_NO(8)) pea1_8 (
		.CLK(CLK), .RST(RST),
		.En_in(En_wr), .layer_done_in(layer_done_wr), .CFG_in(CFG_wr),
		.CTRL_LDM_Store_in(CTRL_LDM_Store_1_wr),
		.Weight_valid_in(Weight_valid_2_1_rg), .Weight_in(Weight_1_rg),
		.Bias_valid_in(Bias_valid_2_1_rg), .Bias_in(Bias_1_rg),
		.Pixel_0_valid_in(Shared_Pixel_0_valid_in_wr[8]), .Pixel_0_in(Shared_Pixel_0_in_wr[8]),
		.ALU_out(PE1_ALU_out_wr[8]),
		.ALU_valid_out(PE1_ALU_valid_wr[8]),
		.ALU_addr_out(PE1_ALU_addr_wr[8]),
		.ALU_en_out(PE1_ALU_en_wr[8])
	);

	PE_lite #(.UNIT_NO(9)) pea1_9 (
		.CLK(CLK), .RST(RST),
		.En_in(En_wr), .layer_done_in(layer_done_wr), .CFG_in(CFG_wr),
		.CTRL_LDM_Store_in(CTRL_LDM_Store_1_wr),
		.Weight_valid_in(Weight_valid_2_1_rg), .Weight_in(Weight_1_rg),
		.Bias_valid_in(Bias_valid_2_1_rg), .Bias_in(Bias_1_rg),
		.Pixel_0_valid_in(Shared_Pixel_0_valid_in_wr[9]), .Pixel_0_in(Shared_Pixel_0_in_wr[9]),
		.ALU_out(PE1_ALU_out_wr[9]),
		.ALU_valid_out(PE1_ALU_valid_wr[9]),
		.ALU_addr_out(PE1_ALU_addr_wr[9]),
		.ALU_en_out(PE1_ALU_en_wr[9])
	);

	PE_lite #(.UNIT_NO(10)) pea1_10 (
		.CLK(CLK), .RST(RST),
		.En_in(En_wr), .layer_done_in(layer_done_wr), .CFG_in(CFG_wr),
		.CTRL_LDM_Store_in(CTRL_LDM_Store_1_wr),
		.Weight_valid_in(Weight_valid_2_1_rg), .Weight_in(Weight_1_rg),
		.Bias_valid_in(Bias_valid_2_1_rg), .Bias_in(Bias_1_rg),
		.Pixel_0_valid_in(Shared_Pixel_0_valid_in_wr[10]), .Pixel_0_in(Shared_Pixel_0_in_wr[10]),
		.ALU_out(PE1_ALU_out_wr[10]),
		.ALU_valid_out(PE1_ALU_valid_wr[10]),
		.ALU_addr_out(PE1_ALU_addr_wr[10]),
		.ALU_en_out(PE1_ALU_en_wr[10])
	);

	PE_lite #(.UNIT_NO(11)) pea1_11 (
		.CLK(CLK), .RST(RST),
		.En_in(En_wr), .layer_done_in(layer_done_wr), .CFG_in(CFG_wr),
		.CTRL_LDM_Store_in(CTRL_LDM_Store_1_wr),
		.Weight_valid_in(Weight_valid_2_1_rg), .Weight_in(Weight_1_rg),
		.Bias_valid_in(Bias_valid_2_1_rg), .Bias_in(Bias_1_rg),
		.Pixel_0_valid_in(Shared_Pixel_0_valid_in_wr[11]), .Pixel_0_in(Shared_Pixel_0_in_wr[11]),
		.ALU_out(PE1_ALU_out_wr[11]),
		.ALU_valid_out(PE1_ALU_valid_wr[11]),
		.ALU_addr_out(PE1_ALU_addr_wr[11]),
		.ALU_en_out(PE1_ALU_en_wr[11])
	);

	PE_lite #(.UNIT_NO(12)) pea1_12 (
		.CLK(CLK), .RST(RST),
		.En_in(En_wr), .layer_done_in(layer_done_wr), .CFG_in(CFG_wr),
		.CTRL_LDM_Store_in(CTRL_LDM_Store_1_wr),
		.Weight_valid_in(Weight_valid_2_1_rg), .Weight_in(Weight_1_rg),
		.Bias_valid_in(Bias_valid_2_1_rg), .Bias_in(Bias_1_rg),
		.Pixel_0_valid_in(Shared_Pixel_0_valid_in_wr[12]), .Pixel_0_in(Shared_Pixel_0_in_wr[12]),
		.ALU_out(PE1_ALU_out_wr[12]),
		.ALU_valid_out(PE1_ALU_valid_wr[12]),
		.ALU_addr_out(PE1_ALU_addr_wr[12]),
		.ALU_en_out(PE1_ALU_en_wr[12])
	);

	PE_lite #(.UNIT_NO(13)) pea1_13 (
		.CLK(CLK), .RST(RST),
		.En_in(En_wr), .layer_done_in(layer_done_wr), .CFG_in(CFG_wr),
		.CTRL_LDM_Store_in(CTRL_LDM_Store_1_wr),
		.Weight_valid_in(Weight_valid_2_1_rg), .Weight_in(Weight_1_rg),
		.Bias_valid_in(Bias_valid_2_1_rg), .Bias_in(Bias_1_rg),
		.Pixel_0_valid_in(Shared_Pixel_0_valid_in_wr[13]), .Pixel_0_in(Shared_Pixel_0_in_wr[13]),
		.ALU_out(PE1_ALU_out_wr[13]),
		.ALU_valid_out(PE1_ALU_valid_wr[13]),
		.ALU_addr_out(PE1_ALU_addr_wr[13]),
		.ALU_en_out(PE1_ALU_en_wr[13])
	);

	PE_lite #(.UNIT_NO(14)) pea1_14 (
		.CLK(CLK), .RST(RST),
		.En_in(En_wr), .layer_done_in(layer_done_wr), .CFG_in(CFG_wr),
		.CTRL_LDM_Store_in(CTRL_LDM_Store_1_wr),
		.Weight_valid_in(Weight_valid_2_1_rg), .Weight_in(Weight_1_rg),
		.Bias_valid_in(Bias_valid_2_1_rg), .Bias_in(Bias_1_rg),
		.Pixel_0_valid_in(Shared_Pixel_0_valid_in_wr[14]), .Pixel_0_in(Shared_Pixel_0_in_wr[14]),
		.ALU_out(PE1_ALU_out_wr[14]),
		.ALU_valid_out(PE1_ALU_valid_wr[14]),
		.ALU_addr_out(PE1_ALU_addr_wr[14]),
		.ALU_en_out(PE1_ALU_en_wr[14])
	);

	PE_lite #(.UNIT_NO(15)) pea1_15 (
		.CLK(CLK), .RST(RST),
		.En_in(En_wr), .layer_done_in(layer_done_wr), .CFG_in(CFG_wr),
		.CTRL_LDM_Store_in(CTRL_LDM_Store_1_wr),
		.Weight_valid_in(Weight_valid_2_1_rg), .Weight_in(Weight_1_rg),
		.Bias_valid_in(Bias_valid_2_1_rg), .Bias_in(Bias_1_rg),
		.Pixel_0_valid_in(Shared_Pixel_0_valid_in_wr[15]), .Pixel_0_in(Shared_Pixel_0_in_wr[15]),
		.ALU_out(PE1_ALU_out_wr[15]),
		.ALU_valid_out(PE1_ALU_valid_wr[15]),
		.ALU_addr_out(PE1_ALU_addr_wr[15]),
		.ALU_en_out(PE1_ALU_en_wr[15])
	);

	PE_lite #(.UNIT_NO(16)) pea1_16 (
		.CLK(CLK), .RST(RST),
		.En_in(En_wr), .layer_done_in(layer_done_wr), .CFG_in(CFG_wr),
		.CTRL_LDM_Store_in(CTRL_LDM_Store_1_wr),
		.Weight_valid_in(Weight_valid_2_1_rg), .Weight_in(Weight_1_rg),
		.Bias_valid_in(Bias_valid_2_1_rg), .Bias_in(Bias_1_rg),
		.Pixel_0_valid_in(Shared_Pixel_0_valid_in_wr[16]), .Pixel_0_in(Shared_Pixel_0_in_wr[16]),
		.ALU_out(PE1_ALU_out_wr[16]),
		.ALU_valid_out(PE1_ALU_valid_wr[16]),
		.ALU_addr_out(PE1_ALU_addr_wr[16]),
		.ALU_en_out(PE1_ALU_en_wr[16])
	);

	PE_lite #(.UNIT_NO(17)) pea1_17 (
		.CLK(CLK), .RST(RST),
		.En_in(En_wr), .layer_done_in(layer_done_wr), .CFG_in(CFG_wr),
		.CTRL_LDM_Store_in(CTRL_LDM_Store_1_wr),
		.Weight_valid_in(Weight_valid_2_1_rg), .Weight_in(Weight_1_rg),
		.Bias_valid_in(Bias_valid_2_1_rg), .Bias_in(Bias_1_rg),
		.Pixel_0_valid_in(Shared_Pixel_0_valid_in_wr[17]), .Pixel_0_in(Shared_Pixel_0_in_wr[17]),
		.ALU_out(PE1_ALU_out_wr[17]),
		.ALU_valid_out(PE1_ALU_valid_wr[17]),
		.ALU_addr_out(PE1_ALU_addr_wr[17]),
		.ALU_en_out(PE1_ALU_en_wr[17])
	);

	PE_lite #(.UNIT_NO(18)) pea1_18 (
		.CLK(CLK), .RST(RST),
		.En_in(En_wr), .layer_done_in(layer_done_wr), .CFG_in(CFG_wr),
		.CTRL_LDM_Store_in(CTRL_LDM_Store_1_wr),
		.Weight_valid_in(Weight_valid_2_1_rg), .Weight_in(Weight_1_rg),
		.Bias_valid_in(Bias_valid_2_1_rg), .Bias_in(Bias_1_rg),
		.Pixel_0_valid_in(Shared_Pixel_0_valid_in_wr[18]), .Pixel_0_in(Shared_Pixel_0_in_wr[18]),
		.ALU_out(PE1_ALU_out_wr[18]),
		.ALU_valid_out(PE1_ALU_valid_wr[18]),
		.ALU_addr_out(PE1_ALU_addr_wr[18]),
		.ALU_en_out(PE1_ALU_en_wr[18])
	);

	PE_lite #(.UNIT_NO(19)) pea1_19 (
		.CLK(CLK), .RST(RST),
		.En_in(En_wr), .layer_done_in(layer_done_wr), .CFG_in(CFG_wr),
		.CTRL_LDM_Store_in(CTRL_LDM_Store_1_wr),
		.Weight_valid_in(Weight_valid_2_1_rg), .Weight_in(Weight_1_rg),
		.Bias_valid_in(Bias_valid_2_1_rg), .Bias_in(Bias_1_rg),
		.Pixel_0_valid_in(Shared_Pixel_0_valid_in_wr[19]), .Pixel_0_in(Shared_Pixel_0_in_wr[19]),
		.ALU_out(PE1_ALU_out_wr[19]),
		.ALU_valid_out(PE1_ALU_valid_wr[19]),
		.ALU_addr_out(PE1_ALU_addr_wr[19]),
		.ALU_en_out(PE1_ALU_en_wr[19])
	);

	PE_lite #(.UNIT_NO(20)) pea1_20 (
		.CLK(CLK), .RST(RST),
		.En_in(En_wr), .layer_done_in(layer_done_wr), .CFG_in(CFG_wr),
		.CTRL_LDM_Store_in(CTRL_LDM_Store_1_wr),
		.Weight_valid_in(Weight_valid_2_1_rg), .Weight_in(Weight_1_rg),
		.Bias_valid_in(Bias_valid_2_1_rg), .Bias_in(Bias_1_rg),
		.Pixel_0_valid_in(Shared_Pixel_0_valid_in_wr[20]), .Pixel_0_in(Shared_Pixel_0_in_wr[20]),
		.ALU_out(PE1_ALU_out_wr[20]),
		.ALU_valid_out(PE1_ALU_valid_wr[20]),
		.ALU_addr_out(PE1_ALU_addr_wr[20]),
		.ALU_en_out(PE1_ALU_en_wr[20])
	);

	PE_lite #(.UNIT_NO(21)) pea1_21 (
		.CLK(CLK), .RST(RST),
		.En_in(En_wr), .layer_done_in(layer_done_wr), .CFG_in(CFG_wr),
		.CTRL_LDM_Store_in(CTRL_LDM_Store_1_wr),
		.Weight_valid_in(Weight_valid_2_1_rg), .Weight_in(Weight_1_rg),
		.Bias_valid_in(Bias_valid_2_1_rg), .Bias_in(Bias_1_rg),
		.Pixel_0_valid_in(Shared_Pixel_0_valid_in_wr[21]), .Pixel_0_in(Shared_Pixel_0_in_wr[21]),
		.ALU_out(PE1_ALU_out_wr[21]),
		.ALU_valid_out(PE1_ALU_valid_wr[21]),
		.ALU_addr_out(PE1_ALU_addr_wr[21]),
		.ALU_en_out(PE1_ALU_en_wr[21])
	);

	PE_lite #(.UNIT_NO(22)) pea1_22 (
		.CLK(CLK), .RST(RST),
		.En_in(En_wr), .layer_done_in(layer_done_wr), .CFG_in(CFG_wr),
		.CTRL_LDM_Store_in(CTRL_LDM_Store_1_wr),
		.Weight_valid_in(Weight_valid_2_1_rg), .Weight_in(Weight_1_rg),
		.Bias_valid_in(Bias_valid_2_1_rg), .Bias_in(Bias_1_rg),
		.Pixel_0_valid_in(Shared_Pixel_0_valid_in_wr[22]), .Pixel_0_in(Shared_Pixel_0_in_wr[22]),
		.ALU_out(PE1_ALU_out_wr[22]),
		.ALU_valid_out(PE1_ALU_valid_wr[22]),
		.ALU_addr_out(PE1_ALU_addr_wr[22]),
		.ALU_en_out(PE1_ALU_en_wr[22])
	);

	PE_lite #(.UNIT_NO(23)) pea1_23 (
		.CLK(CLK), .RST(RST),
		.En_in(En_wr), .layer_done_in(layer_done_wr), .CFG_in(CFG_wr),
		.CTRL_LDM_Store_in(CTRL_LDM_Store_1_wr),
		.Weight_valid_in(Weight_valid_2_1_rg), .Weight_in(Weight_1_rg),
		.Bias_valid_in(Bias_valid_2_1_rg), .Bias_in(Bias_1_rg),
		.Pixel_0_valid_in(Shared_Pixel_0_valid_in_wr[23]), .Pixel_0_in(Shared_Pixel_0_in_wr[23]),
		.ALU_out(PE1_ALU_out_wr[23]),
		.ALU_valid_out(PE1_ALU_valid_wr[23]),
		.ALU_addr_out(PE1_ALU_addr_wr[23]),
		.ALU_en_out(PE1_ALU_en_wr[23])
	);

	PE_lite #(.UNIT_NO(24)) pea1_24 (
		.CLK(CLK), .RST(RST),
		.En_in(En_wr), .layer_done_in(layer_done_wr), .CFG_in(CFG_wr),
		.CTRL_LDM_Store_in(CTRL_LDM_Store_1_wr),
		.Weight_valid_in(Weight_valid_2_1_rg), .Weight_in(Weight_1_rg),
		.Bias_valid_in(Bias_valid_2_1_rg), .Bias_in(Bias_1_rg),
		.Pixel_0_valid_in(Shared_Pixel_0_valid_in_wr[24]), .Pixel_0_in(Shared_Pixel_0_in_wr[24]),
		.ALU_out(PE1_ALU_out_wr[24]),
		.ALU_valid_out(PE1_ALU_valid_wr[24]),
		.ALU_addr_out(PE1_ALU_addr_wr[24]),
		.ALU_en_out(PE1_ALU_en_wr[24])
	);

	PE_lite #(.UNIT_NO(25)) pea1_25 (
		.CLK(CLK), .RST(RST),
		.En_in(En_wr), .layer_done_in(layer_done_wr), .CFG_in(CFG_wr),
		.CTRL_LDM_Store_in(CTRL_LDM_Store_1_wr),
		.Weight_valid_in(Weight_valid_2_1_rg), .Weight_in(Weight_1_rg),
		.Bias_valid_in(Bias_valid_2_1_rg), .Bias_in(Bias_1_rg),
		.Pixel_0_valid_in(Shared_Pixel_0_valid_in_wr[25]), .Pixel_0_in(Shared_Pixel_0_in_wr[25]),
		.ALU_out(PE1_ALU_out_wr[25]),
		.ALU_valid_out(PE1_ALU_valid_wr[25]),
		.ALU_addr_out(PE1_ALU_addr_wr[25]),
		.ALU_en_out(PE1_ALU_en_wr[25])
	);

	PE_lite #(.UNIT_NO(26)) pea1_26 (
		.CLK(CLK), .RST(RST),
		.En_in(En_wr), .layer_done_in(layer_done_wr), .CFG_in(CFG_wr),
		.CTRL_LDM_Store_in(CTRL_LDM_Store_1_wr),
		.Weight_valid_in(Weight_valid_2_1_rg), .Weight_in(Weight_1_rg),
		.Bias_valid_in(Bias_valid_2_1_rg), .Bias_in(Bias_1_rg),
		.Pixel_0_valid_in(Shared_Pixel_0_valid_in_wr[26]), .Pixel_0_in(Shared_Pixel_0_in_wr[26]),
		.ALU_out(PE1_ALU_out_wr[26]),
		.ALU_valid_out(PE1_ALU_valid_wr[26]),
		.ALU_addr_out(PE1_ALU_addr_wr[26]),
		.ALU_en_out(PE1_ALU_en_wr[26])
	);

	PE_lite #(.UNIT_NO(27)) pea1_27 (
		.CLK(CLK), .RST(RST),
		.En_in(En_wr), .layer_done_in(layer_done_wr), .CFG_in(CFG_wr),
		.CTRL_LDM_Store_in(CTRL_LDM_Store_1_wr),
		.Weight_valid_in(Weight_valid_2_1_rg), .Weight_in(Weight_1_rg),
		.Bias_valid_in(Bias_valid_2_1_rg), .Bias_in(Bias_1_rg),
		.Pixel_0_valid_in(Shared_Pixel_0_valid_in_wr[27]), .Pixel_0_in(Shared_Pixel_0_in_wr[27]),
		.ALU_out(PE1_ALU_out_wr[27]),
		.ALU_valid_out(PE1_ALU_valid_wr[27]),
		.ALU_addr_out(PE1_ALU_addr_wr[27]),
		.ALU_en_out(PE1_ALU_en_wr[27])
	);

	PE_lite #(.UNIT_NO(28)) pea1_28 (
		.CLK(CLK), .RST(RST),
		.En_in(En_wr), .layer_done_in(layer_done_wr), .CFG_in(CFG_wr),
		.CTRL_LDM_Store_in(CTRL_LDM_Store_1_wr),
		.Weight_valid_in(Weight_valid_2_1_rg), .Weight_in(Weight_1_rg),
		.Bias_valid_in(Bias_valid_2_1_rg), .Bias_in(Bias_1_rg),
		.Pixel_0_valid_in(Shared_Pixel_0_valid_in_wr[28]), .Pixel_0_in(Shared_Pixel_0_in_wr[28]),
		.ALU_out(PE1_ALU_out_wr[28]),
		.ALU_valid_out(PE1_ALU_valid_wr[28]),
		.ALU_addr_out(PE1_ALU_addr_wr[28]),
		.ALU_en_out(PE1_ALU_en_wr[28])
	);

	PE_lite #(.UNIT_NO(29)) pea1_29 (
		.CLK(CLK), .RST(RST),
		.En_in(En_wr), .layer_done_in(layer_done_wr), .CFG_in(CFG_wr),
		.CTRL_LDM_Store_in(CTRL_LDM_Store_1_wr),
		.Weight_valid_in(Weight_valid_2_1_rg), .Weight_in(Weight_1_rg),
		.Bias_valid_in(Bias_valid_2_1_rg), .Bias_in(Bias_1_rg),
		.Pixel_0_valid_in(Shared_Pixel_0_valid_in_wr[29]), .Pixel_0_in(Shared_Pixel_0_in_wr[29]),
		.ALU_out(PE1_ALU_out_wr[29]),
		.ALU_valid_out(PE1_ALU_valid_wr[29]),
		.ALU_addr_out(PE1_ALU_addr_wr[29]),
		.ALU_en_out(PE1_ALU_en_wr[29])
	);

	PE_lite #(.UNIT_NO(30)) pea1_30 (
		.CLK(CLK), .RST(RST),
		.En_in(En_wr), .layer_done_in(layer_done_wr), .CFG_in(CFG_wr),
		.CTRL_LDM_Store_in(CTRL_LDM_Store_1_wr),
		.Weight_valid_in(Weight_valid_2_1_rg), .Weight_in(Weight_1_rg),
		.Bias_valid_in(Bias_valid_2_1_rg), .Bias_in(Bias_1_rg),
		.Pixel_0_valid_in(Shared_Pixel_0_valid_in_wr[30]), .Pixel_0_in(Shared_Pixel_0_in_wr[30]),
		.ALU_out(PE1_ALU_out_wr[30]),
		.ALU_valid_out(PE1_ALU_valid_wr[30]),
		.ALU_addr_out(PE1_ALU_addr_wr[30]),
		.ALU_en_out(PE1_ALU_en_wr[30])
	);

	PE_lite #(.UNIT_NO(31)) pea1_31 (
		.CLK(CLK), .RST(RST),
		.En_in(En_wr), .layer_done_in(layer_done_wr), .CFG_in(CFG_wr),
		.CTRL_LDM_Store_in(CTRL_LDM_Store_1_wr),
		.Weight_valid_in(Weight_valid_2_1_rg), .Weight_in(Weight_1_rg),
		.Bias_valid_in(Bias_valid_2_1_rg), .Bias_in(Bias_1_rg),
		.Pixel_0_valid_in(Shared_Pixel_0_valid_in_wr[31]), .Pixel_0_in(Shared_Pixel_0_in_wr[31]),
		.ALU_out(PE1_ALU_out_wr[31]),
		.ALU_valid_out(PE1_ALU_valid_wr[31]),
		.ALU_addr_out(PE1_ALU_addr_wr[31]),
		.ALU_en_out(PE1_ALU_en_wr[31])
	);

	PE_lite #(.UNIT_NO(32)) pea1_32 (
		.CLK(CLK), .RST(RST),
		.En_in(En_wr), .layer_done_in(layer_done_wr), .CFG_in(CFG_wr),
		.CTRL_LDM_Store_in(CTRL_LDM_Store_1_wr),
		.Weight_valid_in(Weight_valid_2_1_rg), .Weight_in(Weight_1_rg),
		.Bias_valid_in(Bias_valid_2_1_rg), .Bias_in(Bias_1_rg),
		.Pixel_0_valid_in(Shared_Pixel_0_valid_in_wr[32]), .Pixel_0_in(Shared_Pixel_0_in_wr[32]),
		.ALU_out(PE1_ALU_out_wr[32]),
		.ALU_valid_out(PE1_ALU_valid_wr[32]),
		.ALU_addr_out(PE1_ALU_addr_wr[32]),
		.ALU_en_out(PE1_ALU_en_wr[32])
	);

	PE_lite #(.UNIT_NO(33)) pea1_33 (
		.CLK(CLK), .RST(RST),
		.En_in(En_wr), .layer_done_in(layer_done_wr), .CFG_in(CFG_wr),
		.CTRL_LDM_Store_in(CTRL_LDM_Store_1_wr),
		.Weight_valid_in(Weight_valid_2_1_rg), .Weight_in(Weight_1_rg),
		.Bias_valid_in(Bias_valid_2_1_rg), .Bias_in(Bias_1_rg),
		.Pixel_0_valid_in(Shared_Pixel_0_valid_in_wr[33]), .Pixel_0_in(Shared_Pixel_0_in_wr[33]),
		.ALU_out(PE1_ALU_out_wr[33]),
		.ALU_valid_out(PE1_ALU_valid_wr[33]),
		.ALU_addr_out(PE1_ALU_addr_wr[33]),
		.ALU_en_out(PE1_ALU_en_wr[33])
	);

	PE_lite #(.UNIT_NO(34)) pea1_34 (
		.CLK(CLK), .RST(RST),
		.En_in(En_wr), .layer_done_in(layer_done_wr), .CFG_in(CFG_wr),
		.CTRL_LDM_Store_in(CTRL_LDM_Store_1_wr),
		.Weight_valid_in(Weight_valid_2_1_rg), .Weight_in(Weight_1_rg),
		.Bias_valid_in(Bias_valid_2_1_rg), .Bias_in(Bias_1_rg),
		.Pixel_0_valid_in(Shared_Pixel_0_valid_in_wr[34]), .Pixel_0_in(Shared_Pixel_0_in_wr[34]),
		.ALU_out(PE1_ALU_out_wr[34]),
		.ALU_valid_out(PE1_ALU_valid_wr[34]),
		.ALU_addr_out(PE1_ALU_addr_wr[34]),
		.ALU_en_out(PE1_ALU_en_wr[34])
	);

	PE_lite #(.UNIT_NO(35)) pea1_35 (
		.CLK(CLK), .RST(RST),
		.En_in(En_wr), .layer_done_in(layer_done_wr), .CFG_in(CFG_wr),
		.CTRL_LDM_Store_in(CTRL_LDM_Store_1_wr),
		.Weight_valid_in(Weight_valid_2_1_rg), .Weight_in(Weight_1_rg),
		.Bias_valid_in(Bias_valid_2_1_rg), .Bias_in(Bias_1_rg),
		.Pixel_0_valid_in(Shared_Pixel_0_valid_in_wr[35]), .Pixel_0_in(Shared_Pixel_0_in_wr[35]),
		.ALU_out(PE1_ALU_out_wr[35]),
		.ALU_valid_out(PE1_ALU_valid_wr[35]),
		.ALU_addr_out(PE1_ALU_addr_wr[35]),
		.ALU_en_out(PE1_ALU_en_wr[35])
	);

	PE_lite #(.UNIT_NO(36)) pea1_36 (
		.CLK(CLK), .RST(RST),
		.En_in(En_wr), .layer_done_in(layer_done_wr), .CFG_in(CFG_wr),
		.CTRL_LDM_Store_in(CTRL_LDM_Store_1_wr),
		.Weight_valid_in(Weight_valid_2_1_rg), .Weight_in(Weight_1_rg),
		.Bias_valid_in(Bias_valid_2_1_rg), .Bias_in(Bias_1_rg),
		.Pixel_0_valid_in(Shared_Pixel_0_valid_in_wr[36]), .Pixel_0_in(Shared_Pixel_0_in_wr[36]),
		.ALU_out(PE1_ALU_out_wr[36]),
		.ALU_valid_out(PE1_ALU_valid_wr[36]),
		.ALU_addr_out(PE1_ALU_addr_wr[36]),
		.ALU_en_out(PE1_ALU_en_wr[36])
	);

	PE_lite #(.UNIT_NO(37)) pea1_37 (
		.CLK(CLK), .RST(RST),
		.En_in(En_wr), .layer_done_in(layer_done_wr), .CFG_in(CFG_wr),
		.CTRL_LDM_Store_in(CTRL_LDM_Store_1_wr),
		.Weight_valid_in(Weight_valid_2_1_rg), .Weight_in(Weight_1_rg),
		.Bias_valid_in(Bias_valid_2_1_rg), .Bias_in(Bias_1_rg),
		.Pixel_0_valid_in(Shared_Pixel_0_valid_in_wr[37]), .Pixel_0_in(Shared_Pixel_0_in_wr[37]),
		.ALU_out(PE1_ALU_out_wr[37]),
		.ALU_valid_out(PE1_ALU_valid_wr[37]),
		.ALU_addr_out(PE1_ALU_addr_wr[37]),
		.ALU_en_out(PE1_ALU_en_wr[37])
	);

	PE_lite #(.UNIT_NO(38)) pea1_38 (
		.CLK(CLK), .RST(RST),
		.En_in(En_wr), .layer_done_in(layer_done_wr), .CFG_in(CFG_wr),
		.CTRL_LDM_Store_in(CTRL_LDM_Store_1_wr),
		.Weight_valid_in(Weight_valid_2_1_rg), .Weight_in(Weight_1_rg),
		.Bias_valid_in(Bias_valid_2_1_rg), .Bias_in(Bias_1_rg),
		.Pixel_0_valid_in(Shared_Pixel_0_valid_in_wr[38]), .Pixel_0_in(Shared_Pixel_0_in_wr[38]),
		.ALU_out(PE1_ALU_out_wr[38]),
		.ALU_valid_out(PE1_ALU_valid_wr[38]),
		.ALU_addr_out(PE1_ALU_addr_wr[38]),
		.ALU_en_out(PE1_ALU_en_wr[38])
	);

	PE_lite #(.UNIT_NO(39)) pea1_39 (
		.CLK(CLK), .RST(RST),
		.En_in(En_wr), .layer_done_in(layer_done_wr), .CFG_in(CFG_wr),
		.CTRL_LDM_Store_in(CTRL_LDM_Store_1_wr),
		.Weight_valid_in(Weight_valid_2_1_rg), .Weight_in(Weight_1_rg),
		.Bias_valid_in(Bias_valid_2_1_rg), .Bias_in(Bias_1_rg),
		.Pixel_0_valid_in(Shared_Pixel_0_valid_in_wr[39]), .Pixel_0_in(Shared_Pixel_0_in_wr[39]),
		.ALU_out(PE1_ALU_out_wr[39]),
		.ALU_valid_out(PE1_ALU_valid_wr[39]),
		.ALU_addr_out(PE1_ALU_addr_wr[39]),
		.ALU_en_out(PE1_ALU_en_wr[39])
	);

endmodule
