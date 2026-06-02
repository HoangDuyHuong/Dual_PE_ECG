`include "common.vh"

// =========================================================
// MODULE 1: DÙNG CHO WRAM, BRAM, CRAM (Có chức năng Hold)
// =========================================================
module Dual_Port_RAM
#(
  parameter AWIDTH = 13, 
  parameter DWIDTH = 32 
)
(
  input clka, input ena, input wea, input [AWIDTH-1:0] addra, input [DWIDTH-1:0] dina, output reg [DWIDTH-1:0] douta,
  input clkb, input enb, input web, input [AWIDTH-1:0] addrb, input [DWIDTH-1:0] dinb, output reg [DWIDTH-1:0] doutb 
);

	(* ram_style = "block" *) reg [DWIDTH-1:0] mem [2**AWIDTH-1:0];
	
	// Khởi tạo RAM = 0 để diệt lỗi X ban đầu
	integer i;
	initial begin
		for (i = 0; i < 2**AWIDTH; i = i + 1) mem[i] = 0;
		douta = 0; doutb = 0;
	end

	always @(posedge clka) begin
		if (ena) begin
			if (wea) mem[addra] <= dina;
			douta <= mem[addra]; // Giữ nguyên giá trị cũ nếu ena = 0
		end
	end
	
	always @(posedge clkb) begin
		if (enb) begin
			if (web) mem[addrb] <= dinb;
			doutb <= mem[addrb]; // Giữ nguyên giá trị cũ nếu enb = 0
		end
	end
endmodule

// =========================================================
// MODULE 2: DÙNG CHO LDM (Có chức năng xuất 0 để dùng cho OR-Tree)
// =========================================================
module Dual_Port_RAM_2
#(
  parameter AWIDTH = 10, 
  parameter DWIDTH = 32  
)
(
  input clka, input ena, input wea, input [AWIDTH-1:0] addra, input [DWIDTH-1:0] dina, output [DWIDTH-1:0] douta,
  input clkb, input enb, input web, input [AWIDTH-1:0] addrb, input [DWIDTH-1:0] dinb, output [DWIDTH-1:0] doutb 
);

	(* ram_style = "block" *) reg [DWIDTH-1:0] mem [2**AWIDTH-1:0];
	reg [DWIDTH-1:0] rdata_a = 0;
	reg [DWIDTH-1:0] rdata_b = 0;
	
	// Thêm thanh ghi delay Enable để khớp với độ trễ 1 clock của BRAM
	reg ena_reg = 0;
	reg enb_reg = 0;

	integer i;
	initial begin
		for (i = 0; i < 2**AWIDTH; i = i + 1) mem[i] = 0;
	end

	always @(posedge clka) begin
		ena_reg <= ena; // Ghi nhớ trạng thái Enable
		if (ena) begin
			if (wea) mem[addra] <= dina;
			rdata_a <= mem[addra];
		end
	end
	
	always @(posedge clkb) begin
		enb_reg <= enb; // Ghi nhớ trạng thái Enable
		if (enb) begin
			if (web) mem[addrb] <= dinb;
			rdata_b <= mem[addrb];
		end
	end

	// Chỉ nhả dữ liệu ra nếu nhịp clock trước đó có kích hoạt Enable
	assign douta = ena_reg ? rdata_a : 0;
	assign doutb = enb_reg ? rdata_b : 0;

endmodule

// =========================================================
// MODULE 3: DÙNG CHO WRAM & BRAM CỦA TINA (1 Write, 2 Read)
// =========================================================
module Dual_Port_RAM_1W2R
#(
  parameter AWIDTH = 13, 
  parameter DWIDTH = 32 
)
(
  input clk,
  
  // --- Port AXI (Dùng để ARM nạp Weight/Bias ban đầu) ---
  input axi_we,
  input [AWIDTH-1:0] axi_addr,
  input [DWIDTH-1:0] axi_din,
  
  // --- Tín hiệu điều khiển chế độ ---
  // 0: Chế độ nạp data từ AXI
  // 1: Chế độ tính toán (Cấp 2 data cùng lúc cho PEA 0 và PEA 1)
  input compute_en, 
  
  // --- Port Read 0 (Cấp cho PEA 0 - Tính Channel n) ---
  input en_0,
  input [AWIDTH-1:0] addr_0,
  output reg [DWIDTH-1:0] dout_0,
  
  // --- Port Read 1 (Cấp cho PEA 1 - Tính Channel n+1) ---
  input en_1,
  input [AWIDTH-1:0] addr_1,
  output reg [DWIDTH-1:0] dout_1
);

	(* ram_style = "block" *) reg [DWIDTH-1:0] mem [2**AWIDTH-1:0];
	
	// Khởi tạo RAM
	integer i;
	initial begin
		for (i = 0; i < 2**AWIDTH; i = i + 1) mem[i] = 0;
		dout_0 = 0;
		dout_1 = 0;
	end

	// ---------------------------------------------------------
	// BỘ MUX CHO PORT A
	// ---------------------------------------------------------
	// Nếu compute_en = 0 (Đang nạp): wea lấy từ AXI, ena luôn bật, address lấy từ AXI
	// Nếu compute_en = 1 (Đang chạy): wea = 0 (chỉ đọc), ena lấy từ Controller, address lấy từ Controller
	wire wea = compute_en ? 1'b0 : axi_we;
	wire ena = compute_en ? en_0 : 1'b1; 
	wire [AWIDTH-1:0] addra = compute_en ? addr_0 : axi_addr;
	
	// Thực thi Port A (Xử lý MUX nội bộ)
	always @(posedge clk) begin
		if (ena) begin
			if (wea) mem[addra] <= axi_din;
			dout_0 <= mem[addra]; // Sẽ xuất Weight/Bias cho PEA 0 khi compute_en = 1
		end
	end
	
	// Thực thi Port B (Dành riêng cho PEA 1 đọc)
	always @(posedge clk) begin
		if (en_1) begin
			dout_1 <= mem[addr_1]; // Sẽ xuất Weight/Bias cho PEA 1
		end
	end

endmodule