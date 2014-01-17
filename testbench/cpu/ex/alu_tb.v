`include "nettype.h"
`include "global_config.h"
`include "stddef.h"
`include "timescale.h"

`include "isa.h"
`include "cpu.h"


module alu_tb();

	reg [`WORD_DATA_BUS] in_0;
	reg [`WORD_DATA_BUS] in_1;
	reg [`ALU_OP_BUS] op;
	wire [`WORD_DATA_BUS] out;
	wire of;


	alu alu(
		.in_0(in_0), .in_1(in_1), .op(op), .out(out), .of(of)
		);
	
	initial begin
		$display($time, " alu testbench.");
		in_0 	<= `WORD_DATA_W'h0;
		in_1 	<= `WORD_DATA_W'h0;
		op 		<= `ALU_OP_NOP;

		#1 begin
		$display($time, "and.");
		op 		<= `ALU_OP_AND;
		in_0 	<= `WORD_DATA_W'h0f;
		in_1	<= `WORD_DATA_W'hf0;
		end
	

		#1 begin
			$display($time, "or.");
			op 		<= `ALU_OP_OR;
			in_0	<= `WORD_DATA_W'h0f;
			in_1 	<= `WORD_DATA_W'hf0;
		end

		#1 begin
			$display($time, "xor.");
			op 		<= `ALU_OP_XOR;
			in_0 	<= `WORD_DATA_W'h0f;
			in_1 	<= `WORD_DATA_W'hf0;
		end
		

		#1 begin
			$display($time, "adds.");
			op 		<= `ALU_OP_ADDS;
			in_0 	<= `WORD_DATA_W'h01020304;
			in_1	<= `WORD_DATA_W'h00010203;
		end
		

		#1 begin
			$display($time, "adds.");
			op 		<= `ALU_OP_ADDS;
			in_0 	<= `WORD_DATA_W'h7fffffff;
			in_1 	<= `WORD_DATA_W'h7fffffff;
		end
		

		#1 begin
			$display($time, "addu.");
			op 		<= `ALU_OP_ADDS;
			in_0 	<= `WORD_DATA_W'hefffffff;
			in_1 	<= `WORD_DATA_W'h00000001;
		end
		

		#1 begin
			$display($time, "subs.");
			op 		<= `ALU_OP_SUBS;
			in_0 	<= `WORD_DATA_W'h05;
			in_1 	<= `WORD_DATA_W'h02;
		end
		

		#1 begin
			$display($time, "subs.");
			op 		<= `ALU_OP_SUBS;
			in_0 	<= `WORD_DATA_W'h01;
			in_1 	<= `WORD_DATA_W'h02;
		end
		

		#1 begin
			$display($time, "subu.");
			op 		<= `ALU_OP_SUBS;
			in_0 	<= `WORD_DATA_W'h01;
			in_1 	<= `WORD_DATA_W'h02;
		end
		

		#1 begin
			$display($time, "shrl");
			op 		<= `ALU_OP_SHRL;
			in_0 	<= `WORD_DATA_W'hf0f0f0f0;
			in_1 	<= `WORD_DATA_W'h04;
		end
		

		#1 begin
			$display($time, "shll");
			op 		<= `ALU_OP_SHLL;
			in_0 	<= `WORD_DATA_W'h0f0f0f0f;
			in_1 	<= `WORD_DATA_W'h04;
		end


	end


	
	


endmodule