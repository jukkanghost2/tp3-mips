`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/16/2021 03:13:23 PM
// Design Name: 
// Module Name: I_FETCH
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


module I_FETCH
    #(  //PARAMETERS
        parameter DATA_WIDTH = 32
    )
    (   //INPUTS
        input i_clock,
        input i_reset,
        input [1:0] i_select,
        input [DATA_WIDTH - 1:0] i_instruccion,
        input [DATA_WIDTH - 1:0] i_address,
        input [DATA_WIDTH - 1:0] i_pc_branch,
        input [DATA_WIDTH - 1:0] i_pc_jump,
        input i_loading,
        //OUTPUTS
        output [DATA_WIDTH - 1:0] o_instruccion,
        output [DATA_WIDTH - 1:0] o_pc_incr
    );

    wire [DATA_WIDTH - 1:0] current_pc;
    wire [DATA_WIDTH - 1:0] pc_mux_wire;
    wire [DATA_WIDTH - 1:0] instr_mux;
    wire haltsignal_pc;

    PC 
    #( 
     .DATA_WIDTH    (DATA_WIDTH)
     )
     pc (
     .i_clock    (i_clock),
     .i_reset    (i_reset),
     .i_pc_mux   (pc_mux_wire),
     .i_haltsignal   (haltsignal_pc),
     .o_pc       (current_pc)
     );

    PC_MUX 
    #( 
     .DATA_WIDTH    (DATA_WIDTH)
     )
     pc_mux (
     .i_pc_branch    (i_pc_branch),
     .i_pc_jump      (i_pc_jump),
     .i_pc_incr      (o_pc_incr),
     .i_select       (i_select),   
     .o_pc           (pc_mux_wire)
     );

    PC_ADDER 
    #( 
     .DATA_WIDTH    (DATA_WIDTH)
     )
     pc_adder (
     .i_pc          (current_pc),
     .o_pc_incr     (o_pc_incr)
     );

    MEM_INSTRUCCIONES 
    #( 
     .DATA_WIDTH    (DATA_WIDTH)
     )
     mem_instruccions
     (
     .i_clock           (i_clock),
     .i_reset           (i_reset),
     .i_pc              (current_pc),
     .i_instruccion              (i_instruccion),
     .i_address              (i_address),
     .i_loading              (i_loading),
     .o_instruccion     (instr_mux),
     .o_haltsignal     (haltsignal_pc)
     );

     MUX_INSTR_NOP
     #( 
     .DATA_WIDTH    (DATA_WIDTH)
     )
     mux_instr_nop (
     .i_instruccion          (instr_mux),
     .i_branch     (i_select[0]),
     .o_instr_nop     (o_instruccion)
     );

endmodule
