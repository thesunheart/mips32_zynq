`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/28 15:14:46
// Design Name: 
// Module Name: mem_ctrl
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


module mem_ctrl(
    input rst,
    input [`RegBus] mem_wdata,
    input [`RegAddrBus] mem_waddr,
    input mem_wr_en,
    
    output reg [`RegBus] wdata,
    output reg [`RegAddrBus] waddr,
    output reg wr_en

    );

    always@(*)begin 
        if(rst == `RstEnable)begin 
            wdata <= `ZeroWord;
            waddr <= `NOPRegAddr;
            wr_en <= `WriteDisable;
        end
        else begin 
            wdata <= mem_wdata;
            waddr <= mem_waddr;
            wr_en <= mem_wr_en;
        end
    end
endmodule
