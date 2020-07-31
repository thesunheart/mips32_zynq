`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/28 15:23:24
// Design Name: 
// Module Name: mips32_zynq
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


module mips32_zynq(
    input clk,
    input rst,
    input [`InstBus] rom_data,//指令存储寄存器
    output [`InstAddrBus] rom_addr,
    output rom_en

    );

    wire [`InstAddrBus] pc;
    wire [`InstAddrBus] id_pc;
    wire [`InstBus] id_inst;

    wire [`RegBus] reg1_data;
    wire [`RegBus] reg2_data;
    wire reg1_rd_en;
    wire reg2_rd_en;
    wire [`RegAddrBus] reg1_addr;
    wire [`RegAddrBus] reg2_addr;
    wire [`RegBus] reg1_out;
    wire [`RegBus] reg2_out;

    wire [`AluOpBus] aluop;
    wire [`AluSelBus] alusel;
    wire [`RegAddrBus] waddr;
    wire wr_en;

    wire [`AluOpBus] ex_aluop;
    wire [`AluSelBus] ex_alusel;
    wire [`RegBus] ex_reg1;
    wire [`RegBus] ex_reg2;
    wire [`RegAddrBus] ex_waddr;
    wire ex_wr_en;

    wire [`RegBus] wdata_out;
    wire [`RegAddrBus] waddr_out;
    wire wr_en1; 

    wire [`RegBus] mem_wdata;
    wire [`RegAddrBus] mem_waddr;
    wire mem_wr_en;

    wire [`RegBus] wdata;
    wire [`RegAddrBus] waddr1;
    wire wr_en2;

    wire [`RegBus] wb_wdata;
    wire [`RegAddrBus] wb_waddr;
    wire wb_wr_en;

    wire [`RegBus] wb_hi;
    wire [`RegBus] wb_lo;
    wire wb_hilo_en;

    wire [`RegBus] mem_hi;
    wire [`RegBus] mem_lo;
    wire mem_hilo_en;

    wire [`RegBus] hi_out;
    wire [`RegBus] lo_out;

    wire [`RegBus] ex_hi;
    wire [`RegBus] ex_lo;
    wire ex_hilo_en;

    wire [`RegBus] hi;
    wire [`RegBus] lo;
    wire hilo_en;


    pc_ctrl pc_ctrl(
    .clk (clk),
    .rst (rst),
    .pc (pc),
    .chip_en (rom_en) 

    );

    pc_id pc_id(
    .clk(clk),
    .rst (rst),
    .pc (pc),
    .pc_inst (rom_data),
    .id_pc (id_pc),
    .id_inst (id_inst)

    );

    assign rom_addr = pc;
    
    reg_file reg_file(//根据指令集，寄存器要支持最多同时读出两个数据和写入一个数据
    .rst (rst),
    .clk (clk),

    .wr_en (wb_wr_en),
    .wraddr (wb_waddr),
    .wrdata (wb_wdata),

    .rd_en1 (reg1_rd_en),
    .rdaddr1 (reg1_addr),
    .rddata1 (reg1_data),

    .rd_en2 (reg2_rd_en),
    .rdaddr2 (reg2_addr),
    .rddata2 (reg2_data)

    );

    id_ctrl id(//纯组合逻辑电路
    .rst (rst),
    .id_pc (id_pc),
    .id_inst (id_inst),

    .reg1_data (reg1_data),
    .reg2_data (reg2_data),

    .ex_wr_en (wr_en1),//防止流水线数据读写冲突
    .ex_wdata (wdata_out),
    .ex_waddr (waddr_out),

    .mem_wr_en (wr_en2),
    .mem_wdata (wdata),
    .mem_waddr (waddr1),

    .reg1_rd_en (reg1_rd_en),
    .reg2_rd_en (reg2_rd_en),
    .reg1_addr (reg1_addr),
    .reg2_addr (reg2_addr),

    .reg1_out (reg1_out),
    .reg2_out (reg2_out),

    .aluop (aluop),
    .alusel (alusel),
    .waddr (waddr),
    .wr_en (wr_en)
    );

    id_ex id_ex(
    .clk (clk),
    .rst (rst),
    .id_aluop (aluop),
    .id_alusel (alusel),
    .id_reg1 (reg1_out),
    .id_reg2 (reg2_out),
    .id_waddr (waddr),
    .id_wr_en (wr_en),

    .ex_aluop (ex_aluop),
    .ex_alusel (ex_alusel),
    .ex_reg1 (ex_reg1),
    .ex_reg2 (ex_reg2),
    .ex_waddr (ex_waddr),
    .ex_wr_en (ex_wr_en)

    );

    ex_ctrl ex(
    .rst (rst),
    .ex_aluop (ex_aluop),
    .ex_aluselop (ex_alusel),
    .ex_reg1 (ex_reg1),
    .ex_reg2 (ex_reg2),
    .ex_waddr (ex_waddr),
    .ex_wr_en (ex_wr_en),

    .wdata_out (wdata_out),
    .waddr_out (waddr_out),
    .wr_en (wr_en1),

    .hi (hi_out),
    .lo (lo_out),

    .wb_hi (wb_hi),
    .wb_lo (wb_lo),
    .wb_hilo_en (wb_hilo_en),

    .mem_hi (mem_hi),
    .mem_lo (mem_lo),
    .mem_hilo_en (mem_hilo_en),

    .hi_out (ex_hi),
    .lo_out (ex_lo),
    .hilo_en_out (ex_hilo_en)

    );

    ex_mem ex_mem(
    .clk (clk),
    .rst (rst),
    .wdata (wdata_out),
    .waddr (waddr_out),
    .wr_en (wr_en1),

    .ex_hi (ex_hi),
    .ex_lo (ex_lo),
    .ex_hilo_en (ex_hilo_en),
    
    .mem_wdata (mem_wdata),
    .mem_waddr (mem_waddr),
    .mem_wr_en (mem_wr_en),

    .mem_hi (hi),
    .mem_lo (lo),
    .mem_hilo_en (hilo_en)

    );

    mem_ctrl mem(
    .rst (rst),
    .mem_wdata (mem_wdata),
    .mem_waddr (mem_waddr),
    .mem_wr_en (mem_wr_en),

    .hi (hi),
    .lo (lo),
    .hilo_en (hilo_en),
    
    .wdata (wdata),
    .waddr (waddr1),
    .wr_en (wr_en2),

    .hi_out (mem_hi),
    .lo_out (mem_lo),
    .hilo_en_out (mem_hilo_en)

    );

    mem_wb mem_wb(
    .clk (clk),
    .rst (rst),
    .wdata (wdata),
    .waddr (waddr1),
    .wr_en (wr_en2),

    .mem_hi (mem_hi),
    .mem_lo (mem_lo),
    .mem_hilo_en (mem_hilo_en),
    
    .wb_wdata (wb_wdata),
    .wb_waddr (wb_waddr),
    .wb_wr_en (wb_wr_en),

    .wb_hi (wb_hi),
    .wb_lo (wb_lo),
    .wb_hilo_en (wb_hilo_en)

    );

    hilo_reg hilo_ctrl(//乘除法特殊寄存器
    .clk (clk),
    .rst (rst),
    .wr_en (wb_hilo_en),
    .hi (wb_hi),
    .lo (wb_lo),
    .hi_out (hi_out),
    .lo_out (lo_out)

    );




endmodule
