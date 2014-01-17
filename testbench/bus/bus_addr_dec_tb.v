`include "nettype.h"
`include "global_config.h"
`include "stddef.h"
`include "timescale.h"

`include "bus.h"


module bus_addr_dec_tb();
	reg [`WORD_ADDR_BUS] s_addr;
	wire s0_cs_;
	wire s1_cs_;
	wire s2_cs_;
	wire s3_cs_;
	wire s4_cs_;
	wire s5_cs_;
	wire s6_cs_;
	wire s7_cs_;

	bus_addr_dec bus_addr_dec(
		.s_addr(s_addr),
		.s0_cs_(s0_cs_), .s1_cs_(s1_cs_), .s2_cs_(s2_cs_),
		.s3_cs_(s3_cs_), .s4_cs_(s4_cs_), .s5_cs_(s5_cs_),
		.s6_cs_(s6_cs_), .s7_cs_(s7_cs_)
		);

	initial begin
		#0 begin
			s_addr <= `WORD_ADDR_W'h0;
		end

		#1 begin
			s_addr = s_addr + `WORD_ADDR_W'b000111111111111111111111111111;
		end

		#1 begin
			s_addr = s_addr + `WORD_ADDR_W'b000111111111111111111111111111;
		end

		#1 begin
			s_addr = s_addr + `WORD_ADDR_W'b000111111111111111111111111111;
		end

		#1 begin
			s_addr = s_addr + `WORD_ADDR_W'b000111111111111111111111111111;
		end

		#1 begin
			s_addr = s_addr + `WORD_ADDR_W'b000111111111111111111111111111;
		end

		#1 begin
			s_addr = s_addr + `WORD_ADDR_W'b000111111111111111111111111111;
		end

		#1 begin
			s_addr = s_addr + `WORD_ADDR_W'b000111111111111111111111111111;
		end
		#1 begin
			s_addr = s_addr + `WORD_ADDR_W'b000111111111111111111111111111;
		end

		#1 begin
			s_addr = s_addr + `WORD_ADDR_W'b000111111111111111111111111111;
		end

	end


endmodule