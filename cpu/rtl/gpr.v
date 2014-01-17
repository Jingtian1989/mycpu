`include "nettype.h"
`include "global_config.h"
`include "stddef.h"
`include "timescale.h"

`include "cpu.h"

/* 通用寄存器：
 *		指令最大可以指定三个寄存器作为操作数，从其中两个寄存器读取值，
 *		然后向另外一个寄存器写入值，因此寄存器堆需要有两个读取端口和
 *		一个写入端口。
 */

module gpr(
	input wire clk, input wire reset,
	input wire [`REG_ADDR_BUS] r_addr0, output wire [`WORD_DATA_BUS] r_data0,
	input wire [`REG_ADDR_BUS] r_addr1, output wire [`WORD_DATA_BUS] r_data1,
	input wire we_,
	input wire [`REG_ADDR_BUS] w_addr, input wire [`WORD_DATA_BUS] w_data
 	);
	reg [`WORD_DATA_BUS] gprs[`REG_NUM - 1 : 0];
	integer i;
	assign r_data0 = we_ == `ENABLE_ && w_addr == r_addr0  ? 
		w_data : gprs[r_addr0];

	assign r_data1 = we_ == `ENABLE_ && w_addr == r_addr1  ?
		w_data : gprs[r_addr1];
	
	always @(posedge clk or `RESET_EDGE reset) begin
		if (reset == `RESET_ENABLE) begin
			for( i = 0; i < `REG_NUM; i = i + 1) begin
				gprs[i] <= `WORD_DATA_W'h0;
			end
		end else begin 
			if (we_ == `ENABLE_) begin
				gprs[w_addr] <= w_data;
			end
		end
	end
endmodule