`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: UNC FCEFyN
// Engineer: Daniele - Gonzalez
// 
// Create Date: 11/20/2021 12:17:42 PM
// Design Name: 
// Module Name: MUX_EX_REGB_RESULT_MEM
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


module MUX_EX_REGB_RESULT_MEM
    #(
        parameter DATA_WIDTH = 32
    )
    (
        input [DATA_WIDTH - 1 : 0]  i_regB,
        input [DATA_WIDTH - 1 : 0]  i_datawrite,
        input [DATA_WIDTH - 1 : 0]  i_aluresult,
        input  [1:0]                i_cortocircuitoB,
        output [DATA_WIDTH - 1 : 0] o_datoBAlu
    );

    reg [DATA_WIDTH - 1:0] out;

    assign o_datoBAlu = out;

    always @(*) begin
        case(i_cortocircuitoB)
        2'b00:   out = i_regB;
        2'b01:   out = i_datawrite;
        2'b10:   out = i_aluresult;
        default: out = 0;
        endcase
    end
endmodule