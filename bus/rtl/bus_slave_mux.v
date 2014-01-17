`include "nettype.h"
`include "global_config.h"
`include "stddef.h"
`include "timescale.h"

`include "bus.h"
/*
 *	总线从属多路复用器：
 *		基于地址解码器输出的片选信号，将被选择的总线从属的输出信号发送到总线。
 */


module bus_slave_mux(
	input wire s0_cs_, input wire [`WORD_DATA_BUS] s0_r_data, input wire s0_rdy_,
	input wire s1_cs_, input wire [`WORD_DATA_BUS] s1_r_data, input wire s1_rdy_,
	input wire s2_cs_, input wire [`WORD_DATA_BUS] s2_r_data, input wire s2_rdy_,
	input wire s3_cs_, input wire [`WORD_DATA_BUS] s3_r_data, input wire s3_rdy_,
	input wire s4_cs_, input wire [`WORD_DATA_BUS] s4_r_data, input wire s4_rdy_,
	input wire s5_cs_, input wire [`WORD_DATA_BUS] s5_r_data, input wire s5_rdy_,
	input wire s6_cs_, input wire [`WORD_DATA_BUS] s6_r_data, input wire s6_rdy_,
	input wire s7_cs_, input wire [`WORD_DATA_BUS] s7_r_data, input wire s7_rdy_,
	output reg [`WORD_DATA_BUS] m_r_data, output reg m_rdy_
	);
	always @(*) begin
		if(s0_cs_ == `ENABLE_) begin
			m_r_data	=	s0_r_data;
			m_rdy_		=	s0_rdy_;
		end else if (s1_cs_ == `ENABLE_) begin
			m_r_data 	=	s1_r_data;
			m_rdy_		=	s1_rdy_;
		end else if (s2_cs_ == `ENABLE_) begin
			m_r_data 	=	s2_r_data;
			m_rdy_		=	s2_rdy_;
		end else if (s3_cs_ == `ENABLE_) begin
			m_r_data 	=	s3_r_data;
			m_rdy_		=	s3_rdy_;
		end else if (s4_cs_ == `ENABLE_) begin
			m_r_data 	=	s4_r_data;
			m_rdy_		=	s4_rdy_;
		end else if (s5_cs_ == `ENABLE_) begin
			m_r_data 	=	s5_r_data;
			m_rdy_		=	s5_rdy_;
		end else if (s6_cs_ == `ENABLE_) begin
			m_r_data 	=	s6_r_data;
			m_rdy_		=	s6_rdy_;
		end else if (s7_cs_ == `ENABLE_) begin
			m_r_data 	=	s7_r_data;
			m_rdy_		=	s7_rdy_;
		end else begin
			m_r_data	=	`WORD_DATA_W'h0;
			m_rdy_		=	`DISABLE_;
		end
	end

endmodule
