`include "nettype.h"
`include "global_config.h"
`include "stddef.h"
`include "timescale.h"

module if_reg_tb();
	reg clk;
	reg reset;
	reg [`WORD_DATA_BUS] insn;
	reg stall;
	reg flush;
	reg [`WORD_ADDR_BUS] new_pc;
	reg br_taken;
	reg [`WORD_ADDR_BUS] br_addr;

	wire [`WORD_ADDR_BUS] if_pc;
	wire [`WORD_DATA_BUS] if_insn;
	wire if_en_;

	if_reg if_reg(
		.clk(clk), .reset(reset), 
		.insn(insn), 
		.stall(stall), .flush(flush), .new_pc(new_pc),
		.br_taken(br_taken), .br_addr(br_addr),
		.if_pc(if_pc), .if_insn(if_insn),
		.if_en_(if_en_)
		);
	always #(1) begin
		clk 	<= ~clk;
	end

	initial begin
		#0 begin
			clk 		<= 1'b0;
			reset 		<= `RESET_DISABLE;
			insn 		<= `WORD_DATA_W'h0;
			stall 		<= `DISABLE;
			flush 		<= `DISABLE;
			new_pc 		<= `WORD_ADDR_W'h0;
			br_taken 	<= `DISABLE;
			br_addr 	<= `WORD_ADDR_W'h0;
		end

		#1 begin
			reset 		<= `RESET_ENABLE;
		end

		#1 begin
			reset 		<= `RESET_DISABLE;
		end

		#1  begin
			insn 		<= `WORD_DATA_W'h1;
			new_pc 		<= `WORD_DATA_W'h0;
			br_taken 	<= `ENABLE;
			br_addr 	<= `WORD_ADDR_W'h99;
		end

		#1 begin
			br_taken 	<= `DISABLE;
		end

		#1 begin
			insn 		<= `WORD_DATA_W'h2;
		end
	end
	


endmodule