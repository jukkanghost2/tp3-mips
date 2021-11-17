`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/16/2021 10:13:44 AM
// Design Name: 
// Module Name: PC_MUX
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


module PC_MUX
    #(  //PARAMETERS
        parameter DATA_WIDTH = 32
    )
    (   //INPUTS
        input [DATA_WIDTH - 1:0] i_pc_branch,
        input [DATA_WIDTH - 1:0] i_pc_jump,
        input [DATA_WIDTH - 1:0] i_pc_incr,
        input [1:0] i_select,
        //OUTPUTS
        output [DATA_WIDTH - 1:0] o_pc
    );

    reg [DATA_WIDTH - 1 : 0] out;

    assign o_pc = out;

    always @(*) begin
        case(i_select)
            2'b00: out = i_pc_branch;
            2'b01: out = i_pc_jump;
            2'b10: out = i_pc_incr;
            default: out = 0;
        endcase
    end
    
endmodule
