/*
 *-----------------------------------------------------------------------------
 * Title         : Processing Element Lite (For PEA 1)
 * Description   : Stripped-down version of PE.v, containing only ALU and 
 * control logic for MAC operations. No local memory (LSU).
 *-----------------------------------------------------------------------------
 */
 
`timescale 1ns/1ns
`include "common.vh"

module PE_lite
#(
    parameter UNIT_NO = 0
)
(
    input  wire                                 CLK,
    input  wire                                 RST,
    
    //-----------------------------------------------------//
    //          			Input Signals                  // 
    //-----------------------------------------------------//

    ///*** From the Controller ***///	
    input  wire                                 En_in,
    input  wire                                 layer_done_in,
    input  wire signed [`ALU_CFG_BITS-1:0]      CFG_in,
    input  wire [`D_LDM_BITS+`SA_LDM_BITS-1:0]  CTRL_LDM_Store_in,

    ///*** From the Weight RAM (Dual-Port Branch) ***///	
    input  wire                                 Weight_valid_in,	
    input  wire signed [`WORD_BITS-1:0]         Weight_in,

    ///*** From the Bias RAM (Dual-Port Branch) ***///	
    input  wire                                 Bias_valid_in,	
    input  wire signed [`WORD_BITS-1:0]         Bias_in,
    
    ///*** From Shared Pixel Distributor (SPD) ***///			
    input  wire                                 Pixel_0_valid_in,	
    input  wire signed [`WORD_BITS-1:0]         Pixel_0_in,
    
    //-----------------------------------------------------//
    //          			Output Signals                 // 
    //-----------------------------------------------------//  
    
    ///*** Output to Shared Pixel Memory (LSU in PEA 0) ***///
    output wire signed [`WORD_BITS-1:0]         ALU_out,
    output wire                                 ALU_valid_out,
    output wire [`D_LDM_BITS+`LDM_ADDR_BITS-1:0] ALU_addr_out,
    output wire                                 ALU_en_out
);
 
    // *************** Wire signals *************** //
    wire                                        S0_valid_wr;
    wire signed [`WORD_BITS-1:0]                S0_wr;
    wire                                        S1_valid_wr;
    wire signed [`WORD_BITS-1:0]                S1_wr;
    wire                                        S2_valid_wr;
    wire signed [`WORD_BITS-1:0]                S2_wr;
    
    // *************** Register signals *************** //		
    reg [`LDM_ADDR_BITS-1:0]                    ALU_LDM_addrb_rg;
    reg                                         Pixel_0_valid_rg;
    reg [`D_LDM_BITS+`SA_LDM_BITS-1:0] CTRL_LDM_Store_d1_rg;
    reg [`D_LDM_BITS+`SA_LDM_BITS-1:0] CTRL_LDM_Store_d2_rg;

    //-----------------------------------------------------//
    //          		Routing Logic to ALU                   // 
    //-----------------------------------------------------//
    
    // S0 is Weight
    assign S0_valid_wr = (CFG_in[`ALU_CFG_BITS-2:0] == `EXE_MAC) ? Weight_valid_in : Pixel_0_valid_in;
    assign S0_wr       = (CFG_in[`ALU_CFG_BITS-2:0] == `EXE_MAC) ? Weight_in : Pixel_0_in;
        
    // S1 in MAC operation is Pixel_0
    assign S1_valid_wr = Pixel_0_valid_in;
    assign S1_wr       = Pixel_0_in;
        
    // S2 in MAC operation is Bias
    assign S2_valid_wr = Bias_valid_in;
    assign S2_wr       = Bias_in;
    
    //-----------------------------------------------------//
    //          		ALU Instantiation                      // 
    //-----------------------------------------------------//
    ALU alu
    (
        .CLK(CLK),
        .RST(RST),
        .En_in(En_in),
        .CFG_in(CFG_in[`ALU_CFG_BITS-2:0]),
        .ReLU_en_in(CFG_in[`ALU_CFG_BITS-1:`ALU_CFG_BITS-1]),
        .S0_valid_in(S0_valid_wr),
        .S0_in(S0_wr),
        .S1_valid_in(S1_valid_wr),
        .S1_in(S1_wr),
        .S2_valid_in(S2_valid_wr),
        .S2_in(S2_wr),
        .D0_out(ALU_out),
        .Valid_out(ALU_valid_out)
    );

    //-----------------------------------------------------//
    //          		Write Address Logic                    // 
    //-----------------------------------------------------//
    assign ALU_addr_out =
        {CTRL_LDM_Store_d2_rg[`D_LDM_BITS+`SA_LDM_BITS-1:`SA_LDM_BITS],
        ALU_LDM_addrb_rg + CTRL_LDM_Store_d2_rg[`SA_LDM_BITS-1:0]};  

     assign ALU_en_out   = ALU_valid_out & En_in & (CFG_in[`ALU_CFG_BITS-2:0] == `EXE_MAC);
    
    always @(posedge CLK or negedge RST) begin
        if (~RST) begin
            ALU_LDM_addrb_rg     <= 6'h3F;
            Pixel_0_valid_rg     <= 0;
            CTRL_LDM_Store_d1_rg <= 0;
            CTRL_LDM_Store_d2_rg <= 0;
        end
        else begin
            if(layer_done_in) begin
                ALU_LDM_addrb_rg     <= 6'h3F;
                Pixel_0_valid_rg     <= 0;
                CTRL_LDM_Store_d1_rg <= 0;
                CTRL_LDM_Store_d2_rg <= 0;
            end
            else if(En_in) begin
                CTRL_LDM_Store_d1_rg <= CTRL_LDM_Store_in;
                CTRL_LDM_Store_d2_rg <= CTRL_LDM_Store_d1_rg;

                Pixel_0_valid_rg <= Pixel_0_valid_in;

                if(CFG_in[`ALU_CFG_BITS-2:0] == `EXE_MAC) begin
                    ALU_LDM_addrb_rg <= ALU_LDM_addrb_rg + Bias_valid_in;
                end
                else begin
                    ALU_LDM_addrb_rg <= ALU_LDM_addrb_rg + Pixel_0_valid_rg;
                end
            end
        end
    end
  
endmodule
