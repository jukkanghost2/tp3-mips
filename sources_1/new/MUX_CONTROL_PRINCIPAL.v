`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: UNC FCEFyN
// Engineer: Daniele - Gonzalez
// 
// Create Date: 11/22/2021 01:24:43 PM
// Design Name: 
// Module Name: MUX_CONTROL_PRINCIPAL
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


module MUX_CONTROL_PRINCIPAL
    (   //INPUTS
        input [8:0]     i_control,
        input           i_burbuja,
        //OUTPUTS
        output [8:0]    o_control
    );

    assign o_control = i_burbuja ? 9'b001100000 : i_control;
endmodule