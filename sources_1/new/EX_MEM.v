`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/17/2021 07:05:49 PM
// Design Name: 
// Module Name: EX_MEM
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


module EX_MEM
    #(  //PARAMETERS
        parameter DATA_WIDTH = 32
    )
    (   //INPUTS
        input i_clock,
        input i_reset,
        input [DATA_WIDTH - 1:0] i_aluresult,
        input [DATA_WIDTH - 1:0] i_regB,
        input [4:0] i_rd_rt,
        input [2:0] i_mem,
        input [1:0] i_wb,
        //OUTPUTS
        output [DATA_WIDTH - 1:0] o_aluresult,
        output [DATA_WIDTH - 1:0] o_regB,
        output [4:0] o_rd_rt,
        output [2:0] o_mem,
        output [1:0] o_wb
    );

    reg [DATA_WIDTH - 1:0] aluresult;
    reg [DATA_WIDTH - 1:0] regB;
    reg [4:0] rd_rt;
    reg [2:0] mem;
    reg [1:0] wb;

    assign o_aluresult = aluresult;
    assign o_regB = regB;
    assign o_rd_rt = rd_rt;
    assign o_mem = mem;
    assign o_wb = wb;

    always @(posedge i_clock) begin
        aluresult <= i_aluresult;
        regB <= i_regB;
        rd_rt <= o_rd_rt;
        mem <= i_mem;
        wb <= i_wb;
    end
    
endmodule
