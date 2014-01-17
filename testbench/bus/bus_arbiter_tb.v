`include "nettype.h"
`include "global_config.h"
`include "stddef.h"
`include "timescale.h"

`include "bus.h"


module bus_arbiter_tb();
	reg clk;
	reg reset;
	reg m0_req_;
	reg m1_req_;
	reg m2_req_;
	reg m3_req_;

	wire m0_grnt_;
	wire m1_grnt_;
	wire m2_grnt_;
	wire m3_grnt_;

	bus_arbiter bus_arbiter(
		.clk(clk), .reset(reset),
		.m0_req_(m0_req_), .m0_grnt_(m0_grnt_),
		.m1_req_(m1_req_), .m1_grnt_(m1_grnt_),
		.m2_req_(m2_req_), .m2_grnt_(m2_grnt_),
		.m3_req_(m3_req_), .m3_grnt_(m3_grnt_)
		);

	always #(1) begin
		clk 	<= ~clk;
	end

	initial begin
		#0 begin
			clk 		<= 1'b0;
			reset 		<= `RESET_DISABLE;
			m0_req_ 	<= `DISABLE_;
			m1_req_ 	<= `DISABLE_;
			m2_req_ 	<= `DISABLE_;
			m3_req_ 	<= `DISABLE_;
		end

		#1 begin
			reset 		<= `RESET_ENABLE;
		end

		#1 begin
			reset 		<= `RESET_DISABLE;
		end

		#2 begin
			m0_req_		<= `ENABLE_;
			m1_req_ 	<= `DISABLE_;
			m2_req_ 	<= `DISABLE_;
			m3_req_ 	<= `DISABLE_;
		end

		#2 begin
			m0_req_ 	<= `ENABLE_;
			m1_req_ 	<= `ENABLE_;
			m2_req_ 	<= `DISABLE_;
			m3_req_ 	<= `DISABLE_;
		end

		#2 begin
			m0_req_ 	<= `DISABLE_;
			m1_req_ 	<= `ENABLE_;
			m2_req_ 	<= `ENABLE_;
			m3_req_ 	<= `DISABLE_;
		end
	end



endmodule