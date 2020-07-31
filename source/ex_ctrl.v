`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/28 12:05:16
// Design Name: 
// Module Name: ex_ctrl
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


module ex_ctrl(
    input rst,
    input [`AluOpBus] ex_aluop,
    input [`AluSelBus] ex_aluselop,
    input [`RegBus] ex_reg1,
    input [`RegBus] ex_reg2,
    input [`RegAddrBus] ex_waddr,
    input ex_wr_en,

    output reg [`RegBus] wdata_out,
    output reg [`RegAddrBus] waddr_out,
    output reg wr_en, 

    input [`RegBus] hi,//加入特殊寄存器后防止读写冲突
    input [`RegBus] lo,

    input [`RegBus] wb_hi,
    input [`RegBus] wb_lo,
    input wb_hilo_en,

    input [`RegBus] mem_hi,
    input [`RegBus] mem_lo,
    input mem_hilo_en,

    output reg [`RegBus] hi_out,
    output reg [`RegBus] lo_out,
    output reg hilo_en_out

    );

    reg [`RegBus] logicout;
    reg [`RegBus] hi_reg;
    reg [`RegBus] lo_reg;
    reg [`RegBus] mov_reg;

    always@(*)begin 
        if(rst == `RstEnable)
            {hi_reg, lo_reg} <= {`ZeroWord, `ZeroWord};
        else if(mem_hilo_en == `WriteEnable)
            {hi_reg, lo_reg} <= {mem_hi, mem_lo};
        else if(wb_hilo_en == `WriteEnable)
            {hi_reg, lo_reg} <= {wb_hi, wb_lo};
        else 
            {hi_reg, lo_reg} <= {hi, lo};
    end 

    always@(*)begin 
        if(rst == `RstEnable)
            mov_reg <= `ZeroWord;
        else begin 
            mov_reg <= `ZeroWord;
            case(ex_aluop)
                `EXE_MFHI_OP:
                    mov_reg <= hi_reg;
                `EXE_MFLO_OP:
                    mov_reg <= lo_reg;
                `EXE_MOVZ_OP:
                    mov_reg <= ex_reg1;
                `EXE_MOVN_OP:
                    mov_reg <= ex_reg1;
                default:;
            endcase
        end
    end

    always@(*)begin 
        if(rst == `RstEnable)begin 
            hilo_en_out <= `WriteDisable;
            hi_out <= `ZeroWord;
            lo_out <= `ZeroWord;
        end 
        else if(ex_aluop == `EXE_MTHI_OP)begin 
            hilo_en_out <= `WriteEnable;
            hi_out <= ex_reg1;
            lo_out <= lo_reg;
        end
        else if(ex_aluop == `EXE_MTLO_OP)begin 
            hilo_en_out <= `WriteEnable;
            hi_out <= hi_reg;
            lo_out <= ex_reg1;
        end
        else begin 
            hilo_en_out <= `WriteDisable;
            hi_out <= `ZeroWord;
            lo_out <= `ZeroWord;
        end
    end


    always@(*)begin 
        if(rst == `RstEnable)
            logicout <= `ZeroWord;
        else begin 
            case(ex_aluop)
                `EXE_OR_OP:
                    logicout <= ex_reg1 | ex_reg2;
                `EXE_XOR_OP:
                    logicout <= ex_reg1 ^ ex_reg2;
                `EXE_NOR_OP:
                    logicout <= ~(ex_reg1 | ex_reg2);
                `EXE_AND_OP:
                    logicout <= ex_reg1 & ex_reg2;
                default:
                    logicout <= `ZeroWord;
            endcase
        end
    end

    always@(*)begin 
        wr_en <= ex_wr_en;
        waddr_out <= ex_waddr;
        case(ex_aluselop)
            `EXE_RES_LOGIC:
                wdata_out <= logicout;
            `EXE_RES_MOVE:
                wdata_out <= mov_reg;
            default:
                wdata_out <= `ZeroWord;
        endcase     
    end   

endmodule
