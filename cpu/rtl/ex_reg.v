`include "nettype.h"
`include "global_config.h"
`include "stddef.h"
`include "timescale.h"

`include "isa.h"
`include "cpu.h"

module ex_reg(
	input wire clk, input wire reset,
	input wire [`WORD_DATA_BUS] alu_out, input wire alu_of,
	input wire stall, input wire flush, input wire int_detect,
	input wire [`WORD_ADDR_BUS] id_pc, input wire id_en_,
	input wire id_br_flag, 
	input wire [`MEM_OP_BUS] id_mem_op, input wire [`WORD_DATA_BUS] id_mem_wr_data,
	input wire [`CTRL_OP_BUS] id_ctrl_op, input wire [`REG_ADDR_BUS] id_dst_addr,
	input wire id_gpr_we_, input wire [`ISA_EXP_BUS] id_exp_code,

	output reg [`WORD_ADDR_BUS] ex_pc, output reg ex_en_, output reg ex_br_flag,
	output reg [`MEM_OP_BUS] ex_mem_op, output reg [`WORD_DATA_BUS] ex_mem_wr_data,
	output reg [`CTRL_OP_BUS] ex_ctrl_op, 
	output reg [`REG_ADDR_BUS] ex_dst_addr, output reg ex_gpr_we_, output reg [`ISA_EXP_BUS] ex_exp_code,
	output reg [`WORD_DATA_BUS] ex_out
	);

	always @(posedge clk or `RESET_EDGE reset) begin
		if (reset == `RESET_ENABLE) begin
			ex_pc 			<= `WORD_ADDR_W'h0;
			ex_en_ 			<= `DISABLE_;
			ex_br_flag 		<= `DISABLE;
			ex_mem_op 		<= `MEM_OP_NOP;
			ex_mem_wr_data 	<= `WORD_DATA_W'h0;
			ex_ctrl_op 		<= `CTRL_OP_NOP;
			ex_dst_addr		<= `REG_ADDR_W'd0;
			ex_gpr_we_ 		<= `DISABLE_;
			ex_exp_code 	<= `ISA_EXP_NO_EXP;
			ex_out 			<= `WORD_DATA_W'h0;
		end else begin
			if (stall == `DISABLE) begin
				if (flush == `ENABLE) begin
					ex_pc 			<= `WORD_ADDR_W'h0;
					ex_en_ 			<= `DISABLE_;
					ex_br_flag 		<= `DISABLE;
					ex_mem_op 		<= `MEM_OP_NOP;
					ex_mem_wr_data 	<= `WORD_DATA_W'h0;
					ex_ctrl_op 		<= `CTRL_OP_NOP;
					ex_dst_addr		<= `REG_ADDR_W'd0;
					ex_gpr_we_ 		<= `DISABLE_;
					ex_exp_code 	<= `ISA_EXP_NO_EXP;
					ex_out 			<= `WORD_DATA_W'h0;
				end else if (int_detect == `ENABLE) begin
					ex_pc 			<= id_pc;
					ex_en_ 			<= id_en_;
					ex_br_flag 		<= id_br_flag;
					ex_mem_op 		<= `MEM_OP_NOP;
					ex_mem_wr_data 	<= `WORD_DATA_W'h0;
					ex_ctrl_op 		<= `CTRL_OP_NOP;
					ex_dst_addr 	<= `REG_ADDR_W'd0;
					ex_gpr_we_ 		<= `DISABLE_;
					ex_exp_code 	<= `ISA_EXP_EXT_INT;
					ex_out 			<= `WORD_DATA_W'h0;
				end else if (alu_of == `ENABLE) begin
					ex_pc 			<= id_pc;
					ex_en_ 			<= id_en_;
					ex_br_flag 		<= id_br_flag;
					ex_mem_op 		<= `MEM_OP_NOP;
					ex_mem_wr_data 	<= `WORD_DATA_W'h0;
					ex_ctrl_op 		<= `CTRL_OP_NOP;
					ex_dst_addr 	<= `REG_ADDR_W'd0;
					ex_gpr_we_ 		<= `DISABLE_;
					ex_exp_code 	<= `ISA_EXP_OVERFLOW;
					ex_out 			<= `WORD_DATA_W'h0;
				end else begin
					ex_pc 			<= id_pc;
					ex_en_ 			<= id_en_;
					ex_br_flag 		<= id_br_flag;
					ex_mem_op 		<= id_mem_op;
					ex_mem_wr_data 	<= id_mem_wr_data;
					ex_ctrl_op 		<= id_ctrl_op;
					ex_dst_addr 	<= id_dst_addr;
					ex_gpr_we_ 		<= id_gpr_we_;
					ex_exp_code 	<= id_exp_code;
					ex_out 			<= alu_out;
				end
			end
		end
	end
endmodule