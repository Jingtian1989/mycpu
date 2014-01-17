`ifndef __MY_CPU_BUS_H__
`define __MY_CPU_BUS_H__
`define BUS_MASTER_CH		4
`define BUS_MASTER_INDEX_W	2
`define BUS_MASTER_BUS		1:0
`define BUS_MASTER_0			2'h0
`define BUS_MASTER_1			2'h1
`define BUS_MASTER_2			2'h2
`define BUS_MASTER_3			2'h3

`define BUS_SLAVE_CH					8
`define BUS_SLAVE_INDEX_W			3
`define BUS_SLAVE_INDEX_BUS		2:0
`define BUS_SLAVE_INDEX_LOCALE	29:27
`define BUS_SLAVE_0					3'h0
`define BUS_SLAVE_1					3'h1
`define BUS_SLAVE_2					3'h2
`define BUS_SLAVE_3					3'h3
`define BUS_SLAVE_4					3'h4
`define BUS_SLAVE_5					3'h5
`define BUS_SLAVE_6					3'h6
`define BUS_SLAVE_7					3'h7

`endif