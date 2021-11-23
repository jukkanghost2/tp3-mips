`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: UNC FCEFyN
// Engineer: Daniele - Gonzalez
// 
// Create Date: 11/20/2021 11:59:50 AM
// Design Name: 
// Module Name: MUX_EX_REGA_RESULT_MEM
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


module MUX_EX_REGA_RESULT_MEM
   #(
        parameter DATA_WIDTH = 32
    )
    (
        input [DATA_WIDTH - 1 : 0]  i_regA,
        input [DATA_WIDTH - 1 : 0]  i_datawrite,
        input [DATA_WIDTH - 1 : 0]  i_aluresult,
        input  [1:0]                i_cortocircuitoA,
        output [DATA_WIDTH - 1 : 0] o_datoAAlu
    );

    reg [DATA_WIDTH - 1:0] out;

    assign o_datoAAlu = out;

    always @(*) begin
        case(i_cortocircuitoA)
        2'b00:
            out = i_regA;
        2'b01:
            out = i_datawrite;
        2'b10:
            out = i_aluresult;
        default:
            out = 0;
        endcase
    end
endmodule