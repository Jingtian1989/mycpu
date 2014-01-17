`ifndef __MY_CPU_SPR_H__
`define __MY_CPU_SPR_H__

`define SPR_CNT_BUS			63:0
`define SPR_CNT_DATA_W		64
`define SPR_CNT_H_LOCALE	63:32

`define SPR_CNT_L_LOCALE	31:0
`define SPR_NUM				32
`define SPR_ADDR_W			5
`define SPR_ADDR_BUS		4:0

`define SPR_ZERO        	5'h0
`define SPR_PC          	5'h0
`define SPR_EPC         	5'h1
`define SPR_CNT_L       	5'h2
`define SPR_CNT_H       	5'h3
`define SPR_INT_MASK   		5'h4
`define SPR_INT_PENDING 	5'h5
`define SPR_VECTOR      	5'h6
`define SPR_MODE        	5'h7
`define SPR_SP          	5'h8

`endif