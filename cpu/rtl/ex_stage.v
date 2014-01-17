`include "nettype.h"
`include "global_config.h"
`include "stddef.h"
`include "timescale.h"

`include "isa.h"
`include "cpu.h"

module ex_stage(
	input wire [`WORD_ADDR_BUS] id_pc, input wire id_en_,
	input wire [`ALU_OP_BUS] id_alu_op, input wire [`WORD_DATA_BUS] id_alu_in_0,
	input wire [`WORD_DATA_BUS] id_alu_in_1,
	input wire id_br_flag, input wire [`MEM_OP_BUS] id_mem_op, input wire [`WORD_DATA_BUS]id_mem_wr_data,
	input wire [`CTRL_OP_BUS] id_ctrl_op, input wire [`REG_ADDR_BUS] id_dst_addr, input wire id_gpr_we_,
	input wire [`ISA_EXP_BUS] id_exp_code,

	input wire clk, input wire reset, input wire int_detect, input wire stall,
	input wire flush,

	output wire [`WORD_ADDR_BUS] ex_pc, output wire ex_en_, output wire ex_br_flag,
	output wire [`MEM_OP_BUS] ex_mem_op, output wire [`WORD_DATA_BUS] ex_mem_wr_data,
	output wire [`CTRL_OP_BUS] ex_ctrl_op, 
	output wire [`REG_ADDR_BUS] ex_dst_addr,output wire ex_gpr_we_, output wire [`ISA_EXP_BUS] ex_exp_code,
	output wire [`WORD_DATA_BUS] ex_out,
	output wire [`WORD_DATA_BUS] ex_fwd_data
	);

	wire [`WORD_DATA_BUS] alu_out;
	wire alu_of;
	assign ex_fwd_data = alu_out;
	alu alu(
		.in_0(id_alu_in_0), .in_1(id_alu_in_1), .op(id_alu_op),
		.out(alu_out), .of(alu_of) 
		);
	ex_reg ex_reg(
		.clk(clk), .reset(reset),
		.alu_out(alu_out), .alu_of(alu_of),
		.stall(stall), .flush(flush), .int_detect(int_detect),
		.id_pc(id_pc), .id_en_(id_en_), 
		.id_br_flag(id_br_flag), 
		.id_mem_op(id_mem_op), .id_mem_wr_data(id_mem_wr_data),
		.id_ctrl_op(id_ctrl_op), .id_dst_addr(id_dst_addr),
		.id_gpr_we_(id_gpr_we_), .id_exp_code(id_exp_code),
		
		.ex_pc(ex_pc), .ex_en_(ex_en_), .ex_br_flag(ex_br_flag),
		.ex_mem_op(ex_mem_op), .ex_mem_wr_data(ex_mem_wr_data),
		.ex_ctrl_op(ex_ctrl_op), 
		.ex_dst_addr(ex_dst_addr), .ex_gpr_we_(ex_gpr_we_), .ex_exp_code(ex_exp_code),
		.ex_out(ex_out)
		);

endmodule