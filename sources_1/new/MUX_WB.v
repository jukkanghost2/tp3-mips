`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: UNC FCEFyN
// Engineer: Daniele - Gonzalez
// 
// Create Date: 11/17/2021 07:34:11 PM
// Design Name: 
// Module Name: MUX_WB
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


module MUX_WB
    #(
        parameter DATA_WIDTH = 32
    )
    (
        input [DATA_WIDTH - 1 : 0]  i_address,
        input [DATA_WIDTH - 1 : 0]  i_dataread,
        input                       i_memtoreg,
        output [DATA_WIDTH - 1 : 0] o_mem_or_reg
    );

    assign o_mem_or_reg = i_memtoreg ? i_address : i_dataread;
endmodule