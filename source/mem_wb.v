`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/28 15:19:20
// Design Name: 
// Module Name: mem_wb
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


module mem_wb(
    input clk,
    input rst,
    input [`RegBus] wdata,
    input [`RegAddrBus] waddr,
    input wr_en,
    
    output reg [`RegBus] wb_wdata,
    output reg [`RegAddrBus] wb_waddr,
    output reg wb_wr_en

    );

    always@(posedge clk)begin 
        if(rst == `RstEnable)begin 
            wb_wdata <= `ZeroWord;
            wb_waddr <= `NOPRegAddr;
            wb_wr_en <= `WriteDisable;
        end
        else begin 
            wb_wdata <= wdata;
            wb_waddr <= waddr;
            wb_wr_en <= wr_en;
        end
    end
endmodule
