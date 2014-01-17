`include "nettype.h"
`include "global_config.h"
`include "stddef.h"
`include "timescale.h"

`include "cpu.h"
`include "isa.h"

module id_reg_tb();

	reg clk;
	reg reset;

	reg [`ALU_OP_BUS] alu_op;
	reg [`WORD_DATA_BUS] alu_in_0;
	reg [`WORD_DATA_BUS] alu_in_1;

	reg br_flag;
	reg [`MEM_OP_BUS] mem_op;
	reg [`WORD_DATA_BUS] mem_wr_data;
	reg [`CTRL_OP_BUS] ctrl_op;
	reg [`REG_ADDR_BUS] dst_addr;
	reg gpr_we_;
	reg [`ISA_EXP_BUS] exp_code;
	reg stall;
	reg flush;

	reg [`WORD_ADDR_BUS] if_pc;
	reg if_en_;

	wire [`WORD_ADDR_BUS] id_pc;
	wire id_en_;
	wire [`ALU_OP_BUS] id_alu_op;
	wire [`WORD_DATA_BUS] id_alu_in_0;
	wire [`WORD_DATA_BUS] id_alu_in_1;
	wire id_br_flag;
	wire [`MEM_OP_BUS] id_mem_op;
	wire [`WORD_DATA_BUS] id_mem_wr_data;
	wire [`CTRL_OP_BUS] id_ctrl_op;
	wire [`REG_ADDR_BUS] id_dst_addr;
	wire id_gpr_we_;
	wire [`ISA_EXP_BUS] id_exp_code;


	always #(1) begin
		clk 		<= ~clk;
	end

	id_reg id_reg(
		.clk(clk), .reset(reset),
		.alu_op(alu_op), .alu_in_0(alu_in_0), .alu_in_1(alu_in_1),
		.br_flag(br_flag),
		.mem_op(mem_op), .mem_wr_data(mem_wr_data),
		.ctrl_op(ctrl_op), .dst_addr(dst_addr),
		.gpr_we_(gpr_we_), .exp_code(exp_code),
		.stall(stall), .flush(flush),

		.if_pc(if_pc), .if_en_(if_en_),
		.id_pc(id_pc), .id_en_(id_en_),
		.id_alu_op(id_alu_op), .id_alu_in_0(id_alu_in_0), .id_alu_in_1(id_alu_in_1),

		.id_br_flag(id_br_flag), .id_mem_op(id_mem_op), .id_mem_wr_data(id_mem_wr_data),
		.id_ctrl_op(id_ctrl_op), .id_dst_addr(id_dst_addr), .id_gpr_we_(id_gpr_we_),
		.id_exp_code(id_exp_code)
		);


	initial begin
		#0 begin
			clk 		<= 1'b0;
			reset 		<= `RESET_DISABLE;
			alu_op 		<= `ALU_OP_NOP;
			alu_in_0 	<= `WORD_DATA_W'h0;
			alu_in_1 	<= `WORD_DATA_W'h0;
			br_flag 	<= `DISABLE;
			mem_op 		<= `MEM_OP_NOP;
			mem_wr_data <= `WORD_DATA_W'h0;
			ctrl_op 	<= `CTRL_OP_NOP;

			dst_addr 	<= `REG_ADDR_W'h0;
			gpr_we_ 	<= `DISABLE_;
			exp_code 	<= `ISA_EXP_NO_EXP;
			stall 		<= `DISABLE;
			flush 		<= `DISABLE;

			if_pc 		<= `WORD_ADDR_W'h0;
			if_en_ 		<= `DISABLE_;
		end

		#1 begin
			reset 		<= `RESET_ENABLE;
		end

		#1 begin
			reset 		<= `RESET_DISABLE;
			alu_op 		<= `ALU_OP_AND;
			alu_in_0 	<= `WORD_DATA_W'h0;
			alu_in_1 	<= `WORD_DATA_W'hf;
			br_flag 	<= `DISABLE;
			mem_op 		<= `MEM_OP_NOP;
			mem_wr_data <= `WORD_DATA_W'h0;
			ctrl_op 	<= `CTRL_OP_NOP;

			dst_addr 	<= `REG_ADDR_W'h1;
			gpr_we_ 	<= `ENABLE_;
			exp_code 	<= `ISA_EXP_NO_EXP;

			if_pc 		<= `WORD_ADDR_W'h99;
			if_en_ 		<= `ENABLE_;
		end
	end

endmodule