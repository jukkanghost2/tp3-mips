`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/16/2021 04:26:37 PM
// Design Name: 
// Module Name: EXTENSOR
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


module EXTENSOR
   #(  //PARAMETERS
        parameter DATA_WIDTH = 32,
        parameter IMM_WIDTH = 16
    )
    (   //INPUTS
        input [DATA_WIDTH - 1:0] i_instruccion,
        //OUTPUTS
        output [DATA_WIDTH - 1:0] o_branchoffset
    );

    assign o_branchoffset = {{IMM_WIDTH{i_instruccion[IMM_WIDTH - 1]}}, i_instruccion[IMM_WIDTH - 1:0]};
endmodule
