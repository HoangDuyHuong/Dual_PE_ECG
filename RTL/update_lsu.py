import os
import re

files_to_update = ["LSU.v", "LSU_LP.v", "LSU_RP.v"]

pe1_inputs = """
\t///*** From the ALU (PEA 1) ***///
\tinput  wire [`D_LDM_BITS+`LDM_ADDR_BITS-1:0]  \tPE1_LDM_addra_in,
\tinput  wire signed [`WORD_BITS-1:0]          \tPE1_LDM_dina_in,
\tinput  wire \t\t\t\t\t              \tPE1_LDM_ena_in,
\tinput  wire \t\t\t\t\t              \tPE1_LDM_wea_in,

\t///*** From the ALU ***///"""

new_ldm_logic = """//------- LDM0 -------//
\tassign LDM0_ena_wr \t\t= (AXI_LDM_ena_in & (AXI_LDM_addra_in[`LDM_NUM_BITS+`LDM_ADDR_BITS-1:`LDM_ADDR_BITS]==0)) ? AXI_LDM_ena_in:
\t\t\t\t\t\t\t  (PE1_LDM_ena_in & (PE1_LDM_addra_in[`D_LDM_BITS+`LDM_ADDR_BITS-1:`LDM_ADDR_BITS]==0)) ? PE1_LDM_ena_in:
\t\t\t\t\t\t\t  (CTRL_LDM_ena_in & (CTRL_LDM_addra_in[`S_LDM_BITS+`LDM_ADDR_BITS-1:`LDM_ADDR_BITS]==0)) ? CTRL_LDM_ena_in: 0;
\tassign LDM0_wea_wr \t\t= (AXI_LDM_addra_in[`LDM_NUM_BITS+`LDM_ADDR_BITS-1:`LDM_ADDR_BITS]==0) ? AXI_LDM_wea_in:
\t\t\t\t\t\t\t  (PE1_LDM_addra_in[`D_LDM_BITS+`LDM_ADDR_BITS-1:`LDM_ADDR_BITS]==0) ? PE1_LDM_wea_in: 0;
\tassign LDM0_addra_wr \t= (AXI_LDM_ena_in & (AXI_LDM_addra_in[`LDM_NUM_BITS+`LDM_ADDR_BITS-1:`LDM_ADDR_BITS]==0)) ? AXI_LDM_addra_in[`LDM_ADDR_BITS-1:0]:
\t\t\t\t\t\t\t  (PE1_LDM_ena_in & (PE1_LDM_addra_in[`D_LDM_BITS+`LDM_ADDR_BITS-1:`LDM_ADDR_BITS]==0)) ? PE1_LDM_addra_in[`LDM_ADDR_BITS-1:0]:
\t\t\t\t\t\t\t  (CTRL_LDM_ena_in & (CTRL_LDM_addra_in[`S_LDM_BITS+`LDM_ADDR_BITS-1:`LDM_ADDR_BITS]==0)) ? CTRL_LDM_addra_in[`LDM_ADDR_BITS-1:0]: 0;
\tassign LDM0_dina_wr \t= (AXI_LDM_addra_in[`LDM_NUM_BITS+`LDM_ADDR_BITS-1:`LDM_ADDR_BITS]==0) ? AXI_LDM_dina_in:
\t\t\t\t\t\t\t  (PE1_LDM_addra_in[`D_LDM_BITS+`LDM_ADDR_BITS-1:`LDM_ADDR_BITS]==0) ? PE1_LDM_dina_in: 0;

\tassign LDM0_enb_wr \t\t= (ALU_LDM_enb_in & (ALU_LDM_addrb_in[`D_LDM_BITS+`LDM_ADDR_BITS-1:`LDM_ADDR_BITS]==0)) ? ALU_LDM_enb_in:
\t\t\t\t\t\t\t  (CTRL_LDM_enb_in & (CTRL_LDM_addrb_in[`S_LDM_BITS+`LDM_ADDR_BITS-1:`LDM_ADDR_BITS]==0)) ? CTRL_LDM_enb_in: 0;
\tassign LDM0_web_wr \t\t= (ALU_LDM_enb_in & (ALU_LDM_addrb_in[`D_LDM_BITS+`LDM_ADDR_BITS-1:`LDM_ADDR_BITS]==0)) ? ALU_LDM_web_in: 0;
\tassign LDM0_addrb_wr \t= (ALU_LDM_enb_in & (ALU_LDM_addrb_in[`D_LDM_BITS+`LDM_ADDR_BITS-1:`LDM_ADDR_BITS]==0)) ? ALU_LDM_addrb_in[`LDM_ADDR_BITS-1:0]:
\t\t\t\t\t\t\t  (CTRL_LDM_enb_in & (CTRL_LDM_addrb_in[`S_LDM_BITS+`LDM_ADDR_BITS-1:`LDM_ADDR_BITS]==0)) ? CTRL_LDM_addrb_in[`LDM_ADDR_BITS-1:0]: 0;
\tassign LDM0_dinb_wr \t= ALU_LDM_dinb_in;

//------- LDM1 -------//
\tassign LDM1_ena_wr \t\t= (AXI_LDM_ena_in & (AXI_LDM_addra_in[`LDM_NUM_BITS+`LDM_ADDR_BITS-1:`LDM_ADDR_BITS]==1)) ? AXI_LDM_ena_in:
\t\t\t\t\t\t\t  (PE1_LDM_ena_in & (PE1_LDM_addra_in[`D_LDM_BITS+`LDM_ADDR_BITS-1:`LDM_ADDR_BITS]==1)) ? PE1_LDM_ena_in:
\t\t\t\t\t\t\t  (CTRL_LDM_ena_in & (CTRL_LDM_addra_in[`S_LDM_BITS+`LDM_ADDR_BITS-1:`LDM_ADDR_BITS]==1)) ? CTRL_LDM_ena_in: 0;
\tassign LDM1_wea_wr \t\t= (AXI_LDM_addra_in[`LDM_NUM_BITS+`LDM_ADDR_BITS-1:`LDM_ADDR_BITS]==1) ? AXI_LDM_wea_in : 
\t\t\t\t\t\t\t  (PE1_LDM_addra_in[`D_LDM_BITS+`LDM_ADDR_BITS-1:`LDM_ADDR_BITS]==1) ? PE1_LDM_wea_in: 0;
\tassign LDM1_addra_wr \t= (AXI_LDM_ena_in & (AXI_LDM_addra_in[`LDM_NUM_BITS+`LDM_ADDR_BITS-1:`LDM_ADDR_BITS]==1)) ? AXI_LDM_addra_in[`LDM_ADDR_BITS-1:0]:
\t\t\t\t\t\t\t  (PE1_LDM_ena_in & (PE1_LDM_addra_in[`D_LDM_BITS+`LDM_ADDR_BITS-1:`LDM_ADDR_BITS]==1)) ? PE1_LDM_addra_in[`LDM_ADDR_BITS-1:0]:
\t\t\t\t\t\t\t  (CTRL_LDM_ena_in & (CTRL_LDM_addra_in[`S_LDM_BITS+`LDM_ADDR_BITS-1:`LDM_ADDR_BITS]==1)) ? CTRL_LDM_addra_in[`LDM_ADDR_BITS-1:0]: 0;
\tassign LDM1_dina_wr \t= (AXI_LDM_addra_in[`LDM_NUM_BITS+`LDM_ADDR_BITS-1:`LDM_ADDR_BITS] == 1) ? AXI_LDM_dina_in: 
\t\t\t\t\t\t\t  (PE1_LDM_addra_in[`D_LDM_BITS+`LDM_ADDR_BITS-1:`LDM_ADDR_BITS]==1) ? PE1_LDM_dina_in: 0;

\tassign LDM1_enb_wr \t\t= (ALU_LDM_enb_in & (ALU_LDM_addrb_in[`D_LDM_BITS+`LDM_ADDR_BITS-1:`LDM_ADDR_BITS]==1)) ? ALU_LDM_enb_in:
\t\t\t\t\t\t\t  (CTRL_LDM_enb_in & (CTRL_LDM_addrb_in[`S_LDM_BITS+`LDM_ADDR_BITS-1:`LDM_ADDR_BITS]==1)) ? CTRL_LDM_enb_in: 0;
\tassign LDM1_web_wr \t\t= (ALU_LDM_enb_in & (ALU_LDM_addrb_in[`D_LDM_BITS+`LDM_ADDR_BITS-1:`LDM_ADDR_BITS]==1)) ? ALU_LDM_web_in: 0;
\tassign LDM1_addrb_wr \t= (ALU_LDM_enb_in & (ALU_LDM_addrb_in[`D_LDM_BITS+`LDM_ADDR_BITS-1:`LDM_ADDR_BITS]==1)) ? ALU_LDM_addrb_in[`LDM_ADDR_BITS-1:0]: 
\t\t\t\t\t\t\t  (CTRL_LDM_enb_in & (CTRL_LDM_addrb_in[`S_LDM_BITS+`LDM_ADDR_BITS-1:`LDM_ADDR_BITS]==1)) ? CTRL_LDM_addrb_in[`LDM_ADDR_BITS-1:0]: 0;
\tassign LDM1_dinb_wr \t= ALU_LDM_dinb_in;

//------- LDM2 -------//
\tassign LDM2_ena_wr \t\t= (AXI_LDM_ena_in & (AXI_LDM_addra_in[`LDM_NUM_BITS+`LDM_ADDR_BITS-1:`LDM_ADDR_BITS]==2)) ? AXI_LDM_ena_in:
\t\t\t\t\t\t\t  (PE1_LDM_ena_in & (PE1_LDM_addra_in[`D_LDM_BITS+`LDM_ADDR_BITS-1:`LDM_ADDR_BITS]==2)) ? PE1_LDM_ena_in:
\t\t\t\t\t\t\t  (CTRL_LDM_ena_in & (CTRL_LDM_addra_in[`S_LDM_BITS+`LDM_ADDR_BITS-1:`LDM_ADDR_BITS]==2)) ? CTRL_LDM_ena_in: 0;
\tassign LDM2_wea_wr \t\t= (PE1_LDM_addra_in[`D_LDM_BITS+`LDM_ADDR_BITS-1:`LDM_ADDR_BITS]==2) ? PE1_LDM_wea_in: 0;
\tassign LDM2_addra_wr \t= (AXI_LDM_ena_in & (AXI_LDM_addra_in[`LDM_NUM_BITS+`LDM_ADDR_BITS-1:`LDM_ADDR_BITS]==2)) ? AXI_LDM_addra_in[`LDM_ADDR_BITS-1:0]:
\t\t\t\t\t\t\t  (PE1_LDM_ena_in & (PE1_LDM_addra_in[`D_LDM_BITS+`LDM_ADDR_BITS-1:`LDM_ADDR_BITS]==2)) ? PE1_LDM_addra_in[`LDM_ADDR_BITS-1:0]:
\t\t\t\t\t\t\t  (CTRL_LDM_ena_in & (CTRL_LDM_addra_in[`S_LDM_BITS+`LDM_ADDR_BITS-1:`LDM_ADDR_BITS]==2)) ? CTRL_LDM_addra_in[`LDM_ADDR_BITS-1:0]: 0;
\tassign LDM2_dina_wr \t= (PE1_LDM_addra_in[`D_LDM_BITS+`LDM_ADDR_BITS-1:`LDM_ADDR_BITS]==2) ? PE1_LDM_dina_in: 0;

\tassign LDM2_enb_wr \t\t= (ALU_LDM_enb_in & (ALU_LDM_addrb_in[`D_LDM_BITS+`LDM_ADDR_BITS-1:`LDM_ADDR_BITS]==2)) ? ALU_LDM_enb_in:
\t\t\t\t\t\t\t  (CTRL_LDM_enb_in & (CTRL_LDM_addrb_in[`S_LDM_BITS+`LDM_ADDR_BITS-1:`LDM_ADDR_BITS]==2)) ? CTRL_LDM_enb_in: 0;
\tassign LDM2_web_wr \t\t= (ALU_LDM_enb_in & (ALU_LDM_addrb_in[`D_LDM_BITS+`LDM_ADDR_BITS-1:`LDM_ADDR_BITS]==2)) ? ALU_LDM_web_in: 0;
\tassign LDM2_addrb_wr \t= (ALU_LDM_enb_in & (ALU_LDM_addrb_in[`D_LDM_BITS+`LDM_ADDR_BITS-1:`LDM_ADDR_BITS]==2)) ? ALU_LDM_addrb_in[`LDM_ADDR_BITS-1:0]: 
\t\t\t\t\t\t\t  (CTRL_LDM_enb_in & (CTRL_LDM_addrb_in[`S_LDM_BITS+`LDM_ADDR_BITS-1:`LDM_ADDR_BITS]==2)) ? CTRL_LDM_addrb_in[`LDM_ADDR_BITS-1:0]: 0;
\tassign LDM2_dinb_wr \t= ALU_LDM_dinb_in;

//------- LDM3 -------//
\tassign LDM3_ena_wr \t\t= (CFG_in == `EXE_ADD) ? CTRL_LDM_ena_in: (AXI_LDM_ena_in & (AXI_LDM_addra_in[`LDM_NUM_BITS+`LDM_ADDR_BITS-1:`LDM_ADDR_BITS]==3)) ? AXI_LDM_ena_in:
\t\t\t\t\t\t\t (PE1_LDM_ena_in & (PE1_LDM_addra_in[`D_LDM_BITS+`LDM_ADDR_BITS-1:`LDM_ADDR_BITS]==3)) ? PE1_LDM_ena_in:
\t\t\t\t\t\t\t (CTRL_LDM_ena_in & (CTRL_LDM_addra_in[`S_LDM_BITS+`LDM_ADDR_BITS-1:`LDM_ADDR_BITS]==3)) ? CTRL_LDM_ena_in : 0;
\tassign LDM3_wea_wr \t\t= (PE1_LDM_addra_in[`D_LDM_BITS+`LDM_ADDR_BITS-1:`LDM_ADDR_BITS]==3) ? PE1_LDM_wea_in: 0;
\tassign LDM3_addra_wr \t= (CFG_in == `EXE_ADD) ? CTRL_LDM_addra_in: (AXI_LDM_ena_in & (AXI_LDM_addra_in[`LDM_NUM_BITS+`LDM_ADDR_BITS-1:`LDM_ADDR_BITS]==3)) ? AXI_LDM_addra_in[`LDM_ADDR_BITS-1:0]:
\t\t\t\t\t\t     (PE1_LDM_ena_in & (PE1_LDM_addra_in[`D_LDM_BITS+`LDM_ADDR_BITS-1:`LDM_ADDR_BITS]==3)) ? PE1_LDM_addra_in[`LDM_ADDR_BITS-1:0]:
\t\t\t\t\t\t     (CTRL_LDM_ena_in & (CTRL_LDM_addra_in[`S_LDM_BITS+`LDM_ADDR_BITS-1:`LDM_ADDR_BITS]==3)) ? CTRL_LDM_addra_in[`LDM_ADDR_BITS-1:0] : 0;
\tassign LDM3_dina_wr \t= (PE1_LDM_addra_in[`D_LDM_BITS+`LDM_ADDR_BITS-1:`LDM_ADDR_BITS]==3) ? PE1_LDM_dina_in: 0;
\tassign LDM3_enb_wr \t\t= (ALU_LDM_enb_in & (ALU_LDM_addrb_in[`D_LDM_BITS+`LDM_ADDR_BITS-1:`LDM_ADDR_BITS]==3)) ? ALU_LDM_enb_in:
\t\t\t\t\t\t\t  (CTRL_LDM_enb_in & (CTRL_LDM_addrb_in[`S_LDM_BITS+`LDM_ADDR_BITS-1:`LDM_ADDR_BITS]==3)) ? CTRL_LDM_enb_in: 0;
\tassign LDM3_web_wr \t\t= (ALU_LDM_enb_in & (ALU_LDM_addrb_in[`D_LDM_BITS+`LDM_ADDR_BITS-1:`LDM_ADDR_BITS]==3)) ? ALU_LDM_web_in: 0;
\tassign LDM3_addrb_wr \t= (ALU_LDM_enb_in & (ALU_LDM_addrb_in[`D_LDM_BITS+`LDM_ADDR_BITS-1:`LDM_ADDR_BITS]==3)) ? ALU_LDM_addrb_in[`LDM_ADDR_BITS-1:0]: 
\t\t\t\t\t\t\t  (CTRL_LDM_enb_in & (CTRL_LDM_addrb_in[`S_LDM_BITS+`LDM_ADDR_BITS-1:`LDM_ADDR_BITS]==3)) ? CTRL_LDM_addrb_in[`LDM_ADDR_BITS-1:0]: 0;
\tassign LDM3_dinb_wr \t= ALU_LDM_dinb_in;

"""

for filename in files_to_update:
    if os.path.exists(filename):
        with open(filename, 'r') as f:
            content = f.read()

        # Thêm ngõ vào PE1
        if "///*** From the ALU (PEA 1) ***///" not in content:
            content = content.replace("\t///*** From the ALU ***///", pe1_inputs)
            
        # Thay thế khối LDM logic
        start_marker = "//------- LDM0 -------//"
        end_marker = "/// BRAM 16-bit x 64"
        
        if start_marker in content and end_marker in content:
            before_ldm = content.split(start_marker)[0]
            after_ldm = content.split(end_marker)[1]
            new_content = before_ldm + new_ldm_logic + end_marker + after_ldm
            
            with open(filename, 'w') as f:
                f.write(new_content)
            print(f"Đã cập nhật thành công file: {filename}")
        else:
            print(f"Không tìm thấy cấu trúc LDM trong file {filename}")
    else:
        print(f"Lỗi: Không tìm thấy file {filename}")