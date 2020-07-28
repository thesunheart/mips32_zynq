`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/28 17:01:36
// Design Name: 
// Module Name: TestBench
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


module TestBench(

    );

    reg clk;
    reg rst;

    initial begin 
        clk = 1'b0;
        rst = `RstEnable;
        #200
        rst = `RstDisable;
        #1000
        $stop;
    end

    always#10 clk = ~clk;

    mips32_sopc mips32_sopc(
    .clk (clk),
    .rst (rst)

    );
endmodule
