`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/26 20:38:37
// Design Name: 
// Module Name: pc_ctrl
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


module pc_ctrl(
    input clk,
    input rst,
    output reg [`InstAddrBus] pc,
    output reg chip_en //指令存储器使能

    );

    always@(posedge clk)begin
        if(rst == `RstEnable)
            chip_en <= `ChipDisable;
        else
            chip_en <= `ChipEnable;
    end 

    always@(posedge clk)begin
        if(chip_en == `ChipDisable)
            pc <= 32'h0;
        else 
            pc <= pc + 32'h4; 
    end

endmodule
