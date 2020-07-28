`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/26 21:19:16
// Design Name: 
// Module Name: reg_file
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


module reg_file(//根据指令集，寄存器要支持最多同时读出两个数据和写入一个数据
    input rst,
    input clk,

    input wr_en,
    input [`RegAddrBus] wraddr,
    input [`RegBus] wrdata,

    input rd_en1,
    input [`RegAddrBus] rdaddr1,
    output reg [`RegBus] rddata1,

    input rd_en2,
    input [`RegAddrBus] rdaddr2,
    output reg [`RegBus] rddata2

    );

    reg [`RegBus] regs [0:`RegNum - 1];//大端

    always@(posedge clk)begin //回写阶段的实现，因此会是时序电路
        if(rst == `RstDisable)begin 
            if((wr_en == `WriteEnable) && (wraddr !== `RegNumLog2'h0))//MIPS架构规定reg0只能为0，不能写入
                regs[wraddr] <= wrdata;
        end
    end

    always@(*)begin //组合逻辑电路，保证读出数据到译码阶段结束为一个时钟周期
        if(`RstEnable)
            rddata1 <= `ZeroWord;
        else if(rdaddr1 == `RegNumLog2'h0)
            rddata1 <= `ZeroWord;
        else if((wr_en == `WriteEnable) && (rd_en1 == `ReadEnable) && (wraddr == rdaddr1))
            rddata1 <= wrdata;
        else if(rd_en1 == `ReadEnable)
            rddata1 <= regs[rdaddr1];
        else 
            rddata1 <= `ZeroWord;
    end

    always@(*)begin //组合逻辑电路，保证读出数据到译码阶段结束为一个时钟周期
        if(`RstEnable)
            rddata2 <= `ZeroWord;
        else if(rdaddr2 == `RegNumLog2'h0)
            rddata2 <= `ZeroWord;
        else if((wr_en == `WriteEnable) && (rd_en2 == `ReadEnable) && (wraddr == rdaddr1))
            rddata2 <= wrdata;
        else if(rd_en2 == `ReadEnable)
            rddata2 <= regs[rdaddr2];
        else 
            rddata2 <= `ZeroWord;
    end

endmodule
