`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/16/2021 06:52:29 PM
// Design Name: 
// Module Name: MUX_2_1_EX
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


module MUX_2_1_EX
    #(
        parameter DATA_WIDTH = 32
    )
    (
        input [DATA_WIDTH - 1 : 0]  i_mux_ex_regb_result_mem,
        input [15:0]  i_extendido,
        input                       i_alusrc,
        output [DATA_WIDTH - 1 : 0] o_datoBAlu
    );

    assign o_datoBAlu = i_alusrc ? i_extendido : i_mux_ex_regb_result_mem;
endmodule
