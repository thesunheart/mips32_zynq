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

    input [`RegBus] hi,
    input [`RegBus] lo,
    input hilo_en,
    
    output reg [`RegBus] wdata,
    output reg [`RegAddrBus] waddr,
    output reg wr_en,

    output reg [`RegBus] hi_out,
    output reg [`RegBus] lo_out,
    output reg hilo_en_out

    );

    always@(*)begin 
        if(rst == `RstEnable)begin 
            wdata <= `ZeroWord;
            waddr <= `NOPRegAddr;
            wr_en <= `WriteDisable;
            hi_out <= `ZeroWord;
            lo_out <= `ZeroWord;
            hilo_en_out <= `WriteDisable;
        end
        else begin 
            wdata <= mem_wdata;
            waddr <= mem_waddr;
            wr_en <= mem_wr_en;
            hi_out <= hi;
            lo_out <= lo;
            hilo_en_out <= hilo_en;
        end
    end
endmodule
