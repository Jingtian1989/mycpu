`include "nettype.h"
`include "global_config.h"
`include "stddef.h"
`include "timescale.h"

`include "isa.h"
`include "cpu.h"

/*
 *	ALU:
 *		根据输入指定的操作对数据进行处理，并输出处理结果。
 */
module alu(
	input wire [`WORD_DATA_BUS] in_0, input wire [`WORD_DATA_BUS] in_1,
	input wire [`ALU_OP_BUS] op, 
	output reg [`WORD_DATA_BUS] out, output reg of
	);

	wire signed [`WORD_DATA_BUS] s_in_0 = $signed(in_0);
	wire signed [`WORD_DATA_BUS] s_in_1 = $signed(in_1);
	wire signed [`WORD_DATA_BUS] s_out 	= $signed(out);

	/*	算数逻辑运算	*/
	always @(*) begin
		case (op)
			`ALU_OP_AND : begin
				out = in_0 & in_1;
			end `ALU_OP_OR : begin 
				out = in_0 | in_1;
			end `ALU_OP_XOR : begin
				out = in_0 ^ in_1;
			end `ALU_OP_ADDS : begin
				out = in_0 + in_1;
			end `ALU_OP_ADDU : begin
				out = in_0 + in_1;
			end `ALU_OP_SUBS : begin
				out = in_0 - in_1;
			end `ALU_OP_SUBU : begin
				out = in_0 - in_1;
			end `ALU_OP_SHRL : begin
				out = in_0 >> in_1[`SH_AMOUNT_LOCALE];
			end `ALU_OP_SHLL : begin
				out = in_0 << in_1[`SH_AMOUNT_LOCALE];
			end default : begin
				out = in_0;
			end
		endcase
	end

	/*	溢出检查	*/
	always @(*) begin
		case (op)
			`ALU_OP_ADDS : begin
				if (((s_in_0 > 0) && (s_in_1 > 0) && (s_out < 0)) || 
					((s_in_0 < 0) && (s_in_1 < 0) && (s_out > 0))) begin
					of = `ENABLE;
				end else begin
					of = `DISABLE;
				end 
			end `ALU_OP_SUBS : begin
				if ( ((s_in_0 < 0) && (s_in_1 > 0) && (s_out > 0)) || 
					((s_in_0 > 0) && (s_in_1 < 0) && (s_out < 0)))begin
					of = `ENABLE;		
				end else begin
					of = `DISABLE;
				end
			end default : begin
				of = `DISABLE;
			end
		endcase
	end
	
endmodule