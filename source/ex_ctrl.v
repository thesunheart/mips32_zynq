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
    reg [`RegBus] arith_reg;
    reg [`DoubleRegBus] mult_reg;

    wire [`RegBus] reg2;
    wire [`RegBus] sum_result;
    wire over_sum;//溢出
    wire reg_compare;//比较reg1是否小于reg2
    wire [`RegBus] mult_op1;//乘法
    wire [`RegBus] mult_op2;
    wire [`DoubleRegBus] hilo_temp;
    

    assign reg2 = ((ex_aluop == `EXE_SUB_OP) || (ex_aluop == `EXE_SUBU_OP) || (ex_aluop == `EXE_SLT_OP)) ? (~ex_reg2) + 1 : ex_reg2;//求补码
    assign sum_result = ex_reg1 + reg2;
    assign over_sum = (~ex_reg1[31] & ~reg2[31] & sum_result[31]) || (ex_reg1[31] & reg2[31] & ~sum_result[31]);
    assign reg_compare = (ex_aluop == `EXE_SLT_OP) ? ((ex_reg1[31] & ~ex_reg2[31]) || (~ex_reg1[31] & ~ex_reg2[31] & sum_result[31]) || (ex_reg1[31] & ex_reg2[31] & sum_result[31])) : (ex_reg1 < ex_reg2);//无符号数自由比较

    assign mult_op1 = ((ex_aluop == `EXE_MUL_OP) || (ex_aluop == `EXE_MULT_OP) && ex_reg1[31]) ? (~ex_reg1 + 1) : ex_reg1;
    assign mult_op2 = ((ex_aluop == `EXE_MUL_OP) || (ex_aluop == `EXE_MULT_OP) && ex_reg2[31]) ? (~ex_reg2 + 1) : ex_reg2;
    assign hilo_temp = mult_op1 * mult_op2;

    always@(*)begin 
        if(rst == `RstEnable)
            mult_reg <= {`ZeroWord, `ZeroWord};
        else if((ex_aluop == `EXE_MULT_OP) || (ex_aluop == `EXE_MUL_OP))begin 
            if(ex_reg1[31] ^ ex_reg2[31])
                mult_reg <= ~hilo_temp + 1;
            else 
                mult_reg <= hilo_temp;
        end
        else 
            mult_reg <= hilo_temp;
    end

    always@(*)begin 
        if(rst == `RstEnable)
            arith_reg <= `ZeroWord;
        else begin 
            case(ex_aluop)
                `EXE_SLT_OP, `EXE_SLTU_OP:
                    arith_reg <= reg_compare;
                `EXE_ADD_OP, `EXE_ADDU_OP, `EXE_ADDI_OP, `EXE_ADDIU_OP, `EXE_SUB_OP, `EXE_SUBU_OP:
                    arith_reg <= sum_result;
                default:
                    arith_reg <= `ZeroWord;
            endcase
        end
    end

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
        else if((ex_aluop == `EXE_MULT_OP) || (ex_aluop == `EXE_MULTU_OP))begin  
            hilo_en_out <= `WriteEnable;
            hi_out <= mult_reg[63:32];
            lo_out <= mult_reg[31:0];
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
        if(((ex_aluop == `EXE_ADD_OP) || (ex_aluop == `EXE_ADDI_OP) || (ex_aluop == `EXE_SUB_OP)) && (over_sum == 1'b1))
            wr_en <= `WriteDisable;
        else 
            wr_en <= ex_wr_en;
        waddr_out <= ex_waddr;
        case(ex_aluselop)
            `EXE_RES_LOGIC:
                wdata_out <= logicout;
            `EXE_RES_MOVE:
                wdata_out <= mov_reg;
            `EXE_RES_ARITHMETIC:
                wdata_out <= arith_reg;
            `EXE_RES_MUL:
                wdata_out <= mult_reg[31:0];
            default:
                wdata_out <= `ZeroWord;
        endcase     
    end   

endmodule
