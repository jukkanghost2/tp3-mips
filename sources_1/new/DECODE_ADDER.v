`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: UNC FCEFyN
// Engineer: Daniele - Gonzalez
// 
// Create Date: 11/16/2021 04:46:29 PM
// Design Name: 
// Module Name: DECODE_ADDER
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


module DECODE_ADDER
    #(  //PARAMETERS
        parameter DATA_WIDTH = 32
    )
    (   //INPUTS
        input [DATA_WIDTH - 1:0]    i_currentpc,
        input [DATA_WIDTH - 1:0]    i_extendido,
        //OUTPUTS
        output [DATA_WIDTH - 1:0]   o_pcbranch
    );

    assign o_pcbranch = i_currentpc + (i_extendido << 2);
endmodule