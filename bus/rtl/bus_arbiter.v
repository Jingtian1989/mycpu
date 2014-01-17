`include "nettype.h"
`include "global_config.h"
`include "stddef.h"
`include "timescale.h"

`include "bus.h"
/*
 * 总线仲裁器：
 *		对总线使用权进行调停。
 */
module bus_arbiter(input wire clk, input wire reset,
						 input wire m0_req_, output reg m0_grnt_,
						 input wire m1_req_, output reg m1_grnt_,
						 input wire m2_req_, output reg m2_grnt_,
						 input wire m3_req_, output reg m3_grnt_);
						 
	reg[`BUS_MASTER_BUS] owner;
		
	/*	赋予总线使用权*/
	always @(*) begin
		m0_grnt_ = `DISABLE_;
		m1_grnt_ = `DISABLE_;
		m2_grnt_ = `DISABLE_;
		m3_grnt_ = `DISABLE_;

		case (owner)
			`BUS_MASTER_0 :begin
				m0_grnt_ = `ENABLE_;
			end `BUS_MASTER_1 :begin
				m1_grnt_ = `ENABLE_;
			end `BUS_MASTER_2 : begin
				m2_grnt_ = `ENABLE_;
			end `BUS_MASTER_3 : begin
				m3_grnt_ = `ENABLE_;
			end
		endcase
	end

	/*	总线使用权的仲裁	*/
	always @(posedge clk or `RESET_EDGE reset) begin
		if (reset == `RESET_ENABLE) begin
			/*	异步复位	*/
			owner <= `BUS_MASTER_0;
		end else begin
			/*	仲裁	*/
			case (owner)
			`BUS_MASTER_0 : begin
				if(m0_req_ == `ENABLE_) begin
					owner <= `BUS_MASTER_0;
				end else if(m1_req_ == `ENABLE_) begin
					owner <= `BUS_MASTER_1;
				end else if(m2_req_ == `ENABLE_) begin
					owner <= `BUS_MASTER_2;
				end else if(m3_req_ == `ENABLE_) begin
					owner <= `BUS_MASTER_3;
				end 
			end `BUS_MASTER_1 : begin
				if(m1_req_ == `ENABLE_) begin
					owner <= `BUS_MASTER_1;
				end else if(m2_req_ == `ENABLE_) begin
					owner <= `BUS_MASTER_2;
				end else if(m3_req_ == `ENABLE_) begin
					owner <= `BUS_MASTER_3;
				end else if(m0_req_ == `ENABLE_) begin
					owner <= `BUS_MASTER_0;
				end
			end `BUS_MASTER_2 : begin
				if (m2_req_ == `ENABLE_) begin
					owner <= `BUS_MASTER_2;
				end else if (m3_req_ == `ENABLE_) begin
					owner <= `BUS_MASTER_3;
				end else if (m0_req_ == `ENABLE_) begin
					owner <= `BUS_MASTER_0;
				end else if (m1_req_ == `ENABLE_) begin
					owner <= `BUS_MASTER_1;
				end
			end `BUS_MASTER_3 : begin
				if (m3_req_ == `ENABLE_) begin
					owner <= `BUS_MASTER_3;
				end else if (m0_req_ == `ENABLE_) begin
					owner <= `BUS_MASTER_0;
				end else if (m1_req_ == `ENABLE_) begin
					owner <= `BUS_MASTER_1;
				end else if (m2_req_ == `ENABLE_) begin
					owner <= `BUS_MASTER_2;
				end
			end
			endcase
		end	
	end
endmodule