`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: UNC FCEFyN
// Engineer: Daniele - Gonzalez
// 
// Create Date: 11/11/2021 05:03:11 PM
// Design Name: 
// Module Name: MUX4
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


module MUX4
    #(
        parameter DATA_WIDTH = 32
    )
    (
        input [DATA_WIDTH - 1 : 0]  i_a,
        input [DATA_WIDTH - 1 : 0]  i_b,
        input [DATA_WIDTH - 1 : 0]  i_c,
        input [DATA_WIDTH - 1 : 0]  i_d,
        input  [1:0]                i_select,
        output [DATA_WIDTH - 1 : 0] o_o
    );
    reg [DATA_WIDTH - 1 : 0] out;

    assign o_o = out;

    always @(*) begin
        case(i_select)
            2'b00: out = i_a;
            2'b01: out = i_b;
            2'b10: out = i_c;
            2'b11: out = i_d;
        endcase
    end  
endmodule