`include "nettype.h"
`include "global_config.h"
`include "stddef.h"
`include "timescale.h"

`include "isa.h"
`include "spm.h"
`include "bus.h"
`include "cpu.h"


module bus_if_tb();
	reg clk;
	reg reset;
	reg stall;
	reg flush;
	wire busy;

	reg [`WORD_ADDR_BUS] addr;
	reg as_;
	reg rw;
	reg [`WORD_DATA_BUS] wr_data;
	wire [`WORD_DATA_BUS] rd_data;

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


	bus_if bus_if(
		.clk(clk), .reset(reset),
		.stall(stall), .flush(flush), .busy(busy),
		
		.addr(addr), .as_(as_), .rw(rw),
		.wr_data(wr_data), .rd_data(rd_data),

		.spm_rd_data(spm_rd_data), .spm_addr(spm_addr),
		.spm_as_(spm_as_), .spm_rw(spm_rw), .spm_wr_data(spm_wr_data),

		.bus_rd_data(bus_rd_data), .bus_rdy_(bus_rdy_), .bus_grnt_(bus_grnt_),
		.bus_req_(bus_req_), .bus_addr(bus_addr), .bus_as_(bus_as_),
		.bus_rw(bus_rw), .bus_wr_data(bus_wr_data)
		);


	always #(1) begin
		clk 	<= ~clk;
	end

	initial begin
		clk 	<= 1'b0;
		reset	<= `RESET_DISABLE;
		stall 	<= `DISABLE;
		flush 	<= `DISABLE;

		addr 	<= `WORD_ADDR_W'h0;
		as_ 	<= `DISABLE_;
		rw 		<= `READ;
		wr_data <= `WORD_DATA_W'h0;

		spm_rd_data 	<= `WORD_DATA_W'h0;

		bus_rd_data 	<= `WORD_DATA_W'h0;
		bus_rdy_ 		<= `DISABLE_;
		bus_grnt_ 		<= `DISABLE_;

		#1 begin
			reset 		<= `RESET_ENABLE;
		end

		#1 begin
			reset 		<= `RESET_DISABLE;

			addr 		<= `WORD_ADDR_W'h1;
			as_ 		<= `ENABLE_;
			rw 			<= `READ;
			wr_data 	<= `WORD_DATA_W'h97;

			spm_rd_data <= `WORD_DATA_W'h99;

			bus_rd_data <= `WORD_DATA_W'h98;
			bus_rdy_	<= `DISABLE_;
			bus_grnt_ 	<= `ENABLE_;
		end

		#2 begin
			bus_rdy_ 	<= `ENABLE_;
		end

	end



endmodule