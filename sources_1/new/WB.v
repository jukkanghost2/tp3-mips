`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: UNC FCEFyN
// Engineer: Daniele - Gonzalez
// 
// Create Date: 11/18/2021 12:28:14 AM
// Design Name: 
// Module Name: WB
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


module WB
    #(  //PARAMETERS
        parameter DATA_WIDTH = 32
    )
    (   //INPUTS
        input                       i_reset,
        input [DATA_WIDTH - 1:0]    i_dataread,
        input [DATA_WIDTH - 1:0]    i_address,
        input                       i_memtoreg,
        input [DATA_WIDTH - 1:0]    i_return_address,
        input                       i_return,
        //OUTPUTS
        output [DATA_WIDTH - 1:0]   o_mem_or_reg
    );

    wire [DATA_WIDTH - 1:0] address;

     MUX_WB 
    #( 
     .DATA_WIDTH    (DATA_WIDTH)
    )
    mux_wb (
     .i_address     (address),
     .i_dataread    (i_dataread),
     .i_memtoreg    (i_memtoreg),
     .o_mem_or_reg  (o_mem_or_reg)
    );

     MUX_DATAREG 
    #( 
     .DATA_WIDTH    (DATA_WIDTH)
    )
    mux_datareg (
     .i_address     (i_address),
     .i_return_address    (i_return_address),
     .i_return    (i_return),
     .o_address  (address)
    );
endmodule