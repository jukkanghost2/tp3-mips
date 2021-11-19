`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/16/2021 05:11:28 PM
// Design Name: 
// Module Name: ID_EX
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


module ID_EX
    #(  //PARAMETERS
        parameter DATA_WIDTH = 32,
        parameter SIZEOP = 6
    )
    (   //INPUTS
        input i_clock,
        input i_reset,
        input [DATA_WIDTH - 1:0] i_regA,
        input [DATA_WIDTH - 1:0] i_regB,
        input [DATA_WIDTH - 1:0] i_extendido,
        input [SIZEOP - 1:0] i_opcode,
        input [4:0] i_rt,
        input [4:0] i_rd,
        input [3:0] i_ex,
        input [2:0] i_mem,
        input [1:0] i_wb,
        //OUTPUTS
        output [DATA_WIDTH - 1:0] o_regA,
        output [DATA_WIDTH - 1:0] o_regB,
        output [DATA_WIDTH - 1:0] o_extendido,
        output [SIZEOP - 1:0] o_opcode,
        output [4:0] o_rt,
        output [4:0] o_rd,
        output [3:0] o_ex,
        output [2:0] o_mem,
        output [1:0] o_wb
    );

    reg [DATA_WIDTH - 1:0] regA;
    reg [DATA_WIDTH - 1:0] regB;
    reg [DATA_WIDTH - 1:0] extendido;
    reg [SIZEOP - 1:0] opcode;
    reg [4:0] rt;
    reg [4:0] rd;
    reg [3:0] ex;
    reg [2:0] mem;
    reg [1:0] wb;

    assign o_regA = regA;
    assign o_regB = regB;
    assign o_extendido = extendido;
    assign o_opcode = opcode;
    assign o_rt = rt;
    assign o_rd = rd;
    assign o_ex = ex;
    assign o_mem = mem;
    assign o_wb = wb;
    
    always @(posedge i_clock) begin
        regA <= i_regA;
        regB <= i_regB;
        extendido <= i_extendido;
        opcode <= i_opcode;
        rt <= i_rt;
        rd <= i_rd;
        ex <= i_ex;
        mem <= i_mem;
        wb <= i_wb;
    end

endmodule
