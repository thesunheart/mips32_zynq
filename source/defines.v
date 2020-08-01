
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
`define EXE_RES_MOVE 3'b010 
`define EXE_RES_ARITHMETIC 3'b011 
`define EXE_RES_MUL 3'b100

`define EXE_AND 6'b100100
`define EXE_OR 6'b100101 
`define EXE_XOR 6'b100110 
`define EXE_NOR 6'b100111 
`define EXE_ANDI 6'b001100   
`define EXE_XORI 6'b001110 

`define EXE_SPECIAL_INST 6'b000000 
`define EXE_SPECIAL2_INST 6'b011100 

`define EXE_MOVZ 6'b001010 
`define EXE_MOVN 6'b001011 
`define EXE_MFHI 6'b010000 
`define EXE_MTHI 6'b010001 
`define EXE_MFLO 6'b010010 
`define EXE_MTLO 6'b010011 

`define EXE_MOVZ_OP 8'b00101000 
`define EXE_MOVN_OP 8'b00101100 
`define EXE_MFHI_OP 8'b01000000 
`define EXE_MTHI_OP 8'b01000100 
`define EXE_MFLO_OP 8'b01001000 
`define EXE_MTLO_OP 8'b01001100 

`define EXE_SLT 6'b101010 
`define EXE_SLTU 6'b101011 
`define EXE_SLTI 6'b001010 
`define EXE_SLTIU 6'b001011 
`define EXE_ADD 6'b100000 //有符号型
`define EXE_ADDU 6'b100001 //无符号型
`define EXE_SUB 6'b100010 
`define EXE_SUBU 6'b100011 
`define EXE_ADDI 6'b001000 
`define EXE_ADDIU 6'b001001 
`define EXE_MULT 6'b011000 
`define EXE_MULTU 6'b011001 
`define EXE_MUL 6'b000010 

`define EXE_SLT_OP 8'b00101010 
`define EXE_SLTU_OP 8'b00101011 
`define EXE_SLTI_OP 8'b00001010 
`define EXE_SLTIU_OP 8'b00001011 
`define EXE_ADD_OP 8'b00100000 
`define EXE_ADDU_OP 8'b00100001 
`define EXE_SUB_OP 8'b00100010 
`define EXE_SUBU_OP 8'b00100011 
`define EXE_ADDI_OP 8'b00001000 
`define EXE_ADDIU_OP 8'b00001001 
`define EXE_MULT_OP 8'b00011000 
`define EXE_MULTU_OP 8'b00011001 
`define EXE_MUL_OP 8'b00000010 


