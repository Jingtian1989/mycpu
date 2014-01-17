`include "nettype.h"
`include "global_config.h"
`include "stddef.h"
`include "timescale.h"

`include "isa.h"
`include "spm.h"
`include "bus.h"
`include "cpu.h"

module if_stage(
	output wire busy, 
	input wire [`WORD_DATA_BUS] spm_rd_data, 
	output wire [`WORD_ADDR_BUS] spm_addr, output wire spm_as_, 
	output wire spm_rw, output wire [`WORD_DATA_BUS] spm_wr_data,

	input wire [`WORD_DATA_BUS] bus_rd_data, input wire bus_rdy_, input wire bus_grnt_,
	output wire bus_req_, output wire [`WORD_ADDR_BUS] bus_addr, output wire bus_as_,
	output wire bus_rw, output wire [`WORD_DATA_BUS] bus_wr_data,

	input wire clk, input wire reset, input wire stall, input wire flush,

	input wire [`WORD_ADDR_BUS] new_pc, 
	input wire br_taken, input wire [`WORD_ADDR_BUS] br_addr,
	output wire [`WORD_ADDR_BUS] if_pc, output wire [`WORD_DATA_BUS] if_insn,
	output wire if_en_ 
	); 

	wire rw 	= `READ;
	wire as_ 	= `ENABLE_;
	wire [`WORD_DATA_BUS] wr_data = `WORD_DATA_W'h0;
	wire [`WORD_DATA_BUS] insn;

	bus_if bus_if(
		.clk(clk), .reset(reset), 
		.stall(stall), .flush(flush), .busy(busy),

		.addr(if_pc), .as_(as_), .rw(rw), 
		.wr_data(wr_data), .rd_data(insn),

		.spm_rd_data(spm_rd_data),.spm_addr(spm_addr), 
		.spm_as_(spm_as_), .spm_rw(spm_rw), .spm_wr_data(spm_wr_data),

		.bus_rd_data(bus_rd_data), .bus_rdy_(bus_rdy_), .bus_grnt_(bus_grnt_),
		.bus_req_(bus_req_), .bus_addr(bus_addr), .bus_as_(bus_as_),
		.bus_rw(bus_rw), .bus_wr_data(bus_wr_data)
		);
	if_reg if_reg(
		.clk(clk), .reset(reset), 
		.insn(insn), 
		.stall(stall), .flush(flush), .new_pc(new_pc),
		.br_taken(br_taken), .br_addr(br_addr), 
		.if_pc(if_pc), .if_insn(if_insn), 
		.if_en_(if_en_)
		);

endmodule