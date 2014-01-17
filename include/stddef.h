`ifndef __MY_CPU_STDDEF_H__
`define __MY_CPU_STDDEF_H__

`define HIGH	1'b1
`define LOW		1'b0

`define TRUE	1'b1
`define FALSE	1'b0

`define DISABLE		1'b0
`define ENABLE		1'b1
`define DISABLE_	1'b1
`define ENABLE_		1'b0

`define READ		1'b1
`define WRITE		1'b0

`define BUSY	1'b1
`define FREE	1'b0

`define LSB		0

`define BYTE_DATA_W			8
`define BYTE_MSB			7
`define BYTE_DATA_BUS		7:0

`define HALF_DATA_W			16
`define HALF_MSB			15
`define HALF_DATA_BUS		15:0

`define WORD_DATA_W			32
`define WORD_MSB			31
`define WORD_DATA_BUS		31:0

`define WORD_ADDR_W			30
`define WORD_ADDR_MSB		29
`define WORD_ADDR_BUS		29:0
`define BYTE_OFFSET_W		2
`define BYTE_OFFSET_BUS		1:0
`define WORD_ADDR_LOCALE	31:2
`define BYTE_OFFSET_LOCALE	1:0
`define BYTE_OFFSET_WORD	2'b00

`endif