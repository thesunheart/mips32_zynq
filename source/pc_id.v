`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/26 20:49:26
// Design Name: 
// Module Name: pc_id
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


module pc_id(
    input clk,
    input rst,
    input [`InstAddrBus] pc,
    input [`InstBus] pc_inst,//从指令寄存器取得
    output reg [`InstAddrBus] id_pc,//流水线打一拍输出
    output reg [`InstBus] id_inst

    );

    always@(posedge clk)begin
        if(rst == `RstEnable)begin
            id_pc <= `ZeroWord;
            id_inst <= `ZeroWord;
        end
        else begin
            id_pc <= pc;
            id_inst <= pc_inst;
        end
    end 
endmodule
