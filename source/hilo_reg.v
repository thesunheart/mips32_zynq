`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/31 14:25:35
// Design Name: 
// Module Name: hilo_reg
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


module hilo_reg(//乘除法特殊寄存器
    input clk,
    input rst,
    input wr_en,
    input [`RegBus] hi,
    input [`RegBus] lo,
    output reg [`RegBus] hi_out,
    output reg [`RegBus] lo_out

    );

    always@(posedge clk)begin 
        if(rst == `RstEnable)begin 
            hi_out <= `ZeroWord;
            lo_out <= `ZeroWord;
        end
        else begin 
            hi_out <= hi;
            lo_out <= lo;
        end
    end

endmodule
