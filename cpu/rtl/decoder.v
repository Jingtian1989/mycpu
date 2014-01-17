`include "nettype.h"
`include "global_config.h"
`include "stddef.h"
`include "timescale.h"

`include "cpu.h"
`include "isa.h"

/*
 *	instruction decoder：	
 *		decode from the input instruction, generate address, data, control inst.
 *		the data forwarding, load hazard, branching are also processed in it.
 */	

module decoder(
	/*	if/id stream line registers	*/
	input wire [`WORD_ADDR_BUS] if_pc, input wire [`WORD_DATA_BUS] if_insn,
	/*	gpr registers	*/
	input wire [`WORD_DATA_BUS] gpr_rd_data_0, input wire [`WORD_DATA_BUS] gpr_rd_data_1,
	output wire [`REG_ADDR_BUS] gpr_rd_addr_0, output wire [`REG_ADDR_BUS] gpr_rd_addr_1,
	/*	data forwarding from ex */
	input wire id_en_, input wire [`REG_ADDR_BUS] id_dst_addr, input wire id_gpr_we_, input wire [`WORD_DATA_BUS] ex_fwd_data,
	/*	data forwarding from mem */
	input wire ex_en_, input wire [`REG_ADDR_BUS] ex_dst_addr, input wire ex_gpr_we_, input wire [`WORD_DATA_BUS] mem_fwd_data,
	/*	control registers	*/
	input wire exe_mode, input wire [`WORD_DATA_BUS] creg_rd_data, output wire [`REG_ADDR_BUS] creg_rd_addr,
	/*	load hazard */
	input wire [`MEM_OP_BUS] id_mem_op,
	/*	decode result	*/
	output reg [`ALU_OP_BUS] alu_op, output reg [`WORD_DATA_BUS] alu_in_0, output reg [`WORD_DATA_BUS] alu_in_1,
	output reg [`WORD_ADDR_BUS] br_addr, output reg br_taken, output reg br_flag, 
	output reg [`MEM_OP_BUS] mem_op, output wire [`WORD_DATA_BUS] mem_wr_data,  
	output reg [`CTRL_OP_BUS] ctrl_op, output reg [`REG_ADDR_BUS] dst_addr, output reg gpr_we_,
	output reg [`ISA_EXP_BUS] exp_code, output reg ld_hazard
	);
	
	/*	opcode	*/
	wire [`ISA_OP_BUS] 		op 		=	if_insn[`ISA_OP_LOCALE];
	wire [`REG_ADDR_BUS]	ra_addr	=	if_insn[`ISA_RA_ADDR_LOCALE];
	wire [`REG_ADDR_BUS]	rb_addr	=	if_insn[`ISA_RB_ADDR_LOCALE];
	wire [`REG_ADDR_BUS] 	rc_addr	= 	if_insn[`ISA_RC_ADDR_LOCALE];

	/*	immediate	*/
	wire [`ISA_IMM_BUS]		imm 	= 	if_insn[`ISA_IMM_LOCALE];
	/*	sign extension	*/
	wire [`WORD_DATA_BUS]	imm_s 	=	{{`ISA_EXT_W{imm[`ISA_IMM_MSB]}}, imm};
	wire [`WORD_DATA_BUS]	imm_u 	=	{{`ISA_EXT_W{1'b0}}, imm};

	/*	gprs address	*/
	assign gpr_rd_addr_0 	= ra_addr;
	assign gpr_rd_addr_1	= rb_addr;
	assign creg_rd_addr 	= ra_addr;

	reg [`WORD_DATA_BUS] ra_data;								
	wire signed [`WORD_DATA_BUS] s_ra_data = $signed(ra_data);	
	reg [`WORD_DATA_BUS] rb_data;
	wire signed [`WORD_DATA_BUS]  s_rb_data = $signed(rb_data);

	assign mem_wr_data = rb_data; 								

	/*	branch 	*/
	wire [`WORD_ADDR_BUS] ret_addr	=	if_pc + 1'b1;						//return address
	wire [`WORD_ADDR_BUS] br_target	=	if_pc + imm_s[`WORD_ADDR_MSB:0];	//destination
	wire [`WORD_ADDR_BUS] jr_target = 	ra_data[`WORD_ADDR_LOCALE];			


	/*	data forwarding */
	always @(*) begin
		//ra 
		if((id_en_ == `ENABLE_) && (id_gpr_we_ == `ENABLE_) &&
			(id_dst_addr == ra_addr)) begin
			ra_data = ex_fwd_data;	//ex
		end else if((ex_en_ == `ENABLE_) && (ex_gpr_we_ == `ENABLE_) && 
			(ex_dst_addr == ra_addr)) begin
			ra_data = mem_fwd_data;	//mem
		end else begin
			ra_data = gpr_rd_data_0;//general
		end
		//rb
		if((id_en_ == `ENABLE_) && (id_gpr_we_ == `ENABLE_) &&
			(id_dst_addr == rb_addr)) begin
			rb_data = ex_fwd_data;
		end else if((ex_en_ == `ENABLE_) && (ex_gpr_we_ == `ENABLE_) && 
			(ex_dst_addr == rb_addr)) begin
			rb_data = mem_fwd_data;		
		end else begin
			rb_data = gpr_rd_data_1;
		end 
	end

	/*	load hazard	*/
	always @(*) begin
		if((id_en_ == `ENABLE_) && (id_mem_op == `MEM_OP_LDW) && 		
			(id_dst_addr == ra_addr) || (id_dst_addr == rb_addr)) begin 
			ld_hazard = `ENABLE;	//load hazard occur, delay a cycle		
		end else begin
			ld_hazard = `DISABLE;	
		end
	end

	/*	opcode decode 	*/
	always @(*) begin
		/*	defaults	*/
		alu_op 		=	`ALU_OP_NOP;
		alu_in_0	=	ra_data;
		alu_in_1	=	rb_data;
		br_taken	=	`DISABLE;
		br_flag		=	`DISABLE;
		br_addr		=	`WORD_ADDR_W'h0;
		mem_op 		=	`MEM_OP_NOP;
		ctrl_op 	=	`CTRL_OP_NOP;
		dst_addr 	=	rb_addr;	//gpr write destination
		gpr_we_ 	=	`DISABLE_;
		exp_code	=	`ISA_EXP_NO_EXP;

		case(op)
			/*	logic	*/
			`ISA_OP_ANDR : begin
				alu_op 		=	`ALU_OP_AND;
				dst_addr 	=	rc_addr;
				gpr_we_ 	=	`ENABLE_;
			end `ISA_OP_ANDI :	begin
				alu_op 		=	`ALU_OP_AND;
				alu_in_1	=	imm_u;
				gpr_we_ 	=	`ENABLE_;
			end `ISA_OP_ORR : begin
				alu_op 		= 	`ALU_OP_OR;
				dst_addr 	= 	rc_addr;
				gpr_we_ 	=	`ENABLE_;
			end `ISA_OP_ORI : begin
				alu_op 		=	`ALU_OP_OR;
				alu_in_1 	=	imm_u;
				gpr_we_ 	= 	`ENABLE_;
			end `ISA_OP_XORR : begin
				alu_op 		=	`ALU_OP_XOR;
				dst_addr 	=	rc_addr;
				gpr_we_ 	=	`ENABLE_;
			end `ISA_OP_XORI : begin
				alu_op 		=	`ALU_OP_XOR;
				alu_in_1	= 	imm_u;
				gpr_we_ 	=	`ENABLE_;
			end
			/*	arithmetic 	*/
			`ISA_OP_ADDSR : begin
				alu_op 		=	`ALU_OP_ADDS;
				dst_addr 	=	rc_addr;
				gpr_we_ 	= 	`ENABLE_;
			end `ISA_OP_ADDSI : begin
				alu_op 		=	`ALU_OP_ADDS;
				alu_in_1 	= 	imm_s;
				gpr_we_ 	=	`ENABLE_;
			end `ISA_OP_ADDUR : begin
				alu_op 		= 	`ALU_OP_ADDU;
				dst_addr 	= 	rc_addr;
				gpr_we_ 	=	`ENABLE_;
			end `ISA_OP_ADDUI : begin
				alu_op 		=	`ALU_OP_ADDU;
				alu_in_1 	= 	imm_s;
				gpr_we_ 	= 	`ENABLE_;
			end `ISA_OP_SUBSR : begin
				alu_op 		= 	`ALU_OP_SUBS;
				dst_addr 	= 	rc_addr;
				gpr_we_ 	= 	`ENABLE_;
			end `ISA_OP_SUBUR : begin
				alu_op 		=  	`ALU_OP_SUBU;
				dst_addr 	= 	rc_addr;
				gpr_we_ 	= 	`ENABLE_;
			end
			/*	shifts	*/
			`ISA_OP_SHRLR : begin
				alu_op 		= 	`ALU_OP_SHRL;
				dst_addr 	= 	rc_addr;
				gpr_we_ 	= 	`ENABLE_;	
			end `ISA_OP_SHRLI : begin
				alu_op 		= 	`ALU_OP_SHRL;
				alu_in_1 	= 	imm_u;
				gpr_we_ 	= 	`ENABLE_;
			end `ISA_OP_SHLLR : begin
				alu_op 		= 	`ALU_OP_SHLL;
				dst_addr 	= 	rc_addr;
				gpr_we_ 	= 	`ENABLE_;
			end `ISA_OP_SHLLI : begin
				alu_op 		=	`ALU_OP_SHLL;
				alu_in_1 	= 	imm_u;
				gpr_we_ 	= 	`ENABLE_;
			end

			/* 	branchs 	*/
			`ISA_OP_BE : begin 			//(ra == rb)
				br_addr 	=	br_target;
				br_taken 	= 	(ra_data == rb_data) ? `ENABLE : `DISABLE;
				br_flag 	= 	`ENABLE;
			end `ISA_OP_BNE : begin 	//(ra != rb)
				br_addr 	= 	br_target;
				br_taken 	= 	(ra_data != rb_data) ? `ENABLE : `DISABLE;
				br_flag 	= 	`ENABLE;
			end `ISA_OP_BSGT : begin 	//(ra < rb) signed
				br_addr 	= 	br_target;
				br_taken 	= 	(s_ra_data < s_rb_data) ? `ENABLE : `DISABLE;
				br_flag 	= 	`ENABLE;
			end `ISA_OP_BUGT : begin 	//(ra < rb) unsigned
				br_addr 	= 	br_target;
				br_taken 	= 	(ra_data < rb_data) ? `ENABLE : `DISABLE;
				br_flag 	= 	`ENABLE; 
			end `ISA_OP_JMP : begin
				br_addr 	= 	jr_target;
				br_taken 	= 	`ENABLE;
				br_flag 	= 	`ENABLE;
			end `ISA_OP_CALL : begin
				alu_in_0 	= 	{ret_addr, {`BYTE_OFFSET_W{1'b0}}};
				br_addr 	= 	jr_target;
				br_taken 	= 	`ENABLE;
				br_flag 	= 	`ENABLE;
				dst_addr 	= 	`REG_ADDR_W'd31;
				gpr_we_  	= 	`ENABLE_;
			end
			/*	memory access	*/
			`ISA_OP_LDW : begin
				alu_op  	= 	`ALU_OP_ADDU;
				alu_in_1 	= 	imm_s;
				mem_op 		= 	`MEM_OP_LDW;
				gpr_we_ 	= 	`ENABLE_;
			end `ISA_OP_STW : begin
				alu_op  	= 	`ALU_OP_ADDU;
				alu_in_1 	= 	imm_s;
				mem_op 	 	= 	`MEM_OP_STW;
			end 
			/*	system call	*/
			`ISA_OP_TRAP : begin
				exp_code 	= 	`ISA_EXP_TRAP;
			end 
			/* 	privileged instruction 	*/
			`ISA_OP_RDCR : begin
				if(exe_mode == `CPU_KERNEL_MODE) begin
					alu_in_0	= creg_rd_data;
					gpr_we_  	= `ENABLE_;
				end else begin
					exp_code 	= 	`ISA_EXP_PRV_VIO;
				end
			end `ISA_OP_WRCR : begin
				if(exe_mode == `CPU_KERNEL_MODE) begin
					ctrl_op 	= 	`CTRL_OP_WRCR;
				end else begin
					exp_code 	= 	`ISA_EXP_PRV_VIO;
				end
			end `ISA_OP_EXRT : begin
				if(exe_mode == `CPU_KERNEL_MODE) begin
					ctrl_op 	= 	`CTRL_OP_EXRT;
				end else begin
					exp_code 	= 	`ISA_EXP_PRV_VIO;
				end
			end default : begin
				exp_code 	= 	`ISA_EXP_UNDEF_INSN;
			end

		endcase


	end


endmodule