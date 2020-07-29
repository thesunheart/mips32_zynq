`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/27 22:17:36
// Design Name: 
// Module Name: id_ctrl
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


module id_ctrl(//纯组合逻辑电路
    input rst,
    input [`InstAddrBus] id_pc,
    input [`InstBus] id_inst,

    input [`RegBus] reg1_data,
    input [`RegBus] reg2_data,

    input ex_wr_en,//防止流水线数据读写冲突
    input [`RegBus] ex_wdata,
    input [`RegAddrBus] ex_waddr,

    input mem_wr_en,
    input [`RegBus] mem_wdata,
    input [`RegAddrBus] mem_waddr,

    output reg reg1_rd_en,
    output reg reg2_rd_en,
    output reg [`RegAddrBus] reg1_addr,
    output reg [`RegAddrBus] reg2_addr,

    output reg [`RegBus] reg1_out,//两个操作数并不一定都是从寄存器取出，可能有一个为立即数，要进行选择
    output reg [`RegBus] reg2_out,

    output reg [`AluOpBus] aluop,//根据给出的指令，确定要执行的运算类型，即指令译码
    output reg [`AluSelBus] alusel,//要执行的运算子类型
    output reg [`RegAddrBus] waddr,//要写的寄存器的地址
    output reg wr_en//写寄存器使能
    );

    reg [`RegBus] imm;
    reg instvalid;

    wire [5:0] op;
    assign op = id_inst[31:26];

    always@(*)begin 
        if(rst == `RstEnable)begin 
            aluop <= `EXE_NOP_OP;
            alusel <= `EXE_RES_NOP;
            waddr <= `NOPRegAddr;
            wr_en <= `WriteDisable;
            instvalid <= `InstValid;
            reg1_rd_en <= `ReadDisable;
            reg2_rd_en <= `ReadDisable;
            reg1_addr <= `NOPRegAddr;
            reg2_addr <= `NOPRegAddr;
            imm <= `ZeroWord;
        end
        else begin 
            aluop <= `EXE_NOP_OP;
            alusel <= `EXE_RES_NOP;
            waddr <= id_inst[15:11];
            wr_en <= `WriteDisable;
            instvalid <= `InstInvalid;
            reg1_rd_en <= `ReadDisable;
            reg2_rd_en <= `ReadDisable;
            reg1_addr <= id_inst[25:21];
            reg2_addr <= id_inst[20:16];
            imm <= `ZeroWord;
            case(op)
                `EXE_ORI:begin 
                    wr_en <= `WriteEnable;
                    aluop <= `EXE_OR_OP;
                    alusel <= `EXE_RES_LOGIC;
                    reg1_rd_en <= `ReadEnable;
                    reg2_rd_en <= `ReadDisable;
                    imm <= {16'h0, id_inst[15:0]};
                    waddr <= id_inst[20:16];
                    instvalid <= `InstInvalid;
                end
                default:;
            endcase
        end  
    end

    always@(*)begin 
        if(rst == `RstEnable)
            reg1_out <= `ZeroWord;
        else if((reg1_rd_en == `ReadEnable) && (ex_wr_en == `WriteEnable) && (ex_waddr == reg1_addr))
            reg1_out <= ex_wdata;
        else if((reg1_rd_en == `ReadEnable) && (mem_wr_en == `WriteEnable) && (mem_waddr == reg1_addr))
            reg1_out <= mem_wdata;   
        else if(reg1_rd_en == `ReadEnable)
            reg1_out <= reg1_data;
        else if(reg1_rd_en == `ReadDisable)
            reg1_out <= imm;
        else 
            reg1_out <= `ZeroWord;
    end

    always@(*)begin 
        if(rst == `RstEnable)
            reg2_out <= `ZeroWord;
        else if((reg2_rd_en == `ReadEnable) && (ex_wr_en == `WriteEnable) && (ex_waddr == reg2_addr))
            reg2_out <= ex_wdata;
        else if((reg2_rd_en == `ReadEnable) && (mem_wr_en == `WriteEnable) && (mem_waddr == reg2_addr))
            reg2_out <= mem_wdata;
        else if(reg2_rd_en == `ReadEnable)
            reg2_out <= reg2_data;
        else if(reg2_rd_en == `ReadDisable)
            reg2_out <= imm;
        else 
            reg2_out <= `ZeroWord;
    end
            



endmodule
