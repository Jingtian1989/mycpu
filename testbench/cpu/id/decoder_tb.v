`include "nettype.h"
`include "global_config.h"
`include "stddef.h"
`include "timescale.h"

`include "cpu.h"
`include "isa.h"


module decoder_tb();
	reg [`WORD_ADDR_BUS] if_pc;
	reg [`WORD_DATA_BUS] if_insn;

	reg [`WORD_DATA_BUS] gpr_rd_data_0;
	reg [`WORD_DATA_BUS] gpr_rd_data_1;

	wire [`REG_ADDR_BUS] gpr_rd_addr_0;
	wire [`REG_ADDR_BUS] gpr_rd_addr_1;

	reg id_en_;
	reg [`REG_ADDR_BUS] id_dst_addr;
	reg id_gpr_we_;
	reg [`WORD_DATA_BUS] ex_fwd_data;

	reg ex_en_;
	reg [`REG_ADDR_BUS] ex_dst_addr;
	reg ex_gpr_we_;
	reg [`WORD_DATA_BUS] mem_fwd_data;

	reg exe_mode;
	reg [`WORD_DATA_BUS] creg_rd_data;
	wire [`REG_ADDR_BUS] creg_rd_addr;

	reg [`MEM_OP_BUS] id_mem_op;

	wire [`ALU_OP_BUS] alu_op;
	wire [`WORD_DATA_BUS] alu_in_0;
	wire [`WORD_DATA_BUS] alu_in_1;
	wire [`WORD_ADDR_BUS] br_addr;
	wire br_taken;
	wire br_flag;
	wire [`MEM_OP_BUS] mem_op;
	wire [`WORD_DATA_BUS] mem_wr_data;
	wire [`CTRL_OP_BUS] ctrl_op;
	wire [`REG_ADDR_BUS] dst_addr;
	wire gpr_we_;
	wire [`ISA_EXP_BUS] exp_code;
	wire ld_hazard;


	decoder decoder(
		.if_pc(if_pc), .if_insn(if_insn),
		.gpr_rd_data_0(gpr_rd_data_0), .gpr_rd_data_1(gpr_rd_data_1),
		.gpr_rd_addr_0(gpr_rd_addr_0), .gpr_rd_addr_1(gpr_rd_addr_1),

		.id_en_(id_en_), .id_dst_addr(id_dst_addr), .id_gpr_we_(id_gpr_we_), .ex_fwd_data(ex_fwd_data),
		.ex_en_(ex_en_), .ex_dst_addr(ex_dst_addr), .ex_gpr_we_(ex_gpr_we_), .mem_fwd_data(mem_fwd_data),

		.exe_mode(exe_mode), .creg_rd_data(creg_rd_data), .creg_rd_addr(creg_rd_addr),
		
		.id_mem_op(id_mem_op),

		.alu_op(alu_op), .alu_in_0(alu_in_0), .alu_in_1(alu_in_1),
		.br_addr(br_addr), .br_taken(br_taken), .br_flag(br_flag),
		.mem_op(mem_op), .mem_wr_data(mem_wr_data),
		.ctrl_op(ctrl_op), .dst_addr(dst_addr), .gpr_we_(gpr_we_),
		.exp_code(exp_code), .ld_hazard(ld_hazard)
		);

	initial begin

		#0 begin
			if_insn							<=	`WORD_DATA_W'h0;
			id_en_							<=	`DISABLE_;
			ex_en_							<=	`DISABLE_;
			gpr_rd_data_0					<=	`WORD_DATA_W'h0;
			gpr_rd_data_1					<=	`WORD_DATA_W'h1;
		end


		#1 begin
			if_insn[`ISA_OP_LOCALE] 		<= 	`ISA_OP_LDW;
			if_insn[`ISA_RA_ADDR_LOCALE]	<=	`ISA_REG_ADDR_W'h0;
			if_insn[`ISA_RB_ADDR_LOCALE]	<=	`ISA_REG_ADDR_W'h1;	
			if_insn[`ISA_IMM_LOCALE]		<=	`ISA_IMM_W'h10;
		end

		#1 begin
			if_insn[`ISA_OP_LOCALE] 		<= 	`ISA_OP_STW;
			if_insn[`ISA_RA_ADDR_LOCALE]	<=	`ISA_REG_ADDR_W'h0;
			if_insn[`ISA_RB_ADDR_LOCALE]	<=	`ISA_REG_ADDR_W'h1;
			if_insn[`ISA_IMM_LOCALE]		<=	`ISA_IMM_W'h10;	
		end



		#1 begin
			if_insn[`ISA_OP_LOCALE] 		<= 	`ISA_OP_ANDR;
			if_insn[`ISA_RA_ADDR_LOCALE]	<=	`ISA_REG_ADDR_W'h0;
			if_insn[`ISA_RB_ADDR_LOCALE] 	<=  `ISA_REG_ADDR_W'h1;
			if_insn[`ISA_RC_ADDR_LOCALE] 	<=  `ISA_REG_ADDR_W'h2;
		end

		#1 begin

			if_insn[`ISA_OP_LOCALE] 		<= 	`ISA_OP_ANDI;
			if_insn[`ISA_RA_ADDR_LOCALE]	<= 	`ISA_REG_ADDR_W'h0;
			if_insn[`ISA_RB_ADDR_LOCALE]	<=  `ISA_REG_ADDR_W'h1;
			if_insn[`ISA_IMM_LOCALE]		<=  `ISA_IMM_W'h99;
		end

		#1 begin
			if_insn[`ISA_OP_LOCALE] 		<= 	`ISA_OP_ORR;
			if_insn[`ISA_RA_ADDR_LOCALE] 	<= 	`ISA_REG_ADDR_W'h0;
			if_insn[`ISA_RB_ADDR_LOCALE] 	<= 	`ISA_REG_ADDR_W'h1;
			if_insn[`ISA_RC_ADDR_LOCALE] 	<=	`ISA_REG_ADDR_W'h2;
		end

		#1 begin
			if_insn[`ISA_OP_LOCALE] 		<= 	`ISA_OP_ORI;
			if_insn[`ISA_RA_ADDR_LOCALE]	<=	`ISA_REG_ADDR_W'h0;
			if_insn[`ISA_RB_ADDR_LOCALE] 	<=	`ISA_REG_ADDR_W'h1;
			if_insn[`ISA_IMM_LOCALE]		<=	`ISA_IMM_W'h99;
				
		end

		#1 begin
			if_insn[`ISA_OP_LOCALE] 		<= 	`ISA_OP_XORR;
			if_insn[`ISA_RA_ADDR_LOCALE]	<=	`ISA_REG_ADDR_W'h0;
			if_insn[`ISA_RB_ADDR_LOCALE]	<=	`ISA_REG_ADDR_W'h1;
			if_insn[`ISA_RC_ADDR_LOCALE]	<=	`ISA_REG_ADDR_W'h2;
		end

		#1 begin
			if_insn[`ISA_OP_LOCALE] 		<= 	`ISA_OP_XORI;
			if_insn[`ISA_RA_ADDR_LOCALE]	<=	`ISA_REG_ADDR_W'h0;
			if_insn[`ISA_RB_ADDR_LOCALE]	<=	`ISA_REG_ADDR_W'h1;
			if_insn[`ISA_IMM_LOCALE]		<=	`ISA_IMM_W'h99;
		end

		#1 begin
			if_insn[`ISA_OP_LOCALE] 		<= 	`ISA_OP_ADDSR;
			if_insn[`ISA_RA_ADDR_LOCALE]	<=	`ISA_REG_ADDR_W'h0;
			if_insn[`ISA_RB_ADDR_LOCALE]	<=	`ISA_REG_ADDR_W'h1;
			if_insn[`ISA_RC_ADDR_LOCALE]	<=	`ISA_REG_ADDR_W'h2;
		end

		#1 begin
			if_insn[`ISA_OP_LOCALE] 		<= 	`ISA_OP_ADDSI;
			if_insn[`ISA_RA_ADDR_LOCALE]	<=	`ISA_REG_ADDR_W'h0;
			if_insn[`ISA_RB_ADDR_LOCALE]	<=	`ISA_REG_ADDR_W'h1;
			if_insn[`ISA_IMM_LOCALE]		<=	`ISA_IMM_W'h99;
		end

		#1 begin
			if_insn[`ISA_OP_LOCALE] 		<= 	`ISA_OP_ADDUR;
			if_insn[`ISA_RA_ADDR_LOCALE]	<=	`ISA_REG_ADDR_W'h0;
			if_insn[`ISA_RB_ADDR_LOCALE]	<=	`ISA_REG_ADDR_W'h1;
			if_insn[`ISA_RC_ADDR_LOCALE]	<=	`ISA_REG_ADDR_W'h2;
		end

		#1 begin
			if_insn[`ISA_OP_LOCALE] 		<= 	`ISA_OP_ADDUI;
			if_insn[`ISA_RA_ADDR_LOCALE]	<=	`ISA_REG_ADDR_W'h0;
			if_insn[`ISA_RB_ADDR_LOCALE]	<=	`ISA_REG_ADDR_W'h1;
			if_insn[`ISA_IMM_LOCALE]		<=	`ISA_IMM_W'h99;
		end

		#1 begin
			if_insn[`ISA_OP_LOCALE] 		<= 	`ISA_OP_SUBSR;
			if_insn[`ISA_RA_ADDR_LOCALE]	<=	`ISA_REG_ADDR_W'h0;
			if_insn[`ISA_RB_ADDR_LOCALE]	<=	`ISA_REG_ADDR_W'h1;
			if_insn[`ISA_RC_ADDR_LOCALE]	<=	`ISA_REG_ADDR_W'h2;	
		end
				
		#1 begin
			if_insn[`ISA_OP_LOCALE] 		<= 	`ISA_OP_SUBUR;
			if_insn[`ISA_RA_ADDR_LOCALE]	<=	`ISA_REG_ADDR_W'h0;
			if_insn[`ISA_RB_ADDR_LOCALE]	<=	`ISA_REG_ADDR_W'h1;
			if_insn[`ISA_RC_ADDR_LOCALE]	<=	`ISA_REG_ADDR_W'h2;		
		end

		#1 begin
			if_insn[`ISA_OP_LOCALE] 		<= 	`ISA_OP_SHRLR;
			if_insn[`ISA_RA_ADDR_LOCALE]	<=	`ISA_REG_ADDR_W'h0;
			if_insn[`ISA_RB_ADDR_LOCALE]	<=	`ISA_REG_ADDR_W'h1;
			if_insn[`ISA_RC_ADDR_LOCALE]	<=	`ISA_REG_ADDR_W'h2;			
		end

		#1 begin
			if_insn[`ISA_OP_LOCALE] 		<= 	`ISA_OP_SHRLI;
			if_insn[`ISA_RA_ADDR_LOCALE]	<=	`ISA_REG_ADDR_W'h0;
			if_insn[`ISA_RB_ADDR_LOCALE]	<=	`ISA_REG_ADDR_W'h1;
			if_insn[`ISA_IMM_LOCALE]		<=	`ISA_IMM_W'h99;	
		end

		#1 begin
			if_insn[`ISA_OP_LOCALE] 		<= 	`ISA_OP_SHLLR;
			if_insn[`ISA_RA_ADDR_LOCALE]	<=	`ISA_REG_ADDR_W'h0;
			if_insn[`ISA_RB_ADDR_LOCALE]	<=	`ISA_REG_ADDR_W'h1;
			if_insn[`ISA_RC_ADDR_LOCALE]	<=	`ISA_REG_ADDR_W'h2;		
		end

		#1 begin
			if_insn[`ISA_OP_LOCALE] 		<= 	`ISA_OP_SHLLI;
			if_insn[`ISA_RA_ADDR_LOCALE]	<=	`ISA_REG_ADDR_W'h0;
			if_insn[`ISA_RB_ADDR_LOCALE]	<=	`ISA_REG_ADDR_W'h1;
			if_insn[`ISA_IMM_LOCALE]		<=	`ISA_IMM_W'h99;		
		end

		#1 begin
			if_pc							<=	`WORD_ADDR_W'h0;
			gpr_rd_data_0 					<= 	`WORD_DATA_W'h0;
			gpr_rd_data_1 					<= 	`WORD_DATA_W'h0;
			if_insn[`ISA_OP_LOCALE] 		<= 	`ISA_OP_BE;
			if_insn[`ISA_RA_ADDR_LOCALE]	<=	`ISA_REG_ADDR_W'h0;
			if_insn[`ISA_RB_ADDR_LOCALE]	<=	`ISA_REG_ADDR_W'h1;
			if_insn[`ISA_IMM_LOCALE]		<=	`ISA_IMM_W'h99;	
		end

		#1 begin
			if_pc							<=	`WORD_ADDR_W'h0;
			gpr_rd_data_0 					<= 	`WORD_DATA_W'h0;
			gpr_rd_data_1					<= 	`WORD_DATA_W'h1;
			if_insn[`ISA_OP_LOCALE] 		<= 	`ISA_OP_BNE;
			if_insn[`ISA_RA_ADDR_LOCALE]	<=	`ISA_REG_ADDR_W'h0;
			if_insn[`ISA_RB_ADDR_LOCALE]	<=	`ISA_REG_ADDR_W'h1;
			if_insn[`ISA_IMM_LOCALE]		<=	`ISA_IMM_W'h98;	
		end

		#1 begin
			if_pc							<=	`WORD_ADDR_W'h0;
			gpr_rd_data_0 					<= 	`WORD_DATA_W'h1;
			gpr_rd_data_1					<= 	`WORD_DATA_W'h0;
			if_insn[`ISA_OP_LOCALE] 		<= 	`ISA_OP_BSGT;
			if_insn[`ISA_RA_ADDR_LOCALE]	<=	`ISA_REG_ADDR_W'h0;
			if_insn[`ISA_RB_ADDR_LOCALE]	<=	`ISA_REG_ADDR_W'h1;
			if_insn[`ISA_IMM_LOCALE]		<=	`ISA_IMM_W'h97;	
		end

		#1 begin
			if_pc							<=	`WORD_ADDR_W'h0;
			gpr_rd_data_0 					<= 	`WORD_DATA_W'h1;
			gpr_rd_data_1					<= 	`WORD_DATA_W'h0;
			if_insn[`ISA_OP_LOCALE] 		<= 	`ISA_OP_BUGT;
			if_insn[`ISA_RA_ADDR_LOCALE]	<=	`ISA_REG_ADDR_W'h0;
			if_insn[`ISA_RB_ADDR_LOCALE]	<=	`ISA_REG_ADDR_W'h1;
			if_insn[`ISA_IMM_LOCALE]		<=	`ISA_IMM_W'h96;	
		end
		#1 begin
			if_pc							<=	`WORD_ADDR_W'h0;
			gpr_rd_data_0[`WORD_ADDR_LOCALE]<= 	`WORD_ADDR_W'h10;
			gpr_rd_data_1[`WORD_ADDR_LOCALE]<= 	`WORD_ADDR_W'h20;
			if_insn[`ISA_OP_LOCALE] 		<= 	`ISA_OP_JMP;
			if_insn[`ISA_RA_ADDR_LOCALE]	<=	`ISA_REG_ADDR_W'h0;
		end

		#1 begin
			if_pc							<=	`WORD_ADDR_W'h0;
			gpr_rd_data_0[`WORD_ADDR_LOCALE]<= 	`WORD_ADDR_W'h30;
			gpr_rd_data_1[`WORD_ADDR_LOCALE]<= 	`WORD_ADDR_W'h40;
			if_insn[`ISA_OP_LOCALE] 		<= 	`ISA_OP_CALL;
			if_insn[`ISA_RA_ADDR_LOCALE]	<=	`ISA_REG_ADDR_W'h0;	
		end



		#1 begin
			if_insn[`ISA_OP_LOCALE] 		<= 	`ISA_OP_TRAP;
		end

		#1 begin
			exe_mode						<=	`CPU_USER_MODE;
			creg_rd_data					<=	`WORD_DATA_W'h99;
			if_insn[`ISA_OP_LOCALE] 		<= 	`ISA_OP_RDCR;
			if_insn[`ISA_RA_ADDR_LOCALE]	<=	`ISA_REG_ADDR_W'h0;
			if_insn[`ISA_RB_ADDR_LOCALE]	<=	`ISA_REG_ADDR_W'h1;		
		end

		#1 begin
			exe_mode						<=	`CPU_KERNEL_MODE;
			creg_rd_data					<=	`WORD_DATA_W'h99;
			if_insn[`ISA_OP_LOCALE] 		<= 	`ISA_OP_RDCR;
			if_insn[`ISA_RA_ADDR_LOCALE]	<=	`ISA_REG_ADDR_W'h0;
			if_insn[`ISA_RB_ADDR_LOCALE]	<=	`ISA_REG_ADDR_W'h1;		
		end

		#1 begin
			exe_mode						<=	`CPU_USER_MODE;
			creg_rd_data					<=	`WORD_DATA_W'h99;
			if_insn[`ISA_OP_LOCALE] 		<= 	`ISA_OP_WRCR;
			if_insn[`ISA_RA_ADDR_LOCALE]	<=	`ISA_REG_ADDR_W'h0;
			if_insn[`ISA_RB_ADDR_LOCALE]	<=	`ISA_REG_ADDR_W'h1;			
		end

		#1 begin
			exe_mode						<=	`CPU_KERNEL_MODE;
			creg_rd_data					<=	`WORD_DATA_W'h99;
			if_insn[`ISA_OP_LOCALE] 		<= 	`ISA_OP_WRCR;
			if_insn[`ISA_RA_ADDR_LOCALE]	<=	`ISA_REG_ADDR_W'h0;
			if_insn[`ISA_RB_ADDR_LOCALE]	<=	`ISA_REG_ADDR_W'h1;			
		end

		#1 begin
			exe_mode						<=	`CPU_USER_MODE;
			if_insn[`ISA_OP_LOCALE] 		<= 	`ISA_OP_EXRT;
		end

		#1 begin
			exe_mode						<=	`CPU_KERNEL_MODE;
			if_insn[`ISA_OP_LOCALE] 		<= 	`ISA_OP_EXRT;
		end




		#1 begin
			if_insn[`ISA_OP_LOCALE]			<=	`ISA_OP_ANDR;
			if_insn[`ISA_RA_ADDR_LOCALE]	<=	`ISA_REG_ADDR_W'h0;
			if_insn[`ISA_RB_ADDR_LOCALE]	<=	`ISA_REG_ADDR_W'h1;
			if_insn[`ISA_RC_ADDR_LOCALE]	<=	`ISA_REG_ADDR_W'h3;
			id_en_ 							<=	`ENABLE_;
			id_gpr_we_						<=	`ENABLE_;
			id_dst_addr 					<=	`ISA_REG_ADDR_W'h0;
			ex_fwd_data						<=	`WORD_DATA_W'h99;

			ex_en_ 							<=	`DISABLE_;
			ex_gpr_we_						<=	`DISABLE_;
			ex_dst_addr 					<=	`ISA_REG_ADDR_W'h0;
			mem_fwd_data					<=	`WORD_DATA_W'h0;
		end

		#1 begin
			if_insn[`ISA_OP_LOCALE]			<=	`ISA_OP_ORR;
			if_insn[`ISA_RA_ADDR_LOCALE]	<=	`ISA_REG_ADDR_W'h0;
			if_insn[`ISA_RB_ADDR_LOCALE]	<=	`ISA_REG_ADDR_W'h1;
			if_insn[`ISA_RC_ADDR_LOCALE]	<=	`ISA_REG_ADDR_W'h3;
			id_en_ 							<=	`ENABLE_;
			id_gpr_we_						<=	`ENABLE_;
			id_dst_addr 					<=	`ISA_REG_ADDR_W'h1;
			ex_fwd_data						<=	`WORD_DATA_W'h98;

			ex_en_ 							<=	`DISABLE_;
			ex_gpr_we_						<=	`DISABLE_;
			ex_dst_addr 					<=	`ISA_REG_ADDR_W'h0;
			mem_fwd_data					<=	`WORD_DATA_W'h0;
		end

		#1 begin
			if_insn[`ISA_OP_LOCALE]			<=	`ISA_OP_ANDR;
			if_insn[`ISA_RA_ADDR_LOCALE]	<=	`ISA_REG_ADDR_W'h0;
			if_insn[`ISA_RB_ADDR_LOCALE]	<=	`ISA_REG_ADDR_W'h1;
			if_insn[`ISA_RC_ADDR_LOCALE]	<=	`ISA_REG_ADDR_W'h3;
			id_en_ 							<=	`DISABLE_;
			id_gpr_we_						<=	`DISABLE_;

			ex_en_ 							<=	`ENABLE_;
			ex_gpr_we_						<=	`ENABLE_;
			ex_dst_addr 					<=	`ISA_REG_ADDR_W'h0;
			mem_fwd_data					<=	`WORD_DATA_W'h96;
		end

		#1 begin
			if_insn[`ISA_OP_LOCALE]			<=	`ISA_OP_ORR;
			if_insn[`ISA_RA_ADDR_LOCALE]	<=	`ISA_REG_ADDR_W'h0;
			if_insn[`ISA_RB_ADDR_LOCALE]	<=	`ISA_REG_ADDR_W'h1;
			if_insn[`ISA_RC_ADDR_LOCALE]	<=	`ISA_REG_ADDR_W'h3;
			id_en_ 							<=	`DISABLE_;
			id_gpr_we_						<=	`DISABLE_;

			ex_en_ 							<=	`ENABLE_;
			ex_gpr_we_						<=	`ENABLE_;
			ex_dst_addr 					<=	`ISA_REG_ADDR_W'h1;
			mem_fwd_data					<=	`WORD_DATA_W'h95;
		end

	end



endmodule