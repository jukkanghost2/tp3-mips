`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/17/2021 08:09:08 PM
// Design Name: 
// Module Name: MEM
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


module MEM
    #(  //PARAMETERS
        parameter DATA_WIDTH = 32
    )
    (   //INPUTS
        input i_clock,
        input i_reset,
        input [DATA_WIDTH - 1:0] i_aluresult,
        input [DATA_WIDTH - 1:0] i_regB,
        input [2:0] i_mem,
        //OUTPUTS
        output [DATA_WIDTH - 1:0] o_dataread,
        output [DATA_WIDTH - 1:0] o_address
    );

     MEM_DATOS 
    #( 
     .DATA_WIDTH    (DATA_WIDTH)
     )
     mem_datos (
     .i_clock   (i_clock),
     .i_address       (i_aluresult),
     .i_datawrite       (i_regB),
     .i_memwrite       (i_mem[1]),
     .o_dataread       (o_dataread)
     );
    
endmodule
