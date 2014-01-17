`include "nettype.h"
`include "global_config.h"
`include "stddef.h"
`include "timescale.h"

`include "isa.h"
`include "cpu.h"


module ex_stage_tb();
	
	reg [`WORD_ADDR_BUS] id_pc;
	reg id_en_;
	reg [`ALU_OP_BUS] id_alu_op;
	reg [`WORD_DATA_BUS] id_alu_in_0;
	reg [`WORD_DATA_BUS] id_alu_in_1;

	reg id_br_flag;
	reg [`MEM_OP_BUS] id_mem_op;
	reg [`WORD_DATA_BUS] id_mem_wr_data;
	reg [`CTRL_OP_BUS] id_ctrl_op;
	reg [`REG_ADDR_BUS] id_dst_addr;
	reg id_gpr_we_;
	reg [`ISA_EXP_BUS] id_exp_code;

	reg clk;
	reg reset;
	reg int_detect;
	reg stall;
	reg flush;

	wire [`WORD_ADDR_BUS] ex_pc;
	wire ex_en_;
	wire ex_br_flag;
	wire [`MEM_OP_BUS] ex_mem_op;
	wire [`WORD_DATA_BUS] ex_mem_wr_data;
	wire [`CTRL_OP_BUS] ex_ctrl_op;
	wire [`REG_ADDR_BUS] ex_dst_addr;
	wire ex_gpr_we_;
	wire [`ISA_EXP_BUS] ex_exp_code;
	wire [`WORD_DATA_BUS] ex_out;
	wire [`WORD_DATA_BUS] ex_fwd_data;

 
 	always #(1) begin
 		clk 	<= ~clk;
 	end

 	ex_stage ex_stage(
 		.id_pc(id_pc), .id_en_(id_en_),
 		.id_alu_op(id_alu_op), .id_alu_in_0(id_alu_in_0),
 		.id_alu_in_1(id_alu_in_1),
 		.id_br_flag(id_br_flag), .id_mem_op(id_mem_op), .id_mem_wr_data(id_mem_wr_data),
 		.id_ctrl_op(id_ctrl_op), .id_dst_addr(id_dst_addr), .id_gpr_we_(id_gpr_we_),
 		.id_exp_code(id_exp_code),
 		.clk(clk), .reset(reset), .int_detect(int_detect), .stall(stall),
 		.flush(flush), 
 		.ex_pc(ex_pc), .ex_en_(ex_en_), .ex_br_flag(ex_br_flag),
 		.ex_mem_op(ex_mem_op), .ex_mem_wr_data(ex_mem_wr_data),
 		.ex_ctrl_op(ex_ctrl_op), 
 		.ex_dst_addr(ex_dst_addr), .ex_gpr_we_(ex_gpr_we_), .ex_exp_code(ex_exp_code),
 		.ex_out(ex_out),
 		.ex_fwd_data(ex_fwd_data)
 		);


 	initial begin
 		#0 begin
 			clk 			<= 1'b0;
 			reset 			<= `RESET_DISABLE;
 			int_detect 		<= `DISABLE;
 			stall 			<= `DISABLE;
 			flush 			<= `DISABLE;

 			id_pc 			<= `WORD_ADDR_W'h0;
 			id_en_ 			<= `DISABLE_;
 			id_alu_op 		<= `ALU_OP_NOP;
 			id_alu_in_0 	<= `WORD_DATA_W'h0;
 			id_alu_in_1 	<= `WORD_DATA_W'h0;

 			id_br_flag 		<= `DISABLE;
 			id_mem_op 		<= `MEM_OP_NOP;
 			id_mem_wr_data	<= `WORD_DATA_W'h0;
 			id_ctrl_op 		<= `CTRL_OP_NOP;
 			id_dst_addr 	<= `REG_ADDR_W'h0;
 			id_gpr_we_ 		<= `DISABLE_;
 			id_exp_code 	<= `ISA_EXP_NO_EXP;
 		end

 		#1 begin
 			reset 			<= `RESET_ENABLE;
 		end

 		#1 begin
 			reset 			<= `RESET_DISABLE;
 			id_pc 			<= `WORD_DATA_W'h99;
 			id_en_ 			<= `ENABLE_;
 			id_alu_op 		<= `ALU_OP_AND;
 			id_alu_in_0 	<= `WORD_DATA_W'h0f;
 			id_alu_in_1 	<= `WORD_DATA_W'h0f;
 			id_br_flag 		<= `DISABLE;
 			id_mem_op 		<= `MEM_OP_LDW;
 			id_mem_wr_data 	<= `WORD_DATA_W'h98;
 			id_ctrl_op 		<= `CTRL_OP_NOP;
 			id_dst_addr 	<= `REG_ADDR_W'h0;
 			id_gpr_we_ 		<= `ENABLE_;
 		end
 	end

endmodule
