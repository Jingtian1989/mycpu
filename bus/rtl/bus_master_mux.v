`include "nettype.h"
`include "global_config.h"
`include "stddef.h"
`include "timescale.h"

`include "bus.h"
/*
 *	总线主控多路复用器：
 *		基于总线仲裁器输出的总线赋予信号，选择总线使用权所有者的信号，
 *		并将其输出到总线。
 */
module bus_master_mux(
	input wire [`WORD_ADDR_BUS] m0_addr, input wire m0_as_, input wire m0_rw,
	input wire [`WORD_DATA_BUS] m0_w_data, input wire m0_grnt_,
	input wire [`WORD_ADDR_BUS] m1_addr, input wire m1_as_, input wire m1_rw,
	input wire [`WORD_DATA_BUS] m1_w_data, input wire m1_grnt_,
	input wire [`WORD_ADDR_BUS] m2_addr, input wire m2_as_, input wire m2_rw,
	input wire [`WORD_DATA_BUS] m2_w_data, input wire m2_grnt_,
	input wire [`WORD_ADDR_BUS] m3_addr, input wire m3_as_, input wire m3_rw,
	input wire [`WORD_DATA_BUS] m3_w_data, input wire m3_grnt_,
	
	output reg [`WORD_ADDR_BUS] s_addr, output wire reg, output reg s_rw,
	output reg [`WORD_DATA_BUS] s_w_data);

	always @(*) begin
		if (m0_grnt_ == `ENABLE_) begin
			s_addr 		=	m0_addr;
			s_as_		=	m0_as_;
			s_rw		= 	m0_rw;
			s_w_data	=	s_w_data;
		end else if (m1_grnt_ == `ENABLE_) begin
			s_addr		= 	m1_addr;
			s_as_		=	m1_as_;
			s_rw		=	m1_rw;
			s_w_data	=	m1_w_data;
		end else if (m2_grnt_ == `ENABLE_) begin
			s_addr		= 	m2_addr;
			s_as_		=	m2_as_;
			s_rw		=	m2_rw;
			s_w_data	=	m2_w_data;
		end else if (m3_grnt_ == `ENABLE_) begin
			s_addr		= 	m3_addr;
			s_as_		=	m3_as_;
			s_rw		=	m3_rw;
			s_w_data	=	m3_w_data;
		end else begin
			s_addr		= 	`WORD_ADDR_W'h0;
			s_as_		=	`DISABLE_;
			s_rw		=	`READ;
			s_w_data	=	`WORD_DATA_W'h0;
		end
	end 

endmodule