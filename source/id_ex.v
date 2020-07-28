`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/28 11:47:41
// Design Name: 
// Module Name: id_ex
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


module id_ex(
    input clk,
    input rst,
    input [`AluOpBus] id_aluop,
    input [`AluSelBus] id_alusel,
    input [`RegBus] id_reg1,//源操作数
    input [`RegBus] id_reg2,
    input [`RegAddrBus] id_waddr,
    input id_wr_en,

    output reg [`AluOpBus] ex_aluop,
    output reg [`AluSelBus] ex_alusel,
    output reg [`RegBus] ex_reg1,//源操作数
    output reg [`RegBus] ex_reg2,
    output reg [`RegAddrBus] ex_waddr,
    output reg ex_wr_en

    );

    always@(posedge clk)begin 
        if(rst == `RstEnable)begin 
            ex_aluop <= `EXE_NOP_OP;
            ex_alusel <= `EXE_RES_NOP;
            ex_reg1 <= `ZeroWord;
            ex_reg2 <= `ZeroWord;
            ex_waddr <= `NOPRegAddr;
            ex_wr_en <= `WriteDisable;
        end
        else begin 
            ex_aluop <= id_aluop;
            ex_alusel <= id_alusel;
            ex_reg1 <= id_reg1;
            ex_reg2 <= id_reg2;
            ex_waddr <= id_waddr;
            ex_wr_en <= id_wr_en;
        end
    end

endmodule
