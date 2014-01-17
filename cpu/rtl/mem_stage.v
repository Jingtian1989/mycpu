`include "nettype.h"
`include "global_config.h"
`include "stddef.h"
`include "timescale.h"

`include "isa.h"
`include "cpu.h"
`include "bus.h"
`include "spm.h"


module mem_stage(
	output wire busy, 
	input wire [`WORD_DATA_BUS] spm_rd_data, 
	output wire [`WORD_ADDR_BUS] spm_addr, output wire spm_as_, output wire spm_rw, 
	output wire [`WORD_DATA_BUS] spm_wr_data,

	input wire [`WORD_DATA_BUS] bus_rd_data, input wire bus_rdy_, input wire bus_grnt_
	output wire bus_req_, output wire [`WORD_ADDR_BUS] bus_addr, output wire bus_as_,
	output wire bus_rw, output wire [`WORD_DATA_BUS] bus_wr_data,

	input wire ex_en_, input wire [`CTRL_OP_BUS] ex_mem_op, input wire [`WORD_DATA_BUS] ex_mem_wr_data,
	input wire [`WORD_DATA_BUS] ex_out,
	input wire [`WORD_ADDR_BUS] ex_pc, input wire ex_br_flag, input wire [`CTRL_OP_BUS] ex_ctrl_op,
	input wire [`REG_ADDR_BUS] ex_dst_addr, input wire ex_gpr_we_, input wire [`ISA_EXP_BUS] ex_exp_code,

	input wire clk, input wire reset, input wire stall, input wire flush,

	output wire [`WORD_DATA_BUS] mem_fwd_data,

	output wire [`WORD_ADDR_BUS] mem_pc, output wire mem_en_, output wire mem_br_flag,
	output wire [`CTRL_OP_BUS] mem_ctrl_op, output wire [`REG_ADDR_BUS] mem_dst_addr,
	output wire [`ISA_EXP_BUS] mem_exp_code, output wire [`WORD_DATA_BUS] mem_out
	);
	wire [`WORD_ADDR_BUS] addr;
	wire as_;
	wire rw;
	wire [`WORD_DATA_BUS] wr_data;
	wire [`WORD_DATA_BUS] rd_data;
	wire [`WORD_DATA_BUS] out;
	wire miss_align;

	assign mem_fwd_data = out;

	bus_if bus_if(
		.clk(clk), .reset(reset), 
		.stall(stall), .flush(flush), .busy(busy),
		.addr(addr), .as_(as_), .rw(rw), wr_data(wr_data), rd_data(rd_data),
		
		.spm_rd_data(spm_rd_data), .spm_addr(spm_addr), .spm_as_(spm_as_), .spm_rw(spm_rw),
		.spm_wr_data(spm_wr_data), 
		
		.bus_rd_data(bus_rd_data), .bus_rdy_(bus_rdy_), .bus_grnt_(bus_grnt_),
		.bus_req_(bus_req_), .bus_addr(bus_addr), .bus_as_(bus_as_), 
		.bus_rw(bus_rw), .bus_wr_data(bus_wr_data)
		);
	mem_ctrl mem_ctrl(
		.ex_en_(ex_en_), .ex_mem_op(ex_mem_op), 
		.ex_mem_wr_data(ex_mem_wr_data), .ex_out(ex_out),
		.rd_data(rd_data), .addr(addr),  as_(as_), .rw(rw), .wr_data(wr_data), 
		.out(out), .miss_align(miss_align)
		);
	mem_reg mem_reg(
		.clk(clk), .reset(reset), 
		.out(out), .miss_align(miss_align), 
		.stall(stall), .flush(flush),
		.ex_pc(ex_pc), .ex_en_(ex_en_), .ex_br_flag(ex_br_flag),
		.ex_ctrl_op(ex_ctrl_op), .ex_dst_addr(ex_dst_addr),
		.ex_gpr_we_(ex_gpr_we_), .ex_exp_code(ex_exp_code),

		.mem_pc(mem_pc), .mem_en_(mem_en_), .mem_br_flag(mem_br_flag), 
		.mem_ctrl_op(mem_ctrl_op),.mem_dst_addr(mem_dst_addr),.mem_gpr_we_(mem_gpr_we_), 
		.mem_exp_code(mem_exp_code),.mem_out(mem_out)
		);

endmodule