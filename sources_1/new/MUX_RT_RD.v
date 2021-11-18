`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/17/2021 08:03:04 PM
// Design Name: 
// Module Name: MUX_RT_RD
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


module MUX_RT_RD
    #(
        parameter DATA_WIDTH = 32
    )
    (
        input [4:0]  i_rt,
        input [4:0]  i_rd,
        input        i_regdst,
        output [4:0] o_rt_rd
    );

    assign o_rt_rd = i_regdst ? i_rt : i_rd;
    
endmodule
