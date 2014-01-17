`include "nettype.h"
`include "global_config.h"
`include "stddef.h"
`include "timescale.h"

`include "cpu.h"



module gpr_tb();
	reg clk;
	reg reset;
	reg [`REG_ADDR_BUS] r_addr0;
	reg [`REG_ADDR_BUS] r_addr1;
	wire [`WORD_DATA_BUS] r_data0;
	wire [`WORD_DATA_BUS] r_data1;
	reg we_;
	reg [`REG_ADDR_BUS] w_addr;
	reg [`WORD_DATA_BUS] w_data;
	integer i;

	always #(1) begin
		clk <= ~clk;
	end

	gpr gpr(
		.clk(clk), .reset(reset),
		.r_addr0(r_addr0), .r_addr1(r_addr1),
		.r_data0(r_data0), .r_data1(r_data1),
		.we_(we_), 
		.w_addr(w_addr), .w_data(w_data)
		);

	initial begin

		#0 begin
			clk 		<= 1'b0;
			reset 		<= `RESET_DISABLE;
			r_addr0		<= `REG_ADDR_W'h0;
			r_addr1 	<= `REG_ADDR_W'h0;
			we_ 		<= `DISABLE_;
			w_addr 		<= `REG_ADDR_W'h0;
			w_data 		<= `WORD_DATA_W'h0;
		end

		#1 begin
			reset 	<= `RESET_ENABLE;
		end

		#1 begin
			reset 	<= `RESET_DISABLE;
		end

		#1 begin
			for (i = 0 ; i < `REG_NUM; i = i + 1) begin
				#0 begin
					we_ 		<= 	`ENABLE_;
					w_addr 		<= 	i;
					w_data 		<= 	i+1;
				end
				#2 begin
					we_ 		<= `DISABLE_;
					r_addr0 	<= i;
					r_addr1 	<= i;
					
				end
			end
		end
	end




endmodule