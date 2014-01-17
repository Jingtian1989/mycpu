`include "nettype.h"
`include "global_config.h"
`include "stddef.h"
`include "timescale.h"

`include "cpu.h"
`include "isa.h"

/* 	instruction decoder stream line registers 	*/
module id_reg(
	input wire clk, input wire reset,
	/*	decode result 	*/
	input wire [`ALU_OP_BUS] alu_op, input wire [`WORD_DATA_BUS] alu_in_0, input wire [`WORD_DATA_BUS] alu_in_1,
	input wire br_flag, 
	input wire [`MEM_OP_BUS] mem_op, input wire [`WORD_DATA_BUS] mem_wr_data,
	input wire [`CTRL_OP_BUS] ctrl_op, input wire [`REG_ADDR_BUS] dst_addr,
	input wire gpr_we_, input wire [`ISA_EXP_BUS] exp_code,
	input wire stall, input wire flush,
	/* 	if/id stream line registers 	*/
	input wire [`WORD_ADDR_BUS] if_pc, input wire if_en_,
	/* 	id/ex stream line registers	*/
	output reg [`WORD_ADDR_BUS] id_pc, output reg id_en_,
	output reg [`ALU_OP_BUS] id_alu_op, output reg [`WORD_DATA_BUS] id_alu_in_0, output reg [`WORD_DATA_BUS] id_alu_in_1,
	output reg id_br_flag, output reg [`MEM_OP_BUS] id_mem_op, output reg [`WORD_DATA_BUS] id_mem_wr_data, 
	output reg [`CTRL_OP_BUS] id_ctrl_op, output reg [`REG_ADDR_BUS] id_dst_addr, output reg id_gpr_we_,
	output reg [`ISA_EXP_BUS] id_exp_code
	);
 	
 	always @(posedge clk or `RESET_EDGE reset) begin
 		if (reset == `RESET_ENABLE) begin
 			id_pc 			<=  `WORD_ADDR_W'h0;
 			id_en_ 			<=  `DISABLE_;
 			id_alu_op 		<=	`ALU_OP_NOP;
 			id_alu_in_0 	<= 	`WORD_DATA_W'h0;
 			id_alu_in_1 	<= 	`WORD_DATA_W'h0;
 			id_br_flag 		<=  `DISABLE;
 			id_mem_op 		<= 	`MEM_OP_NOP;
 			id_mem_wr_data 	<=  `WORD_DATA_W'h0;
 			id_ctrl_op 		<=  `CTRL_OP_NOP;
 			id_dst_addr 	<=  `REG_ADDR_W'd0;
 			id_gpr_we_		<=  `DISABLE_;
 			id_exp_code 	<=  `ISA_EXP_NO_EXP;
 		end else begin
 			if (stall == `DISABLE) begin
 				if(flush == `ENABLE) begin
 					id_pc 			<=  `WORD_ADDR_W'h0;
 					id_en_ 			<=  `DISABLE_;
 					id_alu_op 		<=  `ALU_OP_NOP;
 					id_alu_in_0 	<=  `WORD_DATA_W'h0;
 					id_alu_in_1 	<=  `WORD_DATA_W'h0;
 					id_br_flag 		<=  `DISABLE;
 					id_mem_op 		<=  `MEM_OP_NOP;
 					id_mem_wr_data 	<=  `WORD_DATA_W'h0;
 					id_ctrl_op 		<=  `CTRL_OP_NOP;
 					id_dst_addr 	<=  `REG_ADDR_W'd0;
 					id_gpr_we_		<=  `DISABLE_;
 					id_exp_code 	<=  `ISA_EXP_NO_EXP;
 				end else begin
 					id_pc 			<=  if_pc;
 					id_en_ 			<=  if_en_;
 					id_alu_op 		<=  alu_op;
 					id_alu_in_0 	<=  alu_in_0;
 					id_alu_in_1 	<=  alu_in_1;
 					id_br_flag 		<=  br_flag;
 					id_mem_op 		<=  mem_op;
 					id_mem_wr_data 	<=  mem_wr_data;
 					id_ctrl_op 		<=  ctrl_op;
 					id_dst_addr 	<=  dst_addr;
 					id_gpr_we_		<=  gpr_we_;
 					id_exp_code 	<=  exp_code;
 				end
 			end
 		end
 	end

endmodule