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
        parameter DATA_WIDTH = 32
    )
    (   //INPUTS
        input i_clock,
        input i_reset,
        input [DATA_WIDTH - 1:0] i_regA,
        input [DATA_WIDTH - 1:0] i_regB,
        input [DATA_WIDTH - 1:0] i_extendido,
        input [3:0] i_ex,
        input [2:0] i_mem,
        input [1:0] i_wb,
        //OUTPUTS
        output [DATA_WIDTH - 1:0] o_regA,
        output [DATA_WIDTH - 1:0] o_regB,
        output [DATA_WIDTH - 1:0] o_extendido,
        output [3:0] o_ex,
        output [2:0] o_mem,
        output [1:0] o_wb
    );

    reg [DATA_WIDTH - 1:0] regA;
    reg [DATA_WIDTH - 1:0] regB;
    reg [DATA_WIDTH - 1:0] extendido;

    assign o_regA = regA;
    assign o_regB = regB;
    assign o_extendido = extendido;
    
    always @(posedge i_clock) begin
        regA <= i_regA;
        regB <= i_regB;
        extendido <= i_extendido;
    end

endmodule
