`timescale 1ns / 1ns
`include "common.vh"

// =====================================================================
// [BẠN CẦN SỬA Ở ĐÂY] 
// Hãy mở các file .txt mới do code C sinh ra (phiên bản 40 PE), 
// đếm tổng số dòng trong mỗi file và điền vào các tham số DEPTH này:
// =====================================================================
`define		LDM_DEPTH   320
`define		CRAM_DEPTH  1
`define		WRAM_DEPTH  56
`define		BRAM_DEPTH  8

module TB_CNN_1D_Core();
    reg CLK;
    reg RST;
    
    // Input signals
    reg [`PE_NUM_BITS+`LDM_NUM_BITS+`LDM_ADDR_BITS-1:0] AXI_LDM_addra_in;
    reg signed [`WORD_BITS-1:0] AXI_LDM_dina_in;
    reg AXI_LDM_ena_in;
    reg AXI_LDM_wea_in;

    reg [`CRAM_ADDR_BITS-1:0] AXI_CRAM_addra_in;
    reg signed [`CTX_BITS-1:0] AXI_CRAM_dina_in;
    reg AXI_CRAM_ena_in;
    reg AXI_CRAM_wea_in;

    reg [`WRAM_ADDR_BITS-1:0] AXI_WRAM_addra_in;
    reg [`WORD_BITS-1:0] AXI_WRAM_dina_in;
    reg AXI_WRAM_ena_in;
    reg AXI_WRAM_wea_in;

    reg [`BRAM_ADDR_BITS-1:0] AXI_BRAM_addra_in;
    reg [`WORD_BITS-1:0] AXI_BRAM_dina_in;
    reg AXI_BRAM_ena_in;
    reg AXI_BRAM_wea_in;

    reg start_in;
    
    // Output signals
    wire signed [`WORD_BITS-1:0] AXI_LDM_douta_out;
    wire complete_out;
    
    // Memory initialization
    reg [32:0] LDM  [0:`LDM_DEPTH-1];
    reg [63:0] CRAM [0:`CRAM_DEPTH-1];
    reg [32:0] WRAM [0:`WRAM_DEPTH-1];
    reg [32:0] BRAM [0:`BRAM_DEPTH-1];
	
    integer a;    // Intermediate variable for address calculation
    reg [15:0] address;
    integer i;
    
    // [ĐÃ FIX] Khai báo 2 biến để quét LDM
    reg [5:0] addr;
    reg [5:0] pe;
    integer outfile, outfile2, outfile3; // Declare an integer for the file descriptor

    // Instantiate the CNN_1D_Core module
    CNN_1D_Core uut (
        .CLK(CLK),
        .RST(RST),
        .AXI_LDM_addra_in(AXI_LDM_addra_in),
        .AXI_LDM_dina_in(AXI_LDM_dina_in),
        .AXI_LDM_ena_in(AXI_LDM_ena_in),
        .AXI_LDM_wea_in(AXI_LDM_wea_in),
        .AXI_CRAM_addra_in(AXI_CRAM_addra_in),
        .AXI_CRAM_dina_in(AXI_CRAM_dina_in),
        .AXI_CRAM_ena_in(AXI_CRAM_ena_in),
        .AXI_CRAM_wea_in(AXI_CRAM_wea_in),
        .AXI_WRAM_addra_in(AXI_WRAM_addra_in),
        .AXI_WRAM_dina_in(AXI_WRAM_dina_in),
        .AXI_WRAM_ena_in(AXI_WRAM_ena_in),
        .AXI_WRAM_wea_in(AXI_WRAM_wea_in),
        .AXI_BRAM_addra_in(AXI_BRAM_addra_in),
        .AXI_BRAM_dina_in(AXI_BRAM_dina_in),
        .AXI_BRAM_ena_in(AXI_BRAM_ena_in),
        .AXI_BRAM_wea_in(AXI_BRAM_wea_in),
        .start_in(start_in),
        .AXI_LDM_douta_out(AXI_LDM_douta_out),
        .complete_out(complete_out)
    );
    
    // Clock generation
    initial begin
        CLK <= 1'b0;
        forever #5 CLK = ~CLK;  // 10ns clock period
    end

    // Simulation logic
    initial begin
        // Initialize inputs
        RST <= 1'b0;
        AXI_LDM_addra_in <= 0;
        AXI_LDM_dina_in <= 0;
        AXI_LDM_ena_in <= 0;
        AXI_LDM_wea_in <= 0;
        AXI_CRAM_addra_in <= 0;
        AXI_CRAM_dina_in <= 0;
        AXI_CRAM_ena_in <= 0;
        AXI_CRAM_wea_in <= 0;
        AXI_WRAM_addra_in <= 0;
        AXI_WRAM_dina_in <= 0;
        AXI_WRAM_ena_in <= 0;
        AXI_WRAM_wea_in <= 0;
        AXI_BRAM_addra_in <= 0;
        AXI_BRAM_dina_in <= 0;
        AXI_BRAM_ena_in <= 0;
        AXI_BRAM_wea_in <= 0;
        start_in <= 0;
		#40;
        
        // Write to Context RAM (CRAM)
        AXI_CRAM_addra_in <= 0;
        AXI_CRAM_dina_in <= 0;
        AXI_CRAM_ena_in <= 1'b0;
        AXI_CRAM_wea_in <= 1'b0;
        #10;
		
        // Reset sequence
        #60 RST <= 1'b1;
        #45
        // =========================================================
        // KIỂM TRA VÀ NẠP DỮ LIỆU TỪ FILE TXT
        // =========================================================
        begin : FILE_READ_BLOCK
            integer file_ldm, file_cram, file_wram, file_bram;
            
            // 1. Nạp LDM_File
            file_ldm = $fopen("D:/HOC_TAP/KLTN/My_Proj/Advance_ECG/Model in C++/gen_mem/LDM_File.txt", "r");
            if (file_ldm == 0) begin
                $display("\n=======================================================");
                $display("[ERROR] KHONG THE DOC FILE: LDM_File.txt");
                $display("Vui long kiem tra lai duong dan file!");
                $display("=======================================================\n");
                $stop;
            end else begin
                $display("[SUCCESS] Doc thanh cong LDM_File.txt");
                $fclose(file_ldm);
                $readmemh("D:/HOC_TAP/KLTN/My_Proj/Advance_ECG/Model in C++/gen_mem/LDM_File.txt", LDM);
            end

            // 2. Nạp CRAM_File
            file_cram = $fopen("D:/HOC_TAP/KLTN/My_Proj/Advance_ECG/Model in C++/gen_mem/CRAM_File.txt", "r");
            if (file_cram == 0) begin
                $display("\n=======================================================");
                $display("[ERROR] KHONG THE DOC FILE: CRAM_File.txt");
                $display("=======================================================\n");
                $stop;
            end else begin
                $display("[SUCCESS] Doc thanh cong CRAM_File.txt");
                $fclose(file_cram);
                $readmemh("D:/HOC_TAP/KLTN/My_Proj/Advance_ECG/Model in C++/gen_mem/CRAM_File.txt", CRAM);
            end

            // 3. Nạp WRAM_File
            file_wram = $fopen("D:/HOC_TAP/KLTN/My_Proj/Advance_ECG/Model in C++/gen_mem/WRAM_File.txt", "r");
            if (file_wram == 0) begin
                $display("\n=======================================================");
                $display("[ERROR] KHONG THE DOC FILE: WRAM_File.txt");
                $display("=======================================================\n");
                $stop;
            end else begin
                $display("[SUCCESS] Doc thanh cong WRAM_File.txt");
                $fclose(file_wram);
                $readmemh("D:/HOC_TAP/KLTN/My_Proj/Advance_ECG/Model in C++/gen_mem/WRAM_File.txt", WRAM);
            end

            // 4. Nạp BRAM_File
            file_bram = $fopen("D:/HOC_TAP/KLTN/My_Proj/Advance_ECG/Model in C++/gen_mem/BRAM_File.txt", "r");
            if (file_bram == 0) begin
                $display("\n=======================================================");
                $display("[ERROR] KHONG THE DOC FILE: BRAM_File.txt");
                $display("=======================================================\n");
                $stop;
            end else begin
                $display("[SUCCESS] Doc thanh cong BRAM_File.txt");
                $fclose(file_bram);
                $readmemh("D:/HOC_TAP/KLTN/My_Proj/Advance_ECG/Model in C++/gen_mem/BRAM_File.txt", BRAM);
            end
            
            $display(">>> HOAN TAT NAP TOAN BO BO NHO. BAT DAU MO PHONG...\n");
        end

        // Write to Local Data Memory (LDM)
        for (i = 0; i < `LDM_DEPTH; i = i + 1) begin
            AXI_LDM_addra_in <= {LDM[i][`PE_NUM_BITS+`WORD_BITS-1:`WORD_BITS],2'd0,LDM[i][`PE_NUM_BITS+`LDM_ADDR_BITS+`WORD_BITS-1:`WORD_BITS+`PE_NUM_BITS]};
            AXI_LDM_dina_in <= LDM[i][`WORD_BITS-1:0];
            AXI_LDM_ena_in <= 1'b1;
            AXI_LDM_wea_in <= 1'b1;
            #10;
        end
        AXI_LDM_ena_in <= 1'b0;
        AXI_LDM_wea_in <= 1'b0;

		#40;
        // Write to Write RAM (WRAM)
        for (i = 0; i < `WRAM_DEPTH; i = i + 1) begin
            AXI_WRAM_addra_in <= i;
            AXI_WRAM_dina_in <= WRAM[i][`WORD_BITS-1:0];
            AXI_WRAM_ena_in <= 1'b1;
            AXI_WRAM_wea_in <= 1'b1;
            #10;
        end
        AXI_WRAM_ena_in <= 1'b0;
        AXI_WRAM_wea_in <= 1'b0;
		
		#40;
        // Write to Broadcast RAM (BRAM)
        for (i = 0; i < `BRAM_DEPTH; i = i + 1) begin
            AXI_BRAM_addra_in <= i;
            AXI_BRAM_dina_in <= BRAM[i][`WORD_BITS-1:0];
            AXI_BRAM_ena_in <= 1'b1;
            AXI_BRAM_wea_in <= 1'b1;
            #10;
        end
        AXI_BRAM_ena_in <= 1'b0;
        AXI_BRAM_wea_in <= 1'b0;
		
		#40;
        // Write to Context RAM (CRAM)
        for (i = 0; i < `CRAM_DEPTH; i = i + 1) begin
            AXI_CRAM_addra_in <= i;
            AXI_CRAM_dina_in <= CRAM[i][`CTX_BITS-1:0];
            AXI_CRAM_ena_in <= 1'b1;
            AXI_CRAM_wea_in <= 1'b1;
            #10;
        end
        AXI_CRAM_ena_in <= 1'b0;
        AXI_CRAM_wea_in <= 1'b0;

        // Start the core
        #20 start_in <= 1'b1;
        #10 start_in <= 1'b0;

		// [ĐÃ FIX] Sử dụng outfile cho Session 1
		outfile = $fopen("D:/HOC_TAP/KLTN/My_Proj/Advance_ECG/Model in C++/gen_mem/output.txt", "w");
		
		wait (complete_out == 1'b1);
		#1000;
        
		for (addr = 0; addr < 32; addr = addr + 1) begin
			for (pe = 0; pe < 40; pe = pe + 1) begin
				AXI_LDM_addra_in <= {pe[5:0], 2'd3, addr[5:0]};
				AXI_LDM_ena_in <= 1'b1;
				AXI_LDM_wea_in <= 1'b0;
				#10;
				
				if (addr != 0 || pe != 0) begin
					$fwrite(outfile, "%04h\n", AXI_LDM_douta_out); // [ĐÃ FIX] Ghi đúng vào outfile
				end
			end
		end
		
		#10;
		$fwrite(outfile, "%04h\n", AXI_LDM_douta_out); // [ĐÃ FIX]
		AXI_LDM_ena_in <= 1'b0;
		$fclose(outfile);

		/////////////////next session 2
		#100;
		// Nạp lại dữ liệu ảnh vào LDM cho Session 2
        for (i = 0; i < `LDM_DEPTH; i = i + 1) begin
            AXI_LDM_addra_in <= {LDM[i][`PE_NUM_BITS+`WORD_BITS-1:`WORD_BITS],2'd0,LDM[i][`PE_NUM_BITS+`LDM_ADDR_BITS+`WORD_BITS-1:`WORD_BITS+`PE_NUM_BITS]};
            AXI_LDM_dina_in <= LDM[i][`WORD_BITS-1:0];
            AXI_LDM_ena_in <= 1'b1;
            AXI_LDM_wea_in <= 1'b1;
            #10;
        end
        AXI_LDM_ena_in <= 1'b0;
        AXI_LDM_wea_in <= 1'b0;
        
        #20 start_in <= 1'b1;
        #10 start_in <= 1'b0;

		outfile2 = $fopen("D:/HOC_TAP/KLTN/My_Proj/Advance_ECG/Model in C++/gen_mem/output2.txt", "w");
		
		wait (complete_out == 1'b1);
		#1000;
        
		for (addr = 0; addr < 32; addr = addr + 1) begin
			for (pe = 0; pe < 40; pe = pe + 1) begin
				AXI_LDM_addra_in <= {pe[5:0], 2'd3, addr[5:0]};
				AXI_LDM_ena_in <= 1'b1;
				AXI_LDM_wea_in <= 1'b0;
				#10;
				
				if (addr != 0 || pe != 0) begin
					$fwrite(outfile2, "%04h\n", AXI_LDM_douta_out);
				end
			end
		end
		
		#10;
		$fwrite(outfile2, "%04h\n", AXI_LDM_douta_out);
		AXI_LDM_ena_in <= 1'b0;
		$fclose(outfile2);

		/////////////////next session 3
		#100;
		// Nạp lại dữ liệu ảnh vào LDM cho Session 3
        for (i = 0; i < `LDM_DEPTH; i = i + 1) begin
            AXI_LDM_addra_in <= {LDM[i][`PE_NUM_BITS+`WORD_BITS-1:`WORD_BITS],2'd0,LDM[i][`PE_NUM_BITS+`LDM_ADDR_BITS+`WORD_BITS-1:`WORD_BITS+`PE_NUM_BITS]};
            AXI_LDM_dina_in <= LDM[i][`WORD_BITS-1:0];
            AXI_LDM_ena_in <= 1'b1;
            AXI_LDM_wea_in <= 1'b1;
            #10;
        end
        AXI_LDM_ena_in <= 1'b0;
        AXI_LDM_wea_in <= 1'b0;
        
        #20 start_in <= 1'b1;
        #10 start_in <= 1'b0;

		outfile3 = $fopen("D:/HOC_TAP/KLTN/My_Proj/Advance_ECG/Model in C++/gen_mem/output3.txt", "w");
		
		wait (complete_out == 1'b1);
		#1000;
        
		for (addr = 0; addr < 32; addr = addr + 1) begin
			for (pe = 0; pe < 40; pe = pe + 1) begin
				AXI_LDM_addra_in <= {pe[5:0], 2'd3, addr[5:0]};
				AXI_LDM_ena_in <= 1'b1;
				AXI_LDM_wea_in <= 1'b0;
				#10;
				
				if (addr != 0 || pe != 0) begin
					$fwrite(outfile3, "%04h\n", AXI_LDM_douta_out); // [ĐÃ FIX] Ghi đúng vào outfile3
				end
			end
		end
		
		#10;
		$fwrite(outfile3, "%04h\n", AXI_LDM_douta_out); // [ĐÃ FIX]
		AXI_LDM_ena_in <= 1'b0;
		$fclose(outfile3);
		
		$display("Simulation complete.");
        $stop;
    end
endmodule