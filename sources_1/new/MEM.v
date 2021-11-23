`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: UNC FCEFyN
// Engineer: Daniele - Gonzalez
// 
// Create Date: 11/17/2021 08:09:08 PM
// Design Name: 
// Module Name: MEM
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


module MEM
    #(  //PARAMETERS
        parameter DATA_WIDTH = 32
    )
    (   //INPUTS
        input                       i_clock,
        input                       i_reset,
        input                       i_signedmem,
        input [1:0]                 i_sizemem,
        input [DATA_WIDTH - 1:0]    i_address,
        input [DATA_WIDTH - 1:0]    i_datawrite,
        input [2:0]                 i_mem,
        //OUTPUTS
        output [DATA_WIDTH - 1:0]   o_dataread
    );


     MEM_DATOS 
    #( 
     .DATA_WIDTH    (DATA_WIDTH)
    )
    mem_datos (
     .i_clock       (i_clock),
     .i_signed      (i_signedmem),
     .i_size        (i_sizemem),
     .i_address     (i_address),
     .i_datawrite   (i_datawrite),
     .i_memwrite    (i_mem[1]),
     .i_memread     (i_mem[2]),
     .o_dataread    (o_dataread)
    );
endmodule