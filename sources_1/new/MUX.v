`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: UNC FCEFyN
// Engineer: Daniele - Gonzalez
// 
// Create Date: 11/11/2021 04:42:50 PM
// Design Name: 
// Module Name: MUX
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


module MUX
    #(
        parameter DATA_WIDTH = 32
    )
    (
        input [DATA_WIDTH - 1 : 0]  i_a,
        input [DATA_WIDTH - 1 : 0]  i_b,
        input                       i_select,
        output [DATA_WIDTH - 1 : 0] o_o
    );

    assign o_o = i_select ? i_b : i_a;
endmodule