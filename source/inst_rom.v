`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/28 16:20:24
// Design Name: 
// Module Name: inst_rom
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


module inst_rom(
    input rom_en,
    input [`InstAddrBus] addr,//地址按照字节寻址
    output reg [`InstBus] inst,
    output [`InstBus] rom0

    );

    reg [`InstBus] rom [0:`InstMemNum - 1];

    assign rom0 = rom[0];

    initial $readmemh("D:/VivadoProject/mips32_zynq/mips32_zynq.srcs/sources_1/new/inst_rom.data", rom);

    always@(*)begin 
        if(rom_en == `ChipDisable)
            inst <= `ZeroWord;
        else 
            inst <= rom[addr[`InstMemNumLog2 + 1 : 2]];//指令寄存器中每个指令32位，占4个字节，addr是按照字节寻址，因此输进来的地址要除以4，即左移2位
    end

endmodule
