`ifndef __MY_CPU_GLOBAL_CONFIG_H__
`define __MY_CPU_GLOBAL_CONFIG_H__

`define MY_CPU_NEGATIVE_RESET
//`define MY_CPU_POSITIVE_RESET

`define MY_CPU_POSITIVE_MEMORY
//`define MY_CPU_NEGATIVE_MEMORY

`define MY_CPU_IMPLEMENT_TIMER
`define MY_CPU_IMPLEMENT_UART
`define MY_CPU_IMPLEMENT_GPIO

`ifdef MY_CPU_POSITIVE_RESET
`define RESET_EDGE		posedge
`define RESET_ENABLE	1'b1
`define RESET_DISABLE	1'b0
`else
`define RESET_EDGE 		negedge
`define RESET_ENABLE 	1'b0
`define RESET_DISABLE	1'b1
`endif

`ifdef MY_CPU_POSITIVE_MEMORY
`define MEM_ENABLE	1'b1
`define MEM_DISABLE	1'b0
`else
`define MEM_ENABLE	1'b0
`define MEM_DISABLE	1'b1
`endif

`endif