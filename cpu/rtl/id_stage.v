`include "nettype.h"
`include "global_config.h"
`include "stddef.h"
`include "timescale.h"

`include "isa.h"
`include "spm.h"
`include "bus.h"
`include "cpu.h"


module id_stage(

	/*	if/id stream line registers	*/
	input if_en_, input wire [`WORD_ADDR_BUS] if_pc, input wire [`WORD_DATA_BUS] if_insn,

	/*	general registers interface	*/
	input wire [`WORD_DATA_BUS] gpr_rd_data_0, input wire [`WORD_DATA_BUS] gpr_rd_data_1,
	output wire [`REG_ADDR_BUS] gpr_rd_addr_0, output wire [`REG_ADDR_BUS] gpr_rd_addr_1,

	/*	control registers	*/
	input wire exe_mode, input wire [`WORD_DATA_BUS] creg_rd_data, output wire [`REG_ADDR_BUS] creg_rd_addr,
	
	/*	ex data forwarding	*/
	input wire [`WORD_DATA_BUS] ex_fwd_data,

	/*	mem data forwarding	*/
	input wire ex_en_, input wire [`REG_ADDR_BUS] ex_dst_addr, input wire ex_gpr_we_,  
	input wire [`WORD_DATA_BUS] mem_fwd_data,

	/*	branch registers	*/
 	output wire [`WORD_ADDR_BUS] br_addr, output wire br_taken, output wire ld_hazard

	input wire clk, input wire reset, input wire stall, input wire flush, 

	/*	id stream registers	*/
	output wire id_en_, output wire [`REG_ADDR_BUS] id_dst_addr, output wire id_gpr_we_,output wire [`MEM_OP_BUS] id_mem_op, 
	output wire [`WORD_ADDR_BUS] id_pc, 
	output wire [`ALU_OP_BUS] id_alu_op, output wire [`WORD_DATA_BUS] id_alu_in_0, output wire [`WORD_DATA_BUS] id_alu_in_1,
	output wire id_br_flag,  output wire [`WORD_DATA_BUS] id_mem_wr_data, output wire [`CTRL_OP_BUS] id_ctrl_op, 
	output wire [`ISA_EXP_BUS] id_exp_code
	);

	wire [`ALU_OP_BUS] alu_op;
	wire [`WORD_DATA_BUS] alu_in_0;
	wire [`WORD_DATA_BUS] alu_in_1;
	wire br_flag;
	wire [`MEM_OP_BUS] mem_op;
	wire [`WORD_DATA_BUS] mem_wr_data;
	wire [`CTRL_OP_BUS] ctrl_op;
	wire [`REG_ADDR_BUS] dst_addr;
	wire gpr_we_;
	wire [`ISA_EXP_BUS] exp_code;

	decoder decoder(
		.if_pc(if_pc), .if_insn(if_insn), 
		.gpr_rd_data_0(gpr_rd_data_0), .gpr_rd_data_1(gpr_rd_data_1),
		.gpr_rd_addr_0(gpr_rd_addr_0), .gpr_rd_addr_1(gpr_rd_addr_1), 
		.id_en_(id_en_), .id_dst_addr(id_dst_addr), .id_gpr_we_(id_gpr_we_), .ex_fwd_data(ex_fwd_data),
		.ex_en_(ex_en_), .ex_dst_addr(ex_dst_addr), .ex_gpr_we_(ex_gpr_we_), .mem_fwd_data(mem_fwd_data),
		
		.exe_mode(exe_mode), .creg_rd_data(creg_rd_data), .creg_rd_addr(creg_rd_addr),
		.id_mem_op(id_mem_op), 
		.alu_op(alu_op), .alu_in_0(alu_in_0), .alu_in_1(alu_in_1), 
		.br_addr(br_addr), .br_taken(br_taken), .br_flag(br_flag),
		.mem_op(mem_op), .mem_wr_data(mem_wr_data), 
		.ctrl_op(ctrl_op), .dst_addr(dst_addr), .gpr_we_(gpr_we_)
		.exp_code(exp_code), .ld_hazard(ld_hazard)
		);

	id_reg id_reg(
		.clk(clk), .reset(reset),
		.alu_op(alu_op), .alu_in_0(alu_in_0), .alu_in_1(alu_in_1),
		.br_flag(br_flag),
		.mem_op(mem_op), .mem_wr_data(mem_wr_data),
		.ctrl_op(ctrl_op), .dst_addr(dst_addr),
		.gpr_we_(gpr_we_), .exp_code(exp_code),
		.stall(stall), .flush(flush),
		.if_pc(if_pc), .if_en_(if_en_),

		.id_pc(id_pc), .id_en_(id_en_), 
		.id_alu_op(id_alu_op), .id_alu_in_0(id_alu_in_0), .id_alu_in_1(id_alu_in_1),
		.id_br_flag(id_br_flag), .id_mem_op(id_mem_op), .id_mem_wr_data(id_mem_wr_data),
		.id_ctrl_op(id_ctrl_op), .id_dst_addr(id_dst_addr), .id_gpr_we_(id_gpr_we_),
		.id_exp_code(id_exp_code)
	);

endmodule 