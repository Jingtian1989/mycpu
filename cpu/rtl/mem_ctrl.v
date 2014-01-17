`include "nettype.h"
`include "global_config.h"
`include "stddef.h"
`include "timescale.h"

`include "isa.h"
`include "cpu.h"

module mem_ctrl(
	input wire ex_en_, input wire [`MEM_OP_BUS] ex_mem_op,
	input wire [`WORD_DATA_BUS] ex_mem_wr_data, input wire [`WORD_DATA_BUS] ex_out,
	input wire [`WORD_DATA_BUS] rd_data, output wire [`WORD_ADDR_BUS] addr,
	output reg as_, output reg rw, output wire [`WORD_DATA_BUS] wr_data,
	output reg [`WORD_DATA_BUS] out, output reg miss_align
	);
	
	wire [`BYTE_OFFSET_BUS] offset;

	assign wr_data 	= ex_mem_wr_data;
	assign addr 	= ex_out[`WORD_ADDR_LOCALE];
	assign offset 	= ex_out[`BYTE_OFFSET_LOCALE];

	always @(*) begin
		miss_align 	= `DISABLE;
		out 		= `WORD_DATA_W'h0;
		as_			= `DISABLE_;
		rw 			= `READ;

		if (ex_en_ == `ENABLE_) begin
			case (ex_mem_op) 
				`MEM_OP_LDW : begin
					if( offset == `BYTE_OFFSET_WORD) begin
						out 	= rd_data;
						as_ 	= `ENABLE_;
					end else begin
						miss_align 	= `ENABLE;
					end
				end `MEM_OP_STW : begin
					if (offset == `BYTE_OFFSET_WORD) begin
						 	rw 		= `WRITE;
						 	as_ 	= `ENABLE_;
					end else begin
						miss_align 	= `ENABLE;
					end
				end default : begin
					out 	= ex_out;
				end
			endcase
		end
	end

endmodule