
`include "nettype.h"
`include "global_config.h"
`include "stddef.h"
`include "timescale.h"

`include "isa.h"
`include "spm.h"
`include "bus.h"
`include "cpu.h"

/*
 *	bus interface
 */
module bus_if(
	input wire clk, input wire reset,
	input wire stall, input wire flush, output reg busy,
	//cpu interfaces
	input wire [`WORD_ADDR_BUS] addr, input wire as_, input wire rw,
	input wire [`WORD_DATA_BUS] wr_data, output reg [`WORD_DATA_BUS] rd_data,
	//spm interfaces
	input wire [`WORD_DATA_BUS] spm_rd_data, output wire [`SPM_ADDR_BUS] spm_addr,
	output reg spm_as_, output wire spm_rw, output wire[`WORD_DATA_BUS] spm_wr_data,
	//bus interfaces
	input wire [`WORD_DATA_BUS] bus_rd_data, input wire bus_rdy_, input wire bus_grnt_,
	output reg bus_req_,  output reg[`WORD_ADDR_BUS] bus_addr, output reg bus_as_, 
	output reg bus_rw, output reg [`WORD_DATA_BUS] bus_wr_data
	);
	
	reg [`BUS_STATE_BUS] state;
	reg [`WORD_DATA_BUS] rd_buf;
	wire [`BUS_SLAVE_INDEX_BUS] s_index;

	assign s_index = addr[`BUS_SLAVE_INDEX_LOCALE];

	assign spm_addr = addr;
	assign spm_rw = rw;
	assign spm_wr_data = wr_data;

	always @(*) begin
		rd_data = `WORD_DATA_W'h0;
		spm_as_ = `DISABLE_;
		busy 	= `DISABLE;

		case(state) 
			`BUS_STATE_IDLE : begin 	//idle state
				if((flush == `DISABLE) && (as_ == `ENABLE_)) begin
					if(s_index == `BUS_SLAVE_1) begin 		//access spm
						if (stall == `DISABLE) begin 	
							spm_as_ = `ENABLE_;
							if(rw == `READ) begin
								rd_data = spm_rd_data;
							end
						end
					end else begin
						busy = `ENABLE;
					end
				end
			end `BUS_STATE_REQ : begin 		//request bus
				busy = `ENABLE;
			end `BUS_STATE_ACCESS : begin 	//access bus
				if(bus_rdy_ == `ENABLE_) begin  	
					if(rw == `READ) begin  		
						rd_data = bus_rd_data;
					end
				end else begin 			
					busy = `ENABLE;
				end
			end `BUS_STATE_STALL : begin 			
				if(rw == `READ) begin 	
					rd_data = rd_buf;
				end
			end
		endcase
	end

	always @(posedge clk or `RESET_EDGE reset) begin
		if (reset == `RESET_ENABLE) begin
			state		<= `BUS_STATE_IDLE;
			bus_req_ 	<= `DISABLE_;
			bus_addr	<= `WORD_ADDR_W'h0;
			bus_as_		<= `DISABLE_;
			bus_rw		<= `READ;
			bus_wr_data <= `WORD_DATA_W'h0;
			rd_buf		<= `WORD_DATA_W'h0;
			
		end else begin
			
			case(state)
				`BUS_STATE_IDLE : begin
					if((flush == `DISABLE) && (as_ == `ENABLE_)) begin
						if(s_index != `BUS_SLAVE_1) begin
							state 		<= `BUS_STATE_REQ;
							bus_req_ 	<= `ENABLE_;
							bus_addr 	<=  addr;
							bus_rw		<=  rw;
							bus_wr_data	<=  wr_data;

						end
					end
				end `BUS_STATE_REQ : begin
					if(bus_grnt_ == `ENABLE_) begin
						state 	<= `BUS_STATE_ACCESS;
						bus_as_ <= `ENABLE_;
					end
				end `BUS_STATE_ACCESS : begin
					bus_as_		<= `DISABLE_;					
					if(bus_rdy_ == `ENABLE_) begin 

						bus_req_	<= `DISABLE_;
						bus_addr	<= `WORD_ADDR_W'h0;
						bus_rw		<= `READ;
						bus_wr_data <= `WORD_DATA_W'h0;

						if(bus_rw == `READ) begin
							rd_buf 	<= bus_rd_data; 	
						end 

						if (stall == `ENABLE) begin 		
							state 	<= `BUS_STATE_STALL;
						end else begin 						
							state 	<= `BUS_STATE_IDLE;
						end
					end
				end `BUS_STATE_STALL : begin 				
					if(stall == `DISABLE) begin 			
						state 	<= `BUS_STATE_IDLE;
					end
				end
			endcase
		end
	end

	
endmodule 