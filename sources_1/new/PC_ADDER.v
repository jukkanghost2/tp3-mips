`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/16/2021 10:15:08 AM
// Design Name: 
// Module Name: PC_ADDER
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


module PC_ADDER
    #(  //PARAMETERS
        parameter DATA_WIDTH = 32
    )
    (   //INPUTS
        input [DATA_WIDTH - 1:0] i_pc,
        //OUTPUTS
        output [DATA_WIDTH - 1:0] o_pc_incr
    );

    assign o_pc_incr = i_pc + 1;

endmodule
