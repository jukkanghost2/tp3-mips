`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/16/2021 03:55:34 PM
// Design Name: 
// Module Name: IF_ID
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


module IF_ID
   #(  //PARAMETERS
        parameter DATA_WIDTH = 32
    )
    (   //INPUTS
        input i_clock,
        input i_reset,
        input [DATA_WIDTH - 1:0] i_instruccion,
        input [DATA_WIDTH - 1:0] i_pc,
        //OUTPUTS
        output [DATA_WIDTH - 1:0] o_instruccion,
        output [DATA_WIDTH - 1:0] o_pc
    );

    reg [DATA_WIDTH - 1:0] instrout;
    reg [DATA_WIDTH - 1:0] pcout;

    assign o_instruccion = instrout;
    assign o_pc = pcout;
    
    always @(posedge i_clock) begin
        instrout <= i_instruccion;
        pcout <= i_pc;
    end
    
endmodule
