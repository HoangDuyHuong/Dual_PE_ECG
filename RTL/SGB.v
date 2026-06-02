`timescale 1ns/1ns
`include "common.vh"

module SGB
(
	input  wire CLK,
	input  wire RST,

	input wire signed [`WORD_BITS-1:0] PEA0_PE0_Pixel_0_in,
	input wire PEA0_PE0_Pixel_0_valid_in,
	input wire signed [`WORD_BITS-1:0] PEA0_PE0_Pixel_1_in,
	input wire PEA0_PE0_Pixel_1_valid_in,

	input wire signed [`WORD_BITS-1:0] PEA0_PE1_Pixel_0_in,
	input wire PEA0_PE1_Pixel_0_valid_in,
	input wire signed [`WORD_BITS-1:0] PEA0_PE1_Pixel_1_in,
	input wire PEA0_PE1_Pixel_1_valid_in,

	input wire signed [`WORD_BITS-1:0] PEA0_PE2_Pixel_0_in,
	input wire PEA0_PE2_Pixel_0_valid_in,
	input wire signed [`WORD_BITS-1:0] PEA0_PE2_Pixel_1_in,
	input wire PEA0_PE2_Pixel_1_valid_in,

	input wire signed [`WORD_BITS-1:0] PEA0_PE3_Pixel_0_in,
	input wire PEA0_PE3_Pixel_0_valid_in,
	input wire signed [`WORD_BITS-1:0] PEA0_PE3_Pixel_1_in,
	input wire PEA0_PE3_Pixel_1_valid_in,

	input wire signed [`WORD_BITS-1:0] PEA0_PE4_Pixel_0_in,
	input wire PEA0_PE4_Pixel_0_valid_in,
	input wire signed [`WORD_BITS-1:0] PEA0_PE4_Pixel_1_in,
	input wire PEA0_PE4_Pixel_1_valid_in,

	input wire signed [`WORD_BITS-1:0] PEA0_PE5_Pixel_0_in,
	input wire PEA0_PE5_Pixel_0_valid_in,
	input wire signed [`WORD_BITS-1:0] PEA0_PE5_Pixel_1_in,
	input wire PEA0_PE5_Pixel_1_valid_in,

	input wire signed [`WORD_BITS-1:0] PEA0_PE6_Pixel_0_in,
	input wire PEA0_PE6_Pixel_0_valid_in,
	input wire signed [`WORD_BITS-1:0] PEA0_PE6_Pixel_1_in,
	input wire PEA0_PE6_Pixel_1_valid_in,

	input wire signed [`WORD_BITS-1:0] PEA0_PE7_Pixel_0_in,
	input wire PEA0_PE7_Pixel_0_valid_in,
	input wire signed [`WORD_BITS-1:0] PEA0_PE7_Pixel_1_in,
	input wire PEA0_PE7_Pixel_1_valid_in,

	input wire signed [`WORD_BITS-1:0] PEA0_PE8_Pixel_0_in,
	input wire PEA0_PE8_Pixel_0_valid_in,
	input wire signed [`WORD_BITS-1:0] PEA0_PE8_Pixel_1_in,
	input wire PEA0_PE8_Pixel_1_valid_in,

	input wire signed [`WORD_BITS-1:0] PEA0_PE9_Pixel_0_in,
	input wire PEA0_PE9_Pixel_0_valid_in,
	input wire signed [`WORD_BITS-1:0] PEA0_PE9_Pixel_1_in,
	input wire PEA0_PE9_Pixel_1_valid_in,

	input wire signed [`WORD_BITS-1:0] PEA0_PE10_Pixel_0_in,
	input wire PEA0_PE10_Pixel_0_valid_in,
	input wire signed [`WORD_BITS-1:0] PEA0_PE10_Pixel_1_in,
	input wire PEA0_PE10_Pixel_1_valid_in,

	input wire signed [`WORD_BITS-1:0] PEA0_PE11_Pixel_0_in,
	input wire PEA0_PE11_Pixel_0_valid_in,
	input wire signed [`WORD_BITS-1:0] PEA0_PE11_Pixel_1_in,
	input wire PEA0_PE11_Pixel_1_valid_in,

	input wire signed [`WORD_BITS-1:0] PEA0_PE12_Pixel_0_in,
	input wire PEA0_PE12_Pixel_0_valid_in,
	input wire signed [`WORD_BITS-1:0] PEA0_PE12_Pixel_1_in,
	input wire PEA0_PE12_Pixel_1_valid_in,

	input wire signed [`WORD_BITS-1:0] PEA0_PE13_Pixel_0_in,
	input wire PEA0_PE13_Pixel_0_valid_in,
	input wire signed [`WORD_BITS-1:0] PEA0_PE13_Pixel_1_in,
	input wire PEA0_PE13_Pixel_1_valid_in,

	input wire signed [`WORD_BITS-1:0] PEA0_PE14_Pixel_0_in,
	input wire PEA0_PE14_Pixel_0_valid_in,
	input wire signed [`WORD_BITS-1:0] PEA0_PE14_Pixel_1_in,
	input wire PEA0_PE14_Pixel_1_valid_in,

	input wire signed [`WORD_BITS-1:0] PEA0_PE15_Pixel_0_in,
	input wire PEA0_PE15_Pixel_0_valid_in,
	input wire signed [`WORD_BITS-1:0] PEA0_PE15_Pixel_1_in,
	input wire PEA0_PE15_Pixel_1_valid_in,

	input wire signed [`WORD_BITS-1:0] PEA0_PE16_Pixel_0_in,
	input wire PEA0_PE16_Pixel_0_valid_in,
	input wire signed [`WORD_BITS-1:0] PEA0_PE16_Pixel_1_in,
	input wire PEA0_PE16_Pixel_1_valid_in,

	input wire signed [`WORD_BITS-1:0] PEA0_PE17_Pixel_0_in,
	input wire PEA0_PE17_Pixel_0_valid_in,
	input wire signed [`WORD_BITS-1:0] PEA0_PE17_Pixel_1_in,
	input wire PEA0_PE17_Pixel_1_valid_in,

	input wire signed [`WORD_BITS-1:0] PEA0_PE18_Pixel_0_in,
	input wire PEA0_PE18_Pixel_0_valid_in,
	input wire signed [`WORD_BITS-1:0] PEA0_PE18_Pixel_1_in,
	input wire PEA0_PE18_Pixel_1_valid_in,

	input wire signed [`WORD_BITS-1:0] PEA0_PE19_Pixel_0_in,
	input wire PEA0_PE19_Pixel_0_valid_in,
	input wire signed [`WORD_BITS-1:0] PEA0_PE19_Pixel_1_in,
	input wire PEA0_PE19_Pixel_1_valid_in,

	input wire signed [`WORD_BITS-1:0] PEA0_PE20_Pixel_0_in,
	input wire PEA0_PE20_Pixel_0_valid_in,
	input wire signed [`WORD_BITS-1:0] PEA0_PE20_Pixel_1_in,
	input wire PEA0_PE20_Pixel_1_valid_in,

	input wire signed [`WORD_BITS-1:0] PEA0_PE21_Pixel_0_in,
	input wire PEA0_PE21_Pixel_0_valid_in,
	input wire signed [`WORD_BITS-1:0] PEA0_PE21_Pixel_1_in,
	input wire PEA0_PE21_Pixel_1_valid_in,

	input wire signed [`WORD_BITS-1:0] PEA0_PE22_Pixel_0_in,
	input wire PEA0_PE22_Pixel_0_valid_in,
	input wire signed [`WORD_BITS-1:0] PEA0_PE22_Pixel_1_in,
	input wire PEA0_PE22_Pixel_1_valid_in,

	input wire signed [`WORD_BITS-1:0] PEA0_PE23_Pixel_0_in,
	input wire PEA0_PE23_Pixel_0_valid_in,
	input wire signed [`WORD_BITS-1:0] PEA0_PE23_Pixel_1_in,
	input wire PEA0_PE23_Pixel_1_valid_in,

	input wire signed [`WORD_BITS-1:0] PEA0_PE24_Pixel_0_in,
	input wire PEA0_PE24_Pixel_0_valid_in,
	input wire signed [`WORD_BITS-1:0] PEA0_PE24_Pixel_1_in,
	input wire PEA0_PE24_Pixel_1_valid_in,

	input wire signed [`WORD_BITS-1:0] PEA0_PE25_Pixel_0_in,
	input wire PEA0_PE25_Pixel_0_valid_in,
	input wire signed [`WORD_BITS-1:0] PEA0_PE25_Pixel_1_in,
	input wire PEA0_PE25_Pixel_1_valid_in,

	input wire signed [`WORD_BITS-1:0] PEA0_PE26_Pixel_0_in,
	input wire PEA0_PE26_Pixel_0_valid_in,
	input wire signed [`WORD_BITS-1:0] PEA0_PE26_Pixel_1_in,
	input wire PEA0_PE26_Pixel_1_valid_in,

	input wire signed [`WORD_BITS-1:0] PEA0_PE27_Pixel_0_in,
	input wire PEA0_PE27_Pixel_0_valid_in,
	input wire signed [`WORD_BITS-1:0] PEA0_PE27_Pixel_1_in,
	input wire PEA0_PE27_Pixel_1_valid_in,

	input wire signed [`WORD_BITS-1:0] PEA0_PE28_Pixel_0_in,
	input wire PEA0_PE28_Pixel_0_valid_in,
	input wire signed [`WORD_BITS-1:0] PEA0_PE28_Pixel_1_in,
	input wire PEA0_PE28_Pixel_1_valid_in,

	input wire signed [`WORD_BITS-1:0] PEA0_PE29_Pixel_0_in,
	input wire PEA0_PE29_Pixel_0_valid_in,
	input wire signed [`WORD_BITS-1:0] PEA0_PE29_Pixel_1_in,
	input wire PEA0_PE29_Pixel_1_valid_in,

	input wire signed [`WORD_BITS-1:0] PEA0_PE30_Pixel_0_in,
	input wire PEA0_PE30_Pixel_0_valid_in,
	input wire signed [`WORD_BITS-1:0] PEA0_PE30_Pixel_1_in,
	input wire PEA0_PE30_Pixel_1_valid_in,

	input wire signed [`WORD_BITS-1:0] PEA0_PE31_Pixel_0_in,
	input wire PEA0_PE31_Pixel_0_valid_in,
	input wire signed [`WORD_BITS-1:0] PEA0_PE31_Pixel_1_in,
	input wire PEA0_PE31_Pixel_1_valid_in,

	input wire signed [`WORD_BITS-1:0] PEA0_PE32_Pixel_0_in,
	input wire PEA0_PE32_Pixel_0_valid_in,
	input wire signed [`WORD_BITS-1:0] PEA0_PE32_Pixel_1_in,
	input wire PEA0_PE32_Pixel_1_valid_in,

	input wire signed [`WORD_BITS-1:0] PEA0_PE33_Pixel_0_in,
	input wire PEA0_PE33_Pixel_0_valid_in,
	input wire signed [`WORD_BITS-1:0] PEA0_PE33_Pixel_1_in,
	input wire PEA0_PE33_Pixel_1_valid_in,

	input wire signed [`WORD_BITS-1:0] PEA0_PE34_Pixel_0_in,
	input wire PEA0_PE34_Pixel_0_valid_in,
	input wire signed [`WORD_BITS-1:0] PEA0_PE34_Pixel_1_in,
	input wire PEA0_PE34_Pixel_1_valid_in,

	input wire signed [`WORD_BITS-1:0] PEA0_PE35_Pixel_0_in,
	input wire PEA0_PE35_Pixel_0_valid_in,
	input wire signed [`WORD_BITS-1:0] PEA0_PE35_Pixel_1_in,
	input wire PEA0_PE35_Pixel_1_valid_in,

	input wire signed [`WORD_BITS-1:0] PEA0_PE36_Pixel_0_in,
	input wire PEA0_PE36_Pixel_0_valid_in,
	input wire signed [`WORD_BITS-1:0] PEA0_PE36_Pixel_1_in,
	input wire PEA0_PE36_Pixel_1_valid_in,

	input wire signed [`WORD_BITS-1:0] PEA0_PE37_Pixel_0_in,
	input wire PEA0_PE37_Pixel_0_valid_in,
	input wire signed [`WORD_BITS-1:0] PEA0_PE37_Pixel_1_in,
	input wire PEA0_PE37_Pixel_1_valid_in,

	input wire signed [`WORD_BITS-1:0] PEA0_PE38_Pixel_0_in,
	input wire PEA0_PE38_Pixel_0_valid_in,
	input wire signed [`WORD_BITS-1:0] PEA0_PE38_Pixel_1_in,
	input wire PEA0_PE38_Pixel_1_valid_in,

	input wire signed [`WORD_BITS-1:0] PEA0_PE39_Pixel_0_in,
	input wire PEA0_PE39_Pixel_0_valid_in,
	input wire signed [`WORD_BITS-1:0] PEA0_PE39_Pixel_1_in,
	input wire PEA0_PE39_Pixel_1_valid_in,

	///*** From the Controller ***///
	input  wire En_in,
	input  wire [`ALU_CFG_BITS-2:0] CFG_in,
	input  wire [`PE_NUM_BITS-1:0] MUX_Selection_in,
	input  wire Parity_PE_Selection_in,
	input  wire Stride_in,
	input  wire MP_Padding_in,
	input  wire MP_Padding_2_in,
	input  wire MP_Padding_3_in,

	//-----------------------------------------------------//
	//          			Output Signals                 //
	//-----------------------------------------------------//
	output reg signed [`WORD_BITS-1:0] Shared_PE0_Pixel_0_out,
	output reg Shared_PE0_Pixel_0_valid_out,
	output reg signed [`WORD_BITS-1:0] Shared_PE0_Pixel_1_out,
	output reg Shared_PE0_Pixel_1_valid_out,
	output reg signed [`WORD_BITS-1:0] Shared_PE0_Pixel_2_out,
	output reg Shared_PE0_Pixel_2_valid_out,

	output reg signed [`WORD_BITS-1:0] Shared_PE1_Pixel_0_out,
	output reg Shared_PE1_Pixel_0_valid_out,
	output reg signed [`WORD_BITS-1:0] Shared_PE1_Pixel_1_out,
	output reg Shared_PE1_Pixel_1_valid_out,
	output reg signed [`WORD_BITS-1:0] Shared_PE1_Pixel_2_out,
	output reg Shared_PE1_Pixel_2_valid_out,

	output reg signed [`WORD_BITS-1:0] Shared_PE2_Pixel_0_out,
	output reg Shared_PE2_Pixel_0_valid_out,
	output reg signed [`WORD_BITS-1:0] Shared_PE2_Pixel_1_out,
	output reg Shared_PE2_Pixel_1_valid_out,
	output reg signed [`WORD_BITS-1:0] Shared_PE2_Pixel_2_out,
	output reg Shared_PE2_Pixel_2_valid_out,

	output reg signed [`WORD_BITS-1:0] Shared_PE3_Pixel_0_out,
	output reg Shared_PE3_Pixel_0_valid_out,
	output reg signed [`WORD_BITS-1:0] Shared_PE3_Pixel_1_out,
	output reg Shared_PE3_Pixel_1_valid_out,
	output reg signed [`WORD_BITS-1:0] Shared_PE3_Pixel_2_out,
	output reg Shared_PE3_Pixel_2_valid_out,

	output reg signed [`WORD_BITS-1:0] Shared_PE4_Pixel_0_out,
	output reg Shared_PE4_Pixel_0_valid_out,
	output reg signed [`WORD_BITS-1:0] Shared_PE4_Pixel_1_out,
	output reg Shared_PE4_Pixel_1_valid_out,
	output reg signed [`WORD_BITS-1:0] Shared_PE4_Pixel_2_out,
	output reg Shared_PE4_Pixel_2_valid_out,

	output reg signed [`WORD_BITS-1:0] Shared_PE5_Pixel_0_out,
	output reg Shared_PE5_Pixel_0_valid_out,
	output reg signed [`WORD_BITS-1:0] Shared_PE5_Pixel_1_out,
	output reg Shared_PE5_Pixel_1_valid_out,
	output reg signed [`WORD_BITS-1:0] Shared_PE5_Pixel_2_out,
	output reg Shared_PE5_Pixel_2_valid_out,

	output reg signed [`WORD_BITS-1:0] Shared_PE6_Pixel_0_out,
	output reg Shared_PE6_Pixel_0_valid_out,
	output reg signed [`WORD_BITS-1:0] Shared_PE6_Pixel_1_out,
	output reg Shared_PE6_Pixel_1_valid_out,
	output reg signed [`WORD_BITS-1:0] Shared_PE6_Pixel_2_out,
	output reg Shared_PE6_Pixel_2_valid_out,

	output reg signed [`WORD_BITS-1:0] Shared_PE7_Pixel_0_out,
	output reg Shared_PE7_Pixel_0_valid_out,
	output reg signed [`WORD_BITS-1:0] Shared_PE7_Pixel_1_out,
	output reg Shared_PE7_Pixel_1_valid_out,
	output reg signed [`WORD_BITS-1:0] Shared_PE7_Pixel_2_out,
	output reg Shared_PE7_Pixel_2_valid_out,

	output reg signed [`WORD_BITS-1:0] Shared_PE8_Pixel_0_out,
	output reg Shared_PE8_Pixel_0_valid_out,
	output reg signed [`WORD_BITS-1:0] Shared_PE8_Pixel_1_out,
	output reg Shared_PE8_Pixel_1_valid_out,
	output reg signed [`WORD_BITS-1:0] Shared_PE8_Pixel_2_out,
	output reg Shared_PE8_Pixel_2_valid_out,

	output reg signed [`WORD_BITS-1:0] Shared_PE9_Pixel_0_out,
	output reg Shared_PE9_Pixel_0_valid_out,
	output reg signed [`WORD_BITS-1:0] Shared_PE9_Pixel_1_out,
	output reg Shared_PE9_Pixel_1_valid_out,
	output reg signed [`WORD_BITS-1:0] Shared_PE9_Pixel_2_out,
	output reg Shared_PE9_Pixel_2_valid_out,

	output reg signed [`WORD_BITS-1:0] Shared_PE10_Pixel_0_out,
	output reg Shared_PE10_Pixel_0_valid_out,
	output reg signed [`WORD_BITS-1:0] Shared_PE10_Pixel_1_out,
	output reg Shared_PE10_Pixel_1_valid_out,
	output reg signed [`WORD_BITS-1:0] Shared_PE10_Pixel_2_out,
	output reg Shared_PE10_Pixel_2_valid_out,

	output reg signed [`WORD_BITS-1:0] Shared_PE11_Pixel_0_out,
	output reg Shared_PE11_Pixel_0_valid_out,
	output reg signed [`WORD_BITS-1:0] Shared_PE11_Pixel_1_out,
	output reg Shared_PE11_Pixel_1_valid_out,
	output reg signed [`WORD_BITS-1:0] Shared_PE11_Pixel_2_out,
	output reg Shared_PE11_Pixel_2_valid_out,

	output reg signed [`WORD_BITS-1:0] Shared_PE12_Pixel_0_out,
	output reg Shared_PE12_Pixel_0_valid_out,
	output reg signed [`WORD_BITS-1:0] Shared_PE12_Pixel_1_out,
	output reg Shared_PE12_Pixel_1_valid_out,
	output reg signed [`WORD_BITS-1:0] Shared_PE12_Pixel_2_out,
	output reg Shared_PE12_Pixel_2_valid_out,

	output reg signed [`WORD_BITS-1:0] Shared_PE13_Pixel_0_out,
	output reg Shared_PE13_Pixel_0_valid_out,
	output reg signed [`WORD_BITS-1:0] Shared_PE13_Pixel_1_out,
	output reg Shared_PE13_Pixel_1_valid_out,
	output reg signed [`WORD_BITS-1:0] Shared_PE13_Pixel_2_out,
	output reg Shared_PE13_Pixel_2_valid_out,

	output reg signed [`WORD_BITS-1:0] Shared_PE14_Pixel_0_out,
	output reg Shared_PE14_Pixel_0_valid_out,
	output reg signed [`WORD_BITS-1:0] Shared_PE14_Pixel_1_out,
	output reg Shared_PE14_Pixel_1_valid_out,
	output reg signed [`WORD_BITS-1:0] Shared_PE14_Pixel_2_out,
	output reg Shared_PE14_Pixel_2_valid_out,

	output reg signed [`WORD_BITS-1:0] Shared_PE15_Pixel_0_out,
	output reg Shared_PE15_Pixel_0_valid_out,
	output reg signed [`WORD_BITS-1:0] Shared_PE15_Pixel_1_out,
	output reg Shared_PE15_Pixel_1_valid_out,
	output reg signed [`WORD_BITS-1:0] Shared_PE15_Pixel_2_out,
	output reg Shared_PE15_Pixel_2_valid_out,

	output reg signed [`WORD_BITS-1:0] Shared_PE16_Pixel_0_out,
	output reg Shared_PE16_Pixel_0_valid_out,
	output reg signed [`WORD_BITS-1:0] Shared_PE16_Pixel_1_out,
	output reg Shared_PE16_Pixel_1_valid_out,
	output reg signed [`WORD_BITS-1:0] Shared_PE16_Pixel_2_out,
	output reg Shared_PE16_Pixel_2_valid_out,

	output reg signed [`WORD_BITS-1:0] Shared_PE17_Pixel_0_out,
	output reg Shared_PE17_Pixel_0_valid_out,
	output reg signed [`WORD_BITS-1:0] Shared_PE17_Pixel_1_out,
	output reg Shared_PE17_Pixel_1_valid_out,
	output reg signed [`WORD_BITS-1:0] Shared_PE17_Pixel_2_out,
	output reg Shared_PE17_Pixel_2_valid_out,

	output reg signed [`WORD_BITS-1:0] Shared_PE18_Pixel_0_out,
	output reg Shared_PE18_Pixel_0_valid_out,
	output reg signed [`WORD_BITS-1:0] Shared_PE18_Pixel_1_out,
	output reg Shared_PE18_Pixel_1_valid_out,
	output reg signed [`WORD_BITS-1:0] Shared_PE18_Pixel_2_out,
	output reg Shared_PE18_Pixel_2_valid_out,

	output reg signed [`WORD_BITS-1:0] Shared_PE19_Pixel_0_out,
	output reg Shared_PE19_Pixel_0_valid_out,
	output reg signed [`WORD_BITS-1:0] Shared_PE19_Pixel_1_out,
	output reg Shared_PE19_Pixel_1_valid_out,
	output reg signed [`WORD_BITS-1:0] Shared_PE19_Pixel_2_out,
	output reg Shared_PE19_Pixel_2_valid_out,

	output reg signed [`WORD_BITS-1:0] Shared_PE20_Pixel_0_out,
	output reg Shared_PE20_Pixel_0_valid_out,
	output reg signed [`WORD_BITS-1:0] Shared_PE20_Pixel_1_out,
	output reg Shared_PE20_Pixel_1_valid_out,
	output reg signed [`WORD_BITS-1:0] Shared_PE20_Pixel_2_out,
	output reg Shared_PE20_Pixel_2_valid_out,

	output reg signed [`WORD_BITS-1:0] Shared_PE21_Pixel_0_out,
	output reg Shared_PE21_Pixel_0_valid_out,
	output reg signed [`WORD_BITS-1:0] Shared_PE21_Pixel_1_out,
	output reg Shared_PE21_Pixel_1_valid_out,
	output reg signed [`WORD_BITS-1:0] Shared_PE21_Pixel_2_out,
	output reg Shared_PE21_Pixel_2_valid_out,

	output reg signed [`WORD_BITS-1:0] Shared_PE22_Pixel_0_out,
	output reg Shared_PE22_Pixel_0_valid_out,
	output reg signed [`WORD_BITS-1:0] Shared_PE22_Pixel_1_out,
	output reg Shared_PE22_Pixel_1_valid_out,
	output reg signed [`WORD_BITS-1:0] Shared_PE22_Pixel_2_out,
	output reg Shared_PE22_Pixel_2_valid_out,

	output reg signed [`WORD_BITS-1:0] Shared_PE23_Pixel_0_out,
	output reg Shared_PE23_Pixel_0_valid_out,
	output reg signed [`WORD_BITS-1:0] Shared_PE23_Pixel_1_out,
	output reg Shared_PE23_Pixel_1_valid_out,
	output reg signed [`WORD_BITS-1:0] Shared_PE23_Pixel_2_out,
	output reg Shared_PE23_Pixel_2_valid_out,

	output reg signed [`WORD_BITS-1:0] Shared_PE24_Pixel_0_out,
	output reg Shared_PE24_Pixel_0_valid_out,
	output reg signed [`WORD_BITS-1:0] Shared_PE24_Pixel_1_out,
	output reg Shared_PE24_Pixel_1_valid_out,
	output reg signed [`WORD_BITS-1:0] Shared_PE24_Pixel_2_out,
	output reg Shared_PE24_Pixel_2_valid_out,

	output reg signed [`WORD_BITS-1:0] Shared_PE25_Pixel_0_out,
	output reg Shared_PE25_Pixel_0_valid_out,
	output reg signed [`WORD_BITS-1:0] Shared_PE25_Pixel_1_out,
	output reg Shared_PE25_Pixel_1_valid_out,
	output reg signed [`WORD_BITS-1:0] Shared_PE25_Pixel_2_out,
	output reg Shared_PE25_Pixel_2_valid_out,

	output reg signed [`WORD_BITS-1:0] Shared_PE26_Pixel_0_out,
	output reg Shared_PE26_Pixel_0_valid_out,
	output reg signed [`WORD_BITS-1:0] Shared_PE26_Pixel_1_out,
	output reg Shared_PE26_Pixel_1_valid_out,
	output reg signed [`WORD_BITS-1:0] Shared_PE26_Pixel_2_out,
	output reg Shared_PE26_Pixel_2_valid_out,

	output reg signed [`WORD_BITS-1:0] Shared_PE27_Pixel_0_out,
	output reg Shared_PE27_Pixel_0_valid_out,
	output reg signed [`WORD_BITS-1:0] Shared_PE27_Pixel_1_out,
	output reg Shared_PE27_Pixel_1_valid_out,
	output reg signed [`WORD_BITS-1:0] Shared_PE27_Pixel_2_out,
	output reg Shared_PE27_Pixel_2_valid_out,

	output reg signed [`WORD_BITS-1:0] Shared_PE28_Pixel_0_out,
	output reg Shared_PE28_Pixel_0_valid_out,
	output reg signed [`WORD_BITS-1:0] Shared_PE28_Pixel_1_out,
	output reg Shared_PE28_Pixel_1_valid_out,
	output reg signed [`WORD_BITS-1:0] Shared_PE28_Pixel_2_out,
	output reg Shared_PE28_Pixel_2_valid_out,

	output reg signed [`WORD_BITS-1:0] Shared_PE29_Pixel_0_out,
	output reg Shared_PE29_Pixel_0_valid_out,
	output reg signed [`WORD_BITS-1:0] Shared_PE29_Pixel_1_out,
	output reg Shared_PE29_Pixel_1_valid_out,
	output reg signed [`WORD_BITS-1:0] Shared_PE29_Pixel_2_out,
	output reg Shared_PE29_Pixel_2_valid_out,

	output reg signed [`WORD_BITS-1:0] Shared_PE30_Pixel_0_out,
	output reg Shared_PE30_Pixel_0_valid_out,
	output reg signed [`WORD_BITS-1:0] Shared_PE30_Pixel_1_out,
	output reg Shared_PE30_Pixel_1_valid_out,
	output reg signed [`WORD_BITS-1:0] Shared_PE30_Pixel_2_out,
	output reg Shared_PE30_Pixel_2_valid_out,

	output reg signed [`WORD_BITS-1:0] Shared_PE31_Pixel_0_out,
	output reg Shared_PE31_Pixel_0_valid_out,
	output reg signed [`WORD_BITS-1:0] Shared_PE31_Pixel_1_out,
	output reg Shared_PE31_Pixel_1_valid_out,
	output reg signed [`WORD_BITS-1:0] Shared_PE31_Pixel_2_out,
	output reg Shared_PE31_Pixel_2_valid_out,

	output reg signed [`WORD_BITS-1:0] Shared_PE32_Pixel_0_out,
	output reg Shared_PE32_Pixel_0_valid_out,
	output reg signed [`WORD_BITS-1:0] Shared_PE32_Pixel_1_out,
	output reg Shared_PE32_Pixel_1_valid_out,
	output reg signed [`WORD_BITS-1:0] Shared_PE32_Pixel_2_out,
	output reg Shared_PE32_Pixel_2_valid_out,

	output reg signed [`WORD_BITS-1:0] Shared_PE33_Pixel_0_out,
	output reg Shared_PE33_Pixel_0_valid_out,
	output reg signed [`WORD_BITS-1:0] Shared_PE33_Pixel_1_out,
	output reg Shared_PE33_Pixel_1_valid_out,
	output reg signed [`WORD_BITS-1:0] Shared_PE33_Pixel_2_out,
	output reg Shared_PE33_Pixel_2_valid_out,

	output reg signed [`WORD_BITS-1:0] Shared_PE34_Pixel_0_out,
	output reg Shared_PE34_Pixel_0_valid_out,
	output reg signed [`WORD_BITS-1:0] Shared_PE34_Pixel_1_out,
	output reg Shared_PE34_Pixel_1_valid_out,
	output reg signed [`WORD_BITS-1:0] Shared_PE34_Pixel_2_out,
	output reg Shared_PE34_Pixel_2_valid_out,

	output reg signed [`WORD_BITS-1:0] Shared_PE35_Pixel_0_out,
	output reg Shared_PE35_Pixel_0_valid_out,
	output reg signed [`WORD_BITS-1:0] Shared_PE35_Pixel_1_out,
	output reg Shared_PE35_Pixel_1_valid_out,
	output reg signed [`WORD_BITS-1:0] Shared_PE35_Pixel_2_out,
	output reg Shared_PE35_Pixel_2_valid_out,

	output reg signed [`WORD_BITS-1:0] Shared_PE36_Pixel_0_out,
	output reg Shared_PE36_Pixel_0_valid_out,
	output reg signed [`WORD_BITS-1:0] Shared_PE36_Pixel_1_out,
	output reg Shared_PE36_Pixel_1_valid_out,
	output reg signed [`WORD_BITS-1:0] Shared_PE36_Pixel_2_out,
	output reg Shared_PE36_Pixel_2_valid_out,

	output reg signed [`WORD_BITS-1:0] Shared_PE37_Pixel_0_out,
	output reg Shared_PE37_Pixel_0_valid_out,
	output reg signed [`WORD_BITS-1:0] Shared_PE37_Pixel_1_out,
	output reg Shared_PE37_Pixel_1_valid_out,
	output reg signed [`WORD_BITS-1:0] Shared_PE37_Pixel_2_out,
	output reg Shared_PE37_Pixel_2_valid_out,

	output reg signed [`WORD_BITS-1:0] Shared_PE38_Pixel_0_out,
	output reg Shared_PE38_Pixel_0_valid_out,
	output reg signed [`WORD_BITS-1:0] Shared_PE38_Pixel_1_out,
	output reg Shared_PE38_Pixel_1_valid_out,
	output reg signed [`WORD_BITS-1:0] Shared_PE38_Pixel_2_out,
	output reg Shared_PE38_Pixel_2_valid_out,

	output reg signed [`WORD_BITS-1:0] Shared_PE39_Pixel_0_out,
	output reg Shared_PE39_Pixel_0_valid_out,
	output reg signed [`WORD_BITS-1:0] Shared_PE39_Pixel_1_out,
	output reg Shared_PE39_Pixel_1_valid_out,
	output reg signed [`WORD_BITS-1:0] Shared_PE39_Pixel_2_out,
	output reg Shared_PE39_Pixel_2_valid_out


);

	// *************** Wire signals *************** //
	wire signed [`WORD_BITS-1:0] PE0_Pixel_to_MUX_wr;
	wire signed [`WORD_BITS-1:0] PE1_Pixel_to_MUX_wr;
	wire signed [`WORD_BITS-1:0] PE2_Pixel_to_MUX_wr;
	wire signed [`WORD_BITS-1:0] PE3_Pixel_to_MUX_wr;
	wire signed [`WORD_BITS-1:0] PE4_Pixel_to_MUX_wr;
	wire signed [`WORD_BITS-1:0] PE5_Pixel_to_MUX_wr;
	wire signed [`WORD_BITS-1:0] PE6_Pixel_to_MUX_wr;
	wire signed [`WORD_BITS-1:0] PE7_Pixel_to_MUX_wr;
	wire signed [`WORD_BITS-1:0] PE8_Pixel_to_MUX_wr;
	wire signed [`WORD_BITS-1:0] PE9_Pixel_to_MUX_wr;
	wire signed [`WORD_BITS-1:0] PE10_Pixel_to_MUX_wr;
	wire signed [`WORD_BITS-1:0] PE11_Pixel_to_MUX_wr;
	wire signed [`WORD_BITS-1:0] PE12_Pixel_to_MUX_wr;
	wire signed [`WORD_BITS-1:0] PE13_Pixel_to_MUX_wr;
	wire signed [`WORD_BITS-1:0] PE14_Pixel_to_MUX_wr;
	wire signed [`WORD_BITS-1:0] PE15_Pixel_to_MUX_wr;
	wire signed [`WORD_BITS-1:0] PE16_Pixel_to_MUX_wr;
	wire signed [`WORD_BITS-1:0] PE17_Pixel_to_MUX_wr;
	wire signed [`WORD_BITS-1:0] PE18_Pixel_to_MUX_wr;
	wire signed [`WORD_BITS-1:0] PE19_Pixel_to_MUX_wr;
	wire signed [`WORD_BITS-1:0] PE20_Pixel_to_MUX_wr;
	wire signed [`WORD_BITS-1:0] PE21_Pixel_to_MUX_wr;
	wire signed [`WORD_BITS-1:0] PE22_Pixel_to_MUX_wr;
	wire signed [`WORD_BITS-1:0] PE23_Pixel_to_MUX_wr;
	wire signed [`WORD_BITS-1:0] PE24_Pixel_to_MUX_wr;
	wire signed [`WORD_BITS-1:0] PE25_Pixel_to_MUX_wr;
	wire signed [`WORD_BITS-1:0] PE26_Pixel_to_MUX_wr;
	wire signed [`WORD_BITS-1:0] PE27_Pixel_to_MUX_wr;
	wire signed [`WORD_BITS-1:0] PE28_Pixel_to_MUX_wr;
	wire signed [`WORD_BITS-1:0] PE29_Pixel_to_MUX_wr;
	wire signed [`WORD_BITS-1:0] PE30_Pixel_to_MUX_wr;
	wire signed [`WORD_BITS-1:0] PE31_Pixel_to_MUX_wr;
	wire signed [`WORD_BITS-1:0] PE32_Pixel_to_MUX_wr;
	wire signed [`WORD_BITS-1:0] PE33_Pixel_to_MUX_wr;
	wire signed [`WORD_BITS-1:0] PE34_Pixel_to_MUX_wr;
	wire signed [`WORD_BITS-1:0] PE35_Pixel_to_MUX_wr;
	wire signed [`WORD_BITS-1:0] PE36_Pixel_to_MUX_wr;
	wire signed [`WORD_BITS-1:0] PE37_Pixel_to_MUX_wr;
	wire signed [`WORD_BITS-1:0] PE38_Pixel_to_MUX_wr;
	wire signed [`WORD_BITS-1:0] PE39_Pixel_to_MUX_wr;

	wire signed [`WORD_BITS-1:0] Shared_PE0_Pixel_0_out_wr;
	wire Shared_PE0_Pixel_0_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE0_Pixel_1_out_wr;
	wire Shared_PE0_Pixel_1_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE0_Pixel_2_out_wr;
	wire Shared_PE0_Pixel_2_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE1_Pixel_0_out_wr;
	wire Shared_PE1_Pixel_0_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE1_Pixel_1_out_wr;
	wire Shared_PE1_Pixel_1_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE1_Pixel_2_out_wr;
	wire Shared_PE1_Pixel_2_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE2_Pixel_0_out_wr;
	wire Shared_PE2_Pixel_0_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE2_Pixel_1_out_wr;
	wire Shared_PE2_Pixel_1_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE2_Pixel_2_out_wr;
	wire Shared_PE2_Pixel_2_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE3_Pixel_0_out_wr;
	wire Shared_PE3_Pixel_0_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE3_Pixel_1_out_wr;
	wire Shared_PE3_Pixel_1_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE3_Pixel_2_out_wr;
	wire Shared_PE3_Pixel_2_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE4_Pixel_0_out_wr;
	wire Shared_PE4_Pixel_0_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE4_Pixel_1_out_wr;
	wire Shared_PE4_Pixel_1_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE4_Pixel_2_out_wr;
	wire Shared_PE4_Pixel_2_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE5_Pixel_0_out_wr;
	wire Shared_PE5_Pixel_0_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE5_Pixel_1_out_wr;
	wire Shared_PE5_Pixel_1_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE5_Pixel_2_out_wr;
	wire Shared_PE5_Pixel_2_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE6_Pixel_0_out_wr;
	wire Shared_PE6_Pixel_0_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE6_Pixel_1_out_wr;
	wire Shared_PE6_Pixel_1_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE6_Pixel_2_out_wr;
	wire Shared_PE6_Pixel_2_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE7_Pixel_0_out_wr;
	wire Shared_PE7_Pixel_0_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE7_Pixel_1_out_wr;
	wire Shared_PE7_Pixel_1_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE7_Pixel_2_out_wr;
	wire Shared_PE7_Pixel_2_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE8_Pixel_0_out_wr;
	wire Shared_PE8_Pixel_0_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE8_Pixel_1_out_wr;
	wire Shared_PE8_Pixel_1_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE8_Pixel_2_out_wr;
	wire Shared_PE8_Pixel_2_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE9_Pixel_0_out_wr;
	wire Shared_PE9_Pixel_0_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE9_Pixel_1_out_wr;
	wire Shared_PE9_Pixel_1_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE9_Pixel_2_out_wr;
	wire Shared_PE9_Pixel_2_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE10_Pixel_0_out_wr;
	wire Shared_PE10_Pixel_0_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE10_Pixel_1_out_wr;
	wire Shared_PE10_Pixel_1_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE10_Pixel_2_out_wr;
	wire Shared_PE10_Pixel_2_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE11_Pixel_0_out_wr;
	wire Shared_PE11_Pixel_0_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE11_Pixel_1_out_wr;
	wire Shared_PE11_Pixel_1_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE11_Pixel_2_out_wr;
	wire Shared_PE11_Pixel_2_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE12_Pixel_0_out_wr;
	wire Shared_PE12_Pixel_0_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE12_Pixel_1_out_wr;
	wire Shared_PE12_Pixel_1_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE12_Pixel_2_out_wr;
	wire Shared_PE12_Pixel_2_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE13_Pixel_0_out_wr;
	wire Shared_PE13_Pixel_0_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE13_Pixel_1_out_wr;
	wire Shared_PE13_Pixel_1_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE13_Pixel_2_out_wr;
	wire Shared_PE13_Pixel_2_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE14_Pixel_0_out_wr;
	wire Shared_PE14_Pixel_0_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE14_Pixel_1_out_wr;
	wire Shared_PE14_Pixel_1_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE14_Pixel_2_out_wr;
	wire Shared_PE14_Pixel_2_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE15_Pixel_0_out_wr;
	wire Shared_PE15_Pixel_0_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE15_Pixel_1_out_wr;
	wire Shared_PE15_Pixel_1_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE15_Pixel_2_out_wr;
	wire Shared_PE15_Pixel_2_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE16_Pixel_0_out_wr;
	wire Shared_PE16_Pixel_0_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE16_Pixel_1_out_wr;
	wire Shared_PE16_Pixel_1_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE16_Pixel_2_out_wr;
	wire Shared_PE16_Pixel_2_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE17_Pixel_0_out_wr;
	wire Shared_PE17_Pixel_0_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE17_Pixel_1_out_wr;
	wire Shared_PE17_Pixel_1_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE17_Pixel_2_out_wr;
	wire Shared_PE17_Pixel_2_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE18_Pixel_0_out_wr;
	wire Shared_PE18_Pixel_0_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE18_Pixel_1_out_wr;
	wire Shared_PE18_Pixel_1_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE18_Pixel_2_out_wr;
	wire Shared_PE18_Pixel_2_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE19_Pixel_0_out_wr;
	wire Shared_PE19_Pixel_0_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE19_Pixel_1_out_wr;
	wire Shared_PE19_Pixel_1_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE19_Pixel_2_out_wr;
	wire Shared_PE19_Pixel_2_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE20_Pixel_0_out_wr;
	wire Shared_PE20_Pixel_0_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE20_Pixel_1_out_wr;
	wire Shared_PE20_Pixel_1_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE20_Pixel_2_out_wr;
	wire Shared_PE20_Pixel_2_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE21_Pixel_0_out_wr;
	wire Shared_PE21_Pixel_0_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE21_Pixel_1_out_wr;
	wire Shared_PE21_Pixel_1_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE21_Pixel_2_out_wr;
	wire Shared_PE21_Pixel_2_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE22_Pixel_0_out_wr;
	wire Shared_PE22_Pixel_0_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE22_Pixel_1_out_wr;
	wire Shared_PE22_Pixel_1_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE22_Pixel_2_out_wr;
	wire Shared_PE22_Pixel_2_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE23_Pixel_0_out_wr;
	wire Shared_PE23_Pixel_0_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE23_Pixel_1_out_wr;
	wire Shared_PE23_Pixel_1_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE23_Pixel_2_out_wr;
	wire Shared_PE23_Pixel_2_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE24_Pixel_0_out_wr;
	wire Shared_PE24_Pixel_0_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE24_Pixel_1_out_wr;
	wire Shared_PE24_Pixel_1_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE24_Pixel_2_out_wr;
	wire Shared_PE24_Pixel_2_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE25_Pixel_0_out_wr;
	wire Shared_PE25_Pixel_0_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE25_Pixel_1_out_wr;
	wire Shared_PE25_Pixel_1_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE25_Pixel_2_out_wr;
	wire Shared_PE25_Pixel_2_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE26_Pixel_0_out_wr;
	wire Shared_PE26_Pixel_0_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE26_Pixel_1_out_wr;
	wire Shared_PE26_Pixel_1_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE26_Pixel_2_out_wr;
	wire Shared_PE26_Pixel_2_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE27_Pixel_0_out_wr;
	wire Shared_PE27_Pixel_0_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE27_Pixel_1_out_wr;
	wire Shared_PE27_Pixel_1_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE27_Pixel_2_out_wr;
	wire Shared_PE27_Pixel_2_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE28_Pixel_0_out_wr;
	wire Shared_PE28_Pixel_0_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE28_Pixel_1_out_wr;
	wire Shared_PE28_Pixel_1_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE28_Pixel_2_out_wr;
	wire Shared_PE28_Pixel_2_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE29_Pixel_0_out_wr;
	wire Shared_PE29_Pixel_0_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE29_Pixel_1_out_wr;
	wire Shared_PE29_Pixel_1_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE29_Pixel_2_out_wr;
	wire Shared_PE29_Pixel_2_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE30_Pixel_0_out_wr;
	wire Shared_PE30_Pixel_0_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE30_Pixel_1_out_wr;
	wire Shared_PE30_Pixel_1_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE30_Pixel_2_out_wr;
	wire Shared_PE30_Pixel_2_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE31_Pixel_0_out_wr;
	wire Shared_PE31_Pixel_0_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE31_Pixel_1_out_wr;
	wire Shared_PE31_Pixel_1_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE31_Pixel_2_out_wr;
	wire Shared_PE31_Pixel_2_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE32_Pixel_0_out_wr;
	wire Shared_PE32_Pixel_0_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE32_Pixel_1_out_wr;
	wire Shared_PE32_Pixel_1_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE32_Pixel_2_out_wr;
	wire Shared_PE32_Pixel_2_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE33_Pixel_0_out_wr;
	wire Shared_PE33_Pixel_0_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE33_Pixel_1_out_wr;
	wire Shared_PE33_Pixel_1_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE33_Pixel_2_out_wr;
	wire Shared_PE33_Pixel_2_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE34_Pixel_0_out_wr;
	wire Shared_PE34_Pixel_0_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE34_Pixel_1_out_wr;
	wire Shared_PE34_Pixel_1_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE34_Pixel_2_out_wr;
	wire Shared_PE34_Pixel_2_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE35_Pixel_0_out_wr;
	wire Shared_PE35_Pixel_0_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE35_Pixel_1_out_wr;
	wire Shared_PE35_Pixel_1_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE35_Pixel_2_out_wr;
	wire Shared_PE35_Pixel_2_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE36_Pixel_0_out_wr;
	wire Shared_PE36_Pixel_0_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE36_Pixel_1_out_wr;
	wire Shared_PE36_Pixel_1_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE36_Pixel_2_out_wr;
	wire Shared_PE36_Pixel_2_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE37_Pixel_0_out_wr;
	wire Shared_PE37_Pixel_0_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE37_Pixel_1_out_wr;
	wire Shared_PE37_Pixel_1_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE37_Pixel_2_out_wr;
	wire Shared_PE37_Pixel_2_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE38_Pixel_0_out_wr;
	wire Shared_PE38_Pixel_0_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE38_Pixel_1_out_wr;
	wire Shared_PE38_Pixel_1_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE38_Pixel_2_out_wr;
	wire Shared_PE38_Pixel_2_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE39_Pixel_0_out_wr;
	wire Shared_PE39_Pixel_0_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE39_Pixel_1_out_wr;
	wire Shared_PE39_Pixel_1_valid_out_wr;
	wire signed [`WORD_BITS-1:0] Shared_PE39_Pixel_2_out_wr;
	wire Shared_PE39_Pixel_2_valid_out_wr;

	// *************** Register signals *************** //
	reg Parity_PE_Selection_rg;

	assign PE0_Pixel_to_MUX_wr = ((Stride_in == 1) & (CFG_in == `EXE_MAC) && (Parity_PE_Selection_rg == 0)) ? PEA0_PE0_Pixel_0_in :
								 ((Stride_in == 1) & (CFG_in == `EXE_MAC) && (Parity_PE_Selection_rg == 1)) ? PEA0_PE1_Pixel_0_in : PEA0_PE0_Pixel_0_in;
	assign PE1_Pixel_to_MUX_wr = ((Stride_in == 1) & (CFG_in == `EXE_MAC) && (Parity_PE_Selection_rg == 0)) ? PEA0_PE2_Pixel_0_in :
								 ((Stride_in == 1) & (CFG_in == `EXE_MAC) && (Parity_PE_Selection_rg == 1)) ? PEA0_PE3_Pixel_0_in : PEA0_PE1_Pixel_0_in;
	assign PE2_Pixel_to_MUX_wr = ((Stride_in == 1) & (CFG_in == `EXE_MAC) && (Parity_PE_Selection_rg == 0)) ? PEA0_PE4_Pixel_0_in :
								 ((Stride_in == 1) & (CFG_in == `EXE_MAC) && (Parity_PE_Selection_rg == 1)) ? PEA0_PE5_Pixel_0_in : PEA0_PE2_Pixel_0_in;
	assign PE3_Pixel_to_MUX_wr = ((Stride_in == 1) & (CFG_in == `EXE_MAC) && (Parity_PE_Selection_rg == 0)) ? PEA0_PE6_Pixel_0_in :
								 ((Stride_in == 1) & (CFG_in == `EXE_MAC) && (Parity_PE_Selection_rg == 1)) ? PEA0_PE7_Pixel_0_in : PEA0_PE3_Pixel_0_in;
	assign PE4_Pixel_to_MUX_wr = ((Stride_in == 1) & (CFG_in == `EXE_MAC) && (Parity_PE_Selection_rg == 0)) ? PEA0_PE8_Pixel_0_in :
								 ((Stride_in == 1) & (CFG_in == `EXE_MAC) && (Parity_PE_Selection_rg == 1)) ? PEA0_PE9_Pixel_0_in : PEA0_PE4_Pixel_0_in;
	assign PE5_Pixel_to_MUX_wr = ((Stride_in == 1) & (CFG_in == `EXE_MAC) && (Parity_PE_Selection_rg == 0)) ? PEA0_PE10_Pixel_0_in :
								 ((Stride_in == 1) & (CFG_in == `EXE_MAC) && (Parity_PE_Selection_rg == 1)) ? PEA0_PE11_Pixel_0_in : PEA0_PE5_Pixel_0_in;
	assign PE6_Pixel_to_MUX_wr = ((Stride_in == 1) & (CFG_in == `EXE_MAC) && (Parity_PE_Selection_rg == 0)) ? PEA0_PE12_Pixel_0_in :
								 ((Stride_in == 1) & (CFG_in == `EXE_MAC) && (Parity_PE_Selection_rg == 1)) ? PEA0_PE13_Pixel_0_in : PEA0_PE6_Pixel_0_in;
	assign PE7_Pixel_to_MUX_wr = ((Stride_in == 1) & (CFG_in == `EXE_MAC) && (Parity_PE_Selection_rg == 0)) ? PEA0_PE14_Pixel_0_in :
								 ((Stride_in == 1) & (CFG_in == `EXE_MAC) && (Parity_PE_Selection_rg == 1)) ? PEA0_PE15_Pixel_0_in : PEA0_PE7_Pixel_0_in;
	assign PE8_Pixel_to_MUX_wr = ((Stride_in == 1) & (CFG_in == `EXE_MAC) && (Parity_PE_Selection_rg == 0)) ? PEA0_PE16_Pixel_0_in :
								 ((Stride_in == 1) & (CFG_in == `EXE_MAC) && (Parity_PE_Selection_rg == 1)) ? PEA0_PE17_Pixel_0_in : PEA0_PE8_Pixel_0_in;
	assign PE9_Pixel_to_MUX_wr = ((Stride_in == 1) & (CFG_in == `EXE_MAC) && (Parity_PE_Selection_rg == 0)) ? PEA0_PE18_Pixel_0_in :
								 ((Stride_in == 1) & (CFG_in == `EXE_MAC) && (Parity_PE_Selection_rg == 1)) ? PEA0_PE19_Pixel_0_in : PEA0_PE9_Pixel_0_in;
	assign PE10_Pixel_to_MUX_wr = ((Stride_in == 1) & (CFG_in == `EXE_MAC) && (Parity_PE_Selection_rg == 0)) ? PEA0_PE20_Pixel_0_in :
								 ((Stride_in == 1) & (CFG_in == `EXE_MAC) && (Parity_PE_Selection_rg == 1)) ? PEA0_PE21_Pixel_0_in : PEA0_PE10_Pixel_0_in;
	assign PE11_Pixel_to_MUX_wr = ((Stride_in == 1) & (CFG_in == `EXE_MAC) && (Parity_PE_Selection_rg == 0)) ? PEA0_PE22_Pixel_0_in :
								 ((Stride_in == 1) & (CFG_in == `EXE_MAC) && (Parity_PE_Selection_rg == 1)) ? PEA0_PE23_Pixel_0_in : PEA0_PE11_Pixel_0_in;
	assign PE12_Pixel_to_MUX_wr = ((Stride_in == 1) & (CFG_in == `EXE_MAC) && (Parity_PE_Selection_rg == 0)) ? PEA0_PE24_Pixel_0_in :
								 ((Stride_in == 1) & (CFG_in == `EXE_MAC) && (Parity_PE_Selection_rg == 1)) ? PEA0_PE25_Pixel_0_in : PEA0_PE12_Pixel_0_in;
	assign PE13_Pixel_to_MUX_wr = ((Stride_in == 1) & (CFG_in == `EXE_MAC) && (Parity_PE_Selection_rg == 0)) ? PEA0_PE26_Pixel_0_in :
								 ((Stride_in == 1) & (CFG_in == `EXE_MAC) && (Parity_PE_Selection_rg == 1)) ? PEA0_PE27_Pixel_0_in : PEA0_PE13_Pixel_0_in;
	assign PE14_Pixel_to_MUX_wr = ((Stride_in == 1) & (CFG_in == `EXE_MAC) && (Parity_PE_Selection_rg == 0)) ? PEA0_PE28_Pixel_0_in :
								 ((Stride_in == 1) & (CFG_in == `EXE_MAC) && (Parity_PE_Selection_rg == 1)) ? PEA0_PE29_Pixel_0_in : PEA0_PE14_Pixel_0_in;
	assign PE15_Pixel_to_MUX_wr = ((Stride_in == 1) & (CFG_in == `EXE_MAC) && (Parity_PE_Selection_rg == 0)) ? PEA0_PE30_Pixel_0_in :
								 ((Stride_in == 1) & (CFG_in == `EXE_MAC) && (Parity_PE_Selection_rg == 1)) ? PEA0_PE31_Pixel_0_in : PEA0_PE15_Pixel_0_in;
	assign PE16_Pixel_to_MUX_wr = ((Stride_in == 1) & (CFG_in == `EXE_MAC) && (Parity_PE_Selection_rg == 0)) ? PEA0_PE32_Pixel_0_in :
								 ((Stride_in == 1) & (CFG_in == `EXE_MAC) && (Parity_PE_Selection_rg == 1)) ? PEA0_PE33_Pixel_0_in : PEA0_PE16_Pixel_0_in;
	assign PE17_Pixel_to_MUX_wr = ((Stride_in == 1) & (CFG_in == `EXE_MAC) && (Parity_PE_Selection_rg == 0)) ? PEA0_PE34_Pixel_0_in :
								 ((Stride_in == 1) & (CFG_in == `EXE_MAC) && (Parity_PE_Selection_rg == 1)) ? PEA0_PE35_Pixel_0_in : PEA0_PE17_Pixel_0_in;
	assign PE18_Pixel_to_MUX_wr = ((Stride_in == 1) & (CFG_in == `EXE_MAC) && (Parity_PE_Selection_rg == 0)) ? PEA0_PE36_Pixel_0_in :
								 ((Stride_in == 1) & (CFG_in == `EXE_MAC) && (Parity_PE_Selection_rg == 1)) ? PEA0_PE37_Pixel_0_in : PEA0_PE18_Pixel_0_in;
	assign PE19_Pixel_to_MUX_wr = ((Stride_in == 1) & (CFG_in == `EXE_MAC) && (Parity_PE_Selection_rg == 0)) ? PEA0_PE38_Pixel_0_in :
								 ((Stride_in == 1) & (CFG_in == `EXE_MAC) && (Parity_PE_Selection_rg == 1)) ? PEA0_PE39_Pixel_0_in : PEA0_PE19_Pixel_0_in;
	assign PE20_Pixel_to_MUX_wr = ((Stride_in == 1) & (CFG_in == `EXE_MAC) && (Parity_PE_Selection_rg == 0)) ? PEA0_PE0_Pixel_1_in :
								 ((Stride_in == 1) & (CFG_in == `EXE_MAC) && (Parity_PE_Selection_rg == 1)) ? PEA0_PE1_Pixel_1_in : PEA0_PE20_Pixel_0_in;
	assign PE21_Pixel_to_MUX_wr = ((Stride_in == 1) & (CFG_in == `EXE_MAC) && (Parity_PE_Selection_rg == 0)) ? PEA0_PE2_Pixel_1_in :
								 ((Stride_in == 1) & (CFG_in == `EXE_MAC) && (Parity_PE_Selection_rg == 1)) ? PEA0_PE3_Pixel_1_in : PEA0_PE21_Pixel_0_in;
	assign PE22_Pixel_to_MUX_wr = ((Stride_in == 1) & (CFG_in == `EXE_MAC) && (Parity_PE_Selection_rg == 0)) ? PEA0_PE4_Pixel_1_in :
								 ((Stride_in == 1) & (CFG_in == `EXE_MAC) && (Parity_PE_Selection_rg == 1)) ? PEA0_PE5_Pixel_1_in : PEA0_PE22_Pixel_0_in;
	assign PE23_Pixel_to_MUX_wr = ((Stride_in == 1) & (CFG_in == `EXE_MAC) && (Parity_PE_Selection_rg == 0)) ? PEA0_PE6_Pixel_1_in :
								 ((Stride_in == 1) & (CFG_in == `EXE_MAC) && (Parity_PE_Selection_rg == 1)) ? PEA0_PE7_Pixel_1_in : PEA0_PE23_Pixel_0_in;
	assign PE24_Pixel_to_MUX_wr = ((Stride_in == 1) & (CFG_in == `EXE_MAC) && (Parity_PE_Selection_rg == 0)) ? PEA0_PE8_Pixel_1_in :
								 ((Stride_in == 1) & (CFG_in == `EXE_MAC) && (Parity_PE_Selection_rg == 1)) ? PEA0_PE9_Pixel_1_in : PEA0_PE24_Pixel_0_in;
	assign PE25_Pixel_to_MUX_wr = ((Stride_in == 1) & (CFG_in == `EXE_MAC) && (Parity_PE_Selection_rg == 0)) ? PEA0_PE10_Pixel_1_in :
								 ((Stride_in == 1) & (CFG_in == `EXE_MAC) && (Parity_PE_Selection_rg == 1)) ? PEA0_PE11_Pixel_1_in : PEA0_PE25_Pixel_0_in;
	assign PE26_Pixel_to_MUX_wr = ((Stride_in == 1) & (CFG_in == `EXE_MAC) && (Parity_PE_Selection_rg == 0)) ? PEA0_PE12_Pixel_1_in :
								 ((Stride_in == 1) & (CFG_in == `EXE_MAC) && (Parity_PE_Selection_rg == 1)) ? PEA0_PE13_Pixel_1_in : PEA0_PE26_Pixel_0_in;
	assign PE27_Pixel_to_MUX_wr = ((Stride_in == 1) & (CFG_in == `EXE_MAC) && (Parity_PE_Selection_rg == 0)) ? PEA0_PE14_Pixel_1_in :
								 ((Stride_in == 1) & (CFG_in == `EXE_MAC) && (Parity_PE_Selection_rg == 1)) ? PEA0_PE15_Pixel_1_in : PEA0_PE27_Pixel_0_in;
	assign PE28_Pixel_to_MUX_wr = ((Stride_in == 1) & (CFG_in == `EXE_MAC) && (Parity_PE_Selection_rg == 0)) ? PEA0_PE16_Pixel_1_in :
								 ((Stride_in == 1) & (CFG_in == `EXE_MAC) && (Parity_PE_Selection_rg == 1)) ? PEA0_PE17_Pixel_1_in : PEA0_PE28_Pixel_0_in;
	assign PE29_Pixel_to_MUX_wr = ((Stride_in == 1) & (CFG_in == `EXE_MAC) && (Parity_PE_Selection_rg == 0)) ? PEA0_PE18_Pixel_1_in :
								 ((Stride_in == 1) & (CFG_in == `EXE_MAC) && (Parity_PE_Selection_rg == 1)) ? PEA0_PE19_Pixel_1_in : PEA0_PE29_Pixel_0_in;
	assign PE30_Pixel_to_MUX_wr = ((Stride_in == 1) & (CFG_in == `EXE_MAC) && (Parity_PE_Selection_rg == 0)) ? PEA0_PE20_Pixel_1_in :
								 ((Stride_in == 1) & (CFG_in == `EXE_MAC) && (Parity_PE_Selection_rg == 1)) ? PEA0_PE21_Pixel_1_in : PEA0_PE30_Pixel_0_in;
	assign PE31_Pixel_to_MUX_wr = ((Stride_in == 1) & (CFG_in == `EXE_MAC) && (Parity_PE_Selection_rg == 0)) ? PEA0_PE22_Pixel_1_in :
								 ((Stride_in == 1) & (CFG_in == `EXE_MAC) && (Parity_PE_Selection_rg == 1)) ? PEA0_PE23_Pixel_1_in : PEA0_PE31_Pixel_0_in;
	assign PE32_Pixel_to_MUX_wr = ((Stride_in == 1) & (CFG_in == `EXE_MAC) && (Parity_PE_Selection_rg == 0)) ? PEA0_PE24_Pixel_1_in :
								 ((Stride_in == 1) & (CFG_in == `EXE_MAC) && (Parity_PE_Selection_rg == 1)) ? PEA0_PE25_Pixel_1_in : PEA0_PE32_Pixel_0_in;
	assign PE33_Pixel_to_MUX_wr = ((Stride_in == 1) & (CFG_in == `EXE_MAC) && (Parity_PE_Selection_rg == 0)) ? PEA0_PE26_Pixel_1_in :
								 ((Stride_in == 1) & (CFG_in == `EXE_MAC) && (Parity_PE_Selection_rg == 1)) ? PEA0_PE27_Pixel_1_in : PEA0_PE33_Pixel_0_in;
	assign PE34_Pixel_to_MUX_wr = ((Stride_in == 1) & (CFG_in == `EXE_MAC) && (Parity_PE_Selection_rg == 0)) ? PEA0_PE28_Pixel_1_in :
								 ((Stride_in == 1) & (CFG_in == `EXE_MAC) && (Parity_PE_Selection_rg == 1)) ? PEA0_PE29_Pixel_1_in : PEA0_PE34_Pixel_0_in;
	assign PE35_Pixel_to_MUX_wr = ((Stride_in == 1) & (CFG_in == `EXE_MAC) && (Parity_PE_Selection_rg == 0)) ? PEA0_PE30_Pixel_1_in :
								 ((Stride_in == 1) & (CFG_in == `EXE_MAC) && (Parity_PE_Selection_rg == 1)) ? PEA0_PE31_Pixel_1_in : PEA0_PE35_Pixel_0_in;
	assign PE36_Pixel_to_MUX_wr = ((Stride_in == 1) & (CFG_in == `EXE_MAC) && (Parity_PE_Selection_rg == 0)) ? PEA0_PE32_Pixel_1_in :
								 ((Stride_in == 1) & (CFG_in == `EXE_MAC) && (Parity_PE_Selection_rg == 1)) ? PEA0_PE33_Pixel_1_in : PEA0_PE36_Pixel_0_in;
	assign PE37_Pixel_to_MUX_wr = ((Stride_in == 1) & (CFG_in == `EXE_MAC) && (Parity_PE_Selection_rg == 0)) ? PEA0_PE34_Pixel_1_in :
								 ((Stride_in == 1) & (CFG_in == `EXE_MAC) && (Parity_PE_Selection_rg == 1)) ? PEA0_PE35_Pixel_1_in : PEA0_PE37_Pixel_0_in;
	assign PE38_Pixel_to_MUX_wr = ((Stride_in == 1) & (CFG_in == `EXE_MAC) && (Parity_PE_Selection_rg == 0)) ? PEA0_PE36_Pixel_1_in :
								 ((Stride_in == 1) & (CFG_in == `EXE_MAC) && (Parity_PE_Selection_rg == 1)) ? PEA0_PE37_Pixel_1_in : PEA0_PE38_Pixel_0_in;
	assign PE39_Pixel_to_MUX_wr = ((Stride_in == 1) & (CFG_in == `EXE_MAC) && (Parity_PE_Selection_rg == 0)) ? PEA0_PE38_Pixel_1_in :
								 ((Stride_in == 1) & (CFG_in == `EXE_MAC) && (Parity_PE_Selection_rg == 1)) ? PEA0_PE39_Pixel_1_in : PEA0_PE39_Pixel_0_in;

	MUX_40_1 PE0_Pixel_0(
		.data0_in(PE0_Pixel_to_MUX_wr),
		.data1_in(PE1_Pixel_to_MUX_wr),
		.data2_in(PE2_Pixel_to_MUX_wr),
		.data3_in(PE3_Pixel_to_MUX_wr),
		.data4_in(PE4_Pixel_to_MUX_wr),
		.data5_in(PE5_Pixel_to_MUX_wr),
		.data6_in(PE6_Pixel_to_MUX_wr),
		.data7_in(PE7_Pixel_to_MUX_wr),
		.data8_in(PE8_Pixel_to_MUX_wr),
		.data9_in(PE9_Pixel_to_MUX_wr),
		.data10_in(PE10_Pixel_to_MUX_wr),
		.data11_in(PE11_Pixel_to_MUX_wr),
		.data12_in(PE12_Pixel_to_MUX_wr),
		.data13_in(PE13_Pixel_to_MUX_wr),
		.data14_in(PE14_Pixel_to_MUX_wr),
		.data15_in(PE15_Pixel_to_MUX_wr),
		.data16_in(PE16_Pixel_to_MUX_wr),
		.data17_in(PE17_Pixel_to_MUX_wr),
		.data18_in(PE18_Pixel_to_MUX_wr),
		.data19_in(PE19_Pixel_to_MUX_wr),
		.data20_in(PE20_Pixel_to_MUX_wr),
		.data21_in(PE21_Pixel_to_MUX_wr),
		.data22_in(PE22_Pixel_to_MUX_wr),
		.data23_in(PE23_Pixel_to_MUX_wr),
		.data24_in(PE24_Pixel_to_MUX_wr),
		.data25_in(PE25_Pixel_to_MUX_wr),
		.data26_in(PE26_Pixel_to_MUX_wr),
		.data27_in(PE27_Pixel_to_MUX_wr),
		.data28_in(PE28_Pixel_to_MUX_wr),
		.data29_in(PE29_Pixel_to_MUX_wr),
		.data30_in(PE30_Pixel_to_MUX_wr),
		.data31_in(PE31_Pixel_to_MUX_wr),
		.data32_in(PE32_Pixel_to_MUX_wr),
		.data33_in(PE33_Pixel_to_MUX_wr),
		.data34_in(PE34_Pixel_to_MUX_wr),
		.data35_in(PE35_Pixel_to_MUX_wr),
		.data36_in(PE36_Pixel_to_MUX_wr),
		.data37_in(PE37_Pixel_to_MUX_wr),
		.data38_in(PE38_Pixel_to_MUX_wr),
		.data39_in(PE39_Pixel_to_MUX_wr),
		.sel_in(MUX_Selection_in),
		.mux_40_1_out(Shared_PE0_Pixel_0_out_wr)
	);

	MUX_40_1 PE1_Pixel_0(
		.data0_in(PE1_Pixel_to_MUX_wr),
		.data1_in(PE2_Pixel_to_MUX_wr),
		.data2_in(PE3_Pixel_to_MUX_wr),
		.data3_in(PE4_Pixel_to_MUX_wr),
		.data4_in(PE5_Pixel_to_MUX_wr),
		.data5_in(PE6_Pixel_to_MUX_wr),
		.data6_in(PE7_Pixel_to_MUX_wr),
		.data7_in(PE8_Pixel_to_MUX_wr),
		.data8_in(PE9_Pixel_to_MUX_wr),
		.data9_in(PE10_Pixel_to_MUX_wr),
		.data10_in(PE11_Pixel_to_MUX_wr),
		.data11_in(PE12_Pixel_to_MUX_wr),
		.data12_in(PE13_Pixel_to_MUX_wr),
		.data13_in(PE14_Pixel_to_MUX_wr),
		.data14_in(PE15_Pixel_to_MUX_wr),
		.data15_in(PE16_Pixel_to_MUX_wr),
		.data16_in(PE17_Pixel_to_MUX_wr),
		.data17_in(PE18_Pixel_to_MUX_wr),
		.data18_in(PE19_Pixel_to_MUX_wr),
		.data19_in(PE20_Pixel_to_MUX_wr),
		.data20_in(PE21_Pixel_to_MUX_wr),
		.data21_in(PE22_Pixel_to_MUX_wr),
		.data22_in(PE23_Pixel_to_MUX_wr),
		.data23_in(PE24_Pixel_to_MUX_wr),
		.data24_in(PE25_Pixel_to_MUX_wr),
		.data25_in(PE26_Pixel_to_MUX_wr),
		.data26_in(PE27_Pixel_to_MUX_wr),
		.data27_in(PE28_Pixel_to_MUX_wr),
		.data28_in(PE29_Pixel_to_MUX_wr),
		.data29_in(PE30_Pixel_to_MUX_wr),
		.data30_in(PE31_Pixel_to_MUX_wr),
		.data31_in(PE32_Pixel_to_MUX_wr),
		.data32_in(PE33_Pixel_to_MUX_wr),
		.data33_in(PE34_Pixel_to_MUX_wr),
		.data34_in(PE35_Pixel_to_MUX_wr),
		.data35_in(PE36_Pixel_to_MUX_wr),
		.data36_in(PE37_Pixel_to_MUX_wr),
		.data37_in(PE38_Pixel_to_MUX_wr),
		.data38_in(PE39_Pixel_to_MUX_wr),
		.data39_in(PE0_Pixel_to_MUX_wr),
		.sel_in(MUX_Selection_in),
		.mux_40_1_out(Shared_PE1_Pixel_0_out_wr)
	);

	MUX_40_1 PE2_Pixel_0(
		.data0_in(PE2_Pixel_to_MUX_wr),
		.data1_in(PE3_Pixel_to_MUX_wr),
		.data2_in(PE4_Pixel_to_MUX_wr),
		.data3_in(PE5_Pixel_to_MUX_wr),
		.data4_in(PE6_Pixel_to_MUX_wr),
		.data5_in(PE7_Pixel_to_MUX_wr),
		.data6_in(PE8_Pixel_to_MUX_wr),
		.data7_in(PE9_Pixel_to_MUX_wr),
		.data8_in(PE10_Pixel_to_MUX_wr),
		.data9_in(PE11_Pixel_to_MUX_wr),
		.data10_in(PE12_Pixel_to_MUX_wr),
		.data11_in(PE13_Pixel_to_MUX_wr),
		.data12_in(PE14_Pixel_to_MUX_wr),
		.data13_in(PE15_Pixel_to_MUX_wr),
		.data14_in(PE16_Pixel_to_MUX_wr),
		.data15_in(PE17_Pixel_to_MUX_wr),
		.data16_in(PE18_Pixel_to_MUX_wr),
		.data17_in(PE19_Pixel_to_MUX_wr),
		.data18_in(PE20_Pixel_to_MUX_wr),
		.data19_in(PE21_Pixel_to_MUX_wr),
		.data20_in(PE22_Pixel_to_MUX_wr),
		.data21_in(PE23_Pixel_to_MUX_wr),
		.data22_in(PE24_Pixel_to_MUX_wr),
		.data23_in(PE25_Pixel_to_MUX_wr),
		.data24_in(PE26_Pixel_to_MUX_wr),
		.data25_in(PE27_Pixel_to_MUX_wr),
		.data26_in(PE28_Pixel_to_MUX_wr),
		.data27_in(PE29_Pixel_to_MUX_wr),
		.data28_in(PE30_Pixel_to_MUX_wr),
		.data29_in(PE31_Pixel_to_MUX_wr),
		.data30_in(PE32_Pixel_to_MUX_wr),
		.data31_in(PE33_Pixel_to_MUX_wr),
		.data32_in(PE34_Pixel_to_MUX_wr),
		.data33_in(PE35_Pixel_to_MUX_wr),
		.data34_in(PE36_Pixel_to_MUX_wr),
		.data35_in(PE37_Pixel_to_MUX_wr),
		.data36_in(PE38_Pixel_to_MUX_wr),
		.data37_in(PE39_Pixel_to_MUX_wr),
		.data38_in(PE0_Pixel_to_MUX_wr),
		.data39_in(PE1_Pixel_to_MUX_wr),
		.sel_in(MUX_Selection_in),
		.mux_40_1_out(Shared_PE2_Pixel_0_out_wr)
	);

	MUX_40_1 PE3_Pixel_0(
		.data0_in(PE3_Pixel_to_MUX_wr),
		.data1_in(PE4_Pixel_to_MUX_wr),
		.data2_in(PE5_Pixel_to_MUX_wr),
		.data3_in(PE6_Pixel_to_MUX_wr),
		.data4_in(PE7_Pixel_to_MUX_wr),
		.data5_in(PE8_Pixel_to_MUX_wr),
		.data6_in(PE9_Pixel_to_MUX_wr),
		.data7_in(PE10_Pixel_to_MUX_wr),
		.data8_in(PE11_Pixel_to_MUX_wr),
		.data9_in(PE12_Pixel_to_MUX_wr),
		.data10_in(PE13_Pixel_to_MUX_wr),
		.data11_in(PE14_Pixel_to_MUX_wr),
		.data12_in(PE15_Pixel_to_MUX_wr),
		.data13_in(PE16_Pixel_to_MUX_wr),
		.data14_in(PE17_Pixel_to_MUX_wr),
		.data15_in(PE18_Pixel_to_MUX_wr),
		.data16_in(PE19_Pixel_to_MUX_wr),
		.data17_in(PE20_Pixel_to_MUX_wr),
		.data18_in(PE21_Pixel_to_MUX_wr),
		.data19_in(PE22_Pixel_to_MUX_wr),
		.data20_in(PE23_Pixel_to_MUX_wr),
		.data21_in(PE24_Pixel_to_MUX_wr),
		.data22_in(PE25_Pixel_to_MUX_wr),
		.data23_in(PE26_Pixel_to_MUX_wr),
		.data24_in(PE27_Pixel_to_MUX_wr),
		.data25_in(PE28_Pixel_to_MUX_wr),
		.data26_in(PE29_Pixel_to_MUX_wr),
		.data27_in(PE30_Pixel_to_MUX_wr),
		.data28_in(PE31_Pixel_to_MUX_wr),
		.data29_in(PE32_Pixel_to_MUX_wr),
		.data30_in(PE33_Pixel_to_MUX_wr),
		.data31_in(PE34_Pixel_to_MUX_wr),
		.data32_in(PE35_Pixel_to_MUX_wr),
		.data33_in(PE36_Pixel_to_MUX_wr),
		.data34_in(PE37_Pixel_to_MUX_wr),
		.data35_in(PE38_Pixel_to_MUX_wr),
		.data36_in(PE39_Pixel_to_MUX_wr),
		.data37_in(PE0_Pixel_to_MUX_wr),
		.data38_in(PE1_Pixel_to_MUX_wr),
		.data39_in(PE2_Pixel_to_MUX_wr),
		.sel_in(MUX_Selection_in),
		.mux_40_1_out(Shared_PE3_Pixel_0_out_wr)
	);

	MUX_40_1 PE4_Pixel_0(
		.data0_in(PE4_Pixel_to_MUX_wr),
		.data1_in(PE5_Pixel_to_MUX_wr),
		.data2_in(PE6_Pixel_to_MUX_wr),
		.data3_in(PE7_Pixel_to_MUX_wr),
		.data4_in(PE8_Pixel_to_MUX_wr),
		.data5_in(PE9_Pixel_to_MUX_wr),
		.data6_in(PE10_Pixel_to_MUX_wr),
		.data7_in(PE11_Pixel_to_MUX_wr),
		.data8_in(PE12_Pixel_to_MUX_wr),
		.data9_in(PE13_Pixel_to_MUX_wr),
		.data10_in(PE14_Pixel_to_MUX_wr),
		.data11_in(PE15_Pixel_to_MUX_wr),
		.data12_in(PE16_Pixel_to_MUX_wr),
		.data13_in(PE17_Pixel_to_MUX_wr),
		.data14_in(PE18_Pixel_to_MUX_wr),
		.data15_in(PE19_Pixel_to_MUX_wr),
		.data16_in(PE20_Pixel_to_MUX_wr),
		.data17_in(PE21_Pixel_to_MUX_wr),
		.data18_in(PE22_Pixel_to_MUX_wr),
		.data19_in(PE23_Pixel_to_MUX_wr),
		.data20_in(PE24_Pixel_to_MUX_wr),
		.data21_in(PE25_Pixel_to_MUX_wr),
		.data22_in(PE26_Pixel_to_MUX_wr),
		.data23_in(PE27_Pixel_to_MUX_wr),
		.data24_in(PE28_Pixel_to_MUX_wr),
		.data25_in(PE29_Pixel_to_MUX_wr),
		.data26_in(PE30_Pixel_to_MUX_wr),
		.data27_in(PE31_Pixel_to_MUX_wr),
		.data28_in(PE32_Pixel_to_MUX_wr),
		.data29_in(PE33_Pixel_to_MUX_wr),
		.data30_in(PE34_Pixel_to_MUX_wr),
		.data31_in(PE35_Pixel_to_MUX_wr),
		.data32_in(PE36_Pixel_to_MUX_wr),
		.data33_in(PE37_Pixel_to_MUX_wr),
		.data34_in(PE38_Pixel_to_MUX_wr),
		.data35_in(PE39_Pixel_to_MUX_wr),
		.data36_in(PE0_Pixel_to_MUX_wr),
		.data37_in(PE1_Pixel_to_MUX_wr),
		.data38_in(PE2_Pixel_to_MUX_wr),
		.data39_in(PE3_Pixel_to_MUX_wr),
		.sel_in(MUX_Selection_in),
		.mux_40_1_out(Shared_PE4_Pixel_0_out_wr)
	);

	MUX_40_1 PE5_Pixel_0(
		.data0_in(PE5_Pixel_to_MUX_wr),
		.data1_in(PE6_Pixel_to_MUX_wr),
		.data2_in(PE7_Pixel_to_MUX_wr),
		.data3_in(PE8_Pixel_to_MUX_wr),
		.data4_in(PE9_Pixel_to_MUX_wr),
		.data5_in(PE10_Pixel_to_MUX_wr),
		.data6_in(PE11_Pixel_to_MUX_wr),
		.data7_in(PE12_Pixel_to_MUX_wr),
		.data8_in(PE13_Pixel_to_MUX_wr),
		.data9_in(PE14_Pixel_to_MUX_wr),
		.data10_in(PE15_Pixel_to_MUX_wr),
		.data11_in(PE16_Pixel_to_MUX_wr),
		.data12_in(PE17_Pixel_to_MUX_wr),
		.data13_in(PE18_Pixel_to_MUX_wr),
		.data14_in(PE19_Pixel_to_MUX_wr),
		.data15_in(PE20_Pixel_to_MUX_wr),
		.data16_in(PE21_Pixel_to_MUX_wr),
		.data17_in(PE22_Pixel_to_MUX_wr),
		.data18_in(PE23_Pixel_to_MUX_wr),
		.data19_in(PE24_Pixel_to_MUX_wr),
		.data20_in(PE25_Pixel_to_MUX_wr),
		.data21_in(PE26_Pixel_to_MUX_wr),
		.data22_in(PE27_Pixel_to_MUX_wr),
		.data23_in(PE28_Pixel_to_MUX_wr),
		.data24_in(PE29_Pixel_to_MUX_wr),
		.data25_in(PE30_Pixel_to_MUX_wr),
		.data26_in(PE31_Pixel_to_MUX_wr),
		.data27_in(PE32_Pixel_to_MUX_wr),
		.data28_in(PE33_Pixel_to_MUX_wr),
		.data29_in(PE34_Pixel_to_MUX_wr),
		.data30_in(PE35_Pixel_to_MUX_wr),
		.data31_in(PE36_Pixel_to_MUX_wr),
		.data32_in(PE37_Pixel_to_MUX_wr),
		.data33_in(PE38_Pixel_to_MUX_wr),
		.data34_in(PE39_Pixel_to_MUX_wr),
		.data35_in(PE0_Pixel_to_MUX_wr),
		.data36_in(PE1_Pixel_to_MUX_wr),
		.data37_in(PE2_Pixel_to_MUX_wr),
		.data38_in(PE3_Pixel_to_MUX_wr),
		.data39_in(PE4_Pixel_to_MUX_wr),
		.sel_in(MUX_Selection_in),
		.mux_40_1_out(Shared_PE5_Pixel_0_out_wr)
	);

	MUX_40_1 PE6_Pixel_0(
		.data0_in(PE6_Pixel_to_MUX_wr),
		.data1_in(PE7_Pixel_to_MUX_wr),
		.data2_in(PE8_Pixel_to_MUX_wr),
		.data3_in(PE9_Pixel_to_MUX_wr),
		.data4_in(PE10_Pixel_to_MUX_wr),
		.data5_in(PE11_Pixel_to_MUX_wr),
		.data6_in(PE12_Pixel_to_MUX_wr),
		.data7_in(PE13_Pixel_to_MUX_wr),
		.data8_in(PE14_Pixel_to_MUX_wr),
		.data9_in(PE15_Pixel_to_MUX_wr),
		.data10_in(PE16_Pixel_to_MUX_wr),
		.data11_in(PE17_Pixel_to_MUX_wr),
		.data12_in(PE18_Pixel_to_MUX_wr),
		.data13_in(PE19_Pixel_to_MUX_wr),
		.data14_in(PE20_Pixel_to_MUX_wr),
		.data15_in(PE21_Pixel_to_MUX_wr),
		.data16_in(PE22_Pixel_to_MUX_wr),
		.data17_in(PE23_Pixel_to_MUX_wr),
		.data18_in(PE24_Pixel_to_MUX_wr),
		.data19_in(PE25_Pixel_to_MUX_wr),
		.data20_in(PE26_Pixel_to_MUX_wr),
		.data21_in(PE27_Pixel_to_MUX_wr),
		.data22_in(PE28_Pixel_to_MUX_wr),
		.data23_in(PE29_Pixel_to_MUX_wr),
		.data24_in(PE30_Pixel_to_MUX_wr),
		.data25_in(PE31_Pixel_to_MUX_wr),
		.data26_in(PE32_Pixel_to_MUX_wr),
		.data27_in(PE33_Pixel_to_MUX_wr),
		.data28_in(PE34_Pixel_to_MUX_wr),
		.data29_in(PE35_Pixel_to_MUX_wr),
		.data30_in(PE36_Pixel_to_MUX_wr),
		.data31_in(PE37_Pixel_to_MUX_wr),
		.data32_in(PE38_Pixel_to_MUX_wr),
		.data33_in(PE39_Pixel_to_MUX_wr),
		.data34_in(PE0_Pixel_to_MUX_wr),
		.data35_in(PE1_Pixel_to_MUX_wr),
		.data36_in(PE2_Pixel_to_MUX_wr),
		.data37_in(PE3_Pixel_to_MUX_wr),
		.data38_in(PE4_Pixel_to_MUX_wr),
		.data39_in(PE5_Pixel_to_MUX_wr),
		.sel_in(MUX_Selection_in),
		.mux_40_1_out(Shared_PE6_Pixel_0_out_wr)
	);

	MUX_40_1 PE7_Pixel_0(
		.data0_in(PE7_Pixel_to_MUX_wr),
		.data1_in(PE8_Pixel_to_MUX_wr),
		.data2_in(PE9_Pixel_to_MUX_wr),
		.data3_in(PE10_Pixel_to_MUX_wr),
		.data4_in(PE11_Pixel_to_MUX_wr),
		.data5_in(PE12_Pixel_to_MUX_wr),
		.data6_in(PE13_Pixel_to_MUX_wr),
		.data7_in(PE14_Pixel_to_MUX_wr),
		.data8_in(PE15_Pixel_to_MUX_wr),
		.data9_in(PE16_Pixel_to_MUX_wr),
		.data10_in(PE17_Pixel_to_MUX_wr),
		.data11_in(PE18_Pixel_to_MUX_wr),
		.data12_in(PE19_Pixel_to_MUX_wr),
		.data13_in(PE20_Pixel_to_MUX_wr),
		.data14_in(PE21_Pixel_to_MUX_wr),
		.data15_in(PE22_Pixel_to_MUX_wr),
		.data16_in(PE23_Pixel_to_MUX_wr),
		.data17_in(PE24_Pixel_to_MUX_wr),
		.data18_in(PE25_Pixel_to_MUX_wr),
		.data19_in(PE26_Pixel_to_MUX_wr),
		.data20_in(PE27_Pixel_to_MUX_wr),
		.data21_in(PE28_Pixel_to_MUX_wr),
		.data22_in(PE29_Pixel_to_MUX_wr),
		.data23_in(PE30_Pixel_to_MUX_wr),
		.data24_in(PE31_Pixel_to_MUX_wr),
		.data25_in(PE32_Pixel_to_MUX_wr),
		.data26_in(PE33_Pixel_to_MUX_wr),
		.data27_in(PE34_Pixel_to_MUX_wr),
		.data28_in(PE35_Pixel_to_MUX_wr),
		.data29_in(PE36_Pixel_to_MUX_wr),
		.data30_in(PE37_Pixel_to_MUX_wr),
		.data31_in(PE38_Pixel_to_MUX_wr),
		.data32_in(PE39_Pixel_to_MUX_wr),
		.data33_in(PE0_Pixel_to_MUX_wr),
		.data34_in(PE1_Pixel_to_MUX_wr),
		.data35_in(PE2_Pixel_to_MUX_wr),
		.data36_in(PE3_Pixel_to_MUX_wr),
		.data37_in(PE4_Pixel_to_MUX_wr),
		.data38_in(PE5_Pixel_to_MUX_wr),
		.data39_in(PE6_Pixel_to_MUX_wr),
		.sel_in(MUX_Selection_in),
		.mux_40_1_out(Shared_PE7_Pixel_0_out_wr)
	);

	MUX_40_1 PE8_Pixel_0(
		.data0_in(PE8_Pixel_to_MUX_wr),
		.data1_in(PE9_Pixel_to_MUX_wr),
		.data2_in(PE10_Pixel_to_MUX_wr),
		.data3_in(PE11_Pixel_to_MUX_wr),
		.data4_in(PE12_Pixel_to_MUX_wr),
		.data5_in(PE13_Pixel_to_MUX_wr),
		.data6_in(PE14_Pixel_to_MUX_wr),
		.data7_in(PE15_Pixel_to_MUX_wr),
		.data8_in(PE16_Pixel_to_MUX_wr),
		.data9_in(PE17_Pixel_to_MUX_wr),
		.data10_in(PE18_Pixel_to_MUX_wr),
		.data11_in(PE19_Pixel_to_MUX_wr),
		.data12_in(PE20_Pixel_to_MUX_wr),
		.data13_in(PE21_Pixel_to_MUX_wr),
		.data14_in(PE22_Pixel_to_MUX_wr),
		.data15_in(PE23_Pixel_to_MUX_wr),
		.data16_in(PE24_Pixel_to_MUX_wr),
		.data17_in(PE25_Pixel_to_MUX_wr),
		.data18_in(PE26_Pixel_to_MUX_wr),
		.data19_in(PE27_Pixel_to_MUX_wr),
		.data20_in(PE28_Pixel_to_MUX_wr),
		.data21_in(PE29_Pixel_to_MUX_wr),
		.data22_in(PE30_Pixel_to_MUX_wr),
		.data23_in(PE31_Pixel_to_MUX_wr),
		.data24_in(PE32_Pixel_to_MUX_wr),
		.data25_in(PE33_Pixel_to_MUX_wr),
		.data26_in(PE34_Pixel_to_MUX_wr),
		.data27_in(PE35_Pixel_to_MUX_wr),
		.data28_in(PE36_Pixel_to_MUX_wr),
		.data29_in(PE37_Pixel_to_MUX_wr),
		.data30_in(PE38_Pixel_to_MUX_wr),
		.data31_in(PE39_Pixel_to_MUX_wr),
		.data32_in(PE0_Pixel_to_MUX_wr),
		.data33_in(PE1_Pixel_to_MUX_wr),
		.data34_in(PE2_Pixel_to_MUX_wr),
		.data35_in(PE3_Pixel_to_MUX_wr),
		.data36_in(PE4_Pixel_to_MUX_wr),
		.data37_in(PE5_Pixel_to_MUX_wr),
		.data38_in(PE6_Pixel_to_MUX_wr),
		.data39_in(PE7_Pixel_to_MUX_wr),
		.sel_in(MUX_Selection_in),
		.mux_40_1_out(Shared_PE8_Pixel_0_out_wr)
	);

	MUX_40_1 PE9_Pixel_0(
		.data0_in(PE9_Pixel_to_MUX_wr),
		.data1_in(PE10_Pixel_to_MUX_wr),
		.data2_in(PE11_Pixel_to_MUX_wr),
		.data3_in(PE12_Pixel_to_MUX_wr),
		.data4_in(PE13_Pixel_to_MUX_wr),
		.data5_in(PE14_Pixel_to_MUX_wr),
		.data6_in(PE15_Pixel_to_MUX_wr),
		.data7_in(PE16_Pixel_to_MUX_wr),
		.data8_in(PE17_Pixel_to_MUX_wr),
		.data9_in(PE18_Pixel_to_MUX_wr),
		.data10_in(PE19_Pixel_to_MUX_wr),
		.data11_in(PE20_Pixel_to_MUX_wr),
		.data12_in(PE21_Pixel_to_MUX_wr),
		.data13_in(PE22_Pixel_to_MUX_wr),
		.data14_in(PE23_Pixel_to_MUX_wr),
		.data15_in(PE24_Pixel_to_MUX_wr),
		.data16_in(PE25_Pixel_to_MUX_wr),
		.data17_in(PE26_Pixel_to_MUX_wr),
		.data18_in(PE27_Pixel_to_MUX_wr),
		.data19_in(PE28_Pixel_to_MUX_wr),
		.data20_in(PE29_Pixel_to_MUX_wr),
		.data21_in(PE30_Pixel_to_MUX_wr),
		.data22_in(PE31_Pixel_to_MUX_wr),
		.data23_in(PE32_Pixel_to_MUX_wr),
		.data24_in(PE33_Pixel_to_MUX_wr),
		.data25_in(PE34_Pixel_to_MUX_wr),
		.data26_in(PE35_Pixel_to_MUX_wr),
		.data27_in(PE36_Pixel_to_MUX_wr),
		.data28_in(PE37_Pixel_to_MUX_wr),
		.data29_in(PE38_Pixel_to_MUX_wr),
		.data30_in(PE39_Pixel_to_MUX_wr),
		.data31_in(PE0_Pixel_to_MUX_wr),
		.data32_in(PE1_Pixel_to_MUX_wr),
		.data33_in(PE2_Pixel_to_MUX_wr),
		.data34_in(PE3_Pixel_to_MUX_wr),
		.data35_in(PE4_Pixel_to_MUX_wr),
		.data36_in(PE5_Pixel_to_MUX_wr),
		.data37_in(PE6_Pixel_to_MUX_wr),
		.data38_in(PE7_Pixel_to_MUX_wr),
		.data39_in(PE8_Pixel_to_MUX_wr),
		.sel_in(MUX_Selection_in),
		.mux_40_1_out(Shared_PE9_Pixel_0_out_wr)
	);

	MUX_40_1 PE10_Pixel_0(
		.data0_in(PE10_Pixel_to_MUX_wr),
		.data1_in(PE11_Pixel_to_MUX_wr),
		.data2_in(PE12_Pixel_to_MUX_wr),
		.data3_in(PE13_Pixel_to_MUX_wr),
		.data4_in(PE14_Pixel_to_MUX_wr),
		.data5_in(PE15_Pixel_to_MUX_wr),
		.data6_in(PE16_Pixel_to_MUX_wr),
		.data7_in(PE17_Pixel_to_MUX_wr),
		.data8_in(PE18_Pixel_to_MUX_wr),
		.data9_in(PE19_Pixel_to_MUX_wr),
		.data10_in(PE20_Pixel_to_MUX_wr),
		.data11_in(PE21_Pixel_to_MUX_wr),
		.data12_in(PE22_Pixel_to_MUX_wr),
		.data13_in(PE23_Pixel_to_MUX_wr),
		.data14_in(PE24_Pixel_to_MUX_wr),
		.data15_in(PE25_Pixel_to_MUX_wr),
		.data16_in(PE26_Pixel_to_MUX_wr),
		.data17_in(PE27_Pixel_to_MUX_wr),
		.data18_in(PE28_Pixel_to_MUX_wr),
		.data19_in(PE29_Pixel_to_MUX_wr),
		.data20_in(PE30_Pixel_to_MUX_wr),
		.data21_in(PE31_Pixel_to_MUX_wr),
		.data22_in(PE32_Pixel_to_MUX_wr),
		.data23_in(PE33_Pixel_to_MUX_wr),
		.data24_in(PE34_Pixel_to_MUX_wr),
		.data25_in(PE35_Pixel_to_MUX_wr),
		.data26_in(PE36_Pixel_to_MUX_wr),
		.data27_in(PE37_Pixel_to_MUX_wr),
		.data28_in(PE38_Pixel_to_MUX_wr),
		.data29_in(PE39_Pixel_to_MUX_wr),
		.data30_in(PE0_Pixel_to_MUX_wr),
		.data31_in(PE1_Pixel_to_MUX_wr),
		.data32_in(PE2_Pixel_to_MUX_wr),
		.data33_in(PE3_Pixel_to_MUX_wr),
		.data34_in(PE4_Pixel_to_MUX_wr),
		.data35_in(PE5_Pixel_to_MUX_wr),
		.data36_in(PE6_Pixel_to_MUX_wr),
		.data37_in(PE7_Pixel_to_MUX_wr),
		.data38_in(PE8_Pixel_to_MUX_wr),
		.data39_in(PE9_Pixel_to_MUX_wr),
		.sel_in(MUX_Selection_in),
		.mux_40_1_out(Shared_PE10_Pixel_0_out_wr)
	);

	MUX_40_1 PE11_Pixel_0(
		.data0_in(PE11_Pixel_to_MUX_wr),
		.data1_in(PE12_Pixel_to_MUX_wr),
		.data2_in(PE13_Pixel_to_MUX_wr),
		.data3_in(PE14_Pixel_to_MUX_wr),
		.data4_in(PE15_Pixel_to_MUX_wr),
		.data5_in(PE16_Pixel_to_MUX_wr),
		.data6_in(PE17_Pixel_to_MUX_wr),
		.data7_in(PE18_Pixel_to_MUX_wr),
		.data8_in(PE19_Pixel_to_MUX_wr),
		.data9_in(PE20_Pixel_to_MUX_wr),
		.data10_in(PE21_Pixel_to_MUX_wr),
		.data11_in(PE22_Pixel_to_MUX_wr),
		.data12_in(PE23_Pixel_to_MUX_wr),
		.data13_in(PE24_Pixel_to_MUX_wr),
		.data14_in(PE25_Pixel_to_MUX_wr),
		.data15_in(PE26_Pixel_to_MUX_wr),
		.data16_in(PE27_Pixel_to_MUX_wr),
		.data17_in(PE28_Pixel_to_MUX_wr),
		.data18_in(PE29_Pixel_to_MUX_wr),
		.data19_in(PE30_Pixel_to_MUX_wr),
		.data20_in(PE31_Pixel_to_MUX_wr),
		.data21_in(PE32_Pixel_to_MUX_wr),
		.data22_in(PE33_Pixel_to_MUX_wr),
		.data23_in(PE34_Pixel_to_MUX_wr),
		.data24_in(PE35_Pixel_to_MUX_wr),
		.data25_in(PE36_Pixel_to_MUX_wr),
		.data26_in(PE37_Pixel_to_MUX_wr),
		.data27_in(PE38_Pixel_to_MUX_wr),
		.data28_in(PE39_Pixel_to_MUX_wr),
		.data29_in(PE0_Pixel_to_MUX_wr),
		.data30_in(PE1_Pixel_to_MUX_wr),
		.data31_in(PE2_Pixel_to_MUX_wr),
		.data32_in(PE3_Pixel_to_MUX_wr),
		.data33_in(PE4_Pixel_to_MUX_wr),
		.data34_in(PE5_Pixel_to_MUX_wr),
		.data35_in(PE6_Pixel_to_MUX_wr),
		.data36_in(PE7_Pixel_to_MUX_wr),
		.data37_in(PE8_Pixel_to_MUX_wr),
		.data38_in(PE9_Pixel_to_MUX_wr),
		.data39_in(PE10_Pixel_to_MUX_wr),
		.sel_in(MUX_Selection_in),
		.mux_40_1_out(Shared_PE11_Pixel_0_out_wr)
	);

	MUX_40_1 PE12_Pixel_0(
		.data0_in(PE12_Pixel_to_MUX_wr),
		.data1_in(PE13_Pixel_to_MUX_wr),
		.data2_in(PE14_Pixel_to_MUX_wr),
		.data3_in(PE15_Pixel_to_MUX_wr),
		.data4_in(PE16_Pixel_to_MUX_wr),
		.data5_in(PE17_Pixel_to_MUX_wr),
		.data6_in(PE18_Pixel_to_MUX_wr),
		.data7_in(PE19_Pixel_to_MUX_wr),
		.data8_in(PE20_Pixel_to_MUX_wr),
		.data9_in(PE21_Pixel_to_MUX_wr),
		.data10_in(PE22_Pixel_to_MUX_wr),
		.data11_in(PE23_Pixel_to_MUX_wr),
		.data12_in(PE24_Pixel_to_MUX_wr),
		.data13_in(PE25_Pixel_to_MUX_wr),
		.data14_in(PE26_Pixel_to_MUX_wr),
		.data15_in(PE27_Pixel_to_MUX_wr),
		.data16_in(PE28_Pixel_to_MUX_wr),
		.data17_in(PE29_Pixel_to_MUX_wr),
		.data18_in(PE30_Pixel_to_MUX_wr),
		.data19_in(PE31_Pixel_to_MUX_wr),
		.data20_in(PE32_Pixel_to_MUX_wr),
		.data21_in(PE33_Pixel_to_MUX_wr),
		.data22_in(PE34_Pixel_to_MUX_wr),
		.data23_in(PE35_Pixel_to_MUX_wr),
		.data24_in(PE36_Pixel_to_MUX_wr),
		.data25_in(PE37_Pixel_to_MUX_wr),
		.data26_in(PE38_Pixel_to_MUX_wr),
		.data27_in(PE39_Pixel_to_MUX_wr),
		.data28_in(PE0_Pixel_to_MUX_wr),
		.data29_in(PE1_Pixel_to_MUX_wr),
		.data30_in(PE2_Pixel_to_MUX_wr),
		.data31_in(PE3_Pixel_to_MUX_wr),
		.data32_in(PE4_Pixel_to_MUX_wr),
		.data33_in(PE5_Pixel_to_MUX_wr),
		.data34_in(PE6_Pixel_to_MUX_wr),
		.data35_in(PE7_Pixel_to_MUX_wr),
		.data36_in(PE8_Pixel_to_MUX_wr),
		.data37_in(PE9_Pixel_to_MUX_wr),
		.data38_in(PE10_Pixel_to_MUX_wr),
		.data39_in(PE11_Pixel_to_MUX_wr),
		.sel_in(MUX_Selection_in),
		.mux_40_1_out(Shared_PE12_Pixel_0_out_wr)
	);

	MUX_40_1 PE13_Pixel_0(
		.data0_in(PE13_Pixel_to_MUX_wr),
		.data1_in(PE14_Pixel_to_MUX_wr),
		.data2_in(PE15_Pixel_to_MUX_wr),
		.data3_in(PE16_Pixel_to_MUX_wr),
		.data4_in(PE17_Pixel_to_MUX_wr),
		.data5_in(PE18_Pixel_to_MUX_wr),
		.data6_in(PE19_Pixel_to_MUX_wr),
		.data7_in(PE20_Pixel_to_MUX_wr),
		.data8_in(PE21_Pixel_to_MUX_wr),
		.data9_in(PE22_Pixel_to_MUX_wr),
		.data10_in(PE23_Pixel_to_MUX_wr),
		.data11_in(PE24_Pixel_to_MUX_wr),
		.data12_in(PE25_Pixel_to_MUX_wr),
		.data13_in(PE26_Pixel_to_MUX_wr),
		.data14_in(PE27_Pixel_to_MUX_wr),
		.data15_in(PE28_Pixel_to_MUX_wr),
		.data16_in(PE29_Pixel_to_MUX_wr),
		.data17_in(PE30_Pixel_to_MUX_wr),
		.data18_in(PE31_Pixel_to_MUX_wr),
		.data19_in(PE32_Pixel_to_MUX_wr),
		.data20_in(PE33_Pixel_to_MUX_wr),
		.data21_in(PE34_Pixel_to_MUX_wr),
		.data22_in(PE35_Pixel_to_MUX_wr),
		.data23_in(PE36_Pixel_to_MUX_wr),
		.data24_in(PE37_Pixel_to_MUX_wr),
		.data25_in(PE38_Pixel_to_MUX_wr),
		.data26_in(PE39_Pixel_to_MUX_wr),
		.data27_in(PE0_Pixel_to_MUX_wr),
		.data28_in(PE1_Pixel_to_MUX_wr),
		.data29_in(PE2_Pixel_to_MUX_wr),
		.data30_in(PE3_Pixel_to_MUX_wr),
		.data31_in(PE4_Pixel_to_MUX_wr),
		.data32_in(PE5_Pixel_to_MUX_wr),
		.data33_in(PE6_Pixel_to_MUX_wr),
		.data34_in(PE7_Pixel_to_MUX_wr),
		.data35_in(PE8_Pixel_to_MUX_wr),
		.data36_in(PE9_Pixel_to_MUX_wr),
		.data37_in(PE10_Pixel_to_MUX_wr),
		.data38_in(PE11_Pixel_to_MUX_wr),
		.data39_in(PE12_Pixel_to_MUX_wr),
		.sel_in(MUX_Selection_in),
		.mux_40_1_out(Shared_PE13_Pixel_0_out_wr)
	);

	MUX_40_1 PE14_Pixel_0(
		.data0_in(PE14_Pixel_to_MUX_wr),
		.data1_in(PE15_Pixel_to_MUX_wr),
		.data2_in(PE16_Pixel_to_MUX_wr),
		.data3_in(PE17_Pixel_to_MUX_wr),
		.data4_in(PE18_Pixel_to_MUX_wr),
		.data5_in(PE19_Pixel_to_MUX_wr),
		.data6_in(PE20_Pixel_to_MUX_wr),
		.data7_in(PE21_Pixel_to_MUX_wr),
		.data8_in(PE22_Pixel_to_MUX_wr),
		.data9_in(PE23_Pixel_to_MUX_wr),
		.data10_in(PE24_Pixel_to_MUX_wr),
		.data11_in(PE25_Pixel_to_MUX_wr),
		.data12_in(PE26_Pixel_to_MUX_wr),
		.data13_in(PE27_Pixel_to_MUX_wr),
		.data14_in(PE28_Pixel_to_MUX_wr),
		.data15_in(PE29_Pixel_to_MUX_wr),
		.data16_in(PE30_Pixel_to_MUX_wr),
		.data17_in(PE31_Pixel_to_MUX_wr),
		.data18_in(PE32_Pixel_to_MUX_wr),
		.data19_in(PE33_Pixel_to_MUX_wr),
		.data20_in(PE34_Pixel_to_MUX_wr),
		.data21_in(PE35_Pixel_to_MUX_wr),
		.data22_in(PE36_Pixel_to_MUX_wr),
		.data23_in(PE37_Pixel_to_MUX_wr),
		.data24_in(PE38_Pixel_to_MUX_wr),
		.data25_in(PE39_Pixel_to_MUX_wr),
		.data26_in(PE0_Pixel_to_MUX_wr),
		.data27_in(PE1_Pixel_to_MUX_wr),
		.data28_in(PE2_Pixel_to_MUX_wr),
		.data29_in(PE3_Pixel_to_MUX_wr),
		.data30_in(PE4_Pixel_to_MUX_wr),
		.data31_in(PE5_Pixel_to_MUX_wr),
		.data32_in(PE6_Pixel_to_MUX_wr),
		.data33_in(PE7_Pixel_to_MUX_wr),
		.data34_in(PE8_Pixel_to_MUX_wr),
		.data35_in(PE9_Pixel_to_MUX_wr),
		.data36_in(PE10_Pixel_to_MUX_wr),
		.data37_in(PE11_Pixel_to_MUX_wr),
		.data38_in(PE12_Pixel_to_MUX_wr),
		.data39_in(PE13_Pixel_to_MUX_wr),
		.sel_in(MUX_Selection_in),
		.mux_40_1_out(Shared_PE14_Pixel_0_out_wr)
	);

	MUX_40_1 PE15_Pixel_0(
		.data0_in(PE15_Pixel_to_MUX_wr),
		.data1_in(PE16_Pixel_to_MUX_wr),
		.data2_in(PE17_Pixel_to_MUX_wr),
		.data3_in(PE18_Pixel_to_MUX_wr),
		.data4_in(PE19_Pixel_to_MUX_wr),
		.data5_in(PE20_Pixel_to_MUX_wr),
		.data6_in(PE21_Pixel_to_MUX_wr),
		.data7_in(PE22_Pixel_to_MUX_wr),
		.data8_in(PE23_Pixel_to_MUX_wr),
		.data9_in(PE24_Pixel_to_MUX_wr),
		.data10_in(PE25_Pixel_to_MUX_wr),
		.data11_in(PE26_Pixel_to_MUX_wr),
		.data12_in(PE27_Pixel_to_MUX_wr),
		.data13_in(PE28_Pixel_to_MUX_wr),
		.data14_in(PE29_Pixel_to_MUX_wr),
		.data15_in(PE30_Pixel_to_MUX_wr),
		.data16_in(PE31_Pixel_to_MUX_wr),
		.data17_in(PE32_Pixel_to_MUX_wr),
		.data18_in(PE33_Pixel_to_MUX_wr),
		.data19_in(PE34_Pixel_to_MUX_wr),
		.data20_in(PE35_Pixel_to_MUX_wr),
		.data21_in(PE36_Pixel_to_MUX_wr),
		.data22_in(PE37_Pixel_to_MUX_wr),
		.data23_in(PE38_Pixel_to_MUX_wr),
		.data24_in(PE39_Pixel_to_MUX_wr),
		.data25_in(PE0_Pixel_to_MUX_wr),
		.data26_in(PE1_Pixel_to_MUX_wr),
		.data27_in(PE2_Pixel_to_MUX_wr),
		.data28_in(PE3_Pixel_to_MUX_wr),
		.data29_in(PE4_Pixel_to_MUX_wr),
		.data30_in(PE5_Pixel_to_MUX_wr),
		.data31_in(PE6_Pixel_to_MUX_wr),
		.data32_in(PE7_Pixel_to_MUX_wr),
		.data33_in(PE8_Pixel_to_MUX_wr),
		.data34_in(PE9_Pixel_to_MUX_wr),
		.data35_in(PE10_Pixel_to_MUX_wr),
		.data36_in(PE11_Pixel_to_MUX_wr),
		.data37_in(PE12_Pixel_to_MUX_wr),
		.data38_in(PE13_Pixel_to_MUX_wr),
		.data39_in(PE14_Pixel_to_MUX_wr),
		.sel_in(MUX_Selection_in),
		.mux_40_1_out(Shared_PE15_Pixel_0_out_wr)
	);

	MUX_40_1 PE16_Pixel_0(
		.data0_in(PE16_Pixel_to_MUX_wr),
		.data1_in(PE17_Pixel_to_MUX_wr),
		.data2_in(PE18_Pixel_to_MUX_wr),
		.data3_in(PE19_Pixel_to_MUX_wr),
		.data4_in(PE20_Pixel_to_MUX_wr),
		.data5_in(PE21_Pixel_to_MUX_wr),
		.data6_in(PE22_Pixel_to_MUX_wr),
		.data7_in(PE23_Pixel_to_MUX_wr),
		.data8_in(PE24_Pixel_to_MUX_wr),
		.data9_in(PE25_Pixel_to_MUX_wr),
		.data10_in(PE26_Pixel_to_MUX_wr),
		.data11_in(PE27_Pixel_to_MUX_wr),
		.data12_in(PE28_Pixel_to_MUX_wr),
		.data13_in(PE29_Pixel_to_MUX_wr),
		.data14_in(PE30_Pixel_to_MUX_wr),
		.data15_in(PE31_Pixel_to_MUX_wr),
		.data16_in(PE32_Pixel_to_MUX_wr),
		.data17_in(PE33_Pixel_to_MUX_wr),
		.data18_in(PE34_Pixel_to_MUX_wr),
		.data19_in(PE35_Pixel_to_MUX_wr),
		.data20_in(PE36_Pixel_to_MUX_wr),
		.data21_in(PE37_Pixel_to_MUX_wr),
		.data22_in(PE38_Pixel_to_MUX_wr),
		.data23_in(PE39_Pixel_to_MUX_wr),
		.data24_in(PE0_Pixel_to_MUX_wr),
		.data25_in(PE1_Pixel_to_MUX_wr),
		.data26_in(PE2_Pixel_to_MUX_wr),
		.data27_in(PE3_Pixel_to_MUX_wr),
		.data28_in(PE4_Pixel_to_MUX_wr),
		.data29_in(PE5_Pixel_to_MUX_wr),
		.data30_in(PE6_Pixel_to_MUX_wr),
		.data31_in(PE7_Pixel_to_MUX_wr),
		.data32_in(PE8_Pixel_to_MUX_wr),
		.data33_in(PE9_Pixel_to_MUX_wr),
		.data34_in(PE10_Pixel_to_MUX_wr),
		.data35_in(PE11_Pixel_to_MUX_wr),
		.data36_in(PE12_Pixel_to_MUX_wr),
		.data37_in(PE13_Pixel_to_MUX_wr),
		.data38_in(PE14_Pixel_to_MUX_wr),
		.data39_in(PE15_Pixel_to_MUX_wr),
		.sel_in(MUX_Selection_in),
		.mux_40_1_out(Shared_PE16_Pixel_0_out_wr)
	);

	MUX_40_1 PE17_Pixel_0(
		.data0_in(PE17_Pixel_to_MUX_wr),
		.data1_in(PE18_Pixel_to_MUX_wr),
		.data2_in(PE19_Pixel_to_MUX_wr),
		.data3_in(PE20_Pixel_to_MUX_wr),
		.data4_in(PE21_Pixel_to_MUX_wr),
		.data5_in(PE22_Pixel_to_MUX_wr),
		.data6_in(PE23_Pixel_to_MUX_wr),
		.data7_in(PE24_Pixel_to_MUX_wr),
		.data8_in(PE25_Pixel_to_MUX_wr),
		.data9_in(PE26_Pixel_to_MUX_wr),
		.data10_in(PE27_Pixel_to_MUX_wr),
		.data11_in(PE28_Pixel_to_MUX_wr),
		.data12_in(PE29_Pixel_to_MUX_wr),
		.data13_in(PE30_Pixel_to_MUX_wr),
		.data14_in(PE31_Pixel_to_MUX_wr),
		.data15_in(PE32_Pixel_to_MUX_wr),
		.data16_in(PE33_Pixel_to_MUX_wr),
		.data17_in(PE34_Pixel_to_MUX_wr),
		.data18_in(PE35_Pixel_to_MUX_wr),
		.data19_in(PE36_Pixel_to_MUX_wr),
		.data20_in(PE37_Pixel_to_MUX_wr),
		.data21_in(PE38_Pixel_to_MUX_wr),
		.data22_in(PE39_Pixel_to_MUX_wr),
		.data23_in(PE0_Pixel_to_MUX_wr),
		.data24_in(PE1_Pixel_to_MUX_wr),
		.data25_in(PE2_Pixel_to_MUX_wr),
		.data26_in(PE3_Pixel_to_MUX_wr),
		.data27_in(PE4_Pixel_to_MUX_wr),
		.data28_in(PE5_Pixel_to_MUX_wr),
		.data29_in(PE6_Pixel_to_MUX_wr),
		.data30_in(PE7_Pixel_to_MUX_wr),
		.data31_in(PE8_Pixel_to_MUX_wr),
		.data32_in(PE9_Pixel_to_MUX_wr),
		.data33_in(PE10_Pixel_to_MUX_wr),
		.data34_in(PE11_Pixel_to_MUX_wr),
		.data35_in(PE12_Pixel_to_MUX_wr),
		.data36_in(PE13_Pixel_to_MUX_wr),
		.data37_in(PE14_Pixel_to_MUX_wr),
		.data38_in(PE15_Pixel_to_MUX_wr),
		.data39_in(PE16_Pixel_to_MUX_wr),
		.sel_in(MUX_Selection_in),
		.mux_40_1_out(Shared_PE17_Pixel_0_out_wr)
	);

	MUX_40_1 PE18_Pixel_0(
		.data0_in(PE18_Pixel_to_MUX_wr),
		.data1_in(PE19_Pixel_to_MUX_wr),
		.data2_in(PE20_Pixel_to_MUX_wr),
		.data3_in(PE21_Pixel_to_MUX_wr),
		.data4_in(PE22_Pixel_to_MUX_wr),
		.data5_in(PE23_Pixel_to_MUX_wr),
		.data6_in(PE24_Pixel_to_MUX_wr),
		.data7_in(PE25_Pixel_to_MUX_wr),
		.data8_in(PE26_Pixel_to_MUX_wr),
		.data9_in(PE27_Pixel_to_MUX_wr),
		.data10_in(PE28_Pixel_to_MUX_wr),
		.data11_in(PE29_Pixel_to_MUX_wr),
		.data12_in(PE30_Pixel_to_MUX_wr),
		.data13_in(PE31_Pixel_to_MUX_wr),
		.data14_in(PE32_Pixel_to_MUX_wr),
		.data15_in(PE33_Pixel_to_MUX_wr),
		.data16_in(PE34_Pixel_to_MUX_wr),
		.data17_in(PE35_Pixel_to_MUX_wr),
		.data18_in(PE36_Pixel_to_MUX_wr),
		.data19_in(PE37_Pixel_to_MUX_wr),
		.data20_in(PE38_Pixel_to_MUX_wr),
		.data21_in(PE39_Pixel_to_MUX_wr),
		.data22_in(PE0_Pixel_to_MUX_wr),
		.data23_in(PE1_Pixel_to_MUX_wr),
		.data24_in(PE2_Pixel_to_MUX_wr),
		.data25_in(PE3_Pixel_to_MUX_wr),
		.data26_in(PE4_Pixel_to_MUX_wr),
		.data27_in(PE5_Pixel_to_MUX_wr),
		.data28_in(PE6_Pixel_to_MUX_wr),
		.data29_in(PE7_Pixel_to_MUX_wr),
		.data30_in(PE8_Pixel_to_MUX_wr),
		.data31_in(PE9_Pixel_to_MUX_wr),
		.data32_in(PE10_Pixel_to_MUX_wr),
		.data33_in(PE11_Pixel_to_MUX_wr),
		.data34_in(PE12_Pixel_to_MUX_wr),
		.data35_in(PE13_Pixel_to_MUX_wr),
		.data36_in(PE14_Pixel_to_MUX_wr),
		.data37_in(PE15_Pixel_to_MUX_wr),
		.data38_in(PE16_Pixel_to_MUX_wr),
		.data39_in(PE17_Pixel_to_MUX_wr),
		.sel_in(MUX_Selection_in),
		.mux_40_1_out(Shared_PE18_Pixel_0_out_wr)
	);

	MUX_40_1 PE19_Pixel_0(
		.data0_in(PE19_Pixel_to_MUX_wr),
		.data1_in(PE20_Pixel_to_MUX_wr),
		.data2_in(PE21_Pixel_to_MUX_wr),
		.data3_in(PE22_Pixel_to_MUX_wr),
		.data4_in(PE23_Pixel_to_MUX_wr),
		.data5_in(PE24_Pixel_to_MUX_wr),
		.data6_in(PE25_Pixel_to_MUX_wr),
		.data7_in(PE26_Pixel_to_MUX_wr),
		.data8_in(PE27_Pixel_to_MUX_wr),
		.data9_in(PE28_Pixel_to_MUX_wr),
		.data10_in(PE29_Pixel_to_MUX_wr),
		.data11_in(PE30_Pixel_to_MUX_wr),
		.data12_in(PE31_Pixel_to_MUX_wr),
		.data13_in(PE32_Pixel_to_MUX_wr),
		.data14_in(PE33_Pixel_to_MUX_wr),
		.data15_in(PE34_Pixel_to_MUX_wr),
		.data16_in(PE35_Pixel_to_MUX_wr),
		.data17_in(PE36_Pixel_to_MUX_wr),
		.data18_in(PE37_Pixel_to_MUX_wr),
		.data19_in(PE38_Pixel_to_MUX_wr),
		.data20_in(PE39_Pixel_to_MUX_wr),
		.data21_in(PE0_Pixel_to_MUX_wr),
		.data22_in(PE1_Pixel_to_MUX_wr),
		.data23_in(PE2_Pixel_to_MUX_wr),
		.data24_in(PE3_Pixel_to_MUX_wr),
		.data25_in(PE4_Pixel_to_MUX_wr),
		.data26_in(PE5_Pixel_to_MUX_wr),
		.data27_in(PE6_Pixel_to_MUX_wr),
		.data28_in(PE7_Pixel_to_MUX_wr),
		.data29_in(PE8_Pixel_to_MUX_wr),
		.data30_in(PE9_Pixel_to_MUX_wr),
		.data31_in(PE10_Pixel_to_MUX_wr),
		.data32_in(PE11_Pixel_to_MUX_wr),
		.data33_in(PE12_Pixel_to_MUX_wr),
		.data34_in(PE13_Pixel_to_MUX_wr),
		.data35_in(PE14_Pixel_to_MUX_wr),
		.data36_in(PE15_Pixel_to_MUX_wr),
		.data37_in(PE16_Pixel_to_MUX_wr),
		.data38_in(PE17_Pixel_to_MUX_wr),
		.data39_in(PE18_Pixel_to_MUX_wr),
		.sel_in(MUX_Selection_in),
		.mux_40_1_out(Shared_PE19_Pixel_0_out_wr)
	);

	MUX_40_1 PE20_Pixel_0(
		.data0_in(PE20_Pixel_to_MUX_wr),
		.data1_in(PE21_Pixel_to_MUX_wr),
		.data2_in(PE22_Pixel_to_MUX_wr),
		.data3_in(PE23_Pixel_to_MUX_wr),
		.data4_in(PE24_Pixel_to_MUX_wr),
		.data5_in(PE25_Pixel_to_MUX_wr),
		.data6_in(PE26_Pixel_to_MUX_wr),
		.data7_in(PE27_Pixel_to_MUX_wr),
		.data8_in(PE28_Pixel_to_MUX_wr),
		.data9_in(PE29_Pixel_to_MUX_wr),
		.data10_in(PE30_Pixel_to_MUX_wr),
		.data11_in(PE31_Pixel_to_MUX_wr),
		.data12_in(PE32_Pixel_to_MUX_wr),
		.data13_in(PE33_Pixel_to_MUX_wr),
		.data14_in(PE34_Pixel_to_MUX_wr),
		.data15_in(PE35_Pixel_to_MUX_wr),
		.data16_in(PE36_Pixel_to_MUX_wr),
		.data17_in(PE37_Pixel_to_MUX_wr),
		.data18_in(PE38_Pixel_to_MUX_wr),
		.data19_in(PE39_Pixel_to_MUX_wr),
		.data20_in(PE0_Pixel_to_MUX_wr),
		.data21_in(PE1_Pixel_to_MUX_wr),
		.data22_in(PE2_Pixel_to_MUX_wr),
		.data23_in(PE3_Pixel_to_MUX_wr),
		.data24_in(PE4_Pixel_to_MUX_wr),
		.data25_in(PE5_Pixel_to_MUX_wr),
		.data26_in(PE6_Pixel_to_MUX_wr),
		.data27_in(PE7_Pixel_to_MUX_wr),
		.data28_in(PE8_Pixel_to_MUX_wr),
		.data29_in(PE9_Pixel_to_MUX_wr),
		.data30_in(PE10_Pixel_to_MUX_wr),
		.data31_in(PE11_Pixel_to_MUX_wr),
		.data32_in(PE12_Pixel_to_MUX_wr),
		.data33_in(PE13_Pixel_to_MUX_wr),
		.data34_in(PE14_Pixel_to_MUX_wr),
		.data35_in(PE15_Pixel_to_MUX_wr),
		.data36_in(PE16_Pixel_to_MUX_wr),
		.data37_in(PE17_Pixel_to_MUX_wr),
		.data38_in(PE18_Pixel_to_MUX_wr),
		.data39_in(PE19_Pixel_to_MUX_wr),
		.sel_in(MUX_Selection_in),
		.mux_40_1_out(Shared_PE20_Pixel_0_out_wr)
	);

	MUX_40_1 PE21_Pixel_0(
		.data0_in(PE21_Pixel_to_MUX_wr),
		.data1_in(PE22_Pixel_to_MUX_wr),
		.data2_in(PE23_Pixel_to_MUX_wr),
		.data3_in(PE24_Pixel_to_MUX_wr),
		.data4_in(PE25_Pixel_to_MUX_wr),
		.data5_in(PE26_Pixel_to_MUX_wr),
		.data6_in(PE27_Pixel_to_MUX_wr),
		.data7_in(PE28_Pixel_to_MUX_wr),
		.data8_in(PE29_Pixel_to_MUX_wr),
		.data9_in(PE30_Pixel_to_MUX_wr),
		.data10_in(PE31_Pixel_to_MUX_wr),
		.data11_in(PE32_Pixel_to_MUX_wr),
		.data12_in(PE33_Pixel_to_MUX_wr),
		.data13_in(PE34_Pixel_to_MUX_wr),
		.data14_in(PE35_Pixel_to_MUX_wr),
		.data15_in(PE36_Pixel_to_MUX_wr),
		.data16_in(PE37_Pixel_to_MUX_wr),
		.data17_in(PE38_Pixel_to_MUX_wr),
		.data18_in(PE39_Pixel_to_MUX_wr),
		.data19_in(PE0_Pixel_to_MUX_wr),
		.data20_in(PE1_Pixel_to_MUX_wr),
		.data21_in(PE2_Pixel_to_MUX_wr),
		.data22_in(PE3_Pixel_to_MUX_wr),
		.data23_in(PE4_Pixel_to_MUX_wr),
		.data24_in(PE5_Pixel_to_MUX_wr),
		.data25_in(PE6_Pixel_to_MUX_wr),
		.data26_in(PE7_Pixel_to_MUX_wr),
		.data27_in(PE8_Pixel_to_MUX_wr),
		.data28_in(PE9_Pixel_to_MUX_wr),
		.data29_in(PE10_Pixel_to_MUX_wr),
		.data30_in(PE11_Pixel_to_MUX_wr),
		.data31_in(PE12_Pixel_to_MUX_wr),
		.data32_in(PE13_Pixel_to_MUX_wr),
		.data33_in(PE14_Pixel_to_MUX_wr),
		.data34_in(PE15_Pixel_to_MUX_wr),
		.data35_in(PE16_Pixel_to_MUX_wr),
		.data36_in(PE17_Pixel_to_MUX_wr),
		.data37_in(PE18_Pixel_to_MUX_wr),
		.data38_in(PE19_Pixel_to_MUX_wr),
		.data39_in(PE20_Pixel_to_MUX_wr),
		.sel_in(MUX_Selection_in),
		.mux_40_1_out(Shared_PE21_Pixel_0_out_wr)
	);

	MUX_40_1 PE22_Pixel_0(
		.data0_in(PE22_Pixel_to_MUX_wr),
		.data1_in(PE23_Pixel_to_MUX_wr),
		.data2_in(PE24_Pixel_to_MUX_wr),
		.data3_in(PE25_Pixel_to_MUX_wr),
		.data4_in(PE26_Pixel_to_MUX_wr),
		.data5_in(PE27_Pixel_to_MUX_wr),
		.data6_in(PE28_Pixel_to_MUX_wr),
		.data7_in(PE29_Pixel_to_MUX_wr),
		.data8_in(PE30_Pixel_to_MUX_wr),
		.data9_in(PE31_Pixel_to_MUX_wr),
		.data10_in(PE32_Pixel_to_MUX_wr),
		.data11_in(PE33_Pixel_to_MUX_wr),
		.data12_in(PE34_Pixel_to_MUX_wr),
		.data13_in(PE35_Pixel_to_MUX_wr),
		.data14_in(PE36_Pixel_to_MUX_wr),
		.data15_in(PE37_Pixel_to_MUX_wr),
		.data16_in(PE38_Pixel_to_MUX_wr),
		.data17_in(PE39_Pixel_to_MUX_wr),
		.data18_in(PE0_Pixel_to_MUX_wr),
		.data19_in(PE1_Pixel_to_MUX_wr),
		.data20_in(PE2_Pixel_to_MUX_wr),
		.data21_in(PE3_Pixel_to_MUX_wr),
		.data22_in(PE4_Pixel_to_MUX_wr),
		.data23_in(PE5_Pixel_to_MUX_wr),
		.data24_in(PE6_Pixel_to_MUX_wr),
		.data25_in(PE7_Pixel_to_MUX_wr),
		.data26_in(PE8_Pixel_to_MUX_wr),
		.data27_in(PE9_Pixel_to_MUX_wr),
		.data28_in(PE10_Pixel_to_MUX_wr),
		.data29_in(PE11_Pixel_to_MUX_wr),
		.data30_in(PE12_Pixel_to_MUX_wr),
		.data31_in(PE13_Pixel_to_MUX_wr),
		.data32_in(PE14_Pixel_to_MUX_wr),
		.data33_in(PE15_Pixel_to_MUX_wr),
		.data34_in(PE16_Pixel_to_MUX_wr),
		.data35_in(PE17_Pixel_to_MUX_wr),
		.data36_in(PE18_Pixel_to_MUX_wr),
		.data37_in(PE19_Pixel_to_MUX_wr),
		.data38_in(PE20_Pixel_to_MUX_wr),
		.data39_in(PE21_Pixel_to_MUX_wr),
		.sel_in(MUX_Selection_in),
		.mux_40_1_out(Shared_PE22_Pixel_0_out_wr)
	);

	MUX_40_1 PE23_Pixel_0(
		.data0_in(PE23_Pixel_to_MUX_wr),
		.data1_in(PE24_Pixel_to_MUX_wr),
		.data2_in(PE25_Pixel_to_MUX_wr),
		.data3_in(PE26_Pixel_to_MUX_wr),
		.data4_in(PE27_Pixel_to_MUX_wr),
		.data5_in(PE28_Pixel_to_MUX_wr),
		.data6_in(PE29_Pixel_to_MUX_wr),
		.data7_in(PE30_Pixel_to_MUX_wr),
		.data8_in(PE31_Pixel_to_MUX_wr),
		.data9_in(PE32_Pixel_to_MUX_wr),
		.data10_in(PE33_Pixel_to_MUX_wr),
		.data11_in(PE34_Pixel_to_MUX_wr),
		.data12_in(PE35_Pixel_to_MUX_wr),
		.data13_in(PE36_Pixel_to_MUX_wr),
		.data14_in(PE37_Pixel_to_MUX_wr),
		.data15_in(PE38_Pixel_to_MUX_wr),
		.data16_in(PE39_Pixel_to_MUX_wr),
		.data17_in(PE0_Pixel_to_MUX_wr),
		.data18_in(PE1_Pixel_to_MUX_wr),
		.data19_in(PE2_Pixel_to_MUX_wr),
		.data20_in(PE3_Pixel_to_MUX_wr),
		.data21_in(PE4_Pixel_to_MUX_wr),
		.data22_in(PE5_Pixel_to_MUX_wr),
		.data23_in(PE6_Pixel_to_MUX_wr),
		.data24_in(PE7_Pixel_to_MUX_wr),
		.data25_in(PE8_Pixel_to_MUX_wr),
		.data26_in(PE9_Pixel_to_MUX_wr),
		.data27_in(PE10_Pixel_to_MUX_wr),
		.data28_in(PE11_Pixel_to_MUX_wr),
		.data29_in(PE12_Pixel_to_MUX_wr),
		.data30_in(PE13_Pixel_to_MUX_wr),
		.data31_in(PE14_Pixel_to_MUX_wr),
		.data32_in(PE15_Pixel_to_MUX_wr),
		.data33_in(PE16_Pixel_to_MUX_wr),
		.data34_in(PE17_Pixel_to_MUX_wr),
		.data35_in(PE18_Pixel_to_MUX_wr),
		.data36_in(PE19_Pixel_to_MUX_wr),
		.data37_in(PE20_Pixel_to_MUX_wr),
		.data38_in(PE21_Pixel_to_MUX_wr),
		.data39_in(PE22_Pixel_to_MUX_wr),
		.sel_in(MUX_Selection_in),
		.mux_40_1_out(Shared_PE23_Pixel_0_out_wr)
	);

	MUX_40_1 PE24_Pixel_0(
		.data0_in(PE24_Pixel_to_MUX_wr),
		.data1_in(PE25_Pixel_to_MUX_wr),
		.data2_in(PE26_Pixel_to_MUX_wr),
		.data3_in(PE27_Pixel_to_MUX_wr),
		.data4_in(PE28_Pixel_to_MUX_wr),
		.data5_in(PE29_Pixel_to_MUX_wr),
		.data6_in(PE30_Pixel_to_MUX_wr),
		.data7_in(PE31_Pixel_to_MUX_wr),
		.data8_in(PE32_Pixel_to_MUX_wr),
		.data9_in(PE33_Pixel_to_MUX_wr),
		.data10_in(PE34_Pixel_to_MUX_wr),
		.data11_in(PE35_Pixel_to_MUX_wr),
		.data12_in(PE36_Pixel_to_MUX_wr),
		.data13_in(PE37_Pixel_to_MUX_wr),
		.data14_in(PE38_Pixel_to_MUX_wr),
		.data15_in(PE39_Pixel_to_MUX_wr),
		.data16_in(PE0_Pixel_to_MUX_wr),
		.data17_in(PE1_Pixel_to_MUX_wr),
		.data18_in(PE2_Pixel_to_MUX_wr),
		.data19_in(PE3_Pixel_to_MUX_wr),
		.data20_in(PE4_Pixel_to_MUX_wr),
		.data21_in(PE5_Pixel_to_MUX_wr),
		.data22_in(PE6_Pixel_to_MUX_wr),
		.data23_in(PE7_Pixel_to_MUX_wr),
		.data24_in(PE8_Pixel_to_MUX_wr),
		.data25_in(PE9_Pixel_to_MUX_wr),
		.data26_in(PE10_Pixel_to_MUX_wr),
		.data27_in(PE11_Pixel_to_MUX_wr),
		.data28_in(PE12_Pixel_to_MUX_wr),
		.data29_in(PE13_Pixel_to_MUX_wr),
		.data30_in(PE14_Pixel_to_MUX_wr),
		.data31_in(PE15_Pixel_to_MUX_wr),
		.data32_in(PE16_Pixel_to_MUX_wr),
		.data33_in(PE17_Pixel_to_MUX_wr),
		.data34_in(PE18_Pixel_to_MUX_wr),
		.data35_in(PE19_Pixel_to_MUX_wr),
		.data36_in(PE20_Pixel_to_MUX_wr),
		.data37_in(PE21_Pixel_to_MUX_wr),
		.data38_in(PE22_Pixel_to_MUX_wr),
		.data39_in(PE23_Pixel_to_MUX_wr),
		.sel_in(MUX_Selection_in),
		.mux_40_1_out(Shared_PE24_Pixel_0_out_wr)
	);

	MUX_40_1 PE25_Pixel_0(
		.data0_in(PE25_Pixel_to_MUX_wr),
		.data1_in(PE26_Pixel_to_MUX_wr),
		.data2_in(PE27_Pixel_to_MUX_wr),
		.data3_in(PE28_Pixel_to_MUX_wr),
		.data4_in(PE29_Pixel_to_MUX_wr),
		.data5_in(PE30_Pixel_to_MUX_wr),
		.data6_in(PE31_Pixel_to_MUX_wr),
		.data7_in(PE32_Pixel_to_MUX_wr),
		.data8_in(PE33_Pixel_to_MUX_wr),
		.data9_in(PE34_Pixel_to_MUX_wr),
		.data10_in(PE35_Pixel_to_MUX_wr),
		.data11_in(PE36_Pixel_to_MUX_wr),
		.data12_in(PE37_Pixel_to_MUX_wr),
		.data13_in(PE38_Pixel_to_MUX_wr),
		.data14_in(PE39_Pixel_to_MUX_wr),
		.data15_in(PE0_Pixel_to_MUX_wr),
		.data16_in(PE1_Pixel_to_MUX_wr),
		.data17_in(PE2_Pixel_to_MUX_wr),
		.data18_in(PE3_Pixel_to_MUX_wr),
		.data19_in(PE4_Pixel_to_MUX_wr),
		.data20_in(PE5_Pixel_to_MUX_wr),
		.data21_in(PE6_Pixel_to_MUX_wr),
		.data22_in(PE7_Pixel_to_MUX_wr),
		.data23_in(PE8_Pixel_to_MUX_wr),
		.data24_in(PE9_Pixel_to_MUX_wr),
		.data25_in(PE10_Pixel_to_MUX_wr),
		.data26_in(PE11_Pixel_to_MUX_wr),
		.data27_in(PE12_Pixel_to_MUX_wr),
		.data28_in(PE13_Pixel_to_MUX_wr),
		.data29_in(PE14_Pixel_to_MUX_wr),
		.data30_in(PE15_Pixel_to_MUX_wr),
		.data31_in(PE16_Pixel_to_MUX_wr),
		.data32_in(PE17_Pixel_to_MUX_wr),
		.data33_in(PE18_Pixel_to_MUX_wr),
		.data34_in(PE19_Pixel_to_MUX_wr),
		.data35_in(PE20_Pixel_to_MUX_wr),
		.data36_in(PE21_Pixel_to_MUX_wr),
		.data37_in(PE22_Pixel_to_MUX_wr),
		.data38_in(PE23_Pixel_to_MUX_wr),
		.data39_in(PE24_Pixel_to_MUX_wr),
		.sel_in(MUX_Selection_in),
		.mux_40_1_out(Shared_PE25_Pixel_0_out_wr)
	);

	MUX_40_1 PE26_Pixel_0(
		.data0_in(PE26_Pixel_to_MUX_wr),
		.data1_in(PE27_Pixel_to_MUX_wr),
		.data2_in(PE28_Pixel_to_MUX_wr),
		.data3_in(PE29_Pixel_to_MUX_wr),
		.data4_in(PE30_Pixel_to_MUX_wr),
		.data5_in(PE31_Pixel_to_MUX_wr),
		.data6_in(PE32_Pixel_to_MUX_wr),
		.data7_in(PE33_Pixel_to_MUX_wr),
		.data8_in(PE34_Pixel_to_MUX_wr),
		.data9_in(PE35_Pixel_to_MUX_wr),
		.data10_in(PE36_Pixel_to_MUX_wr),
		.data11_in(PE37_Pixel_to_MUX_wr),
		.data12_in(PE38_Pixel_to_MUX_wr),
		.data13_in(PE39_Pixel_to_MUX_wr),
		.data14_in(PE0_Pixel_to_MUX_wr),
		.data15_in(PE1_Pixel_to_MUX_wr),
		.data16_in(PE2_Pixel_to_MUX_wr),
		.data17_in(PE3_Pixel_to_MUX_wr),
		.data18_in(PE4_Pixel_to_MUX_wr),
		.data19_in(PE5_Pixel_to_MUX_wr),
		.data20_in(PE6_Pixel_to_MUX_wr),
		.data21_in(PE7_Pixel_to_MUX_wr),
		.data22_in(PE8_Pixel_to_MUX_wr),
		.data23_in(PE9_Pixel_to_MUX_wr),
		.data24_in(PE10_Pixel_to_MUX_wr),
		.data25_in(PE11_Pixel_to_MUX_wr),
		.data26_in(PE12_Pixel_to_MUX_wr),
		.data27_in(PE13_Pixel_to_MUX_wr),
		.data28_in(PE14_Pixel_to_MUX_wr),
		.data29_in(PE15_Pixel_to_MUX_wr),
		.data30_in(PE16_Pixel_to_MUX_wr),
		.data31_in(PE17_Pixel_to_MUX_wr),
		.data32_in(PE18_Pixel_to_MUX_wr),
		.data33_in(PE19_Pixel_to_MUX_wr),
		.data34_in(PE20_Pixel_to_MUX_wr),
		.data35_in(PE21_Pixel_to_MUX_wr),
		.data36_in(PE22_Pixel_to_MUX_wr),
		.data37_in(PE23_Pixel_to_MUX_wr),
		.data38_in(PE24_Pixel_to_MUX_wr),
		.data39_in(PE25_Pixel_to_MUX_wr),
		.sel_in(MUX_Selection_in),
		.mux_40_1_out(Shared_PE26_Pixel_0_out_wr)
	);

	MUX_40_1 PE27_Pixel_0(
		.data0_in(PE27_Pixel_to_MUX_wr),
		.data1_in(PE28_Pixel_to_MUX_wr),
		.data2_in(PE29_Pixel_to_MUX_wr),
		.data3_in(PE30_Pixel_to_MUX_wr),
		.data4_in(PE31_Pixel_to_MUX_wr),
		.data5_in(PE32_Pixel_to_MUX_wr),
		.data6_in(PE33_Pixel_to_MUX_wr),
		.data7_in(PE34_Pixel_to_MUX_wr),
		.data8_in(PE35_Pixel_to_MUX_wr),
		.data9_in(PE36_Pixel_to_MUX_wr),
		.data10_in(PE37_Pixel_to_MUX_wr),
		.data11_in(PE38_Pixel_to_MUX_wr),
		.data12_in(PE39_Pixel_to_MUX_wr),
		.data13_in(PE0_Pixel_to_MUX_wr),
		.data14_in(PE1_Pixel_to_MUX_wr),
		.data15_in(PE2_Pixel_to_MUX_wr),
		.data16_in(PE3_Pixel_to_MUX_wr),
		.data17_in(PE4_Pixel_to_MUX_wr),
		.data18_in(PE5_Pixel_to_MUX_wr),
		.data19_in(PE6_Pixel_to_MUX_wr),
		.data20_in(PE7_Pixel_to_MUX_wr),
		.data21_in(PE8_Pixel_to_MUX_wr),
		.data22_in(PE9_Pixel_to_MUX_wr),
		.data23_in(PE10_Pixel_to_MUX_wr),
		.data24_in(PE11_Pixel_to_MUX_wr),
		.data25_in(PE12_Pixel_to_MUX_wr),
		.data26_in(PE13_Pixel_to_MUX_wr),
		.data27_in(PE14_Pixel_to_MUX_wr),
		.data28_in(PE15_Pixel_to_MUX_wr),
		.data29_in(PE16_Pixel_to_MUX_wr),
		.data30_in(PE17_Pixel_to_MUX_wr),
		.data31_in(PE18_Pixel_to_MUX_wr),
		.data32_in(PE19_Pixel_to_MUX_wr),
		.data33_in(PE20_Pixel_to_MUX_wr),
		.data34_in(PE21_Pixel_to_MUX_wr),
		.data35_in(PE22_Pixel_to_MUX_wr),
		.data36_in(PE23_Pixel_to_MUX_wr),
		.data37_in(PE24_Pixel_to_MUX_wr),
		.data38_in(PE25_Pixel_to_MUX_wr),
		.data39_in(PE26_Pixel_to_MUX_wr),
		.sel_in(MUX_Selection_in),
		.mux_40_1_out(Shared_PE27_Pixel_0_out_wr)
	);

	MUX_40_1 PE28_Pixel_0(
		.data0_in(PE28_Pixel_to_MUX_wr),
		.data1_in(PE29_Pixel_to_MUX_wr),
		.data2_in(PE30_Pixel_to_MUX_wr),
		.data3_in(PE31_Pixel_to_MUX_wr),
		.data4_in(PE32_Pixel_to_MUX_wr),
		.data5_in(PE33_Pixel_to_MUX_wr),
		.data6_in(PE34_Pixel_to_MUX_wr),
		.data7_in(PE35_Pixel_to_MUX_wr),
		.data8_in(PE36_Pixel_to_MUX_wr),
		.data9_in(PE37_Pixel_to_MUX_wr),
		.data10_in(PE38_Pixel_to_MUX_wr),
		.data11_in(PE39_Pixel_to_MUX_wr),
		.data12_in(PE0_Pixel_to_MUX_wr),
		.data13_in(PE1_Pixel_to_MUX_wr),
		.data14_in(PE2_Pixel_to_MUX_wr),
		.data15_in(PE3_Pixel_to_MUX_wr),
		.data16_in(PE4_Pixel_to_MUX_wr),
		.data17_in(PE5_Pixel_to_MUX_wr),
		.data18_in(PE6_Pixel_to_MUX_wr),
		.data19_in(PE7_Pixel_to_MUX_wr),
		.data20_in(PE8_Pixel_to_MUX_wr),
		.data21_in(PE9_Pixel_to_MUX_wr),
		.data22_in(PE10_Pixel_to_MUX_wr),
		.data23_in(PE11_Pixel_to_MUX_wr),
		.data24_in(PE12_Pixel_to_MUX_wr),
		.data25_in(PE13_Pixel_to_MUX_wr),
		.data26_in(PE14_Pixel_to_MUX_wr),
		.data27_in(PE15_Pixel_to_MUX_wr),
		.data28_in(PE16_Pixel_to_MUX_wr),
		.data29_in(PE17_Pixel_to_MUX_wr),
		.data30_in(PE18_Pixel_to_MUX_wr),
		.data31_in(PE19_Pixel_to_MUX_wr),
		.data32_in(PE20_Pixel_to_MUX_wr),
		.data33_in(PE21_Pixel_to_MUX_wr),
		.data34_in(PE22_Pixel_to_MUX_wr),
		.data35_in(PE23_Pixel_to_MUX_wr),
		.data36_in(PE24_Pixel_to_MUX_wr),
		.data37_in(PE25_Pixel_to_MUX_wr),
		.data38_in(PE26_Pixel_to_MUX_wr),
		.data39_in(PE27_Pixel_to_MUX_wr),
		.sel_in(MUX_Selection_in),
		.mux_40_1_out(Shared_PE28_Pixel_0_out_wr)
	);

	MUX_40_1 PE29_Pixel_0(
		.data0_in(PE29_Pixel_to_MUX_wr),
		.data1_in(PE30_Pixel_to_MUX_wr),
		.data2_in(PE31_Pixel_to_MUX_wr),
		.data3_in(PE32_Pixel_to_MUX_wr),
		.data4_in(PE33_Pixel_to_MUX_wr),
		.data5_in(PE34_Pixel_to_MUX_wr),
		.data6_in(PE35_Pixel_to_MUX_wr),
		.data7_in(PE36_Pixel_to_MUX_wr),
		.data8_in(PE37_Pixel_to_MUX_wr),
		.data9_in(PE38_Pixel_to_MUX_wr),
		.data10_in(PE39_Pixel_to_MUX_wr),
		.data11_in(PE0_Pixel_to_MUX_wr),
		.data12_in(PE1_Pixel_to_MUX_wr),
		.data13_in(PE2_Pixel_to_MUX_wr),
		.data14_in(PE3_Pixel_to_MUX_wr),
		.data15_in(PE4_Pixel_to_MUX_wr),
		.data16_in(PE5_Pixel_to_MUX_wr),
		.data17_in(PE6_Pixel_to_MUX_wr),
		.data18_in(PE7_Pixel_to_MUX_wr),
		.data19_in(PE8_Pixel_to_MUX_wr),
		.data20_in(PE9_Pixel_to_MUX_wr),
		.data21_in(PE10_Pixel_to_MUX_wr),
		.data22_in(PE11_Pixel_to_MUX_wr),
		.data23_in(PE12_Pixel_to_MUX_wr),
		.data24_in(PE13_Pixel_to_MUX_wr),
		.data25_in(PE14_Pixel_to_MUX_wr),
		.data26_in(PE15_Pixel_to_MUX_wr),
		.data27_in(PE16_Pixel_to_MUX_wr),
		.data28_in(PE17_Pixel_to_MUX_wr),
		.data29_in(PE18_Pixel_to_MUX_wr),
		.data30_in(PE19_Pixel_to_MUX_wr),
		.data31_in(PE20_Pixel_to_MUX_wr),
		.data32_in(PE21_Pixel_to_MUX_wr),
		.data33_in(PE22_Pixel_to_MUX_wr),
		.data34_in(PE23_Pixel_to_MUX_wr),
		.data35_in(PE24_Pixel_to_MUX_wr),
		.data36_in(PE25_Pixel_to_MUX_wr),
		.data37_in(PE26_Pixel_to_MUX_wr),
		.data38_in(PE27_Pixel_to_MUX_wr),
		.data39_in(PE28_Pixel_to_MUX_wr),
		.sel_in(MUX_Selection_in),
		.mux_40_1_out(Shared_PE29_Pixel_0_out_wr)
	);

	MUX_40_1 PE30_Pixel_0(
		.data0_in(PE30_Pixel_to_MUX_wr),
		.data1_in(PE31_Pixel_to_MUX_wr),
		.data2_in(PE32_Pixel_to_MUX_wr),
		.data3_in(PE33_Pixel_to_MUX_wr),
		.data4_in(PE34_Pixel_to_MUX_wr),
		.data5_in(PE35_Pixel_to_MUX_wr),
		.data6_in(PE36_Pixel_to_MUX_wr),
		.data7_in(PE37_Pixel_to_MUX_wr),
		.data8_in(PE38_Pixel_to_MUX_wr),
		.data9_in(PE39_Pixel_to_MUX_wr),
		.data10_in(PE0_Pixel_to_MUX_wr),
		.data11_in(PE1_Pixel_to_MUX_wr),
		.data12_in(PE2_Pixel_to_MUX_wr),
		.data13_in(PE3_Pixel_to_MUX_wr),
		.data14_in(PE4_Pixel_to_MUX_wr),
		.data15_in(PE5_Pixel_to_MUX_wr),
		.data16_in(PE6_Pixel_to_MUX_wr),
		.data17_in(PE7_Pixel_to_MUX_wr),
		.data18_in(PE8_Pixel_to_MUX_wr),
		.data19_in(PE9_Pixel_to_MUX_wr),
		.data20_in(PE10_Pixel_to_MUX_wr),
		.data21_in(PE11_Pixel_to_MUX_wr),
		.data22_in(PE12_Pixel_to_MUX_wr),
		.data23_in(PE13_Pixel_to_MUX_wr),
		.data24_in(PE14_Pixel_to_MUX_wr),
		.data25_in(PE15_Pixel_to_MUX_wr),
		.data26_in(PE16_Pixel_to_MUX_wr),
		.data27_in(PE17_Pixel_to_MUX_wr),
		.data28_in(PE18_Pixel_to_MUX_wr),
		.data29_in(PE19_Pixel_to_MUX_wr),
		.data30_in(PE20_Pixel_to_MUX_wr),
		.data31_in(PE21_Pixel_to_MUX_wr),
		.data32_in(PE22_Pixel_to_MUX_wr),
		.data33_in(PE23_Pixel_to_MUX_wr),
		.data34_in(PE24_Pixel_to_MUX_wr),
		.data35_in(PE25_Pixel_to_MUX_wr),
		.data36_in(PE26_Pixel_to_MUX_wr),
		.data37_in(PE27_Pixel_to_MUX_wr),
		.data38_in(PE28_Pixel_to_MUX_wr),
		.data39_in(PE29_Pixel_to_MUX_wr),
		.sel_in(MUX_Selection_in),
		.mux_40_1_out(Shared_PE30_Pixel_0_out_wr)
	);

	MUX_40_1 PE31_Pixel_0(
		.data0_in(PE31_Pixel_to_MUX_wr),
		.data1_in(PE32_Pixel_to_MUX_wr),
		.data2_in(PE33_Pixel_to_MUX_wr),
		.data3_in(PE34_Pixel_to_MUX_wr),
		.data4_in(PE35_Pixel_to_MUX_wr),
		.data5_in(PE36_Pixel_to_MUX_wr),
		.data6_in(PE37_Pixel_to_MUX_wr),
		.data7_in(PE38_Pixel_to_MUX_wr),
		.data8_in(PE39_Pixel_to_MUX_wr),
		.data9_in(PE0_Pixel_to_MUX_wr),
		.data10_in(PE1_Pixel_to_MUX_wr),
		.data11_in(PE2_Pixel_to_MUX_wr),
		.data12_in(PE3_Pixel_to_MUX_wr),
		.data13_in(PE4_Pixel_to_MUX_wr),
		.data14_in(PE5_Pixel_to_MUX_wr),
		.data15_in(PE6_Pixel_to_MUX_wr),
		.data16_in(PE7_Pixel_to_MUX_wr),
		.data17_in(PE8_Pixel_to_MUX_wr),
		.data18_in(PE9_Pixel_to_MUX_wr),
		.data19_in(PE10_Pixel_to_MUX_wr),
		.data20_in(PE11_Pixel_to_MUX_wr),
		.data21_in(PE12_Pixel_to_MUX_wr),
		.data22_in(PE13_Pixel_to_MUX_wr),
		.data23_in(PE14_Pixel_to_MUX_wr),
		.data24_in(PE15_Pixel_to_MUX_wr),
		.data25_in(PE16_Pixel_to_MUX_wr),
		.data26_in(PE17_Pixel_to_MUX_wr),
		.data27_in(PE18_Pixel_to_MUX_wr),
		.data28_in(PE19_Pixel_to_MUX_wr),
		.data29_in(PE20_Pixel_to_MUX_wr),
		.data30_in(PE21_Pixel_to_MUX_wr),
		.data31_in(PE22_Pixel_to_MUX_wr),
		.data32_in(PE23_Pixel_to_MUX_wr),
		.data33_in(PE24_Pixel_to_MUX_wr),
		.data34_in(PE25_Pixel_to_MUX_wr),
		.data35_in(PE26_Pixel_to_MUX_wr),
		.data36_in(PE27_Pixel_to_MUX_wr),
		.data37_in(PE28_Pixel_to_MUX_wr),
		.data38_in(PE29_Pixel_to_MUX_wr),
		.data39_in(PE30_Pixel_to_MUX_wr),
		.sel_in(MUX_Selection_in),
		.mux_40_1_out(Shared_PE31_Pixel_0_out_wr)
	);

	MUX_40_1 PE32_Pixel_0(
		.data0_in(PE32_Pixel_to_MUX_wr),
		.data1_in(PE33_Pixel_to_MUX_wr),
		.data2_in(PE34_Pixel_to_MUX_wr),
		.data3_in(PE35_Pixel_to_MUX_wr),
		.data4_in(PE36_Pixel_to_MUX_wr),
		.data5_in(PE37_Pixel_to_MUX_wr),
		.data6_in(PE38_Pixel_to_MUX_wr),
		.data7_in(PE39_Pixel_to_MUX_wr),
		.data8_in(PE0_Pixel_to_MUX_wr),
		.data9_in(PE1_Pixel_to_MUX_wr),
		.data10_in(PE2_Pixel_to_MUX_wr),
		.data11_in(PE3_Pixel_to_MUX_wr),
		.data12_in(PE4_Pixel_to_MUX_wr),
		.data13_in(PE5_Pixel_to_MUX_wr),
		.data14_in(PE6_Pixel_to_MUX_wr),
		.data15_in(PE7_Pixel_to_MUX_wr),
		.data16_in(PE8_Pixel_to_MUX_wr),
		.data17_in(PE9_Pixel_to_MUX_wr),
		.data18_in(PE10_Pixel_to_MUX_wr),
		.data19_in(PE11_Pixel_to_MUX_wr),
		.data20_in(PE12_Pixel_to_MUX_wr),
		.data21_in(PE13_Pixel_to_MUX_wr),
		.data22_in(PE14_Pixel_to_MUX_wr),
		.data23_in(PE15_Pixel_to_MUX_wr),
		.data24_in(PE16_Pixel_to_MUX_wr),
		.data25_in(PE17_Pixel_to_MUX_wr),
		.data26_in(PE18_Pixel_to_MUX_wr),
		.data27_in(PE19_Pixel_to_MUX_wr),
		.data28_in(PE20_Pixel_to_MUX_wr),
		.data29_in(PE21_Pixel_to_MUX_wr),
		.data30_in(PE22_Pixel_to_MUX_wr),
		.data31_in(PE23_Pixel_to_MUX_wr),
		.data32_in(PE24_Pixel_to_MUX_wr),
		.data33_in(PE25_Pixel_to_MUX_wr),
		.data34_in(PE26_Pixel_to_MUX_wr),
		.data35_in(PE27_Pixel_to_MUX_wr),
		.data36_in(PE28_Pixel_to_MUX_wr),
		.data37_in(PE29_Pixel_to_MUX_wr),
		.data38_in(PE30_Pixel_to_MUX_wr),
		.data39_in(PE31_Pixel_to_MUX_wr),
		.sel_in(MUX_Selection_in),
		.mux_40_1_out(Shared_PE32_Pixel_0_out_wr)
	);

	MUX_40_1 PE33_Pixel_0(
		.data0_in(PE33_Pixel_to_MUX_wr),
		.data1_in(PE34_Pixel_to_MUX_wr),
		.data2_in(PE35_Pixel_to_MUX_wr),
		.data3_in(PE36_Pixel_to_MUX_wr),
		.data4_in(PE37_Pixel_to_MUX_wr),
		.data5_in(PE38_Pixel_to_MUX_wr),
		.data6_in(PE39_Pixel_to_MUX_wr),
		.data7_in(PE0_Pixel_to_MUX_wr),
		.data8_in(PE1_Pixel_to_MUX_wr),
		.data9_in(PE2_Pixel_to_MUX_wr),
		.data10_in(PE3_Pixel_to_MUX_wr),
		.data11_in(PE4_Pixel_to_MUX_wr),
		.data12_in(PE5_Pixel_to_MUX_wr),
		.data13_in(PE6_Pixel_to_MUX_wr),
		.data14_in(PE7_Pixel_to_MUX_wr),
		.data15_in(PE8_Pixel_to_MUX_wr),
		.data16_in(PE9_Pixel_to_MUX_wr),
		.data17_in(PE10_Pixel_to_MUX_wr),
		.data18_in(PE11_Pixel_to_MUX_wr),
		.data19_in(PE12_Pixel_to_MUX_wr),
		.data20_in(PE13_Pixel_to_MUX_wr),
		.data21_in(PE14_Pixel_to_MUX_wr),
		.data22_in(PE15_Pixel_to_MUX_wr),
		.data23_in(PE16_Pixel_to_MUX_wr),
		.data24_in(PE17_Pixel_to_MUX_wr),
		.data25_in(PE18_Pixel_to_MUX_wr),
		.data26_in(PE19_Pixel_to_MUX_wr),
		.data27_in(PE20_Pixel_to_MUX_wr),
		.data28_in(PE21_Pixel_to_MUX_wr),
		.data29_in(PE22_Pixel_to_MUX_wr),
		.data30_in(PE23_Pixel_to_MUX_wr),
		.data31_in(PE24_Pixel_to_MUX_wr),
		.data32_in(PE25_Pixel_to_MUX_wr),
		.data33_in(PE26_Pixel_to_MUX_wr),
		.data34_in(PE27_Pixel_to_MUX_wr),
		.data35_in(PE28_Pixel_to_MUX_wr),
		.data36_in(PE29_Pixel_to_MUX_wr),
		.data37_in(PE30_Pixel_to_MUX_wr),
		.data38_in(PE31_Pixel_to_MUX_wr),
		.data39_in(PE32_Pixel_to_MUX_wr),
		.sel_in(MUX_Selection_in),
		.mux_40_1_out(Shared_PE33_Pixel_0_out_wr)
	);

	MUX_40_1 PE34_Pixel_0(
		.data0_in(PE34_Pixel_to_MUX_wr),
		.data1_in(PE35_Pixel_to_MUX_wr),
		.data2_in(PE36_Pixel_to_MUX_wr),
		.data3_in(PE37_Pixel_to_MUX_wr),
		.data4_in(PE38_Pixel_to_MUX_wr),
		.data5_in(PE39_Pixel_to_MUX_wr),
		.data6_in(PE0_Pixel_to_MUX_wr),
		.data7_in(PE1_Pixel_to_MUX_wr),
		.data8_in(PE2_Pixel_to_MUX_wr),
		.data9_in(PE3_Pixel_to_MUX_wr),
		.data10_in(PE4_Pixel_to_MUX_wr),
		.data11_in(PE5_Pixel_to_MUX_wr),
		.data12_in(PE6_Pixel_to_MUX_wr),
		.data13_in(PE7_Pixel_to_MUX_wr),
		.data14_in(PE8_Pixel_to_MUX_wr),
		.data15_in(PE9_Pixel_to_MUX_wr),
		.data16_in(PE10_Pixel_to_MUX_wr),
		.data17_in(PE11_Pixel_to_MUX_wr),
		.data18_in(PE12_Pixel_to_MUX_wr),
		.data19_in(PE13_Pixel_to_MUX_wr),
		.data20_in(PE14_Pixel_to_MUX_wr),
		.data21_in(PE15_Pixel_to_MUX_wr),
		.data22_in(PE16_Pixel_to_MUX_wr),
		.data23_in(PE17_Pixel_to_MUX_wr),
		.data24_in(PE18_Pixel_to_MUX_wr),
		.data25_in(PE19_Pixel_to_MUX_wr),
		.data26_in(PE20_Pixel_to_MUX_wr),
		.data27_in(PE21_Pixel_to_MUX_wr),
		.data28_in(PE22_Pixel_to_MUX_wr),
		.data29_in(PE23_Pixel_to_MUX_wr),
		.data30_in(PE24_Pixel_to_MUX_wr),
		.data31_in(PE25_Pixel_to_MUX_wr),
		.data32_in(PE26_Pixel_to_MUX_wr),
		.data33_in(PE27_Pixel_to_MUX_wr),
		.data34_in(PE28_Pixel_to_MUX_wr),
		.data35_in(PE29_Pixel_to_MUX_wr),
		.data36_in(PE30_Pixel_to_MUX_wr),
		.data37_in(PE31_Pixel_to_MUX_wr),
		.data38_in(PE32_Pixel_to_MUX_wr),
		.data39_in(PE33_Pixel_to_MUX_wr),
		.sel_in(MUX_Selection_in),
		.mux_40_1_out(Shared_PE34_Pixel_0_out_wr)
	);

	MUX_40_1 PE35_Pixel_0(
		.data0_in(PE35_Pixel_to_MUX_wr),
		.data1_in(PE36_Pixel_to_MUX_wr),
		.data2_in(PE37_Pixel_to_MUX_wr),
		.data3_in(PE38_Pixel_to_MUX_wr),
		.data4_in(PE39_Pixel_to_MUX_wr),
		.data5_in(PE0_Pixel_to_MUX_wr),
		.data6_in(PE1_Pixel_to_MUX_wr),
		.data7_in(PE2_Pixel_to_MUX_wr),
		.data8_in(PE3_Pixel_to_MUX_wr),
		.data9_in(PE4_Pixel_to_MUX_wr),
		.data10_in(PE5_Pixel_to_MUX_wr),
		.data11_in(PE6_Pixel_to_MUX_wr),
		.data12_in(PE7_Pixel_to_MUX_wr),
		.data13_in(PE8_Pixel_to_MUX_wr),
		.data14_in(PE9_Pixel_to_MUX_wr),
		.data15_in(PE10_Pixel_to_MUX_wr),
		.data16_in(PE11_Pixel_to_MUX_wr),
		.data17_in(PE12_Pixel_to_MUX_wr),
		.data18_in(PE13_Pixel_to_MUX_wr),
		.data19_in(PE14_Pixel_to_MUX_wr),
		.data20_in(PE15_Pixel_to_MUX_wr),
		.data21_in(PE16_Pixel_to_MUX_wr),
		.data22_in(PE17_Pixel_to_MUX_wr),
		.data23_in(PE18_Pixel_to_MUX_wr),
		.data24_in(PE19_Pixel_to_MUX_wr),
		.data25_in(PE20_Pixel_to_MUX_wr),
		.data26_in(PE21_Pixel_to_MUX_wr),
		.data27_in(PE22_Pixel_to_MUX_wr),
		.data28_in(PE23_Pixel_to_MUX_wr),
		.data29_in(PE24_Pixel_to_MUX_wr),
		.data30_in(PE25_Pixel_to_MUX_wr),
		.data31_in(PE26_Pixel_to_MUX_wr),
		.data32_in(PE27_Pixel_to_MUX_wr),
		.data33_in(PE28_Pixel_to_MUX_wr),
		.data34_in(PE29_Pixel_to_MUX_wr),
		.data35_in(PE30_Pixel_to_MUX_wr),
		.data36_in(PE31_Pixel_to_MUX_wr),
		.data37_in(PE32_Pixel_to_MUX_wr),
		.data38_in(PE33_Pixel_to_MUX_wr),
		.data39_in(PE34_Pixel_to_MUX_wr),
		.sel_in(MUX_Selection_in),
		.mux_40_1_out(Shared_PE35_Pixel_0_out_wr)
	);

	MUX_40_1 PE36_Pixel_0(
		.data0_in(PE36_Pixel_to_MUX_wr),
		.data1_in(PE37_Pixel_to_MUX_wr),
		.data2_in(PE38_Pixel_to_MUX_wr),
		.data3_in(PE39_Pixel_to_MUX_wr),
		.data4_in(PE0_Pixel_to_MUX_wr),
		.data5_in(PE1_Pixel_to_MUX_wr),
		.data6_in(PE2_Pixel_to_MUX_wr),
		.data7_in(PE3_Pixel_to_MUX_wr),
		.data8_in(PE4_Pixel_to_MUX_wr),
		.data9_in(PE5_Pixel_to_MUX_wr),
		.data10_in(PE6_Pixel_to_MUX_wr),
		.data11_in(PE7_Pixel_to_MUX_wr),
		.data12_in(PE8_Pixel_to_MUX_wr),
		.data13_in(PE9_Pixel_to_MUX_wr),
		.data14_in(PE10_Pixel_to_MUX_wr),
		.data15_in(PE11_Pixel_to_MUX_wr),
		.data16_in(PE12_Pixel_to_MUX_wr),
		.data17_in(PE13_Pixel_to_MUX_wr),
		.data18_in(PE14_Pixel_to_MUX_wr),
		.data19_in(PE15_Pixel_to_MUX_wr),
		.data20_in(PE16_Pixel_to_MUX_wr),
		.data21_in(PE17_Pixel_to_MUX_wr),
		.data22_in(PE18_Pixel_to_MUX_wr),
		.data23_in(PE19_Pixel_to_MUX_wr),
		.data24_in(PE20_Pixel_to_MUX_wr),
		.data25_in(PE21_Pixel_to_MUX_wr),
		.data26_in(PE22_Pixel_to_MUX_wr),
		.data27_in(PE23_Pixel_to_MUX_wr),
		.data28_in(PE24_Pixel_to_MUX_wr),
		.data29_in(PE25_Pixel_to_MUX_wr),
		.data30_in(PE26_Pixel_to_MUX_wr),
		.data31_in(PE27_Pixel_to_MUX_wr),
		.data32_in(PE28_Pixel_to_MUX_wr),
		.data33_in(PE29_Pixel_to_MUX_wr),
		.data34_in(PE30_Pixel_to_MUX_wr),
		.data35_in(PE31_Pixel_to_MUX_wr),
		.data36_in(PE32_Pixel_to_MUX_wr),
		.data37_in(PE33_Pixel_to_MUX_wr),
		.data38_in(PE34_Pixel_to_MUX_wr),
		.data39_in(PE35_Pixel_to_MUX_wr),
		.sel_in(MUX_Selection_in),
		.mux_40_1_out(Shared_PE36_Pixel_0_out_wr)
	);

	MUX_40_1 PE37_Pixel_0(
		.data0_in(PE37_Pixel_to_MUX_wr),
		.data1_in(PE38_Pixel_to_MUX_wr),
		.data2_in(PE39_Pixel_to_MUX_wr),
		.data3_in(PE0_Pixel_to_MUX_wr),
		.data4_in(PE1_Pixel_to_MUX_wr),
		.data5_in(PE2_Pixel_to_MUX_wr),
		.data6_in(PE3_Pixel_to_MUX_wr),
		.data7_in(PE4_Pixel_to_MUX_wr),
		.data8_in(PE5_Pixel_to_MUX_wr),
		.data9_in(PE6_Pixel_to_MUX_wr),
		.data10_in(PE7_Pixel_to_MUX_wr),
		.data11_in(PE8_Pixel_to_MUX_wr),
		.data12_in(PE9_Pixel_to_MUX_wr),
		.data13_in(PE10_Pixel_to_MUX_wr),
		.data14_in(PE11_Pixel_to_MUX_wr),
		.data15_in(PE12_Pixel_to_MUX_wr),
		.data16_in(PE13_Pixel_to_MUX_wr),
		.data17_in(PE14_Pixel_to_MUX_wr),
		.data18_in(PE15_Pixel_to_MUX_wr),
		.data19_in(PE16_Pixel_to_MUX_wr),
		.data20_in(PE17_Pixel_to_MUX_wr),
		.data21_in(PE18_Pixel_to_MUX_wr),
		.data22_in(PE19_Pixel_to_MUX_wr),
		.data23_in(PE20_Pixel_to_MUX_wr),
		.data24_in(PE21_Pixel_to_MUX_wr),
		.data25_in(PE22_Pixel_to_MUX_wr),
		.data26_in(PE23_Pixel_to_MUX_wr),
		.data27_in(PE24_Pixel_to_MUX_wr),
		.data28_in(PE25_Pixel_to_MUX_wr),
		.data29_in(PE26_Pixel_to_MUX_wr),
		.data30_in(PE27_Pixel_to_MUX_wr),
		.data31_in(PE28_Pixel_to_MUX_wr),
		.data32_in(PE29_Pixel_to_MUX_wr),
		.data33_in(PE30_Pixel_to_MUX_wr),
		.data34_in(PE31_Pixel_to_MUX_wr),
		.data35_in(PE32_Pixel_to_MUX_wr),
		.data36_in(PE33_Pixel_to_MUX_wr),
		.data37_in(PE34_Pixel_to_MUX_wr),
		.data38_in(PE35_Pixel_to_MUX_wr),
		.data39_in(PE36_Pixel_to_MUX_wr),
		.sel_in(MUX_Selection_in),
		.mux_40_1_out(Shared_PE37_Pixel_0_out_wr)
	);

	MUX_40_1 PE38_Pixel_0(
		.data0_in(PE38_Pixel_to_MUX_wr),
		.data1_in(PE39_Pixel_to_MUX_wr),
		.data2_in(PE0_Pixel_to_MUX_wr),
		.data3_in(PE1_Pixel_to_MUX_wr),
		.data4_in(PE2_Pixel_to_MUX_wr),
		.data5_in(PE3_Pixel_to_MUX_wr),
		.data6_in(PE4_Pixel_to_MUX_wr),
		.data7_in(PE5_Pixel_to_MUX_wr),
		.data8_in(PE6_Pixel_to_MUX_wr),
		.data9_in(PE7_Pixel_to_MUX_wr),
		.data10_in(PE8_Pixel_to_MUX_wr),
		.data11_in(PE9_Pixel_to_MUX_wr),
		.data12_in(PE10_Pixel_to_MUX_wr),
		.data13_in(PE11_Pixel_to_MUX_wr),
		.data14_in(PE12_Pixel_to_MUX_wr),
		.data15_in(PE13_Pixel_to_MUX_wr),
		.data16_in(PE14_Pixel_to_MUX_wr),
		.data17_in(PE15_Pixel_to_MUX_wr),
		.data18_in(PE16_Pixel_to_MUX_wr),
		.data19_in(PE17_Pixel_to_MUX_wr),
		.data20_in(PE18_Pixel_to_MUX_wr),
		.data21_in(PE19_Pixel_to_MUX_wr),
		.data22_in(PE20_Pixel_to_MUX_wr),
		.data23_in(PE21_Pixel_to_MUX_wr),
		.data24_in(PE22_Pixel_to_MUX_wr),
		.data25_in(PE23_Pixel_to_MUX_wr),
		.data26_in(PE24_Pixel_to_MUX_wr),
		.data27_in(PE25_Pixel_to_MUX_wr),
		.data28_in(PE26_Pixel_to_MUX_wr),
		.data29_in(PE27_Pixel_to_MUX_wr),
		.data30_in(PE28_Pixel_to_MUX_wr),
		.data31_in(PE29_Pixel_to_MUX_wr),
		.data32_in(PE30_Pixel_to_MUX_wr),
		.data33_in(PE31_Pixel_to_MUX_wr),
		.data34_in(PE32_Pixel_to_MUX_wr),
		.data35_in(PE33_Pixel_to_MUX_wr),
		.data36_in(PE34_Pixel_to_MUX_wr),
		.data37_in(PE35_Pixel_to_MUX_wr),
		.data38_in(PE36_Pixel_to_MUX_wr),
		.data39_in(PE37_Pixel_to_MUX_wr),
		.sel_in(MUX_Selection_in),
		.mux_40_1_out(Shared_PE38_Pixel_0_out_wr)
	);

	MUX_40_1 PE39_Pixel_0(
		.data0_in(PE39_Pixel_to_MUX_wr),
		.data1_in(PE0_Pixel_to_MUX_wr),
		.data2_in(PE1_Pixel_to_MUX_wr),
		.data3_in(PE2_Pixel_to_MUX_wr),
		.data4_in(PE3_Pixel_to_MUX_wr),
		.data5_in(PE4_Pixel_to_MUX_wr),
		.data6_in(PE5_Pixel_to_MUX_wr),
		.data7_in(PE6_Pixel_to_MUX_wr),
		.data8_in(PE7_Pixel_to_MUX_wr),
		.data9_in(PE8_Pixel_to_MUX_wr),
		.data10_in(PE9_Pixel_to_MUX_wr),
		.data11_in(PE10_Pixel_to_MUX_wr),
		.data12_in(PE11_Pixel_to_MUX_wr),
		.data13_in(PE12_Pixel_to_MUX_wr),
		.data14_in(PE13_Pixel_to_MUX_wr),
		.data15_in(PE14_Pixel_to_MUX_wr),
		.data16_in(PE15_Pixel_to_MUX_wr),
		.data17_in(PE16_Pixel_to_MUX_wr),
		.data18_in(PE17_Pixel_to_MUX_wr),
		.data19_in(PE18_Pixel_to_MUX_wr),
		.data20_in(PE19_Pixel_to_MUX_wr),
		.data21_in(PE20_Pixel_to_MUX_wr),
		.data22_in(PE21_Pixel_to_MUX_wr),
		.data23_in(PE22_Pixel_to_MUX_wr),
		.data24_in(PE23_Pixel_to_MUX_wr),
		.data25_in(PE24_Pixel_to_MUX_wr),
		.data26_in(PE25_Pixel_to_MUX_wr),
		.data27_in(PE26_Pixel_to_MUX_wr),
		.data28_in(PE27_Pixel_to_MUX_wr),
		.data29_in(PE28_Pixel_to_MUX_wr),
		.data30_in(PE29_Pixel_to_MUX_wr),
		.data31_in(PE30_Pixel_to_MUX_wr),
		.data32_in(PE31_Pixel_to_MUX_wr),
		.data33_in(PE32_Pixel_to_MUX_wr),
		.data34_in(PE33_Pixel_to_MUX_wr),
		.data35_in(PE34_Pixel_to_MUX_wr),
		.data36_in(PE35_Pixel_to_MUX_wr),
		.data37_in(PE36_Pixel_to_MUX_wr),
		.data38_in(PE37_Pixel_to_MUX_wr),
		.data39_in(PE38_Pixel_to_MUX_wr),
		.sel_in(MUX_Selection_in),
		.mux_40_1_out(Shared_PE39_Pixel_0_out_wr)
	);

	assign Shared_PE0_Pixel_1_out_wr = (MP_Padding_in) ? PEA0_PE0_Pixel_0_in : PEA0_PE1_Pixel_0_in;
	assign Shared_PE0_Pixel_2_out_wr = (MP_Padding_in) ? PEA0_PE1_Pixel_0_in : PEA0_PE2_Pixel_0_in;
	assign Shared_PE1_Pixel_1_out_wr = (MP_Padding_in) ? PEA0_PE1_Pixel_0_in : PEA0_PE2_Pixel_0_in;
	assign Shared_PE1_Pixel_2_out_wr = (MP_Padding_in) ? PEA0_PE2_Pixel_0_in : PEA0_PE3_Pixel_0_in;
	assign Shared_PE2_Pixel_1_out_wr = (MP_Padding_in) ? PEA0_PE2_Pixel_0_in : PEA0_PE3_Pixel_0_in;
	assign Shared_PE2_Pixel_2_out_wr = (MP_Padding_in) ? PEA0_PE3_Pixel_0_in : PEA0_PE4_Pixel_0_in;
	assign Shared_PE3_Pixel_1_out_wr = (MP_Padding_in) ? PEA0_PE3_Pixel_0_in : PEA0_PE4_Pixel_0_in;
	assign Shared_PE3_Pixel_2_out_wr = (MP_Padding_in) ? PEA0_PE4_Pixel_0_in : PEA0_PE5_Pixel_0_in;
	assign Shared_PE4_Pixel_1_out_wr = (MP_Padding_in) ? PEA0_PE4_Pixel_0_in : PEA0_PE5_Pixel_0_in;
	assign Shared_PE4_Pixel_2_out_wr = (MP_Padding_in) ? PEA0_PE5_Pixel_0_in : PEA0_PE6_Pixel_0_in;
	assign Shared_PE5_Pixel_1_out_wr = (MP_Padding_in) ? PEA0_PE5_Pixel_0_in : PEA0_PE6_Pixel_0_in;
	assign Shared_PE5_Pixel_2_out_wr = (MP_Padding_in) ? PEA0_PE6_Pixel_0_in : PEA0_PE7_Pixel_0_in;
	assign Shared_PE6_Pixel_1_out_wr = (MP_Padding_in) ? PEA0_PE6_Pixel_0_in : PEA0_PE7_Pixel_0_in;
	assign Shared_PE6_Pixel_2_out_wr = (MP_Padding_in) ? PEA0_PE7_Pixel_0_in : PEA0_PE8_Pixel_0_in;
	assign Shared_PE7_Pixel_1_out_wr = (MP_Padding_in) ? PEA0_PE7_Pixel_0_in : PEA0_PE8_Pixel_0_in;
	assign Shared_PE7_Pixel_2_out_wr = (MP_Padding_in) ? PEA0_PE8_Pixel_0_in : PEA0_PE9_Pixel_0_in;
	assign Shared_PE8_Pixel_1_out_wr = (MP_Padding_in) ? PEA0_PE8_Pixel_0_in : PEA0_PE9_Pixel_0_in;
	assign Shared_PE8_Pixel_2_out_wr = (MP_Padding_in) ? PEA0_PE9_Pixel_0_in : PEA0_PE10_Pixel_0_in;
	assign Shared_PE9_Pixel_1_out_wr = (MP_Padding_in) ? PEA0_PE9_Pixel_0_in : PEA0_PE10_Pixel_0_in;
	assign Shared_PE9_Pixel_2_out_wr = (MP_Padding_in) ? PEA0_PE10_Pixel_0_in : PEA0_PE11_Pixel_0_in;
	assign Shared_PE10_Pixel_1_out_wr = (MP_Padding_in) ? PEA0_PE10_Pixel_0_in : PEA0_PE11_Pixel_0_in;
	assign Shared_PE10_Pixel_2_out_wr = (MP_Padding_in) ? PEA0_PE11_Pixel_0_in : PEA0_PE12_Pixel_0_in;
	assign Shared_PE11_Pixel_1_out_wr = (MP_Padding_in) ? PEA0_PE11_Pixel_0_in : PEA0_PE12_Pixel_0_in;
	assign Shared_PE11_Pixel_2_out_wr = (MP_Padding_in) ? PEA0_PE12_Pixel_0_in : PEA0_PE13_Pixel_0_in;
	assign Shared_PE12_Pixel_1_out_wr = (MP_Padding_in) ? PEA0_PE12_Pixel_0_in : PEA0_PE13_Pixel_0_in;
	assign Shared_PE12_Pixel_2_out_wr = (MP_Padding_in) ? PEA0_PE13_Pixel_0_in : PEA0_PE14_Pixel_0_in;
	assign Shared_PE13_Pixel_1_out_wr = (MP_Padding_in) ? PEA0_PE13_Pixel_0_in : PEA0_PE14_Pixel_0_in;
	assign Shared_PE13_Pixel_2_out_wr = (MP_Padding_in) ? PEA0_PE14_Pixel_0_in : PEA0_PE15_Pixel_0_in;
	assign Shared_PE14_Pixel_1_out_wr = (MP_Padding_in) ? PEA0_PE14_Pixel_0_in : PEA0_PE15_Pixel_0_in;
	assign Shared_PE14_Pixel_2_out_wr = (MP_Padding_in) ? PEA0_PE15_Pixel_0_in : PEA0_PE16_Pixel_0_in;
	assign Shared_PE15_Pixel_1_out_wr = (MP_Padding_in) ? PEA0_PE15_Pixel_0_in : PEA0_PE16_Pixel_0_in;
	assign Shared_PE15_Pixel_2_out_wr = (MP_Padding_in) ? PEA0_PE16_Pixel_0_in : PEA0_PE17_Pixel_0_in;
	assign Shared_PE16_Pixel_1_out_wr = (MP_Padding_in) ? PEA0_PE16_Pixel_0_in : PEA0_PE17_Pixel_0_in;
	assign Shared_PE16_Pixel_2_out_wr = (MP_Padding_in) ? PEA0_PE17_Pixel_0_in : PEA0_PE18_Pixel_0_in;
	assign Shared_PE17_Pixel_1_out_wr = (MP_Padding_in) ? PEA0_PE17_Pixel_0_in : PEA0_PE18_Pixel_0_in;
	assign Shared_PE17_Pixel_2_out_wr = (MP_Padding_in) ? PEA0_PE18_Pixel_0_in : PEA0_PE19_Pixel_0_in;
	assign Shared_PE18_Pixel_1_out_wr = (MP_Padding_in) ? PEA0_PE18_Pixel_0_in : PEA0_PE19_Pixel_0_in;
	assign Shared_PE18_Pixel_2_out_wr = (MP_Padding_in) ? PEA0_PE19_Pixel_0_in : PEA0_PE20_Pixel_0_in;
	assign Shared_PE19_Pixel_1_out_wr = (MP_Padding_in) ? PEA0_PE19_Pixel_0_in : PEA0_PE20_Pixel_0_in;
	assign Shared_PE19_Pixel_2_out_wr = (MP_Padding_in) ? PEA0_PE20_Pixel_0_in : PEA0_PE21_Pixel_0_in;
	assign Shared_PE20_Pixel_1_out_wr = (MP_Padding_in) ? PEA0_PE20_Pixel_0_in : PEA0_PE21_Pixel_0_in;
	assign Shared_PE20_Pixel_2_out_wr = (MP_Padding_in) ? PEA0_PE21_Pixel_0_in : PEA0_PE22_Pixel_0_in;
	assign Shared_PE21_Pixel_1_out_wr = (MP_Padding_in) ? PEA0_PE21_Pixel_0_in : PEA0_PE22_Pixel_0_in;
	assign Shared_PE21_Pixel_2_out_wr = (MP_Padding_in) ? PEA0_PE22_Pixel_0_in : PEA0_PE23_Pixel_0_in;
	assign Shared_PE22_Pixel_1_out_wr = (MP_Padding_in) ? PEA0_PE22_Pixel_0_in : PEA0_PE23_Pixel_0_in;
	assign Shared_PE22_Pixel_2_out_wr = (MP_Padding_in) ? PEA0_PE23_Pixel_0_in : PEA0_PE24_Pixel_0_in;
	assign Shared_PE23_Pixel_1_out_wr = (MP_Padding_in) ? PEA0_PE23_Pixel_0_in : PEA0_PE24_Pixel_0_in;
	assign Shared_PE23_Pixel_2_out_wr = (MP_Padding_in) ? PEA0_PE24_Pixel_0_in : PEA0_PE25_Pixel_0_in;
	assign Shared_PE24_Pixel_1_out_wr = (MP_Padding_in) ? PEA0_PE24_Pixel_0_in : PEA0_PE25_Pixel_0_in;
	assign Shared_PE24_Pixel_2_out_wr = (MP_Padding_in) ? PEA0_PE25_Pixel_0_in : PEA0_PE26_Pixel_0_in;
	assign Shared_PE25_Pixel_1_out_wr = (MP_Padding_in) ? PEA0_PE25_Pixel_0_in : PEA0_PE26_Pixel_0_in;
	assign Shared_PE25_Pixel_2_out_wr = (MP_Padding_in) ? PEA0_PE26_Pixel_0_in : PEA0_PE27_Pixel_0_in;
	assign Shared_PE26_Pixel_1_out_wr = (MP_Padding_in) ? PEA0_PE26_Pixel_0_in : PEA0_PE27_Pixel_0_in;
	assign Shared_PE26_Pixel_2_out_wr = (MP_Padding_in) ? PEA0_PE27_Pixel_0_in : PEA0_PE28_Pixel_0_in;
	assign Shared_PE27_Pixel_1_out_wr = (MP_Padding_in) ? PEA0_PE27_Pixel_0_in : PEA0_PE28_Pixel_0_in;
	assign Shared_PE27_Pixel_2_out_wr = (MP_Padding_in) ? PEA0_PE28_Pixel_0_in : PEA0_PE29_Pixel_0_in;
	assign Shared_PE28_Pixel_1_out_wr = (MP_Padding_in) ? PEA0_PE28_Pixel_0_in : PEA0_PE29_Pixel_0_in;
	assign Shared_PE28_Pixel_2_out_wr = (MP_Padding_in) ? PEA0_PE29_Pixel_0_in : PEA0_PE30_Pixel_0_in;
	assign Shared_PE29_Pixel_1_out_wr = (MP_Padding_in) ? PEA0_PE29_Pixel_0_in : PEA0_PE30_Pixel_0_in;
	assign Shared_PE29_Pixel_2_out_wr = (MP_Padding_in) ? PEA0_PE30_Pixel_0_in : PEA0_PE31_Pixel_0_in;
	assign Shared_PE30_Pixel_1_out_wr = (MP_Padding_in) ? PEA0_PE30_Pixel_0_in : PEA0_PE31_Pixel_0_in;
	assign Shared_PE30_Pixel_2_out_wr = (MP_Padding_in) ? PEA0_PE31_Pixel_0_in : PEA0_PE32_Pixel_0_in;
	assign Shared_PE31_Pixel_1_out_wr = (MP_Padding_in) ? PEA0_PE31_Pixel_0_in : PEA0_PE32_Pixel_0_in;
	assign Shared_PE31_Pixel_2_out_wr = (MP_Padding_in) ? PEA0_PE32_Pixel_0_in : PEA0_PE33_Pixel_0_in;
	assign Shared_PE32_Pixel_1_out_wr = (MP_Padding_in) ? PEA0_PE32_Pixel_0_in : PEA0_PE33_Pixel_0_in;
	assign Shared_PE32_Pixel_2_out_wr = (MP_Padding_in) ? PEA0_PE33_Pixel_0_in : PEA0_PE34_Pixel_0_in;
	assign Shared_PE33_Pixel_1_out_wr = (MP_Padding_in) ? PEA0_PE33_Pixel_0_in : PEA0_PE34_Pixel_0_in;
	assign Shared_PE33_Pixel_2_out_wr = (MP_Padding_in) ? PEA0_PE34_Pixel_0_in : PEA0_PE35_Pixel_0_in;
	assign Shared_PE34_Pixel_1_out_wr = (MP_Padding_in) ? PEA0_PE34_Pixel_0_in : PEA0_PE35_Pixel_0_in;
	assign Shared_PE34_Pixel_2_out_wr = (MP_Padding_in) ? PEA0_PE35_Pixel_0_in : PEA0_PE36_Pixel_0_in;
	assign Shared_PE35_Pixel_1_out_wr = (MP_Padding_in) ? PEA0_PE35_Pixel_0_in : PEA0_PE36_Pixel_0_in;
	assign Shared_PE35_Pixel_2_out_wr = (MP_Padding_in) ? PEA0_PE36_Pixel_0_in : PEA0_PE37_Pixel_0_in;
	assign Shared_PE36_Pixel_1_out_wr = (MP_Padding_in) ? PEA0_PE36_Pixel_0_in : PEA0_PE37_Pixel_0_in;
	assign Shared_PE36_Pixel_2_out_wr = (MP_Padding_in) ? PEA0_PE37_Pixel_0_in : PEA0_PE38_Pixel_0_in;
	assign Shared_PE37_Pixel_1_out_wr = (MP_Padding_in) ? PEA0_PE37_Pixel_0_in : PEA0_PE38_Pixel_0_in;
	assign Shared_PE37_Pixel_2_out_wr = (MP_Padding_in) ? PEA0_PE38_Pixel_0_in : PEA0_PE39_Pixel_0_in;
	assign Shared_PE38_Pixel_1_out_wr = (MP_Padding_in) ? PEA0_PE38_Pixel_0_in : PEA0_PE39_Pixel_0_in;
	assign Shared_PE38_Pixel_2_out_wr = (MP_Padding_3_in) ? 0 : (MP_Padding_in) ? PEA0_PE39_Pixel_1_in : PEA0_PE0_Pixel_1_in;
	assign Shared_PE39_Pixel_1_out_wr = (MP_Padding_3_in) ? 0 : (MP_Padding_in) ? PEA0_PE39_Pixel_1_in : PEA0_PE0_Pixel_1_in;
	assign Shared_PE39_Pixel_2_out_wr = (MP_Padding_3_in) ? 0 : (MP_Padding_2_in) ? 0 : (MP_Padding_in) ? PEA0_PE0_Pixel_1_in : PEA0_PE1_Pixel_1_in;

	assign Shared_PE0_Pixel_0_valid_out_wr = PEA0_PE0_Pixel_0_valid_in | PEA0_PE1_Pixel_0_valid_in;
	assign Shared_PE0_Pixel_1_valid_out_wr = PEA0_PE0_Pixel_0_valid_in | PEA0_PE1_Pixel_0_valid_in;
	assign Shared_PE0_Pixel_2_valid_out_wr = PEA0_PE0_Pixel_0_valid_in | PEA0_PE1_Pixel_0_valid_in;

	assign Shared_PE1_Pixel_0_valid_out_wr = PEA0_PE1_Pixel_0_valid_in | PEA0_PE0_Pixel_0_valid_in;
	assign Shared_PE1_Pixel_1_valid_out_wr = PEA0_PE1_Pixel_0_valid_in | PEA0_PE0_Pixel_0_valid_in;
	assign Shared_PE1_Pixel_2_valid_out_wr = PEA0_PE1_Pixel_0_valid_in | PEA0_PE0_Pixel_0_valid_in;

	assign Shared_PE2_Pixel_0_valid_out_wr = PEA0_PE2_Pixel_0_valid_in | PEA0_PE3_Pixel_0_valid_in;
	assign Shared_PE2_Pixel_1_valid_out_wr = PEA0_PE2_Pixel_0_valid_in | PEA0_PE3_Pixel_0_valid_in;
	assign Shared_PE2_Pixel_2_valid_out_wr = PEA0_PE2_Pixel_0_valid_in | PEA0_PE3_Pixel_0_valid_in;

	assign Shared_PE3_Pixel_0_valid_out_wr = PEA0_PE3_Pixel_0_valid_in | PEA0_PE2_Pixel_0_valid_in;
	assign Shared_PE3_Pixel_1_valid_out_wr = PEA0_PE3_Pixel_0_valid_in | PEA0_PE2_Pixel_0_valid_in;
	assign Shared_PE3_Pixel_2_valid_out_wr = PEA0_PE3_Pixel_0_valid_in | PEA0_PE2_Pixel_0_valid_in;

	assign Shared_PE4_Pixel_0_valid_out_wr = PEA0_PE4_Pixel_0_valid_in | PEA0_PE5_Pixel_0_valid_in;
	assign Shared_PE4_Pixel_1_valid_out_wr = PEA0_PE4_Pixel_0_valid_in | PEA0_PE5_Pixel_0_valid_in;
	assign Shared_PE4_Pixel_2_valid_out_wr = PEA0_PE4_Pixel_0_valid_in | PEA0_PE5_Pixel_0_valid_in;

	assign Shared_PE5_Pixel_0_valid_out_wr = PEA0_PE5_Pixel_0_valid_in | PEA0_PE4_Pixel_0_valid_in;
	assign Shared_PE5_Pixel_1_valid_out_wr = PEA0_PE5_Pixel_0_valid_in | PEA0_PE4_Pixel_0_valid_in;
	assign Shared_PE5_Pixel_2_valid_out_wr = PEA0_PE5_Pixel_0_valid_in | PEA0_PE4_Pixel_0_valid_in;

	assign Shared_PE6_Pixel_0_valid_out_wr = PEA0_PE6_Pixel_0_valid_in | PEA0_PE7_Pixel_0_valid_in;
	assign Shared_PE6_Pixel_1_valid_out_wr = PEA0_PE6_Pixel_0_valid_in | PEA0_PE7_Pixel_0_valid_in;
	assign Shared_PE6_Pixel_2_valid_out_wr = PEA0_PE6_Pixel_0_valid_in | PEA0_PE7_Pixel_0_valid_in;

	assign Shared_PE7_Pixel_0_valid_out_wr = PEA0_PE7_Pixel_0_valid_in | PEA0_PE6_Pixel_0_valid_in;
	assign Shared_PE7_Pixel_1_valid_out_wr = PEA0_PE7_Pixel_0_valid_in | PEA0_PE6_Pixel_0_valid_in;
	assign Shared_PE7_Pixel_2_valid_out_wr = PEA0_PE7_Pixel_0_valid_in | PEA0_PE6_Pixel_0_valid_in;

	assign Shared_PE8_Pixel_0_valid_out_wr = PEA0_PE8_Pixel_0_valid_in | PEA0_PE9_Pixel_0_valid_in;
	assign Shared_PE8_Pixel_1_valid_out_wr = PEA0_PE8_Pixel_0_valid_in | PEA0_PE9_Pixel_0_valid_in;
	assign Shared_PE8_Pixel_2_valid_out_wr = PEA0_PE8_Pixel_0_valid_in | PEA0_PE9_Pixel_0_valid_in;

	assign Shared_PE9_Pixel_0_valid_out_wr = PEA0_PE9_Pixel_0_valid_in | PEA0_PE8_Pixel_0_valid_in;
	assign Shared_PE9_Pixel_1_valid_out_wr = PEA0_PE9_Pixel_0_valid_in | PEA0_PE8_Pixel_0_valid_in;
	assign Shared_PE9_Pixel_2_valid_out_wr = PEA0_PE9_Pixel_0_valid_in | PEA0_PE8_Pixel_0_valid_in;

	assign Shared_PE10_Pixel_0_valid_out_wr = PEA0_PE10_Pixel_0_valid_in | PEA0_PE11_Pixel_0_valid_in;
	assign Shared_PE10_Pixel_1_valid_out_wr = PEA0_PE10_Pixel_0_valid_in | PEA0_PE11_Pixel_0_valid_in;
	assign Shared_PE10_Pixel_2_valid_out_wr = PEA0_PE10_Pixel_0_valid_in | PEA0_PE11_Pixel_0_valid_in;

	assign Shared_PE11_Pixel_0_valid_out_wr = PEA0_PE11_Pixel_0_valid_in | PEA0_PE10_Pixel_0_valid_in;
	assign Shared_PE11_Pixel_1_valid_out_wr = PEA0_PE11_Pixel_0_valid_in | PEA0_PE10_Pixel_0_valid_in;
	assign Shared_PE11_Pixel_2_valid_out_wr = PEA0_PE11_Pixel_0_valid_in | PEA0_PE10_Pixel_0_valid_in;

	assign Shared_PE12_Pixel_0_valid_out_wr = PEA0_PE12_Pixel_0_valid_in | PEA0_PE13_Pixel_0_valid_in;
	assign Shared_PE12_Pixel_1_valid_out_wr = PEA0_PE12_Pixel_0_valid_in | PEA0_PE13_Pixel_0_valid_in;
	assign Shared_PE12_Pixel_2_valid_out_wr = PEA0_PE12_Pixel_0_valid_in | PEA0_PE13_Pixel_0_valid_in;

	assign Shared_PE13_Pixel_0_valid_out_wr = PEA0_PE13_Pixel_0_valid_in | PEA0_PE12_Pixel_0_valid_in;
	assign Shared_PE13_Pixel_1_valid_out_wr = PEA0_PE13_Pixel_0_valid_in | PEA0_PE12_Pixel_0_valid_in;
	assign Shared_PE13_Pixel_2_valid_out_wr = PEA0_PE13_Pixel_0_valid_in | PEA0_PE12_Pixel_0_valid_in;

	assign Shared_PE14_Pixel_0_valid_out_wr = PEA0_PE14_Pixel_0_valid_in | PEA0_PE15_Pixel_0_valid_in;
	assign Shared_PE14_Pixel_1_valid_out_wr = PEA0_PE14_Pixel_0_valid_in | PEA0_PE15_Pixel_0_valid_in;
	assign Shared_PE14_Pixel_2_valid_out_wr = PEA0_PE14_Pixel_0_valid_in | PEA0_PE15_Pixel_0_valid_in;

	assign Shared_PE15_Pixel_0_valid_out_wr = PEA0_PE15_Pixel_0_valid_in | PEA0_PE14_Pixel_0_valid_in;
	assign Shared_PE15_Pixel_1_valid_out_wr = PEA0_PE15_Pixel_0_valid_in | PEA0_PE14_Pixel_0_valid_in;
	assign Shared_PE15_Pixel_2_valid_out_wr = PEA0_PE15_Pixel_0_valid_in | PEA0_PE14_Pixel_0_valid_in;

	assign Shared_PE16_Pixel_0_valid_out_wr = PEA0_PE16_Pixel_0_valid_in | PEA0_PE17_Pixel_0_valid_in;
	assign Shared_PE16_Pixel_1_valid_out_wr = PEA0_PE16_Pixel_0_valid_in | PEA0_PE17_Pixel_0_valid_in;
	assign Shared_PE16_Pixel_2_valid_out_wr = PEA0_PE16_Pixel_0_valid_in | PEA0_PE17_Pixel_0_valid_in;

	assign Shared_PE17_Pixel_0_valid_out_wr = PEA0_PE17_Pixel_0_valid_in | PEA0_PE16_Pixel_0_valid_in;
	assign Shared_PE17_Pixel_1_valid_out_wr = PEA0_PE17_Pixel_0_valid_in | PEA0_PE16_Pixel_0_valid_in;
	assign Shared_PE17_Pixel_2_valid_out_wr = PEA0_PE17_Pixel_0_valid_in | PEA0_PE16_Pixel_0_valid_in;

	assign Shared_PE18_Pixel_0_valid_out_wr = PEA0_PE18_Pixel_0_valid_in | PEA0_PE19_Pixel_0_valid_in;
	assign Shared_PE18_Pixel_1_valid_out_wr = PEA0_PE18_Pixel_0_valid_in | PEA0_PE19_Pixel_0_valid_in;
	assign Shared_PE18_Pixel_2_valid_out_wr = PEA0_PE18_Pixel_0_valid_in | PEA0_PE19_Pixel_0_valid_in;

	assign Shared_PE19_Pixel_0_valid_out_wr = PEA0_PE19_Pixel_0_valid_in | PEA0_PE18_Pixel_0_valid_in;
	assign Shared_PE19_Pixel_1_valid_out_wr = PEA0_PE19_Pixel_0_valid_in | PEA0_PE18_Pixel_0_valid_in;
	assign Shared_PE19_Pixel_2_valid_out_wr = PEA0_PE19_Pixel_0_valid_in | PEA0_PE18_Pixel_0_valid_in;

	assign Shared_PE20_Pixel_0_valid_out_wr = PEA0_PE20_Pixel_0_valid_in | PEA0_PE21_Pixel_0_valid_in;
	assign Shared_PE20_Pixel_1_valid_out_wr = PEA0_PE20_Pixel_0_valid_in | PEA0_PE21_Pixel_0_valid_in;
	assign Shared_PE20_Pixel_2_valid_out_wr = PEA0_PE20_Pixel_0_valid_in | PEA0_PE21_Pixel_0_valid_in;

	assign Shared_PE21_Pixel_0_valid_out_wr = PEA0_PE21_Pixel_0_valid_in | PEA0_PE20_Pixel_0_valid_in;
	assign Shared_PE21_Pixel_1_valid_out_wr = PEA0_PE21_Pixel_0_valid_in | PEA0_PE20_Pixel_0_valid_in;
	assign Shared_PE21_Pixel_2_valid_out_wr = PEA0_PE21_Pixel_0_valid_in | PEA0_PE20_Pixel_0_valid_in;

	assign Shared_PE22_Pixel_0_valid_out_wr = PEA0_PE22_Pixel_0_valid_in | PEA0_PE23_Pixel_0_valid_in;
	assign Shared_PE22_Pixel_1_valid_out_wr = PEA0_PE22_Pixel_0_valid_in | PEA0_PE23_Pixel_0_valid_in;
	assign Shared_PE22_Pixel_2_valid_out_wr = PEA0_PE22_Pixel_0_valid_in | PEA0_PE23_Pixel_0_valid_in;

	assign Shared_PE23_Pixel_0_valid_out_wr = PEA0_PE23_Pixel_0_valid_in | PEA0_PE22_Pixel_0_valid_in;
	assign Shared_PE23_Pixel_1_valid_out_wr = PEA0_PE23_Pixel_0_valid_in | PEA0_PE22_Pixel_0_valid_in;
	assign Shared_PE23_Pixel_2_valid_out_wr = PEA0_PE23_Pixel_0_valid_in | PEA0_PE22_Pixel_0_valid_in;

	assign Shared_PE24_Pixel_0_valid_out_wr = PEA0_PE24_Pixel_0_valid_in | PEA0_PE25_Pixel_0_valid_in;
	assign Shared_PE24_Pixel_1_valid_out_wr = PEA0_PE24_Pixel_0_valid_in | PEA0_PE25_Pixel_0_valid_in;
	assign Shared_PE24_Pixel_2_valid_out_wr = PEA0_PE24_Pixel_0_valid_in | PEA0_PE25_Pixel_0_valid_in;

	assign Shared_PE25_Pixel_0_valid_out_wr = PEA0_PE25_Pixel_0_valid_in | PEA0_PE24_Pixel_0_valid_in;
	assign Shared_PE25_Pixel_1_valid_out_wr = PEA0_PE25_Pixel_0_valid_in | PEA0_PE24_Pixel_0_valid_in;
	assign Shared_PE25_Pixel_2_valid_out_wr = PEA0_PE25_Pixel_0_valid_in | PEA0_PE24_Pixel_0_valid_in;

	assign Shared_PE26_Pixel_0_valid_out_wr = PEA0_PE26_Pixel_0_valid_in | PEA0_PE27_Pixel_0_valid_in;
	assign Shared_PE26_Pixel_1_valid_out_wr = PEA0_PE26_Pixel_0_valid_in | PEA0_PE27_Pixel_0_valid_in;
	assign Shared_PE26_Pixel_2_valid_out_wr = PEA0_PE26_Pixel_0_valid_in | PEA0_PE27_Pixel_0_valid_in;

	assign Shared_PE27_Pixel_0_valid_out_wr = PEA0_PE27_Pixel_0_valid_in | PEA0_PE26_Pixel_0_valid_in;
	assign Shared_PE27_Pixel_1_valid_out_wr = PEA0_PE27_Pixel_0_valid_in | PEA0_PE26_Pixel_0_valid_in;
	assign Shared_PE27_Pixel_2_valid_out_wr = PEA0_PE27_Pixel_0_valid_in | PEA0_PE26_Pixel_0_valid_in;

	assign Shared_PE28_Pixel_0_valid_out_wr = PEA0_PE28_Pixel_0_valid_in | PEA0_PE29_Pixel_0_valid_in;
	assign Shared_PE28_Pixel_1_valid_out_wr = PEA0_PE28_Pixel_0_valid_in | PEA0_PE29_Pixel_0_valid_in;
	assign Shared_PE28_Pixel_2_valid_out_wr = PEA0_PE28_Pixel_0_valid_in | PEA0_PE29_Pixel_0_valid_in;

	assign Shared_PE29_Pixel_0_valid_out_wr = PEA0_PE29_Pixel_0_valid_in | PEA0_PE28_Pixel_0_valid_in;
	assign Shared_PE29_Pixel_1_valid_out_wr = PEA0_PE29_Pixel_0_valid_in | PEA0_PE28_Pixel_0_valid_in;
	assign Shared_PE29_Pixel_2_valid_out_wr = PEA0_PE29_Pixel_0_valid_in | PEA0_PE28_Pixel_0_valid_in;

	assign Shared_PE30_Pixel_0_valid_out_wr = PEA0_PE30_Pixel_0_valid_in | PEA0_PE31_Pixel_0_valid_in;
	assign Shared_PE30_Pixel_1_valid_out_wr = PEA0_PE30_Pixel_0_valid_in | PEA0_PE31_Pixel_0_valid_in;
	assign Shared_PE30_Pixel_2_valid_out_wr = PEA0_PE30_Pixel_0_valid_in | PEA0_PE31_Pixel_0_valid_in;

	assign Shared_PE31_Pixel_0_valid_out_wr = PEA0_PE31_Pixel_0_valid_in | PEA0_PE30_Pixel_0_valid_in;
	assign Shared_PE31_Pixel_1_valid_out_wr = PEA0_PE31_Pixel_0_valid_in | PEA0_PE30_Pixel_0_valid_in;
	assign Shared_PE31_Pixel_2_valid_out_wr = PEA0_PE31_Pixel_0_valid_in | PEA0_PE30_Pixel_0_valid_in;

	assign Shared_PE32_Pixel_0_valid_out_wr = PEA0_PE32_Pixel_0_valid_in | PEA0_PE33_Pixel_0_valid_in;
	assign Shared_PE32_Pixel_1_valid_out_wr = PEA0_PE32_Pixel_0_valid_in | PEA0_PE33_Pixel_0_valid_in;
	assign Shared_PE32_Pixel_2_valid_out_wr = PEA0_PE32_Pixel_0_valid_in | PEA0_PE33_Pixel_0_valid_in;

	assign Shared_PE33_Pixel_0_valid_out_wr = PEA0_PE33_Pixel_0_valid_in | PEA0_PE32_Pixel_0_valid_in;
	assign Shared_PE33_Pixel_1_valid_out_wr = PEA0_PE33_Pixel_0_valid_in | PEA0_PE32_Pixel_0_valid_in;
	assign Shared_PE33_Pixel_2_valid_out_wr = PEA0_PE33_Pixel_0_valid_in | PEA0_PE32_Pixel_0_valid_in;

	assign Shared_PE34_Pixel_0_valid_out_wr = PEA0_PE34_Pixel_0_valid_in | PEA0_PE35_Pixel_0_valid_in;
	assign Shared_PE34_Pixel_1_valid_out_wr = PEA0_PE34_Pixel_0_valid_in | PEA0_PE35_Pixel_0_valid_in;
	assign Shared_PE34_Pixel_2_valid_out_wr = PEA0_PE34_Pixel_0_valid_in | PEA0_PE35_Pixel_0_valid_in;

	assign Shared_PE35_Pixel_0_valid_out_wr = PEA0_PE35_Pixel_0_valid_in | PEA0_PE34_Pixel_0_valid_in;
	assign Shared_PE35_Pixel_1_valid_out_wr = PEA0_PE35_Pixel_0_valid_in | PEA0_PE34_Pixel_0_valid_in;
	assign Shared_PE35_Pixel_2_valid_out_wr = PEA0_PE35_Pixel_0_valid_in | PEA0_PE34_Pixel_0_valid_in;

	assign Shared_PE36_Pixel_0_valid_out_wr = PEA0_PE36_Pixel_0_valid_in | PEA0_PE37_Pixel_0_valid_in;
	assign Shared_PE36_Pixel_1_valid_out_wr = PEA0_PE36_Pixel_0_valid_in | PEA0_PE37_Pixel_0_valid_in;
	assign Shared_PE36_Pixel_2_valid_out_wr = PEA0_PE36_Pixel_0_valid_in | PEA0_PE37_Pixel_0_valid_in;

	assign Shared_PE37_Pixel_0_valid_out_wr = PEA0_PE37_Pixel_0_valid_in | PEA0_PE36_Pixel_0_valid_in;
	assign Shared_PE37_Pixel_1_valid_out_wr = PEA0_PE37_Pixel_0_valid_in | PEA0_PE36_Pixel_0_valid_in;
	assign Shared_PE37_Pixel_2_valid_out_wr = PEA0_PE37_Pixel_0_valid_in | PEA0_PE36_Pixel_0_valid_in;

	assign Shared_PE38_Pixel_0_valid_out_wr = PEA0_PE38_Pixel_0_valid_in | PEA0_PE39_Pixel_0_valid_in;
	assign Shared_PE38_Pixel_1_valid_out_wr = PEA0_PE38_Pixel_0_valid_in | PEA0_PE39_Pixel_0_valid_in;
	assign Shared_PE38_Pixel_2_valid_out_wr = PEA0_PE38_Pixel_0_valid_in | PEA0_PE39_Pixel_0_valid_in;

	assign Shared_PE39_Pixel_0_valid_out_wr = PEA0_PE39_Pixel_0_valid_in | PEA0_PE38_Pixel_0_valid_in;
	assign Shared_PE39_Pixel_1_valid_out_wr = PEA0_PE39_Pixel_0_valid_in | PEA0_PE38_Pixel_0_valid_in;
	assign Shared_PE39_Pixel_2_valid_out_wr = PEA0_PE39_Pixel_0_valid_in | PEA0_PE38_Pixel_0_valid_in;

	always @(posedge CLK or negedge RST) begin
		if (~RST) begin
			Shared_PE0_Pixel_0_out <= 0;
			Shared_PE0_Pixel_0_valid_out <= 0;
			Shared_PE0_Pixel_1_out <= 0;
			Shared_PE0_Pixel_1_valid_out <= 0;
			Shared_PE0_Pixel_2_out <= 0;
			Shared_PE0_Pixel_2_valid_out <= 0;
			Shared_PE1_Pixel_0_out <= 0;
			Shared_PE1_Pixel_0_valid_out <= 0;
			Shared_PE1_Pixel_1_out <= 0;
			Shared_PE1_Pixel_1_valid_out <= 0;
			Shared_PE1_Pixel_2_out <= 0;
			Shared_PE1_Pixel_2_valid_out <= 0;
			Shared_PE2_Pixel_0_out <= 0;
			Shared_PE2_Pixel_0_valid_out <= 0;
			Shared_PE2_Pixel_1_out <= 0;
			Shared_PE2_Pixel_1_valid_out <= 0;
			Shared_PE2_Pixel_2_out <= 0;
			Shared_PE2_Pixel_2_valid_out <= 0;
			Shared_PE3_Pixel_0_out <= 0;
			Shared_PE3_Pixel_0_valid_out <= 0;
			Shared_PE3_Pixel_1_out <= 0;
			Shared_PE3_Pixel_1_valid_out <= 0;
			Shared_PE3_Pixel_2_out <= 0;
			Shared_PE3_Pixel_2_valid_out <= 0;
			Shared_PE4_Pixel_0_out <= 0;
			Shared_PE4_Pixel_0_valid_out <= 0;
			Shared_PE4_Pixel_1_out <= 0;
			Shared_PE4_Pixel_1_valid_out <= 0;
			Shared_PE4_Pixel_2_out <= 0;
			Shared_PE4_Pixel_2_valid_out <= 0;
			Shared_PE5_Pixel_0_out <= 0;
			Shared_PE5_Pixel_0_valid_out <= 0;
			Shared_PE5_Pixel_1_out <= 0;
			Shared_PE5_Pixel_1_valid_out <= 0;
			Shared_PE5_Pixel_2_out <= 0;
			Shared_PE5_Pixel_2_valid_out <= 0;
			Shared_PE6_Pixel_0_out <= 0;
			Shared_PE6_Pixel_0_valid_out <= 0;
			Shared_PE6_Pixel_1_out <= 0;
			Shared_PE6_Pixel_1_valid_out <= 0;
			Shared_PE6_Pixel_2_out <= 0;
			Shared_PE6_Pixel_2_valid_out <= 0;
			Shared_PE7_Pixel_0_out <= 0;
			Shared_PE7_Pixel_0_valid_out <= 0;
			Shared_PE7_Pixel_1_out <= 0;
			Shared_PE7_Pixel_1_valid_out <= 0;
			Shared_PE7_Pixel_2_out <= 0;
			Shared_PE7_Pixel_2_valid_out <= 0;
			Shared_PE8_Pixel_0_out <= 0;
			Shared_PE8_Pixel_0_valid_out <= 0;
			Shared_PE8_Pixel_1_out <= 0;
			Shared_PE8_Pixel_1_valid_out <= 0;
			Shared_PE8_Pixel_2_out <= 0;
			Shared_PE8_Pixel_2_valid_out <= 0;
			Shared_PE9_Pixel_0_out <= 0;
			Shared_PE9_Pixel_0_valid_out <= 0;
			Shared_PE9_Pixel_1_out <= 0;
			Shared_PE9_Pixel_1_valid_out <= 0;
			Shared_PE9_Pixel_2_out <= 0;
			Shared_PE9_Pixel_2_valid_out <= 0;
			Shared_PE10_Pixel_0_out <= 0;
			Shared_PE10_Pixel_0_valid_out <= 0;
			Shared_PE10_Pixel_1_out <= 0;
			Shared_PE10_Pixel_1_valid_out <= 0;
			Shared_PE10_Pixel_2_out <= 0;
			Shared_PE10_Pixel_2_valid_out <= 0;
			Shared_PE11_Pixel_0_out <= 0;
			Shared_PE11_Pixel_0_valid_out <= 0;
			Shared_PE11_Pixel_1_out <= 0;
			Shared_PE11_Pixel_1_valid_out <= 0;
			Shared_PE11_Pixel_2_out <= 0;
			Shared_PE11_Pixel_2_valid_out <= 0;
			Shared_PE12_Pixel_0_out <= 0;
			Shared_PE12_Pixel_0_valid_out <= 0;
			Shared_PE12_Pixel_1_out <= 0;
			Shared_PE12_Pixel_1_valid_out <= 0;
			Shared_PE12_Pixel_2_out <= 0;
			Shared_PE12_Pixel_2_valid_out <= 0;
			Shared_PE13_Pixel_0_out <= 0;
			Shared_PE13_Pixel_0_valid_out <= 0;
			Shared_PE13_Pixel_1_out <= 0;
			Shared_PE13_Pixel_1_valid_out <= 0;
			Shared_PE13_Pixel_2_out <= 0;
			Shared_PE13_Pixel_2_valid_out <= 0;
			Shared_PE14_Pixel_0_out <= 0;
			Shared_PE14_Pixel_0_valid_out <= 0;
			Shared_PE14_Pixel_1_out <= 0;
			Shared_PE14_Pixel_1_valid_out <= 0;
			Shared_PE14_Pixel_2_out <= 0;
			Shared_PE14_Pixel_2_valid_out <= 0;
			Shared_PE15_Pixel_0_out <= 0;
			Shared_PE15_Pixel_0_valid_out <= 0;
			Shared_PE15_Pixel_1_out <= 0;
			Shared_PE15_Pixel_1_valid_out <= 0;
			Shared_PE15_Pixel_2_out <= 0;
			Shared_PE15_Pixel_2_valid_out <= 0;
			Shared_PE16_Pixel_0_out <= 0;
			Shared_PE16_Pixel_0_valid_out <= 0;
			Shared_PE16_Pixel_1_out <= 0;
			Shared_PE16_Pixel_1_valid_out <= 0;
			Shared_PE16_Pixel_2_out <= 0;
			Shared_PE16_Pixel_2_valid_out <= 0;
			Shared_PE17_Pixel_0_out <= 0;
			Shared_PE17_Pixel_0_valid_out <= 0;
			Shared_PE17_Pixel_1_out <= 0;
			Shared_PE17_Pixel_1_valid_out <= 0;
			Shared_PE17_Pixel_2_out <= 0;
			Shared_PE17_Pixel_2_valid_out <= 0;
			Shared_PE18_Pixel_0_out <= 0;
			Shared_PE18_Pixel_0_valid_out <= 0;
			Shared_PE18_Pixel_1_out <= 0;
			Shared_PE18_Pixel_1_valid_out <= 0;
			Shared_PE18_Pixel_2_out <= 0;
			Shared_PE18_Pixel_2_valid_out <= 0;
			Shared_PE19_Pixel_0_out <= 0;
			Shared_PE19_Pixel_0_valid_out <= 0;
			Shared_PE19_Pixel_1_out <= 0;
			Shared_PE19_Pixel_1_valid_out <= 0;
			Shared_PE19_Pixel_2_out <= 0;
			Shared_PE19_Pixel_2_valid_out <= 0;
			Shared_PE20_Pixel_0_out <= 0;
			Shared_PE20_Pixel_0_valid_out <= 0;
			Shared_PE20_Pixel_1_out <= 0;
			Shared_PE20_Pixel_1_valid_out <= 0;
			Shared_PE20_Pixel_2_out <= 0;
			Shared_PE20_Pixel_2_valid_out <= 0;
			Shared_PE21_Pixel_0_out <= 0;
			Shared_PE21_Pixel_0_valid_out <= 0;
			Shared_PE21_Pixel_1_out <= 0;
			Shared_PE21_Pixel_1_valid_out <= 0;
			Shared_PE21_Pixel_2_out <= 0;
			Shared_PE21_Pixel_2_valid_out <= 0;
			Shared_PE22_Pixel_0_out <= 0;
			Shared_PE22_Pixel_0_valid_out <= 0;
			Shared_PE22_Pixel_1_out <= 0;
			Shared_PE22_Pixel_1_valid_out <= 0;
			Shared_PE22_Pixel_2_out <= 0;
			Shared_PE22_Pixel_2_valid_out <= 0;
			Shared_PE23_Pixel_0_out <= 0;
			Shared_PE23_Pixel_0_valid_out <= 0;
			Shared_PE23_Pixel_1_out <= 0;
			Shared_PE23_Pixel_1_valid_out <= 0;
			Shared_PE23_Pixel_2_out <= 0;
			Shared_PE23_Pixel_2_valid_out <= 0;
			Shared_PE24_Pixel_0_out <= 0;
			Shared_PE24_Pixel_0_valid_out <= 0;
			Shared_PE24_Pixel_1_out <= 0;
			Shared_PE24_Pixel_1_valid_out <= 0;
			Shared_PE24_Pixel_2_out <= 0;
			Shared_PE24_Pixel_2_valid_out <= 0;
			Shared_PE25_Pixel_0_out <= 0;
			Shared_PE25_Pixel_0_valid_out <= 0;
			Shared_PE25_Pixel_1_out <= 0;
			Shared_PE25_Pixel_1_valid_out <= 0;
			Shared_PE25_Pixel_2_out <= 0;
			Shared_PE25_Pixel_2_valid_out <= 0;
			Shared_PE26_Pixel_0_out <= 0;
			Shared_PE26_Pixel_0_valid_out <= 0;
			Shared_PE26_Pixel_1_out <= 0;
			Shared_PE26_Pixel_1_valid_out <= 0;
			Shared_PE26_Pixel_2_out <= 0;
			Shared_PE26_Pixel_2_valid_out <= 0;
			Shared_PE27_Pixel_0_out <= 0;
			Shared_PE27_Pixel_0_valid_out <= 0;
			Shared_PE27_Pixel_1_out <= 0;
			Shared_PE27_Pixel_1_valid_out <= 0;
			Shared_PE27_Pixel_2_out <= 0;
			Shared_PE27_Pixel_2_valid_out <= 0;
			Shared_PE28_Pixel_0_out <= 0;
			Shared_PE28_Pixel_0_valid_out <= 0;
			Shared_PE28_Pixel_1_out <= 0;
			Shared_PE28_Pixel_1_valid_out <= 0;
			Shared_PE28_Pixel_2_out <= 0;
			Shared_PE28_Pixel_2_valid_out <= 0;
			Shared_PE29_Pixel_0_out <= 0;
			Shared_PE29_Pixel_0_valid_out <= 0;
			Shared_PE29_Pixel_1_out <= 0;
			Shared_PE29_Pixel_1_valid_out <= 0;
			Shared_PE29_Pixel_2_out <= 0;
			Shared_PE29_Pixel_2_valid_out <= 0;
			Shared_PE30_Pixel_0_out <= 0;
			Shared_PE30_Pixel_0_valid_out <= 0;
			Shared_PE30_Pixel_1_out <= 0;
			Shared_PE30_Pixel_1_valid_out <= 0;
			Shared_PE30_Pixel_2_out <= 0;
			Shared_PE30_Pixel_2_valid_out <= 0;
			Shared_PE31_Pixel_0_out <= 0;
			Shared_PE31_Pixel_0_valid_out <= 0;
			Shared_PE31_Pixel_1_out <= 0;
			Shared_PE31_Pixel_1_valid_out <= 0;
			Shared_PE31_Pixel_2_out <= 0;
			Shared_PE31_Pixel_2_valid_out <= 0;
			Shared_PE32_Pixel_0_out <= 0;
			Shared_PE32_Pixel_0_valid_out <= 0;
			Shared_PE32_Pixel_1_out <= 0;
			Shared_PE32_Pixel_1_valid_out <= 0;
			Shared_PE32_Pixel_2_out <= 0;
			Shared_PE32_Pixel_2_valid_out <= 0;
			Shared_PE33_Pixel_0_out <= 0;
			Shared_PE33_Pixel_0_valid_out <= 0;
			Shared_PE33_Pixel_1_out <= 0;
			Shared_PE33_Pixel_1_valid_out <= 0;
			Shared_PE33_Pixel_2_out <= 0;
			Shared_PE33_Pixel_2_valid_out <= 0;
			Shared_PE34_Pixel_0_out <= 0;
			Shared_PE34_Pixel_0_valid_out <= 0;
			Shared_PE34_Pixel_1_out <= 0;
			Shared_PE34_Pixel_1_valid_out <= 0;
			Shared_PE34_Pixel_2_out <= 0;
			Shared_PE34_Pixel_2_valid_out <= 0;
			Shared_PE35_Pixel_0_out <= 0;
			Shared_PE35_Pixel_0_valid_out <= 0;
			Shared_PE35_Pixel_1_out <= 0;
			Shared_PE35_Pixel_1_valid_out <= 0;
			Shared_PE35_Pixel_2_out <= 0;
			Shared_PE35_Pixel_2_valid_out <= 0;
			Shared_PE36_Pixel_0_out <= 0;
			Shared_PE36_Pixel_0_valid_out <= 0;
			Shared_PE36_Pixel_1_out <= 0;
			Shared_PE36_Pixel_1_valid_out <= 0;
			Shared_PE36_Pixel_2_out <= 0;
			Shared_PE36_Pixel_2_valid_out <= 0;
			Shared_PE37_Pixel_0_out <= 0;
			Shared_PE37_Pixel_0_valid_out <= 0;
			Shared_PE37_Pixel_1_out <= 0;
			Shared_PE37_Pixel_1_valid_out <= 0;
			Shared_PE37_Pixel_2_out <= 0;
			Shared_PE37_Pixel_2_valid_out <= 0;
			Shared_PE38_Pixel_0_out <= 0;
			Shared_PE38_Pixel_0_valid_out <= 0;
			Shared_PE38_Pixel_1_out <= 0;
			Shared_PE38_Pixel_1_valid_out <= 0;
			Shared_PE38_Pixel_2_out <= 0;
			Shared_PE38_Pixel_2_valid_out <= 0;
			Shared_PE39_Pixel_0_out <= 0;
			Shared_PE39_Pixel_0_valid_out <= 0;
			Shared_PE39_Pixel_1_out <= 0;
			Shared_PE39_Pixel_1_valid_out <= 0;
			Shared_PE39_Pixel_2_out <= 0;
			Shared_PE39_Pixel_2_valid_out <= 0;
			Parity_PE_Selection_rg <= 0;
		end
		else begin
			if(En_in) begin
				Shared_PE0_Pixel_0_out <= Shared_PE0_Pixel_0_out_wr;
				Shared_PE0_Pixel_0_valid_out <= Shared_PE0_Pixel_0_valid_out_wr;
				Shared_PE0_Pixel_1_out <= Shared_PE0_Pixel_1_out_wr;
				Shared_PE0_Pixel_1_valid_out <= Shared_PE0_Pixel_1_valid_out_wr;
				Shared_PE0_Pixel_2_out <= Shared_PE0_Pixel_2_out_wr;
				Shared_PE0_Pixel_2_valid_out <= Shared_PE0_Pixel_2_valid_out_wr;
				Shared_PE1_Pixel_0_out <= Shared_PE1_Pixel_0_out_wr;
				Shared_PE1_Pixel_0_valid_out <= Shared_PE1_Pixel_0_valid_out_wr;
				Shared_PE1_Pixel_1_out <= Shared_PE1_Pixel_1_out_wr;
				Shared_PE1_Pixel_1_valid_out <= Shared_PE1_Pixel_1_valid_out_wr;
				Shared_PE1_Pixel_2_out <= Shared_PE1_Pixel_2_out_wr;
				Shared_PE1_Pixel_2_valid_out <= Shared_PE1_Pixel_2_valid_out_wr;
				Shared_PE2_Pixel_0_out <= Shared_PE2_Pixel_0_out_wr;
				Shared_PE2_Pixel_0_valid_out <= Shared_PE2_Pixel_0_valid_out_wr;
				Shared_PE2_Pixel_1_out <= Shared_PE2_Pixel_1_out_wr;
				Shared_PE2_Pixel_1_valid_out <= Shared_PE2_Pixel_1_valid_out_wr;
				Shared_PE2_Pixel_2_out <= Shared_PE2_Pixel_2_out_wr;
				Shared_PE2_Pixel_2_valid_out <= Shared_PE2_Pixel_2_valid_out_wr;
				Shared_PE3_Pixel_0_out <= Shared_PE3_Pixel_0_out_wr;
				Shared_PE3_Pixel_0_valid_out <= Shared_PE3_Pixel_0_valid_out_wr;
				Shared_PE3_Pixel_1_out <= Shared_PE3_Pixel_1_out_wr;
				Shared_PE3_Pixel_1_valid_out <= Shared_PE3_Pixel_1_valid_out_wr;
				Shared_PE3_Pixel_2_out <= Shared_PE3_Pixel_2_out_wr;
				Shared_PE3_Pixel_2_valid_out <= Shared_PE3_Pixel_2_valid_out_wr;
				Shared_PE4_Pixel_0_out <= Shared_PE4_Pixel_0_out_wr;
				Shared_PE4_Pixel_0_valid_out <= Shared_PE4_Pixel_0_valid_out_wr;
				Shared_PE4_Pixel_1_out <= Shared_PE4_Pixel_1_out_wr;
				Shared_PE4_Pixel_1_valid_out <= Shared_PE4_Pixel_1_valid_out_wr;
				Shared_PE4_Pixel_2_out <= Shared_PE4_Pixel_2_out_wr;
				Shared_PE4_Pixel_2_valid_out <= Shared_PE4_Pixel_2_valid_out_wr;
				Shared_PE5_Pixel_0_out <= Shared_PE5_Pixel_0_out_wr;
				Shared_PE5_Pixel_0_valid_out <= Shared_PE5_Pixel_0_valid_out_wr;
				Shared_PE5_Pixel_1_out <= Shared_PE5_Pixel_1_out_wr;
				Shared_PE5_Pixel_1_valid_out <= Shared_PE5_Pixel_1_valid_out_wr;
				Shared_PE5_Pixel_2_out <= Shared_PE5_Pixel_2_out_wr;
				Shared_PE5_Pixel_2_valid_out <= Shared_PE5_Pixel_2_valid_out_wr;
				Shared_PE6_Pixel_0_out <= Shared_PE6_Pixel_0_out_wr;
				Shared_PE6_Pixel_0_valid_out <= Shared_PE6_Pixel_0_valid_out_wr;
				Shared_PE6_Pixel_1_out <= Shared_PE6_Pixel_1_out_wr;
				Shared_PE6_Pixel_1_valid_out <= Shared_PE6_Pixel_1_valid_out_wr;
				Shared_PE6_Pixel_2_out <= Shared_PE6_Pixel_2_out_wr;
				Shared_PE6_Pixel_2_valid_out <= Shared_PE6_Pixel_2_valid_out_wr;
				Shared_PE7_Pixel_0_out <= Shared_PE7_Pixel_0_out_wr;
				Shared_PE7_Pixel_0_valid_out <= Shared_PE7_Pixel_0_valid_out_wr;
				Shared_PE7_Pixel_1_out <= Shared_PE7_Pixel_1_out_wr;
				Shared_PE7_Pixel_1_valid_out <= Shared_PE7_Pixel_1_valid_out_wr;
				Shared_PE7_Pixel_2_out <= Shared_PE7_Pixel_2_out_wr;
				Shared_PE7_Pixel_2_valid_out <= Shared_PE7_Pixel_2_valid_out_wr;
				Shared_PE8_Pixel_0_out <= Shared_PE8_Pixel_0_out_wr;
				Shared_PE8_Pixel_0_valid_out <= Shared_PE8_Pixel_0_valid_out_wr;
				Shared_PE8_Pixel_1_out <= Shared_PE8_Pixel_1_out_wr;
				Shared_PE8_Pixel_1_valid_out <= Shared_PE8_Pixel_1_valid_out_wr;
				Shared_PE8_Pixel_2_out <= Shared_PE8_Pixel_2_out_wr;
				Shared_PE8_Pixel_2_valid_out <= Shared_PE8_Pixel_2_valid_out_wr;
				Shared_PE9_Pixel_0_out <= Shared_PE9_Pixel_0_out_wr;
				Shared_PE9_Pixel_0_valid_out <= Shared_PE9_Pixel_0_valid_out_wr;
				Shared_PE9_Pixel_1_out <= Shared_PE9_Pixel_1_out_wr;
				Shared_PE9_Pixel_1_valid_out <= Shared_PE9_Pixel_1_valid_out_wr;
				Shared_PE9_Pixel_2_out <= Shared_PE9_Pixel_2_out_wr;
				Shared_PE9_Pixel_2_valid_out <= Shared_PE9_Pixel_2_valid_out_wr;
				Shared_PE10_Pixel_0_out <= Shared_PE10_Pixel_0_out_wr;
				Shared_PE10_Pixel_0_valid_out <= Shared_PE10_Pixel_0_valid_out_wr;
				Shared_PE10_Pixel_1_out <= Shared_PE10_Pixel_1_out_wr;
				Shared_PE10_Pixel_1_valid_out <= Shared_PE10_Pixel_1_valid_out_wr;
				Shared_PE10_Pixel_2_out <= Shared_PE10_Pixel_2_out_wr;
				Shared_PE10_Pixel_2_valid_out <= Shared_PE10_Pixel_2_valid_out_wr;
				Shared_PE11_Pixel_0_out <= Shared_PE11_Pixel_0_out_wr;
				Shared_PE11_Pixel_0_valid_out <= Shared_PE11_Pixel_0_valid_out_wr;
				Shared_PE11_Pixel_1_out <= Shared_PE11_Pixel_1_out_wr;
				Shared_PE11_Pixel_1_valid_out <= Shared_PE11_Pixel_1_valid_out_wr;
				Shared_PE11_Pixel_2_out <= Shared_PE11_Pixel_2_out_wr;
				Shared_PE11_Pixel_2_valid_out <= Shared_PE11_Pixel_2_valid_out_wr;
				Shared_PE12_Pixel_0_out <= Shared_PE12_Pixel_0_out_wr;
				Shared_PE12_Pixel_0_valid_out <= Shared_PE12_Pixel_0_valid_out_wr;
				Shared_PE12_Pixel_1_out <= Shared_PE12_Pixel_1_out_wr;
				Shared_PE12_Pixel_1_valid_out <= Shared_PE12_Pixel_1_valid_out_wr;
				Shared_PE12_Pixel_2_out <= Shared_PE12_Pixel_2_out_wr;
				Shared_PE12_Pixel_2_valid_out <= Shared_PE12_Pixel_2_valid_out_wr;
				Shared_PE13_Pixel_0_out <= Shared_PE13_Pixel_0_out_wr;
				Shared_PE13_Pixel_0_valid_out <= Shared_PE13_Pixel_0_valid_out_wr;
				Shared_PE13_Pixel_1_out <= Shared_PE13_Pixel_1_out_wr;
				Shared_PE13_Pixel_1_valid_out <= Shared_PE13_Pixel_1_valid_out_wr;
				Shared_PE13_Pixel_2_out <= Shared_PE13_Pixel_2_out_wr;
				Shared_PE13_Pixel_2_valid_out <= Shared_PE13_Pixel_2_valid_out_wr;
				Shared_PE14_Pixel_0_out <= Shared_PE14_Pixel_0_out_wr;
				Shared_PE14_Pixel_0_valid_out <= Shared_PE14_Pixel_0_valid_out_wr;
				Shared_PE14_Pixel_1_out <= Shared_PE14_Pixel_1_out_wr;
				Shared_PE14_Pixel_1_valid_out <= Shared_PE14_Pixel_1_valid_out_wr;
				Shared_PE14_Pixel_2_out <= Shared_PE14_Pixel_2_out_wr;
				Shared_PE14_Pixel_2_valid_out <= Shared_PE14_Pixel_2_valid_out_wr;
				Shared_PE15_Pixel_0_out <= Shared_PE15_Pixel_0_out_wr;
				Shared_PE15_Pixel_0_valid_out <= Shared_PE15_Pixel_0_valid_out_wr;
				Shared_PE15_Pixel_1_out <= Shared_PE15_Pixel_1_out_wr;
				Shared_PE15_Pixel_1_valid_out <= Shared_PE15_Pixel_1_valid_out_wr;
				Shared_PE15_Pixel_2_out <= Shared_PE15_Pixel_2_out_wr;
				Shared_PE15_Pixel_2_valid_out <= Shared_PE15_Pixel_2_valid_out_wr;
				Shared_PE16_Pixel_0_out <= Shared_PE16_Pixel_0_out_wr;
				Shared_PE16_Pixel_0_valid_out <= Shared_PE16_Pixel_0_valid_out_wr;
				Shared_PE16_Pixel_1_out <= Shared_PE16_Pixel_1_out_wr;
				Shared_PE16_Pixel_1_valid_out <= Shared_PE16_Pixel_1_valid_out_wr;
				Shared_PE16_Pixel_2_out <= Shared_PE16_Pixel_2_out_wr;
				Shared_PE16_Pixel_2_valid_out <= Shared_PE16_Pixel_2_valid_out_wr;
				Shared_PE17_Pixel_0_out <= Shared_PE17_Pixel_0_out_wr;
				Shared_PE17_Pixel_0_valid_out <= Shared_PE17_Pixel_0_valid_out_wr;
				Shared_PE17_Pixel_1_out <= Shared_PE17_Pixel_1_out_wr;
				Shared_PE17_Pixel_1_valid_out <= Shared_PE17_Pixel_1_valid_out_wr;
				Shared_PE17_Pixel_2_out <= Shared_PE17_Pixel_2_out_wr;
				Shared_PE17_Pixel_2_valid_out <= Shared_PE17_Pixel_2_valid_out_wr;
				Shared_PE18_Pixel_0_out <= Shared_PE18_Pixel_0_out_wr;
				Shared_PE18_Pixel_0_valid_out <= Shared_PE18_Pixel_0_valid_out_wr;
				Shared_PE18_Pixel_1_out <= Shared_PE18_Pixel_1_out_wr;
				Shared_PE18_Pixel_1_valid_out <= Shared_PE18_Pixel_1_valid_out_wr;
				Shared_PE18_Pixel_2_out <= Shared_PE18_Pixel_2_out_wr;
				Shared_PE18_Pixel_2_valid_out <= Shared_PE18_Pixel_2_valid_out_wr;
				Shared_PE19_Pixel_0_out <= Shared_PE19_Pixel_0_out_wr;
				Shared_PE19_Pixel_0_valid_out <= Shared_PE19_Pixel_0_valid_out_wr;
				Shared_PE19_Pixel_1_out <= Shared_PE19_Pixel_1_out_wr;
				Shared_PE19_Pixel_1_valid_out <= Shared_PE19_Pixel_1_valid_out_wr;
				Shared_PE19_Pixel_2_out <= Shared_PE19_Pixel_2_out_wr;
				Shared_PE19_Pixel_2_valid_out <= Shared_PE19_Pixel_2_valid_out_wr;
				Shared_PE20_Pixel_0_out <= Shared_PE20_Pixel_0_out_wr;
				Shared_PE20_Pixel_0_valid_out <= Shared_PE20_Pixel_0_valid_out_wr;
				Shared_PE20_Pixel_1_out <= Shared_PE20_Pixel_1_out_wr;
				Shared_PE20_Pixel_1_valid_out <= Shared_PE20_Pixel_1_valid_out_wr;
				Shared_PE20_Pixel_2_out <= Shared_PE20_Pixel_2_out_wr;
				Shared_PE20_Pixel_2_valid_out <= Shared_PE20_Pixel_2_valid_out_wr;
				Shared_PE21_Pixel_0_out <= Shared_PE21_Pixel_0_out_wr;
				Shared_PE21_Pixel_0_valid_out <= Shared_PE21_Pixel_0_valid_out_wr;
				Shared_PE21_Pixel_1_out <= Shared_PE21_Pixel_1_out_wr;
				Shared_PE21_Pixel_1_valid_out <= Shared_PE21_Pixel_1_valid_out_wr;
				Shared_PE21_Pixel_2_out <= Shared_PE21_Pixel_2_out_wr;
				Shared_PE21_Pixel_2_valid_out <= Shared_PE21_Pixel_2_valid_out_wr;
				Shared_PE22_Pixel_0_out <= Shared_PE22_Pixel_0_out_wr;
				Shared_PE22_Pixel_0_valid_out <= Shared_PE22_Pixel_0_valid_out_wr;
				Shared_PE22_Pixel_1_out <= Shared_PE22_Pixel_1_out_wr;
				Shared_PE22_Pixel_1_valid_out <= Shared_PE22_Pixel_1_valid_out_wr;
				Shared_PE22_Pixel_2_out <= Shared_PE22_Pixel_2_out_wr;
				Shared_PE22_Pixel_2_valid_out <= Shared_PE22_Pixel_2_valid_out_wr;
				Shared_PE23_Pixel_0_out <= Shared_PE23_Pixel_0_out_wr;
				Shared_PE23_Pixel_0_valid_out <= Shared_PE23_Pixel_0_valid_out_wr;
				Shared_PE23_Pixel_1_out <= Shared_PE23_Pixel_1_out_wr;
				Shared_PE23_Pixel_1_valid_out <= Shared_PE23_Pixel_1_valid_out_wr;
				Shared_PE23_Pixel_2_out <= Shared_PE23_Pixel_2_out_wr;
				Shared_PE23_Pixel_2_valid_out <= Shared_PE23_Pixel_2_valid_out_wr;
				Shared_PE24_Pixel_0_out <= Shared_PE24_Pixel_0_out_wr;
				Shared_PE24_Pixel_0_valid_out <= Shared_PE24_Pixel_0_valid_out_wr;
				Shared_PE24_Pixel_1_out <= Shared_PE24_Pixel_1_out_wr;
				Shared_PE24_Pixel_1_valid_out <= Shared_PE24_Pixel_1_valid_out_wr;
				Shared_PE24_Pixel_2_out <= Shared_PE24_Pixel_2_out_wr;
				Shared_PE24_Pixel_2_valid_out <= Shared_PE24_Pixel_2_valid_out_wr;
				Shared_PE25_Pixel_0_out <= Shared_PE25_Pixel_0_out_wr;
				Shared_PE25_Pixel_0_valid_out <= Shared_PE25_Pixel_0_valid_out_wr;
				Shared_PE25_Pixel_1_out <= Shared_PE25_Pixel_1_out_wr;
				Shared_PE25_Pixel_1_valid_out <= Shared_PE25_Pixel_1_valid_out_wr;
				Shared_PE25_Pixel_2_out <= Shared_PE25_Pixel_2_out_wr;
				Shared_PE25_Pixel_2_valid_out <= Shared_PE25_Pixel_2_valid_out_wr;
				Shared_PE26_Pixel_0_out <= Shared_PE26_Pixel_0_out_wr;
				Shared_PE26_Pixel_0_valid_out <= Shared_PE26_Pixel_0_valid_out_wr;
				Shared_PE26_Pixel_1_out <= Shared_PE26_Pixel_1_out_wr;
				Shared_PE26_Pixel_1_valid_out <= Shared_PE26_Pixel_1_valid_out_wr;
				Shared_PE26_Pixel_2_out <= Shared_PE26_Pixel_2_out_wr;
				Shared_PE26_Pixel_2_valid_out <= Shared_PE26_Pixel_2_valid_out_wr;
				Shared_PE27_Pixel_0_out <= Shared_PE27_Pixel_0_out_wr;
				Shared_PE27_Pixel_0_valid_out <= Shared_PE27_Pixel_0_valid_out_wr;
				Shared_PE27_Pixel_1_out <= Shared_PE27_Pixel_1_out_wr;
				Shared_PE27_Pixel_1_valid_out <= Shared_PE27_Pixel_1_valid_out_wr;
				Shared_PE27_Pixel_2_out <= Shared_PE27_Pixel_2_out_wr;
				Shared_PE27_Pixel_2_valid_out <= Shared_PE27_Pixel_2_valid_out_wr;
				Shared_PE28_Pixel_0_out <= Shared_PE28_Pixel_0_out_wr;
				Shared_PE28_Pixel_0_valid_out <= Shared_PE28_Pixel_0_valid_out_wr;
				Shared_PE28_Pixel_1_out <= Shared_PE28_Pixel_1_out_wr;
				Shared_PE28_Pixel_1_valid_out <= Shared_PE28_Pixel_1_valid_out_wr;
				Shared_PE28_Pixel_2_out <= Shared_PE28_Pixel_2_out_wr;
				Shared_PE28_Pixel_2_valid_out <= Shared_PE28_Pixel_2_valid_out_wr;
				Shared_PE29_Pixel_0_out <= Shared_PE29_Pixel_0_out_wr;
				Shared_PE29_Pixel_0_valid_out <= Shared_PE29_Pixel_0_valid_out_wr;
				Shared_PE29_Pixel_1_out <= Shared_PE29_Pixel_1_out_wr;
				Shared_PE29_Pixel_1_valid_out <= Shared_PE29_Pixel_1_valid_out_wr;
				Shared_PE29_Pixel_2_out <= Shared_PE29_Pixel_2_out_wr;
				Shared_PE29_Pixel_2_valid_out <= Shared_PE29_Pixel_2_valid_out_wr;
				Shared_PE30_Pixel_0_out <= Shared_PE30_Pixel_0_out_wr;
				Shared_PE30_Pixel_0_valid_out <= Shared_PE30_Pixel_0_valid_out_wr;
				Shared_PE30_Pixel_1_out <= Shared_PE30_Pixel_1_out_wr;
				Shared_PE30_Pixel_1_valid_out <= Shared_PE30_Pixel_1_valid_out_wr;
				Shared_PE30_Pixel_2_out <= Shared_PE30_Pixel_2_out_wr;
				Shared_PE30_Pixel_2_valid_out <= Shared_PE30_Pixel_2_valid_out_wr;
				Shared_PE31_Pixel_0_out <= Shared_PE31_Pixel_0_out_wr;
				Shared_PE31_Pixel_0_valid_out <= Shared_PE31_Pixel_0_valid_out_wr;
				Shared_PE31_Pixel_1_out <= Shared_PE31_Pixel_1_out_wr;
				Shared_PE31_Pixel_1_valid_out <= Shared_PE31_Pixel_1_valid_out_wr;
				Shared_PE31_Pixel_2_out <= Shared_PE31_Pixel_2_out_wr;
				Shared_PE31_Pixel_2_valid_out <= Shared_PE31_Pixel_2_valid_out_wr;
				Shared_PE32_Pixel_0_out <= Shared_PE32_Pixel_0_out_wr;
				Shared_PE32_Pixel_0_valid_out <= Shared_PE32_Pixel_0_valid_out_wr;
				Shared_PE32_Pixel_1_out <= Shared_PE32_Pixel_1_out_wr;
				Shared_PE32_Pixel_1_valid_out <= Shared_PE32_Pixel_1_valid_out_wr;
				Shared_PE32_Pixel_2_out <= Shared_PE32_Pixel_2_out_wr;
				Shared_PE32_Pixel_2_valid_out <= Shared_PE32_Pixel_2_valid_out_wr;
				Shared_PE33_Pixel_0_out <= Shared_PE33_Pixel_0_out_wr;
				Shared_PE33_Pixel_0_valid_out <= Shared_PE33_Pixel_0_valid_out_wr;
				Shared_PE33_Pixel_1_out <= Shared_PE33_Pixel_1_out_wr;
				Shared_PE33_Pixel_1_valid_out <= Shared_PE33_Pixel_1_valid_out_wr;
				Shared_PE33_Pixel_2_out <= Shared_PE33_Pixel_2_out_wr;
				Shared_PE33_Pixel_2_valid_out <= Shared_PE33_Pixel_2_valid_out_wr;
				Shared_PE34_Pixel_0_out <= Shared_PE34_Pixel_0_out_wr;
				Shared_PE34_Pixel_0_valid_out <= Shared_PE34_Pixel_0_valid_out_wr;
				Shared_PE34_Pixel_1_out <= Shared_PE34_Pixel_1_out_wr;
				Shared_PE34_Pixel_1_valid_out <= Shared_PE34_Pixel_1_valid_out_wr;
				Shared_PE34_Pixel_2_out <= Shared_PE34_Pixel_2_out_wr;
				Shared_PE34_Pixel_2_valid_out <= Shared_PE34_Pixel_2_valid_out_wr;
				Shared_PE35_Pixel_0_out <= Shared_PE35_Pixel_0_out_wr;
				Shared_PE35_Pixel_0_valid_out <= Shared_PE35_Pixel_0_valid_out_wr;
				Shared_PE35_Pixel_1_out <= Shared_PE35_Pixel_1_out_wr;
				Shared_PE35_Pixel_1_valid_out <= Shared_PE35_Pixel_1_valid_out_wr;
				Shared_PE35_Pixel_2_out <= Shared_PE35_Pixel_2_out_wr;
				Shared_PE35_Pixel_2_valid_out <= Shared_PE35_Pixel_2_valid_out_wr;
				Shared_PE36_Pixel_0_out <= Shared_PE36_Pixel_0_out_wr;
				Shared_PE36_Pixel_0_valid_out <= Shared_PE36_Pixel_0_valid_out_wr;
				Shared_PE36_Pixel_1_out <= Shared_PE36_Pixel_1_out_wr;
				Shared_PE36_Pixel_1_valid_out <= Shared_PE36_Pixel_1_valid_out_wr;
				Shared_PE36_Pixel_2_out <= Shared_PE36_Pixel_2_out_wr;
				Shared_PE36_Pixel_2_valid_out <= Shared_PE36_Pixel_2_valid_out_wr;
				Shared_PE37_Pixel_0_out <= Shared_PE37_Pixel_0_out_wr;
				Shared_PE37_Pixel_0_valid_out <= Shared_PE37_Pixel_0_valid_out_wr;
				Shared_PE37_Pixel_1_out <= Shared_PE37_Pixel_1_out_wr;
				Shared_PE37_Pixel_1_valid_out <= Shared_PE37_Pixel_1_valid_out_wr;
				Shared_PE37_Pixel_2_out <= Shared_PE37_Pixel_2_out_wr;
				Shared_PE37_Pixel_2_valid_out <= Shared_PE37_Pixel_2_valid_out_wr;
				Shared_PE38_Pixel_0_out <= Shared_PE38_Pixel_0_out_wr;
				Shared_PE38_Pixel_0_valid_out <= Shared_PE38_Pixel_0_valid_out_wr;
				Shared_PE38_Pixel_1_out <= Shared_PE38_Pixel_1_out_wr;
				Shared_PE38_Pixel_1_valid_out <= Shared_PE38_Pixel_1_valid_out_wr;
				Shared_PE38_Pixel_2_out <= Shared_PE38_Pixel_2_out_wr;
				Shared_PE38_Pixel_2_valid_out <= Shared_PE38_Pixel_2_valid_out_wr;
				Shared_PE39_Pixel_0_out <= Shared_PE39_Pixel_0_out_wr;
				Shared_PE39_Pixel_0_valid_out <= Shared_PE39_Pixel_0_valid_out_wr;
				Shared_PE39_Pixel_1_out <= Shared_PE39_Pixel_1_out_wr;
				Shared_PE39_Pixel_1_valid_out <= Shared_PE39_Pixel_1_valid_out_wr;
				Shared_PE39_Pixel_2_out <= Shared_PE39_Pixel_2_out_wr;
				Shared_PE39_Pixel_2_valid_out <= Shared_PE39_Pixel_2_valid_out_wr;
			end
			else begin
				Shared_PE0_Pixel_0_out <= 0;
				Shared_PE0_Pixel_0_valid_out <= 0;
				Shared_PE0_Pixel_1_out <= 0;
				Shared_PE0_Pixel_1_valid_out <= 0;
				Shared_PE0_Pixel_2_out <= 0;
				Shared_PE0_Pixel_2_valid_out <= 0;
				Shared_PE1_Pixel_0_out <= 0;
				Shared_PE1_Pixel_0_valid_out <= 0;
				Shared_PE1_Pixel_1_out <= 0;
				Shared_PE1_Pixel_1_valid_out <= 0;
				Shared_PE1_Pixel_2_out <= 0;
				Shared_PE1_Pixel_2_valid_out <= 0;
				Shared_PE2_Pixel_0_out <= 0;
				Shared_PE2_Pixel_0_valid_out <= 0;
				Shared_PE2_Pixel_1_out <= 0;
				Shared_PE2_Pixel_1_valid_out <= 0;
				Shared_PE2_Pixel_2_out <= 0;
				Shared_PE2_Pixel_2_valid_out <= 0;
				Shared_PE3_Pixel_0_out <= 0;
				Shared_PE3_Pixel_0_valid_out <= 0;
				Shared_PE3_Pixel_1_out <= 0;
				Shared_PE3_Pixel_1_valid_out <= 0;
				Shared_PE3_Pixel_2_out <= 0;
				Shared_PE3_Pixel_2_valid_out <= 0;
				Shared_PE4_Pixel_0_out <= 0;
				Shared_PE4_Pixel_0_valid_out <= 0;
				Shared_PE4_Pixel_1_out <= 0;
				Shared_PE4_Pixel_1_valid_out <= 0;
				Shared_PE4_Pixel_2_out <= 0;
				Shared_PE4_Pixel_2_valid_out <= 0;
				Shared_PE5_Pixel_0_out <= 0;
				Shared_PE5_Pixel_0_valid_out <= 0;
				Shared_PE5_Pixel_1_out <= 0;
				Shared_PE5_Pixel_1_valid_out <= 0;
				Shared_PE5_Pixel_2_out <= 0;
				Shared_PE5_Pixel_2_valid_out <= 0;
				Shared_PE6_Pixel_0_out <= 0;
				Shared_PE6_Pixel_0_valid_out <= 0;
				Shared_PE6_Pixel_1_out <= 0;
				Shared_PE6_Pixel_1_valid_out <= 0;
				Shared_PE6_Pixel_2_out <= 0;
				Shared_PE6_Pixel_2_valid_out <= 0;
				Shared_PE7_Pixel_0_out <= 0;
				Shared_PE7_Pixel_0_valid_out <= 0;
				Shared_PE7_Pixel_1_out <= 0;
				Shared_PE7_Pixel_1_valid_out <= 0;
				Shared_PE7_Pixel_2_out <= 0;
				Shared_PE7_Pixel_2_valid_out <= 0;
				Shared_PE8_Pixel_0_out <= 0;
				Shared_PE8_Pixel_0_valid_out <= 0;
				Shared_PE8_Pixel_1_out <= 0;
				Shared_PE8_Pixel_1_valid_out <= 0;
				Shared_PE8_Pixel_2_out <= 0;
				Shared_PE8_Pixel_2_valid_out <= 0;
				Shared_PE9_Pixel_0_out <= 0;
				Shared_PE9_Pixel_0_valid_out <= 0;
				Shared_PE9_Pixel_1_out <= 0;
				Shared_PE9_Pixel_1_valid_out <= 0;
				Shared_PE9_Pixel_2_out <= 0;
				Shared_PE9_Pixel_2_valid_out <= 0;
				Shared_PE10_Pixel_0_out <= 0;
				Shared_PE10_Pixel_0_valid_out <= 0;
				Shared_PE10_Pixel_1_out <= 0;
				Shared_PE10_Pixel_1_valid_out <= 0;
				Shared_PE10_Pixel_2_out <= 0;
				Shared_PE10_Pixel_2_valid_out <= 0;
				Shared_PE11_Pixel_0_out <= 0;
				Shared_PE11_Pixel_0_valid_out <= 0;
				Shared_PE11_Pixel_1_out <= 0;
				Shared_PE11_Pixel_1_valid_out <= 0;
				Shared_PE11_Pixel_2_out <= 0;
				Shared_PE11_Pixel_2_valid_out <= 0;
				Shared_PE12_Pixel_0_out <= 0;
				Shared_PE12_Pixel_0_valid_out <= 0;
				Shared_PE12_Pixel_1_out <= 0;
				Shared_PE12_Pixel_1_valid_out <= 0;
				Shared_PE12_Pixel_2_out <= 0;
				Shared_PE12_Pixel_2_valid_out <= 0;
				Shared_PE13_Pixel_0_out <= 0;
				Shared_PE13_Pixel_0_valid_out <= 0;
				Shared_PE13_Pixel_1_out <= 0;
				Shared_PE13_Pixel_1_valid_out <= 0;
				Shared_PE13_Pixel_2_out <= 0;
				Shared_PE13_Pixel_2_valid_out <= 0;
				Shared_PE14_Pixel_0_out <= 0;
				Shared_PE14_Pixel_0_valid_out <= 0;
				Shared_PE14_Pixel_1_out <= 0;
				Shared_PE14_Pixel_1_valid_out <= 0;
				Shared_PE14_Pixel_2_out <= 0;
				Shared_PE14_Pixel_2_valid_out <= 0;
				Shared_PE15_Pixel_0_out <= 0;
				Shared_PE15_Pixel_0_valid_out <= 0;
				Shared_PE15_Pixel_1_out <= 0;
				Shared_PE15_Pixel_1_valid_out <= 0;
				Shared_PE15_Pixel_2_out <= 0;
				Shared_PE15_Pixel_2_valid_out <= 0;
				Shared_PE16_Pixel_0_out <= 0;
				Shared_PE16_Pixel_0_valid_out <= 0;
				Shared_PE16_Pixel_1_out <= 0;
				Shared_PE16_Pixel_1_valid_out <= 0;
				Shared_PE16_Pixel_2_out <= 0;
				Shared_PE16_Pixel_2_valid_out <= 0;
				Shared_PE17_Pixel_0_out <= 0;
				Shared_PE17_Pixel_0_valid_out <= 0;
				Shared_PE17_Pixel_1_out <= 0;
				Shared_PE17_Pixel_1_valid_out <= 0;
				Shared_PE17_Pixel_2_out <= 0;
				Shared_PE17_Pixel_2_valid_out <= 0;
				Shared_PE18_Pixel_0_out <= 0;
				Shared_PE18_Pixel_0_valid_out <= 0;
				Shared_PE18_Pixel_1_out <= 0;
				Shared_PE18_Pixel_1_valid_out <= 0;
				Shared_PE18_Pixel_2_out <= 0;
				Shared_PE18_Pixel_2_valid_out <= 0;
				Shared_PE19_Pixel_0_out <= 0;
				Shared_PE19_Pixel_0_valid_out <= 0;
				Shared_PE19_Pixel_1_out <= 0;
				Shared_PE19_Pixel_1_valid_out <= 0;
				Shared_PE19_Pixel_2_out <= 0;
				Shared_PE19_Pixel_2_valid_out <= 0;
				Shared_PE20_Pixel_0_out <= 0;
				Shared_PE20_Pixel_0_valid_out <= 0;
				Shared_PE20_Pixel_1_out <= 0;
				Shared_PE20_Pixel_1_valid_out <= 0;
				Shared_PE20_Pixel_2_out <= 0;
				Shared_PE20_Pixel_2_valid_out <= 0;
				Shared_PE21_Pixel_0_out <= 0;
				Shared_PE21_Pixel_0_valid_out <= 0;
				Shared_PE21_Pixel_1_out <= 0;
				Shared_PE21_Pixel_1_valid_out <= 0;
				Shared_PE21_Pixel_2_out <= 0;
				Shared_PE21_Pixel_2_valid_out <= 0;
				Shared_PE22_Pixel_0_out <= 0;
				Shared_PE22_Pixel_0_valid_out <= 0;
				Shared_PE22_Pixel_1_out <= 0;
				Shared_PE22_Pixel_1_valid_out <= 0;
				Shared_PE22_Pixel_2_out <= 0;
				Shared_PE22_Pixel_2_valid_out <= 0;
				Shared_PE23_Pixel_0_out <= 0;
				Shared_PE23_Pixel_0_valid_out <= 0;
				Shared_PE23_Pixel_1_out <= 0;
				Shared_PE23_Pixel_1_valid_out <= 0;
				Shared_PE23_Pixel_2_out <= 0;
				Shared_PE23_Pixel_2_valid_out <= 0;
				Shared_PE24_Pixel_0_out <= 0;
				Shared_PE24_Pixel_0_valid_out <= 0;
				Shared_PE24_Pixel_1_out <= 0;
				Shared_PE24_Pixel_1_valid_out <= 0;
				Shared_PE24_Pixel_2_out <= 0;
				Shared_PE24_Pixel_2_valid_out <= 0;
				Shared_PE25_Pixel_0_out <= 0;
				Shared_PE25_Pixel_0_valid_out <= 0;
				Shared_PE25_Pixel_1_out <= 0;
				Shared_PE25_Pixel_1_valid_out <= 0;
				Shared_PE25_Pixel_2_out <= 0;
				Shared_PE25_Pixel_2_valid_out <= 0;
				Shared_PE26_Pixel_0_out <= 0;
				Shared_PE26_Pixel_0_valid_out <= 0;
				Shared_PE26_Pixel_1_out <= 0;
				Shared_PE26_Pixel_1_valid_out <= 0;
				Shared_PE26_Pixel_2_out <= 0;
				Shared_PE26_Pixel_2_valid_out <= 0;
				Shared_PE27_Pixel_0_out <= 0;
				Shared_PE27_Pixel_0_valid_out <= 0;
				Shared_PE27_Pixel_1_out <= 0;
				Shared_PE27_Pixel_1_valid_out <= 0;
				Shared_PE27_Pixel_2_out <= 0;
				Shared_PE27_Pixel_2_valid_out <= 0;
				Shared_PE28_Pixel_0_out <= 0;
				Shared_PE28_Pixel_0_valid_out <= 0;
				Shared_PE28_Pixel_1_out <= 0;
				Shared_PE28_Pixel_1_valid_out <= 0;
				Shared_PE28_Pixel_2_out <= 0;
				Shared_PE28_Pixel_2_valid_out <= 0;
				Shared_PE29_Pixel_0_out <= 0;
				Shared_PE29_Pixel_0_valid_out <= 0;
				Shared_PE29_Pixel_1_out <= 0;
				Shared_PE29_Pixel_1_valid_out <= 0;
				Shared_PE29_Pixel_2_out <= 0;
				Shared_PE29_Pixel_2_valid_out <= 0;
				Shared_PE30_Pixel_0_out <= 0;
				Shared_PE30_Pixel_0_valid_out <= 0;
				Shared_PE30_Pixel_1_out <= 0;
				Shared_PE30_Pixel_1_valid_out <= 0;
				Shared_PE30_Pixel_2_out <= 0;
				Shared_PE30_Pixel_2_valid_out <= 0;
				Shared_PE31_Pixel_0_out <= 0;
				Shared_PE31_Pixel_0_valid_out <= 0;
				Shared_PE31_Pixel_1_out <= 0;
				Shared_PE31_Pixel_1_valid_out <= 0;
				Shared_PE31_Pixel_2_out <= 0;
				Shared_PE31_Pixel_2_valid_out <= 0;
				Shared_PE32_Pixel_0_out <= 0;
				Shared_PE32_Pixel_0_valid_out <= 0;
				Shared_PE32_Pixel_1_out <= 0;
				Shared_PE32_Pixel_1_valid_out <= 0;
				Shared_PE32_Pixel_2_out <= 0;
				Shared_PE32_Pixel_2_valid_out <= 0;
				Shared_PE33_Pixel_0_out <= 0;
				Shared_PE33_Pixel_0_valid_out <= 0;
				Shared_PE33_Pixel_1_out <= 0;
				Shared_PE33_Pixel_1_valid_out <= 0;
				Shared_PE33_Pixel_2_out <= 0;
				Shared_PE33_Pixel_2_valid_out <= 0;
				Shared_PE34_Pixel_0_out <= 0;
				Shared_PE34_Pixel_0_valid_out <= 0;
				Shared_PE34_Pixel_1_out <= 0;
				Shared_PE34_Pixel_1_valid_out <= 0;
				Shared_PE34_Pixel_2_out <= 0;
				Shared_PE34_Pixel_2_valid_out <= 0;
				Shared_PE35_Pixel_0_out <= 0;
				Shared_PE35_Pixel_0_valid_out <= 0;
				Shared_PE35_Pixel_1_out <= 0;
				Shared_PE35_Pixel_1_valid_out <= 0;
				Shared_PE35_Pixel_2_out <= 0;
				Shared_PE35_Pixel_2_valid_out <= 0;
				Shared_PE36_Pixel_0_out <= 0;
				Shared_PE36_Pixel_0_valid_out <= 0;
				Shared_PE36_Pixel_1_out <= 0;
				Shared_PE36_Pixel_1_valid_out <= 0;
				Shared_PE36_Pixel_2_out <= 0;
				Shared_PE36_Pixel_2_valid_out <= 0;
				Shared_PE37_Pixel_0_out <= 0;
				Shared_PE37_Pixel_0_valid_out <= 0;
				Shared_PE37_Pixel_1_out <= 0;
				Shared_PE37_Pixel_1_valid_out <= 0;
				Shared_PE37_Pixel_2_out <= 0;
				Shared_PE37_Pixel_2_valid_out <= 0;
				Shared_PE38_Pixel_0_out <= 0;
				Shared_PE38_Pixel_0_valid_out <= 0;
				Shared_PE38_Pixel_1_out <= 0;
				Shared_PE38_Pixel_1_valid_out <= 0;
				Shared_PE38_Pixel_2_out <= 0;
				Shared_PE38_Pixel_2_valid_out <= 0;
				Shared_PE39_Pixel_0_out <= 0;
				Shared_PE39_Pixel_0_valid_out <= 0;
				Shared_PE39_Pixel_1_out <= 0;
				Shared_PE39_Pixel_1_valid_out <= 0;
				Shared_PE39_Pixel_2_out <= 0;
				Shared_PE39_Pixel_2_valid_out <= 0;
			end
			Parity_PE_Selection_rg <= Parity_PE_Selection_in;
		end
	end
endmodule

module MUX_4_1 (
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
