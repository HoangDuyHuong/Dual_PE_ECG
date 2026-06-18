`timescale 1ns/1ns
`include "common.vh"

module ALU_tb;

    reg                                 CLK;
    reg                                 RST;
    reg                                 En_in;
    reg signed [`ALU_CFG_BITS-1:0]      CFG_in;

    reg                                 S0_valid_in;
    reg signed [`WORD_BITS-1:0]         S0_in;

    reg                                 S1_valid_in;
    reg signed [`WORD_BITS-1:0]         S1_in;

    reg                                 S2_valid_in;
    reg signed [`WORD_BITS-1:0]         S2_in;

    wire signed [`WORD_BITS-1:0]        D0_out;
    wire                                Valid_out;

    integer pass_count;
    integer fail_count;
    integer total_count;

    localparam FRAC_BITS = 6;

    // ==================================================
    // DUT: GIU NGUYEN KIEU GOI MODULE NHU CODE TAC GIA
    // ==================================================
    ALU uut (
        .CLK(CLK),
        .RST(RST),
        .En_in(En_in),
        .CFG_in(CFG_in),

        .S0_valid_in(S0_valid_in),
        .S0_in(S0_in),

        .S1_valid_in(S1_valid_in),
        .S1_in(S1_in),

        .S2_valid_in(S2_valid_in),
        .S2_in(S2_in),

        .D0_out(D0_out),
        .Valid_out(Valid_out)
    );

    // ==================================================
    // CLOCK 100 MHz
    // ==================================================
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

    // ==================================================
    // CHUYEN DOI FIXED POINT Q6 <-> SO THAP PHAN
    // ==================================================
    function signed [`WORD_BITS-1:0] to_fixed;
        input real value;
        begin
            to_fixed = $rtoi(value * (1 << FRAC_BITS));
        end
    endfunction

    function real to_real;
        input signed [`WORD_BITS-1:0] value;
        begin
            to_real = $itor(value) / (1 << FRAC_BITS);
        end
    endfunction

    // ==================================================
    // KIEM TRA VA IN KET QUA
    // ==================================================
    task check_result;
        input [8*64-1:0] test_name;
        input signed [`ALU_CFG_BITS-1:0] cfg_value;
        input real s0_value;
        input real s1_value;
        input real s2_value;
        input signed [`WORD_BITS-1:0] expected_value;

        begin
            total_count = total_count + 1;

            $display("--------------------------------------------------");
            $display("[TEST %0d] %0s", total_count, test_name);
            $display("ALU CFG    = %0d", cfg_value);
            $display("S0 input   = %0f | raw = %0d | hex = %h",
                     s0_value, to_fixed(s0_value), to_fixed(s0_value));
            $display("S1 input   = %0f | raw = %0d | hex = %h",
                     s1_value, to_fixed(s1_value), to_fixed(s1_value));
            $display("S2 input   = %0f | raw = %0d | hex = %h",
                     s2_value, to_fixed(s2_value), to_fixed(s2_value));

            $display("Expected   = %0f | raw = %0d | hex = %h",
                     to_real(expected_value), expected_value, expected_value);
            $display("D0_out     = %0f | raw = %0d | hex = %h",
                     to_real(D0_out), D0_out, D0_out);
            $display("Valid_out  = %0d", Valid_out);

            if ((Valid_out == 1'b1) && (D0_out === expected_value)) begin
                $display("RESULT     = PASS");
                pass_count = pass_count + 1;
            end
            else begin
                $display("RESULT     = FAIL");
                fail_count = fail_count + 1;
            end
        end
    endtask

    // ==================================================
    // CAP INPUT CHO ALU
    // ==================================================
    task apply_input;
        input signed [`ALU_CFG_BITS-1:0] cfg_value;
        input real s0_value;
        input real s1_value;
        input real s2_value;

        begin
            @(posedge CLK);
            CFG_in      <= cfg_value;
            En_in       <= 1'b1;

            S0_valid_in <= 1'b1;
            S1_valid_in <= 1'b1;
            S2_valid_in <= 1'b1;

            S0_in       <= to_fixed(s0_value);
            S1_in       <= to_fixed(s1_value);
            S2_in       <= to_fixed(s2_value);
        end
    endtask

    // ==================================================
    // DUA INPUT VE NOP
    // ==================================================
    task clear_input;
        begin
            @(posedge CLK);
            CFG_in      <= `EXE_NOP;
            En_in       <= 1'b1;

            S0_valid_in <= 1'b0;
            S1_valid_in <= 1'b0;
            S2_valid_in <= 1'b0;

            S0_in       <= 0;
            S1_in       <= 0;
            S2_in       <= 0;
        end
    endtask

    // ==================================================
    // TEST CASE
    // ==================================================
    initial begin
        pass_count  = 0;
        fail_count  = 0;
        total_count = 0;

        RST         = 1'b0;
        En_in       = 1'b0;
        CFG_in      = `EXE_NOP;

        S0_valid_in = 1'b0;
        S1_valid_in = 1'b0;
        S2_valid_in = 1'b0;

        S0_in       = 0;
        S1_in       = 0;
        S2_in       = 0;

        $display("==================================================");
        $display("BAT DAU MO PHONG TESTBENCH ALU");
        $display("Clock: 100 MHz, chu ky 10 ns");
        $display("Hien thi input/output theo so thap phan, raw va hex");
        $display("==================================================");

        // Reset
        #60;
        RST = 1'b1;
        #20;

        // ==================================================
        // TEST 1: EXE_ADD
        // Theo ALU goc, EXE_ADD su dung S0 va S2.
        // Chon output duong de tranh hien tuong X voi output am.
        // ==================================================
        apply_input(`EXE_ADD, 20.5, -20.5, 2.5);
        repeat(4) @(posedge CLK);
        #1;

        check_result(
            "EXE_ADD: S0 + S2",
            `EXE_ADD,
            20.5,
            -20.5,
            2.5,
            to_fixed(23.0)
        );

        clear_input();
        repeat(2) @(posedge CLK);

        // ==================================================
        // TEST 2: EXE_MAC
        // S0 * S1 + S2 = (-20.5) * (-2.5) + (-1.5) = 49.75
        // ==================================================
        apply_input(`EXE_MAC, -20.5, -2.5, -1.5);
        repeat(4) @(posedge CLK);
        #1;

        check_result(
            "EXE_MAC: S0 * S1 + S2",
            `EXE_MAC,
            -20.5,
            -2.5,
            -1.5,
            to_fixed(49.75)
        );

        clear_input();
        repeat(2) @(posedge CLK);

        // ==================================================
        // TEST 3: EXE_MP
        // Max Pooling: max(S0, S1, S2) = max(-25.5, -18.5, -2.5) = -2.5
        // ==================================================
        apply_input(`EXE_MP, -25.5, -18.5, -2.5);
        repeat(4) @(posedge CLK);
        #1;

        check_result(
            "EXE_MP: Max Pooling max(S0, S1, S2)",
            `EXE_MP,
            -25.5,
            -18.5,
            -2.5,
            to_fixed(-2.5)
        );

        clear_input();
        repeat(2) @(posedge CLK);

        // ==================================================
        // TONG KET
        // ==================================================
        $display("==================================================");
        $display("KET QUA TONG HOP TESTBENCH ALU");
        $display("TOTAL = %0d", total_count);
        $display("PASS  = %0d", pass_count);
        $display("FAIL  = %0d", fail_count);

        if (fail_count == 0)
            $display("FINAL RESULT: ALL TESTS PASSED");
        else
            $display("FINAL RESULT: TEST FAILED");

        $display("==================================================");

        #50;
        $stop;
    end

endmodule