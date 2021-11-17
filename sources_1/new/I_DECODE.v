`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/16/2021 04:59:24 PM
// Design Name: 
// Module Name: I_DECODE
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


module I_DECODE
   #(  //PARAMETERS
        parameter DATA_WIDTH = 32
    )
    (   //INPUTS
        input i_clock,
        input i_reset,
        input i_write,
        input [DATA_WIDTH - 1:0] i_writedata,
        input [DATA_WIDTH - 1:0] i_instruccion,
        input [DATA_WIDTH - 1:0] i_currentpc,
        //OUTPUTS
        output [DATA_WIDTH - 1:0] o_regA,
        output [DATA_WIDTH - 1:0] o_regB,
        output [DATA_WIDTH - 1:0] o_extendido,
        output [DATA_WIDTH - 1:0] o_pcbranch,
        output [3:0] o_ex,
        output [2:0] o_mem,
        output [1:0] o_wb
    );

    CONTROL_PRINCIPAL 
    #( 
     .DATA_WIDTH    (DATA_WIDTH)
     )
     control_principal (
     .i_instruccion   (i_instruccion),
     .o_ex       (o_ex),
     .o_mem       (o_mem),
     .o_wb       (o_wb)
     );

    REG_BANK 
    #( 
     .DATA_WIDTH    (DATA_WIDTH)
     )
     reg_bank (
     .i_clock    (i_clock),
     .i_reset    (i_reset),
     .i_write    (i_write),
     .i_instruccion   (i_instruccion),
     .i_writedata   (i_writedata),
     .o_regA       (o_regA),
     .o_regB       (o_regB)
     );

    EXTENSOR 
    #( 
     .DATA_WIDTH    (DATA_WIDTH)
     )
     extensor (
     .i_instruccion    (i_instruccion),
     .o_branchoffset    (o_extendido)
     );

    DECODE_ADDER 
    #( 
     .DATA_WIDTH    (DATA_WIDTH)
     )
     decode_adder (
     .i_currentpc          (i_currentpc),
     .i_extendido          (o_extendido),
     .o_pcbranch            (o_pcbranch)
     );

endmodule
