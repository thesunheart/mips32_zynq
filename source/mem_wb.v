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

    input [`RegBus] mem_hi,
    input [`RegBus] mem_lo,
    input mem_hilo_en,
    
    output reg [`RegBus] wb_wdata,
    output reg [`RegAddrBus] wb_waddr,
    output reg wb_wr_en,

    output reg [`RegBus] wb_hi,
    output reg [`RegBus] wb_lo,
    output reg wb_hilo_en

    );

    always@(posedge clk)begin 
        if(rst == `RstEnable)begin 
            wb_wdata <= `ZeroWord;
            wb_waddr <= `NOPRegAddr;
            wb_wr_en <= `WriteDisable;
            wb_hi <= `ZeroWord;
            wb_lo <= `ZeroWord;
            wb_hilo_en <= `WriteDisable;
        end
        else begin 
            wb_wdata <= wdata;
            wb_waddr <= waddr;
            wb_wr_en <= wr_en;
            wb_hi <= mem_hi;
            wb_lo <= mem_lo;
            wb_hilo_en <= mem_hilo_en;
        end
    end
endmodule
