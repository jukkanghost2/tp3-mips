`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/24/2021 03:57:39 PM
// Design Name: 
// Module Name: MUX_RD_31
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


module MUX_RD_31
    (
        input  [4:0] i_rd,
        input        i_rd_selector,
        output [4:0] o_rd
    );

    assign o_rd = i_rd_selector ? 5'b11111 : i_rd;
endmodule
