
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/26 20:34:07
// Design Name: 
// Module Name: defines
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`define RstEnable 1'b1
`define RstDisable 1'b0

`define InstAddrBus 31:0
`define InstBus 31:0
`define InstMemNum 16384//不能太大，FPGA资源不够
`define InstMemNumLog2 14

`define RegAddrBus 4:0
`define RegBus 31:0
`define RegNum 32
`define RegNumLog2 5
`define RegWidth 32
`define NOPRegAddr 5'b0000 
`define DoubleRegWidth 64
`define DoubleRegBus 63:0

`define WriteEnable 1'b1
`define WriteDisable 1'b0
`define ReadEnable 1'b1
`define ReadDisable 1'b0

`define AluOpBus 7:0
`define AluSelBus 2:0

`define InstValid 1'b1
`define InstInvalid 1'b0

`define True 1'b1
`define False 1'b0

`define ChipDisable 1'b0
`define ChipEnable 1'b1

`define ZeroWord 32'h0

`define EXE_ORI 6'b001101//指令ori指令码
`define EXE_NOP 6'b000000

`define EXE_OR_OP 8'b00100101
`define EXE_NOR_OP 8'b00100110
`define EXE_XOR_OP 8'b00100111
`define EXE_AND_OP 8'b00101111
`define EXE_NOP_OP 8'b00000000

`define EXE_RES_LOGIC 3'b001
`define EXE_RES_NOP 3'b000 

`define EXE_AND 6'b100100
`define EXE_OR 6'b100101 
`define EXE_XOR 6'b100110 
`define EXE_NOR 6'b100111 
`define EXE_ANDI 6'b001100   
`define EXE_XORI 6'b001110 

`define EXE_SPECIAL_INST 6'b000000 



