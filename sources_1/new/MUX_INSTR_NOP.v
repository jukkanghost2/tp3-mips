`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: UNC FCEFyN
// Engineer: Daniele - Gonzalez
// 
// Create Date: 11/21/2021 06:38:05 PM
// Design Name: 
// Module Name: MUX_INSTR_NOP
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


module MUX_INSTR_NOP
  #(  //PARAMETERS
        parameter DATA_WIDTH = 32
    )
    (   //INPUTS
        input [DATA_WIDTH - 1:0]    i_instruccion,
        input                       i_branch,
        //OUTPUTS
        output [DATA_WIDTH - 1:0]   o_instr_nop
    );

    localparam [DATA_WIDTH - 1:0]     NOP = 32'b11100000000000000000000000000000;

    assign o_instr_nop = i_branch ? NOP : i_instruccion;
endmodule