`include "nettype.h"
`include "global_config.h"
`include "stddef.h"
`include "timescale.h"

`include "bus.h"
/*
 *	地址解码器：
 *		基于总线主控输出的地址信号，判断将要访问哪个总线从属，并生成片选信号。
 *		访问的地址与总线从属的对应关系称为地址映射。
 *	总线从属				地址 					地址最高3位			分配
 *		0号			0x0000_0000~0x1fff_ffff				3'b000			只读ROM
 *		1号			0x2000_0000~0x3fff_ffff				3'b001			暂时SPM
 *		2号			0x4000_0000~0x5fff_ffff				3'b010			计时器
 *		3号			0x6000_0000~0x7fff_ffff				3'b011			UART
 *		4号			0x8000_0000~0x9fff_ffff				3'b100			GPIO
 *		5号			0xa000_0000~0b5fff_ffff				3'b101			未分配
 *		6号			0xc000_0000~0xdfff_ffff				3'b110			未分配
 *		7号			0xe000_0000~0xffff_ffff				3'b111			未分配
 */


module bus_addr_dec(input wire [`WORD_ADDR_BUS] s_addr,
	output reg s0_cs_, output reg s1_cs_,
	output reg s2_cs_, output reg s3_cs_,
	output reg s4_cs_, output reg s5_cs_,
	output reg s6_cs_, output reg s7_cs_
	);
	wire [`BUS_SLAVE_INDEX_BUS] s_index = s_addr[`BUS_SLAVE_INDEX_LOCALE];

	always @(*) begin
		s0_cs_ = `DISABLE_;
		s1_cs_ = `DISABLE_;
		s2_cs_ = `DISABLE_;
		s3_cs_ = `DISABLE_;
		s4_cs_ = `DISABLE_;
		s5_cs_ = `DISABLE_;
		s6_cs_ = `DISABLE_;
		s7_cs_ = `DISABLE_;

		case (s_index)
			`BUS_SLAVE_0 : begin
				s0_cs_	=	`ENABLE_;
			end `BUS_SLAVE_1 : begin
				s1_cs_	=	`ENABLE_;
			end `BUS_SLAVE_2 : begin
				s2_cs_	=	`ENABLE_;
			end `BUS_SLAVE_3 : begin
				s3_cs_	=	`ENABLE_;
			end `BUS_SLAVE_4 : begin
				s4_cs_	=	`ENABLE_;
			end `BUS_SLAVE_5 : begin
				s5_cs_	=	`ENABLE_;
			end `BUS_SLAVE_6 : begin
				s6_cs_	=	`ENABLE_;
			end `BUS_SLAVE_7 : begin
				s7_cs_	=	`ENABLE_;
			end
		endcase
	end
endmodule