`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/24/2021 04:25:14 PM
// Design Name: 
// Module Name: MUX_DATAREG
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


module MUX_DATAREG
    #(
        parameter DATA_WIDTH = 32
    )
    (
        input [DATA_WIDTH - 1 : 0]  i_address,
        input [DATA_WIDTH - 1 :0]   i_return_address,
        input                       i_return,
        output [DATA_WIDTH - 1 : 0] o_address
    );

    assign o_address = i_return ? i_return_address : i_address;
    
endmodule
