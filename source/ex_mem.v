`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/28 15:08:47
// Design Name: 
// Module Name: ex_mem
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


module ex_mem(
    input clk,
    input rst,
    input [`RegBus] wdata,
    input [`RegAddrBus] waddr,
    input wr_en,

    input [`RegBus] ex_hi,
    input [`RegBus] ex_lo,
    input ex_hilo_en,
    
    output reg [`RegBus] mem_wdata,
    output reg [`RegAddrBus] mem_waddr,
    output reg mem_wr_en,

    output reg [`RegBus] mem_hi,
    output reg [`RegBus] mem_lo,
    output reg mem_hilo_en

    );

    always@(posedge clk)begin 
        if(rst == `RstEnable)begin 
            mem_wdata <= `ZeroWord;
            mem_waddr <= `NOPRegAddr;
            mem_wr_en <= `WriteDisable;
            mem_hi <= `ZeroWord;
            mem_lo <= `ZeroWord;
            mem_hilo_en <= `WriteDisable;
        end
        else begin 
            mem_wdata <= wdata;
            mem_waddr <= waddr;
            mem_wr_en <= wr_en;
            mem_hi <= ex_hi;
            mem_lo <= ex_lo;
            mem_hilo_en <= ex_hilo_en;
        end
    end
            

endmodule
