
`define START_BASE_PHYS	 40'h00a0000000
`define FINISH_BASE_PHYS 40'h00a0000020
`define CTX_PE_BASE_IP	 16'h00a1
`define CTX_RC_BASE_IP	 16'h00a2
`define CTX_IM_BASE_IP	 16'h00a3
`define LMM_BASE_PHYS	 12'h012

`define PE0_BASE_PHYS    32'h00100000
`define PE1_BASE_PHYS    32'h00104000
`define PE2_BASE_PHYS    32'h00108000
`define PE3_BASE_PHYS    32'h0010C000
`define PE4_BASE_PHYS    32'h00110000
`define PE5_BASE_PHYS    32'h00114000
`define PE6_BASE_PHYS    32'h00118000
`define PE7_BASE_PHYS    32'h0011C000
`define PE8_BASE_PHYS    32'h00120000
`define PE9_BASE_PHYS    32'h00124000
`define PE10_BASE_PHYS   32'h00128000  
`define PE11_BASE_PHYS   32'h0012C000
`define PE12_BASE_PHYS   32'h00130000
`define PE13_BASE_PHYS   32'h00134000
`define PE14_BASE_PHYS   32'h00138000
`define PE15_BASE_PHYS   32'h0013C000
// --- THÊM MỚI CHO ĐỦ 40 PE ---
`define PE16_BASE_PHYS   32'h00140000
`define PE17_BASE_PHYS   32'h00144000
`define PE18_BASE_PHYS   32'h00148000
`define PE19_BASE_PHYS   32'h0014C000
`define PE20_BASE_PHYS   32'h00150000
`define PE21_BASE_PHYS   32'h00154000
`define PE22_BASE_PHYS   32'h00158000
`define PE23_BASE_PHYS   32'h0015C000
`define PE24_BASE_PHYS   32'h00160000
`define PE25_BASE_PHYS   32'h00164000
`define PE26_BASE_PHYS   32'h00168000
`define PE27_BASE_PHYS   32'h0016C000
`define PE28_BASE_PHYS   32'h00170000
`define PE29_BASE_PHYS   32'h00174000
`define PE30_BASE_PHYS   32'h00178000
`define PE31_BASE_PHYS   32'h0017C000
`define PE32_BASE_PHYS   32'h00180000
`define PE33_BASE_PHYS   32'h00184000
`define PE34_BASE_PHYS   32'h00188000
`define PE35_BASE_PHYS   32'h0018C000
`define PE36_BASE_PHYS   32'h00190000
`define PE37_BASE_PHYS   32'h00194000
`define PE38_BASE_PHYS   32'h00198000
`define PE39_BASE_PHYS   32'h0019C000



///////////////////////////////////////////////
/// 				Controller 	   		   ////
///////////////////////////////////////////////

`define WRAM_ADDR_BITS      13
`define BRAM_ADDR_BITS      8
`define CRAM_ADDR_BITS      6

`define CTX_BITS      		32 // Padding: 2, n: 5, y: 3, k: 5, j: 3, ALU_CFG_BITS: 3, stride: 1, Residual Connection: 1, Source_LDM: 2, Destinate_LDM: 1, Starting_Address_Store: 6
`define PAD_BITS      		2
`define N_BITS      		5
`define Y_BITS      		3
`define K_BITS      		5
`define J_BITS      		3
`define STRIDE_BITS      	1
`define S_LDM_BITS     		2
`define D_LDM_BITS     		2
`define SA_LDM_BITS     	6

///////////////////////////////////////////////
/// 	Processing Element Array (PEA) 	   ////
///////////////////////////////////////////////
	
`define PE_NUM		       40
`define PE_NUM_BITS	       6

///***---- Processing Element (PE)----***////
	`define WORD_BITS		   16
///--------- Load Store Unit (LSU) ---------////
	`define LDM_ADDR_BITS      6
	`define LDM_NUM_BITS       2
	`define LSU_CFG_BITS       (1+`LDM_ADDR_BITS)
	`define LSU_LDW            1'd0
	`define LSU_STW            1'd1

///------ Arithmetic Logic Unit (ALU)------///
	`define ALU_CFG_BITS   	   3	
	`define EXE_NOP            2'd0
	`define EXE_MAC	           2'd1
	`define EXE_ADD            2'd2
	`define EXE_MP	           2'd3