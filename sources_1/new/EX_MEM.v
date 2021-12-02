`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: UNC FCEFyN
// Engineer: Daniele - Gonzalez
// 
// Create Date: 11/17/2021 07:05:49 PM
// Design Name: 
// Module Name: EX_MEM
// Project Name: MIPS
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


module EX_MEM
    #(  //PARAMETERS
        parameter DATA_WIDTH = 32
    )
    (   //INPUTS
        input                       i_clock,
        input                       i_reset,
        input                       i_start,
        input                       i_step,
        input [DATA_WIDTH - 1:0]    i_aluresult,
        input [DATA_WIDTH - 1:0]    i_regB,
        input [4:0]                 i_rd_rt,
        input [2:0]                 i_mem,
        input [1:0]                 i_wb,
        input [1:0]                 i_sizemem,
        input                       i_signedmem,
        input [DATA_WIDTH - 1:0]    i_return_address,
        input                       i_return,
        input                       i_halt,
        //OUTPUTS
        output [DATA_WIDTH - 1:0]   o_aluresult,
        output [DATA_WIDTH - 1:0]   o_regB,
        output [4:0]                o_rd_rt,
        output [2:0]                o_mem,
        output [1:0]                o_wb,
        output [1:0]                o_sizemem,
        output                      o_signedmem,
        output [DATA_WIDTH - 1:0]   o_return_address,
        output                      o_return,
        output                      o_halt
        );

    reg [DATA_WIDTH - 1:0]  aluresult;
    reg [DATA_WIDTH - 1:0]  regB;
    reg [4:0]               rd_rt;
    reg [2:0]               mem;
    reg [1:0]               wb;
    reg [1:0]               sizemem;
    reg                     signedmem;
    reg [DATA_WIDTH - 1:0]  return_address;
    reg                     return;
    reg                     halt;

    assign o_aluresult      = aluresult;
    assign o_regB           = regB;
    assign o_rd_rt          = rd_rt;
    assign o_mem            = mem;
    assign o_wb             = wb;
    assign o_sizemem        = sizemem;
    assign o_signedmem      = signedmem;
    assign o_return_address = return_address;
    assign o_return         = return;
    assign o_halt           = halt;
    
    always @(posedge i_clock) begin
        if (i_reset) begin
            aluresult       <= 0;
            regB            <= 0;
            rd_rt           <= 0;
            mem             <= 0;
            wb              <= 0;
            sizemem         <= 0;
            signedmem       <= 0;
            return          <= 0;
            return_address  <= 0;
            halt            <= 0;
        end
        else if (i_start && i_step) begin
            aluresult       <= i_aluresult;
            regB            <= i_regB;
            rd_rt           <= i_rd_rt;
            mem             <= i_mem;
            wb              <= i_wb;
            sizemem         <= i_sizemem;
            signedmem       <= i_signedmem;
            return          <= i_return;
            return_address  <= i_return_address;
            halt            <= i_halt;
        end
    end
endmodule