`include "nettype.h"
`include "global_config.h"
`include "stddef.h"
`include "timescale.h"

`include "cpu.h"
`include "isa.h"


/*
 *	stream line registers：
 *		if stage
 */
module if_reg(
	input wire clk, input wire reset, 
	input wire [`WORD_DATA_BUS] insn,
	input wire stall, input wire flush, input wire [`WORD_ADDR_BUS] new_pc,
	input wire br_taken, input wire [`WORD_ADDR_BUS] br_addr, 
	output reg [`WORD_ADDR_BUS] if_pc, output reg [`WORD_DATA_BUS] if_insn,
	output reg if_en_
	);
	always @(posedge clk or `RESET_EDGE reset) begin
		//async reset
		if (reset == `RESET_ENABLE) begin
			if_pc	<= `RESET_VECTOR;
			if_insn <= `ISA_NOP;
			if_en_	<= `DISABLE_;
		end else begin
			/*	update stream line registers	*/
			if (stall == `DISABLE) begin
				if(flush == `ENABLE) begin 					//flush registers
					if_pc 	<= new_pc;
					if_insn <= `ISA_NOP;
					if_en_	<= `DISABLE_;
				end else if (br_taken == `ENABLE) begin 	//handle branch
					if_pc	<= br_addr;
					if_insn	<= insn;
					if_en_	<= `ENABLE_;
				end else begin 								//increase program counter
					if_pc	<= if_pc + 1'd1;
					if_insn <= insn;
					if_en_	<= `ENABLE_;
				end
			end
		end
	end

endmodule