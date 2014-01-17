`include "nettype.h"
`include "global_config.h"
`include "stddef.h"
`include "timescale.h"

`include "isa.h"
`include "cpu.h"


module mem_reg(
	input wire clk, input wire reset,
	input wire [`WORD_DATA_BUS] out, input wire miss_align,
	input wire stall, input wire flush,
	input wire ex_pc, input wire ex_en_, input wire ex_br_flag,
	input wire [`CTRL_OP_BUS] ex_ctrl_op, input wire [`REG_ADDR_BUS] ex_dst_addr,
	input wire ex_gpr_we_, input wire [`ISA_EXP_BUS] ex_exp_code,

	output reg [`WORD_ADDR_BUS] mem_pc, output reg mem_en_,
	output reg mem_br_flag, output reg [`CTRL_OP_BUS] mem_ctrl_op,
	output reg [`REG_ADDR_BUS] mem_dst_addr,
	output reg mem_gpr_we_, output reg [`ISA_EXP_BUS] mem_exp_code,
	output reg [`WORD_DATA_BUS] mem_out 
	);

	always @(posedge clk or `RESET_EDGE reset) begin
		if (reset) begin
			mem_pc 			<= `WORD_ADDR_W'h0;
			mem_en_ 		<= `DISABLE_;
			mem_br_flag 	<= `DISABLE;
			mem_ctrl_op 	<= `CTRL_OP_NOP;
			mem_dst_addr	<= `REG_ADDR_W'h0;
			mem_gpr_we_ 	<= `DISABLE_;
			mem_exp_code 	<= `ISA_EXP_NO_EXP;
			mem_out 		<= `WORD_DATA_W'h0;
		end else begin
			if (stall == `ENABLE) begin
				mem_pc 			<= `WORD_ADDR_W'h0;
				mem_en_ 		<= `DISABLE_;
				mem_br_flag 	<= `DISABLE;
				mem_ctrl_op 	<= `CTRL_OP_NOP;
				mem_dst_addr	<= `REG_ADDR_W'h0;
				mem_gpr_we_ 	<= `DISABLE_;
				mem_exp_code 	<= `ISA_EXP_NO_EXP;
				mem_out 		<= `WORD_DATA_W'h0;
			end else if (miss_align == `ENABLE) begin
				mem_pc 			<= ex_pc;
				mem_en_ 		<= ex_en_;
				mem_br_flag 	<= ex_br_flag;
				mem_ctrl_op 	<= `CTRL_OP_NOP;
				mem_dst_addr	<= `REG_ADDR_W'h0;
				mem_gpr_we_ 	<= `DISABLE_;
				mem_exp_code 	<= `ISA_EXP_MISS_ALIGN;
				mem_out 		<= `WORD_DATA_W'h0;
			end else begin
				mem_pc 			<= ex_pc;
				mem_en_ 		<= ex_en_;
				mem_br_flag 	<= ex_br_flag;
				mem_ctrl_op 	<= ex_ctrl_op;
				mem_dst_addr	<= ex_dst_addr;
				mem_gpr_we_ 	<= ex_gpr_we_;
				mem_exp_code 	<= ex_exp_code;
				mem_out 		<= out;
			end
		end
	end

endmodule