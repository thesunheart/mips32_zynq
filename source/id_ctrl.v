`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/27 22:17:36
// Design Name: 
// Module Name: id_ctrl
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


module id_ctrl(
    input rst,
    input [`InstAddrBus] id_pc,
    input [`InstBus] id_inst,

    input [`RegBus] reg1_data,
    input [`RegBus] reg2_data,

    output reg reg1_rd_en,
    output reg reg2_rd_en,
    output reg [`RegAddrBus] reg1_addr,
    output reg [`RegAddrBus] reg2_addr,

    output reg [`RegBus] reg1_out,
    output reg [`RegBus] reg2_out,

    output reg [`AluOpBus] aluop,
    output reg [`AluSelBus] alusel,
    output reg [`RegAddrBus] waddr,//要写的寄存器的地址
    output reg wr_en//写寄存器使能
    );

    reg [`RegBus] imm;
    reg instvalid;

    always@(*)begin 
        if(rst == `RstEnable)begin 
            aluop <= `EXE_NOP_OP;
            alusel <= `EXE_RES_NOP;
            waddr <= `NOPRegAddr;
            wr_en <= `WriteDisable;
            instvalid <= `InstValid;
            reg1_rd_en <= `ReadDisable;
            reg2_rd_en <= `ReadDisable;
            reg1_addr <= `NOPRegAddr;
            reg2_addr <= `NOPRegAddr;
            imm <= `ZeroWord;
        end
        else begin 
            aluop <= `EXE_NOP_OP;
            alusel <= `EXE_RES_NOP;
            waddr <= id_inst[15:11];
            wr_en <= `WriteDisable;
            instvalid <= `InstInvalid;
            reg1_rd_en <= `ReadDisable;
            reg2_rd_en <= `ReadDisable;
            reg1_addr <= id_inst[25:21];
            reg2_addr <= id_inst[20:16];
            imm <= `ZeroWord;
        end
    end
            



endmodule
