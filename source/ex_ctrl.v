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
    output reg wr_en 

    );

    reg [`RegBus] logicout;

    always@(*)begin 
        if(rst == `RstEnable)
            logicout <= `ZeroWord;
        else begin 
            case(ex_aluop)
                `EXE_OR_OP:
                    logicout <= ex_reg1 | ex_reg2;
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
            default:
                logicout <= `ZeroWord;
        endcase     
    end   

endmodule
