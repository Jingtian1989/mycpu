`include "nettype.h"
`include "global_config.h"
`include "stddef.h"
`include "timescale.h"

`include "isa.h"
`include "spm.h"
`include "bus.h"
`include "cpu.h"

module if_stage_tb();
	wire busy;

	reg [`WORD_DATA_BUS] spm_rd_data;
	wire [`SPM_ADDR_BUS] spm_addr;
	wire spm_as_;
	wire spm_rw;
	wire [`WORD_DATA_BUS] spm_wr_data;

	reg [`WORD_DATA_BUS] bus_rd_data;
	reg bus_rdy_;
	reg bus_grnt_;
	wire bus_req_;
	wire [`WORD_ADDR_BUS] bus_addr;
	wire bus_as_;
	wire bus_rw;
	wire [`WORD_DATA_BUS] bus_wr_data;

	reg clk;
	reg reset;
	reg stall;
	reg flush;

	reg [`WORD_ADDR_BUS] new_pc;
	reg br_taken;
	reg [`WORD_ADDR_BUS] br_addr;
	wire [`WORD_ADDR_BUS] if_pc;
	wire [`WORD_DATA_BUS] if_insn;
	wire if_en_;

	always #(1) begin
		clk 	<= ~clk;
	end

	if_stage if_stage(
		.busy(busy), .spm_rd_data(spm_rd_data),
		.spm_addr(spm_addr), .spm_as_(spm_as_),
		.spm_rw(spm_rw), .spm_wr_data(spm_wr_data),

		.bus_rd_data(bus_rd_data), .bus_rdy_(bus_rdy_), .bus_grnt_(bus_grnt_),
		.bus_req_(bus_req_), .bus_addr(bus_addr), .bus_as_(bus_as_),
		.bus_rw(bus_rw), .bus_wr_data(bus_wr_data),

		.clk(clk), .reset(reset), .stall(stall), .flush(flush),

		.new_pc(new_pc),
		.br_taken(br_taken), .br_addr(br_addr),
		.if_pc(if_pc), .if_insn(if_insn),
		.if_en_(if_en_)
		);


	initial begin
		#0 begin
			spm_rd_data <= `WORD_DATA_W'h0;
			bus_rd_data <= `WORD_DATA_W'h0;
			bus_rdy_ 	<= `DISABLE_;
			bus_grnt_ 	<= `DISABLE_;

			clk 		<= 1'b0;
			reset 		<= `RESET_DISABLE;
			stall 		<= `DISABLE;
			flush 		<= `DISABLE;

			new_pc 		<=`WORD_ADDR_W'h0;
			br_taken 	<=`DISABLE;
			br_addr 	<=`WORD_ADDR_W'h0;

		end

		#1 begin
			reset 		<=`RESET_ENABLE;
		end

		#1 begin
			reset 		<=`RESET_DISABLE;
			spm_rd_data <=`WORD_DATA_W'h99;
			bus_rd_data <=`WORD_DATA_W'h98;
			new_pc 		<=`WORD_ADDR_W'h97;
			br_taken 	<=`DISABLE;
			br_addr 	<=`WORD_ADDR_W'h96;
		end

		#1 begin
			bus_grnt_ 	<=`ENABLE_;
		end

		#1 begin
			bus_rdy_ 	<=`ENABLE_;
		end
	end

endmodule


