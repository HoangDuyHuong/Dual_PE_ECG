/*
 *-----------------------------------------------------------------------------
 * Title         : ALU
 * Project       : CGRA_ECG
 *-----------------------------------------------------------------------------
 * File          : ALU.v
 * Author        : Pham Hoai Luan
 * <pham.luan@is.naist.jp>
 * Created       : 2024.10.15
 *-----------------------------------------------------------------------------
 * Last modified : 2024.10.15
 * Copyright (c) 2024 by NAIST This model is the confidential and
 * proprietary property of NAIST and the possession or use of this
 * file requires a written license from NAIST.
 *-----------------------------------------------------------------------------
 * Modification history :
 * 2024.10.15 : created
 *-----------------------------------------------------------------------------
 */
 
`timescale 1ns/1ns
`include "common.vh"

module ALU
(
	input  wire                                 CLK,
	input  wire                                 RST,
	
	//-----------------------------------------------------//
	//          			Input Signals                  // 
	//-----------------------------------------------------//
	input  wire 					            En_in,
	input  wire signed [`ALU_CFG_BITS-2:0]      CFG_in,
	input  wire 					            ReLU_en_in,
	input  wire 					            S0_valid_in,
	input  wire signed [`WORD_BITS-1:0]         S0_in,
	input  wire 					            S1_valid_in,
	input  wire signed [`WORD_BITS-1:0]         S1_in,
	input  wire 					            S2_valid_in,
	input  wire signed [`WORD_BITS-1:0]         S2_in,
	//-----------------------------------------------------//
	//          			Output Signals                 // 
	//-----------------------------------------------------//
	output wire signed [`WORD_BITS-1:0]         D0_out,
	output wire  					           	Valid_out
);

	// *************** Wire signals *************** //
	wire signed [`WORD_BITS-1:0]      			MAC_wr;
	wire 				      					MAC_valid_wr;
	wire signed [`WORD_BITS-1:0]      			Max_wr;
	wire 				      					Max_valid_wr;
	
	wire signed [`WORD_BITS-1:0]				S1_wr;
	
	// *************** Register signals *************** //
	reg signed [`WORD_BITS-1:0]      			D0_rg;
	reg 				      					D0_valid_rg;
	reg [`ALU_CFG_BITS-2:0]             		CFG_1_rg, CFG_2_rg;
	reg											En_1_rg, En_2_rg; 

	assign S1_wr			= (CFG_in[`ALU_CFG_BITS-2:0] == `EXE_ADD) ? 16'h0040 : S1_in;
	
	MAC mac
	(
    .CLK(CLK),                      
    .RST(RST),
	.ReLU_en_in(ReLU_en_in),
    .S0_valid_in(S0_valid_in),        
    .S0_in(S0_in),  
    .S1_valid_in(S1_valid_in),        
    .S1_in(S1_wr),  
    .S2_valid_in(S2_valid_in),        
    .S2_in(S2_in), 
    .D0_valid(MAC_valid_wr),  
    .D0_out(MAC_wr)  
	);

	MaxValue max (
		.CLK(CLK),                    
		.RST(RST),   
		.S0_valid_in(S0_valid_in),	
		.S0_in(S0_in),
		.S1_valid_in(S1_valid_in),	
		.S1_in(S1_in),    
		.S2_valid_in(S2_valid_in),	
		.S2_in(S2_in), 
		.Max_valid_out(Max_valid_wr),
		.Max_out(Max_wr)
	);

	always @(posedge CLK or negedge RST) begin
        if (~RST) begin
            CFG_1_rg 		<= 0;
			CFG_2_rg		<= 0;
			
            CFG_1_rg 		<= 0; 
			CFG_2_rg		<= 0;
        end
        else begin
			CFG_1_rg 		<= CFG_in;
			CFG_2_rg		<= CFG_1_rg;
			
			En_1_rg 		<= En_in; 
			En_2_rg			<= En_1_rg;
        end
    end
	
	always @(*) begin
		case (CFG_2_rg)
			`EXE_NOP: begin   ///*** No Operation ***///
				D0_rg 		= 0;
				D0_valid_rg	= 0;
			end
			`EXE_MAC: begin   ///*** Mutiply-Adder Operation ***///
				D0_rg 		= MAC_wr; 
				D0_valid_rg	= MAC_valid_wr;
			end
			`EXE_ADD: begin   ///*** Adder Operation ***///
				D0_rg 		= MAC_wr; 
				D0_valid_rg	= MAC_valid_wr;
			end
			`EXE_MP: begin   ///*** Max Pooling Operation ***///
				D0_rg 		= Max_wr; 
				D0_valid_rg	= Max_valid_wr;
			end
			default: begin
				D0_rg 		= 0;
				D0_valid_rg	= 0;
			end
		endcase
	end

	assign D0_out 			= (En_2_rg == 1) ? D0_rg : 0;
	assign Valid_out		= (En_2_rg == 1) ? D0_valid_rg : 0;
	
endmodule

module MaxValue (
    input wire 								CLK,                    
    input wire 								RST,   
	input wire 								S0_valid_in,	
    input wire signed [`WORD_BITS-1:0]  	S0_in,    // Fixed-point input: 1 sign bit, 9 integer bits, 6 fractional bits
	input wire 								S1_valid_in,	
    input wire signed [`WORD_BITS-1:0]  	S1_in,    // Fixed-point input: 1 sign bit, 9 integer bits, 6 fractional bits
	input wire 								S2_valid_in,	
    input wire signed [`WORD_BITS-1:0]  	S2_in,    // Fixed-point input: 1 sign bit, 9 integer bits, 6 fractional bits
	output reg  					        Max_valid_out,
    output reg signed [`WORD_BITS-1:0]  	Max_out   // Fixed-point output: 1 sign bit, 9 integer bits, 6 fractional bits
);

	// Define the fixed-point representation of -10 (16-bit fixed-point: 1 sign, 9 integer, 6 fractional)
    localparam signed [`WORD_BITS-1:0]		NEG_TEN = -10 << 6;
	// Shift by 6 to represent -10 in 6 fractional bits

    // *************** Wire signals *************** //    
    wire signed [`WORD_BITS-1:0] 			max_S0_S1_S2_wr;
	wire signed [`WORD_BITS-1:0] 			max_final_wr;
	
	// *************** Register signals *************** //
	reg signed [`WORD_BITS-1:0] 			max_S0_S1_rg;
	reg signed [`WORD_BITS-1:0] 			S2_rg;
	reg										S0_valid_rg, S1_valid_rg, S2_valid_rg;
	
	// Find the maximum value between max_S0_S1 and S2
    assign max_S0_S1_S2_wr = (max_S0_S1_rg > S2_rg) ? max_S0_S1_rg : S2_rg;
	assign max_final_wr = (max_S0_S1_S2_wr < NEG_TEN) ? NEG_TEN : max_S0_S1_S2_wr;
	
	always @(posedge CLK or negedge RST) begin
        if (~RST) begin
            max_S0_S1_rg		<= 16'sd0;
			S2_rg				<= 16'sd0;
			S0_valid_rg			<= 0;
			S1_valid_rg			<= 0;
			S2_valid_rg			<= 0;
			Max_valid_out		<= 0;
			Max_out				<= 0;
        end
        else begin
			S2_rg 				<= S2_in;
			
			S0_valid_rg			<= S0_valid_in;
			S1_valid_rg			<= S1_valid_in;
			S2_valid_rg			<= S2_valid_in;
			
			if(S0_in > S1_in)
				max_S0_S1_rg 	<= S0_in;
			else 
				max_S0_S1_rg 	<= S1_in;
				
			Max_valid_out 		<= S0_valid_rg & S1_valid_rg & S2_valid_rg;
			Max_out 			<= max_final_wr;
        end
    end 

endmodule

module MAC (
    input wire                          CLK,                      
    input wire                          RST,
	input wire							ReLU_en_in,
    input wire                          S0_valid_in,        
    input wire signed [`WORD_BITS-1:0]  S0_in,   // Fixed-point input: 1 sign bit, 9 integer bits, 6 fractional bits
    input wire                          S1_valid_in,        
    input wire signed [`WORD_BITS-1:0]  S1_in,   // Fixed-point input: 1 sign bit, 9 integer bits, 6 fractional bits
    input wire                          S2_valid_in,        
    input wire signed [`WORD_BITS-1:0]  S2_in,   // Fixed-point input: 1 sign bit, 9 integer bits, 6 fractional bits
    output reg                          D0_valid,  
    output reg signed [`WORD_BITS-1:0]  D0_out   // Fixed-point output: 1 sign bit, 9 integer bits, 6 fractional bits
);

    // *************** Wire signals *************** //
	// Thuộc tính use_dsp ép Vivado sử dụng bộ nhân cứng DSP48
    // THÊM DẤU NGOẶC ĐƠN BẢO VỆ MACRO: (`WORD_BITS*2)-1
    (* use_dsp = "yes" *) wire signed [(`WORD_BITS*2)-1:0] mult_result_wr;
    wire signed [`WORD_BITS-1:0]        sum_final_wr;
    wire signed [`WORD_BITS-1:0]      	bias_wr;
	wire signed [`WORD_BITS-1:0]  		D0_wr, D0_ReLU_wr;
	
    // *************** Register signals *************** //
	reg signed [`WORD_BITS-1:0]      	accumulation_rg;
	reg signed [`WORD_BITS-1:0]      	bias_rg;
    // THÊM DẤU NGOẶC ĐƠN BẢO VỆ MACRO
    reg signed [(`WORD_BITS*2)-1:0]     mult_result_rg;
    reg                                 S0_valid_rg, S1_valid_rg, S2_valid_rg;
	reg 								ReLU_en_rg;

	// Thực hiện phép nhân có dấu trực tiếp
    assign mult_result_wr = S0_in * S1_in;

	// Đưa kết quả về format Q9.6 (dịch phải 6 bit thông qua trích xuất bit 21:6) 
	// và cộng bit 5 để làm tròn (Rounding)
	assign sum_final_wr	  = mult_result_rg[21:6] + mult_result_rg[5];
		
	assign bias_wr		  = (S2_valid_rg) ? bias_rg : 0;
	
	// Cộng dồn kết quả nhân, giá trị tích lũy cũ và bias
	assign D0_wr		  = sum_final_wr + accumulation_rg + bias_wr;
	assign D0_ReLU_wr	  = (ReLU_en_rg & D0_wr[`WORD_BITS-1:`WORD_BITS-1]) ? 0 : D0_wr;

    // Clocked process
    always @(posedge CLK or negedge RST) begin
        if (~RST) begin
            mult_result_rg      		<= 0;
            S0_valid_rg         		<= 0;
            S1_valid_rg         		<= 0;
            S2_valid_rg         		<= 0;
            D0_out              		<= 0;
			accumulation_rg				<= 0;
			bias_rg						<= 0;
			D0_valid            		<= 0;
			ReLU_en_rg					<= 0;
        end 		
        else begin		
			// Pipeline stage 1: Lưu kết quả nhân
            mult_result_rg      		<= mult_result_wr;
            S0_valid_rg         		<= S0_valid_in;
            S1_valid_rg         		<= S1_valid_in;
            S2_valid_rg         		<= S2_valid_in;
			bias_rg						<= S2_in;
			ReLU_en_rg					<= ReLU_en_in;

			// Logic Accumulation
			if(S2_valid_rg) begin
				accumulation_rg			<= 0;
			end                         
			else if(S0_valid_rg|S1_valid_rg)  begin                  
				accumulation_rg			<= D0_wr;
			end
			else begin
				accumulation_rg			<= 0;
			end

            // Pipeline stage 2: Output
			D0_out              		<= D0_ReLU_wr;
			D0_valid            		<= S2_valid_rg;
        end
    end
    
endmodule