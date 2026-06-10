`timescale 1ns / 1ns
`include "common.vh"

// =====================================================================
// DEBUG PREFIX THEO CONTEXT
// Chỉnh RUN_CTX_COUNT để chạy từ ctx1 đến ctx N.
// Ví dụ:
//   RUN_CTX_COUNT = 2  -> chạy ctx1..ctx2, dump output của ctx2
//   RUN_CTX_COUNT = 10 -> chạy ctx1..ctx10, dump output của ctx10
//   RUN_CTX_COUNT = 42 -> chạy full mạng, dump output của ctx42
// Lưu ý: số thứ tự ctx theo golden_manifest.csv là 1..42.
// =====================================================================
`define LDM_DEPTH        320
`define CRAM_FILE_DEPTH  42
`define RUN_CTX_COUNT    11
`define WRAM_DEPTH       6096
`define BRAM_DEPTH       196

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
    // CRAM array vẫn giữ đủ 42 dòng để $readmemh đ�?c full file không báo tràn.
    // Nhưng khi ghi vào DUT, chỉ ghi RUN_CTX_COUNT dòng đầu.
    reg [32:0] LDM  [0:`LDM_DEPTH-1];
    reg [63:0] CRAM [0:`CRAM_FILE_DEPTH-1];
    reg [32:0] WRAM [0:`WRAM_DEPTH-1];
    reg [32:0] BRAM [0:`BRAM_DEPTH-1];

    integer a;
    reg [15:0] address;
    integer i;

    reg [5:0] addr;
    reg [5:0] pe;
    integer outfile;
    integer infofile;
    integer ctx7_trace_file;

    // DEBUG prefix context
    reg [31:0] target_ctx_word;
    reg [4:0] target_n;
    reg [2:0] target_y;
    reg [2:0] target_alu_cfg;
    reg [1:0] target_d_ldm;
    reg [5:0] target_sa_ldm;
    reg [5:0] dump_addr;
    integer rows_to_dump;
    integer out_count;

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

    // Watchdog để không chạy mãi nếu complete_out không lên
    initial begin
        #200000000;
        $display("[TIMEOUT] Simulation qua 200ms ma complete_out chua len. Kiem tra RUN_CTX_COUNT hoac controller.");
        $stop;
    end

    // =========================================================
    // CTX7 / Conv1D_5 / PEA0 PE39 TRACE
    // Mục tiêu: bắt đúng lỗi idx=159 của ctx7.
    // Giữ nguyên flow simulation chính, block này chỉ ghi CSV.
    // =========================================================
    initial begin
        ctx7_trace_file = $fopen("D:/HOC_TAP/KLTN/My_Proj/Advance_ECG/Model in C++/gen_mem/debug_ctx07_pe39_allcycles.csv", "w");
        if (ctx7_trace_file != 0) begin
            $fwrite(ctx7_trace_file, "time,ctx,cfg,en,layer_done,j,k,y,n,pad_read39,pad_state39,overarray,mp_pad,mp_pad2,mp_pad3,store0,waddr0,baddr0,wvalid0,bvalid0,weight0,bias0,spix0,v0,spix1,v1,spix2,v2,s0,s0v,s1,s1v,s2,s2v,d0,d0v,ldm_en,ldm_addr,ldm_data,pixel0_out,pixel0_out_valid,pixel1_out,pixel1_out_valid\n");
        end
    end

    always @(posedge CLK) begin
        if (RST && ctx7_trace_file != 0 && uut.CTX_wr == 32'hc0c3a858 && uut.En_wr) begin
            // Ghi tất cả chu kỳ active của ctx7 PE39 để tránh b�? sót MAC step cuối.
            $fwrite(ctx7_trace_file, "%0t,%08h,%0d,%0b,%0b,%0d,%0d,%0d,%0d,%0b,%0b,%0b,%0b,%0b,%0b,%02h,%0d,%0d,%0b,%0b,%04h,%04h,%04h,%0b,%04h,%0b,%04h,%0b,%04h,%0b,%04h,%0b,%04h,%0b,%04h,%0b,%0b,%02h,%04h,%04h,%0b,%04h,%0b\n",
                $time,
                uut.CTX_wr,
                uut.CFG_wr,
                uut.En_wr,
                uut.layer_done_wr,
                uut.controller.j_count_rg,
                uut.controller.k_count_rg,
                uut.controller.y_count_rg,
                uut.controller.n_count_rg,
                uut.Padding_Read_wr[39],
                uut.pea0_39.Padding_Read_state_wr,
                uut.Overarray_wr,
                uut.MP_Padding_wr,
                uut.MP_Padding_2_wr,
                uut.MP_Padding_3_wr,
                uut.CTRL_LDM_Store_wr,
                uut.CTRL_WRAM_addrb_0_wr,
                uut.CTRL_BRAM_addrb_0_wr,
                uut.Weight_valid_2_0_rg,
                uut.Bias_valid_2_0_rg,
                uut.Weight_0_rg,
                uut.Bias_0_rg,
                uut.Shared_Pixel_0_in_wr[39],
                uut.Shared_Pixel_0_valid_in_wr[39],
                uut.Shared_Pixel_1_in_wr[39],
                uut.Shared_Pixel_1_valid_in_wr[39],
                uut.Shared_Pixel_2_in_wr[39],
                uut.Shared_Pixel_2_valid_in_wr[39],
                uut.pea0_39.S0_wr,
                uut.pea0_39.S0_valid_wr,
                uut.pea0_39.S1_wr,
                uut.pea0_39.S1_valid_wr,
                uut.pea0_39.S2_wr,
                uut.pea0_39.S2_valid_wr,
                uut.pea0_39.D0_wr,
                uut.pea0_39.D0_valid_wr,
                uut.pea0_39.ALU_LDM_enb_wr,
                uut.pea0_39.ALU_LDM_addrb_wr,
                uut.pea0_39.ALU_LDM_dinb_wr,
                uut.Pixel_0_out_wr[39],
                uut.Pixel_0_valid_out_wr[39],
                uut.Pixel_1_out_wr[39],
                uut.Pixel_1_valid_out_wr[39]
            );
        end
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

        if (`RUN_CTX_COUNT < 1 || `RUN_CTX_COUNT > `CRAM_FILE_DEPTH) begin
            $display("[ERROR] RUN_CTX_COUNT phai nam trong khoang 1..%0d", `CRAM_FILE_DEPTH);
            $stop;
        end

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

            $display(">>> HOAN TAT NAP TOAN BO FILE BO NHO. BAT DAU MO PHONG PREFIX CTX...\n");
        end

        // Decode context cuối của prefix để sau complete dump đúng bank/vùng LDM
        target_ctx_word = CRAM[`RUN_CTX_COUNT-1][31:0];
        target_n       = target_ctx_word[29:25];
        target_y       = target_ctx_word[24:22];
        target_alu_cfg = target_ctx_word[13:11];
        target_d_ldm   = target_ctx_word[7:6];
        target_sa_ldm  = target_ctx_word[5:0];

        if (target_alu_cfg[1:0] == `EXE_MAC) begin
            rows_to_dump = (target_n + 1) * 2 * (target_y + 1);
        end else begin
            rows_to_dump = (target_n + 1) * (target_y + 1);
        end

        $display("[PREFIX] RUN_CTX_COUNT=%0d", `RUN_CTX_COUNT);
        $display("[PREFIX] target_ctx_word=%08h n=%0d y=%0d alu_cfg=%0d d_ldm=%0d sa=%0d rows=%0d length=%0d",
                 target_ctx_word, target_n, target_y, target_alu_cfg, target_d_ldm, target_sa_ldm, rows_to_dump, rows_to_dump*40);

        infofile = $fopen("D:/HOC_TAP/KLTN/My_Proj/Advance_ECG/Model in C++/gen_mem/prefix_ctx_info.txt", "w");
        if (infofile != 0) begin
            $fwrite(infofile, "RUN_CTX_COUNT=%0d\n", `RUN_CTX_COUNT);
            $fwrite(infofile, "target_ctx_word=%08h\n", target_ctx_word);
            $fwrite(infofile, "n=%0d\n", target_n);
            $fwrite(infofile, "y=%0d\n", target_y);
            $fwrite(infofile, "alu_cfg=%0d\n", target_alu_cfg);
            $fwrite(infofile, "d_ldm=%0d\n", target_d_ldm);
            $fwrite(infofile, "sa_ldm=%0d\n", target_sa_ldm);
            $fwrite(infofile, "rows_to_dump=%0d\n", rows_to_dump);
            $fwrite(infofile, "length=%0d\n", rows_to_dump*40);
            $fclose(infofile);
        end

        // Write to Local Data Memory (LDM)
        for (i = 0; i < `LDM_DEPTH; i = i + 1) begin
            AXI_LDM_addra_in <= {LDM[i][`PE_NUM_BITS+`WORD_BITS-1:`WORD_BITS], 2'd0, LDM[i][`PE_NUM_BITS+`LDM_ADDR_BITS+`WORD_BITS-1:`WORD_BITS+`PE_NUM_BITS]};
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
        // Chỉ ghi RUN_CTX_COUNT context đầu vào DUT.
        // Vì CNN_1D_Core lấy CTX_maxaddra_rg từ địa chỉ CRAM cuối được ghi,
        // complete_out sẽ lên sau khi chạy xong đúng ctx RUN_CTX_COUNT.
        for (i = 0; i < `RUN_CTX_COUNT; i = i + 1) begin
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

        outfile = $fopen("D:/HOC_TAP/KLTN/My_Proj/Advance_ECG/Model in C++/gen_mem/output.txt", "w");
        if (outfile == 0) begin
            $display("[ERROR] KHONG THE MO output.txt");
            $stop;
        end

        wait (complete_out == 1'b1);
        #1000;

        // Dump output của context cuối trong prefix.
        // Format giữ giống file cũ: mỗi dòng chỉ có 16-bit hex data.
        out_count = 0;
        for (addr = 0; addr < rows_to_dump; addr = addr + 1) begin
            dump_addr = target_sa_ldm + addr[5:0];
            for (pe = 0; pe < 40; pe = pe + 1) begin
                AXI_LDM_addra_in <= {pe[5:0], target_d_ldm, dump_addr};
                AXI_LDM_ena_in <= 1'b1;
                AXI_LDM_wea_in <= 1'b0;
                #10;

                if (out_count != 0) begin
                    $fwrite(outfile, "%04h\n", AXI_LDM_douta_out);
                end
                out_count = out_count + 1;
            end
        end

        #10;
        $fwrite(outfile, "%04h\n", AXI_LDM_douta_out);
        AXI_LDM_ena_in <= 1'b0;
        AXI_LDM_wea_in <= 1'b0;
        $fclose(outfile);

        if (ctx7_trace_file != 0) begin
            $fclose(ctx7_trace_file);
        end

        $display("[DONE] Da chay xong prefix ctx %0d va dump %0d phan tu vao output.txt", `RUN_CTX_COUNT, rows_to_dump*40);
        $display("Simulation complete.");
        $stop;
    end
endmodule
