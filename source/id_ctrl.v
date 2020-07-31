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

    wire [5:0] op = id_inst[31:26];
    wire [4:0] op2 = id_inst[10:6];
    wire [5:0] op3 = id_inst[5:0];
    wire [4:0] op4 = id_inst[20:16];

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
                `EXE_ANDI:begin 
                    wr_en <= `WriteEnable;
                    aluop <= `EXE_AND_OP;
                    alusel <= `EXE_RES_LOGIC;
                    reg1_rd_en <= `ReadEnable;
                    reg2_rd_en <= `ReadDisable;
                    imm <= {16'h0, id_inst[15:0]};
                    waddr <= id_inst[20:16];
                    instvalid <= `InstInvalid;
                end
                `EXE_XORI:begin 
                    wr_en <= `WriteEnable;
                    aluop <= `EXE_XOR_OP;
                    alusel <= `EXE_RES_LOGIC;
                    reg1_rd_en <= `ReadEnable;
                    reg2_rd_en <= `ReadDisable;
                    imm <= {16'h0, id_inst[15:0]};
                    waddr <= id_inst[20:16];
                    instvalid <= `InstInvalid;
                end
                `EXE_SPECIAL_INST:begin 
                    case(op2)
                        5'b00000:begin 
                            case(op3)
                                `EXE_OR:begin 
                                    wr_en <= `WriteEnable;
                                    aluop <= `EXE_OR_OP;
                                    alusel <= `EXE_RES_LOGIC;
                                    reg1_rd_en <= `ReadEnable;
                                    reg2_rd_en <= `ReadEnable;
                                    instvalid <= `InstInvalid;
                                end
                                `EXE_AND:begin 
                                    wr_en <= `WriteEnable;
                                    aluop <= `EXE_AND_OP;
                                    alusel <= `EXE_RES_LOGIC;
                                    reg1_rd_en <= `ReadEnable;
                                    reg2_rd_en <= `ReadEnable;
                                    instvalid <= `InstInvalid;
                                end
                                `EXE_XOR:begin 
                                    wr_en <= `WriteEnable;
                                    aluop <= `EXE_XOR_OP;
                                    alusel <= `EXE_RES_LOGIC;
                                    reg1_rd_en <= `ReadEnable;
                                    reg2_rd_en <= `ReadEnable;
                                    instvalid <= `InstInvalid;
                                end
                                `EXE_NOR:begin 
                                    wr_en <= `WriteEnable;
                                    aluop <= `EXE_NOR_OP;
                                    alusel <= `EXE_RES_LOGIC;
                                    reg1_rd_en <= `ReadEnable;
                                    reg2_rd_en <= `ReadEnable;
                                    instvalid <= `InstInvalid;
                                end
                                `EXE_MFHI:begin 
                                    wr_en <= `WriteEnable;
                                    aluop <= `EXE_MFHI_OP;
                                    alusel <= `EXE_RES_MOVE;
                                    reg1_rd_en <= `ReadDisable;
                                    reg2_rd_en <= `ReadDisable;
                                    instvalid <= `InstInvalid;
                                end
                                `EXE_MFLO:begin 
                                    wr_en <= `WriteEnable;
                                    aluop <= `EXE_MFLO_OP;
                                    alusel <= `EXE_RES_MOVE;
                                    reg1_rd_en <= `ReadDisable;
                                    reg2_rd_en <= `ReadDisable;
                                    instvalid <= `InstInvalid;
                                end
                                `EXE_MTLO:begin 
                                    wr_en <= `WriteDisable;//不需要修改通用寄存器
                                    aluop <= `EXE_MTLO_OP;
                                    reg1_rd_en <= `ReadEnable;
                                    reg2_rd_en <= `ReadDisable;
                                    instvalid <= `InstInvalid;
                                end
                                `EXE_MTHI:begin 
                                    wr_en <= `WriteDisable;
                                    aluop <= `EXE_MTHI_OP;
                                    reg1_rd_en <= `ReadEnable;
                                    reg2_rd_en <= `ReadDisable;
                                    instvalid <= `InstInvalid;
                                end
                                `EXE_MOVN:begin 
                                    if(reg2_data != `ZeroWord)
                                        wr_en <= `WriteEnable;
                                    else 
                                        wr_en <= `WriteDisable;
                                    aluop <= `EXE_MOVN_OP;
                                    alusel <= `EXE_RES_MOVE;
                                    reg1_rd_en <= `ReadEnable;
                                    reg2_rd_en <= `ReadEnable;
                                    instvalid <= `InstInvalid;
                                end
                                `EXE_MOVZ:begin 
                                    if(reg2_data == `ZeroWord)
                                        wr_en <= `WriteEnable;
                                    else 
                                        wr_en <= `WriteDisable;
                                    aluop <= `EXE_MOVZ_OP;
                                    alusel <= `EXE_RES_MOVE;
                                    reg1_rd_en <= `ReadEnable;
                                    reg2_rd_en <= `ReadEnable;
                                    instvalid <= `InstInvalid;
                                end
                                default:;
                            endcase
                        end
                        default:;
                    endcase
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
