`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/28 16:45:05
// Design Name: 
// Module Name: mips32_sopc
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


module mips32_sopc(
    input clk,
    input rst

    );

    wire [`InstBus] inst;
    wire [`InstAddrBus] addr;
    wire rom_en;

    mips32_zynq mips32_zynq(
    .clk (clk),
    .rst (rst),
    .rom_data (inst),
    .rom_addr (addr),
    .rom_en (rom_en)

    );

    inst_rom inst_rom(
    .rom_en (rom_en),
    .addr (addr),
    .inst (inst)

    );

endmodule
