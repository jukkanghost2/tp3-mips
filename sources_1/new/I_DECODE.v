`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: UNC FCEFyN
// Engineer: Daniele - Gonzalez 
// 
// Create Date: 11/16/2021 04:59:24 PM
// Design Name: 
// Module Name: I_DECODE
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


module I_DECODE
   #(  //PARAMETERS
        parameter DATA_WIDTH = 32,
        parameter SIZEOP = 6
    )
    (   //INPUTS
        input                       i_clock,
        input                       i_reset,
        input                       i_regwrite,
        input                       i_burbuja,
        input [DATA_WIDTH - 1:0]    i_writedata,
        input [DATA_WIDTH - 1:0]    i_instruccion,
        input [DATA_WIDTH - 1:0]    i_currentpc,
        input [4:0]                 i_rt_rd,
        input                       i_debug,
        //OUTPUTS
        output [DATA_WIDTH - 1:0]   o_regA,
        output [DATA_WIDTH - 1:0]   o_regB,
        output [DATA_WIDTH - 1:0]   o_extendido,
        output [DATA_WIDTH - 1:0]   o_pcbranch,
        output [SIZEOP - 1:0]       o_opcode,
        output [4:0]                o_rs,
        output [4:0]                o_rt,
        output [4:0]                o_rd,
        output [3:0]                o_ex,
        output [2:0]                o_mem,
        output [1:0]                o_wb,
        output [1:0]                o_sizemem,
        output                      o_signedmem,
        output                      o_branch,
        output [DATA_WIDTH - 1:0]   o_pcjump,
        output                      o_jump,
        output [DATA_WIDTH - 1:0]   o_return_address,
        output                      o_return,
        output                      o_halt,
        output [DATA_WIDTH - 1:0]   o_reg_debug
    );
    wire [8:0]  control_mux;
    wire [8:0]  control_id_ex;
    wire        beq_or_bne;
    wire        rd_selector;

    assign o_opcode = i_instruccion[31:26];
    assign o_rs     = i_instruccion[25:21];
    assign o_rt     = i_instruccion[20:16];
    assign o_ex     = control_id_ex[8:5];
    assign o_mem    = control_id_ex[4:2];
    assign o_wb     = control_id_ex[1:0];

    CONTROL_PRINCIPAL 
    #( 
     .DATA_WIDTH        (DATA_WIDTH),
     .SIZEOP            (SIZEOP)
    )
    control_principal (
     .i_instruccion     (i_instruccion),
     .o_ex              (control_mux[8:5]),
     .o_mem             (control_mux[4:2]),
     .o_wb              (control_mux[1:0]),
     .o_sizemem         (o_sizemem),
     .o_signedmem       (o_signedmem),
     .o_beq_or_bne      (beq_or_bne),
     .o_halt            (o_halt)
    );

    MUX_CONTROL_PRINCIPAL 
    mux_control_principal (
     .i_control         (control_mux),
     .i_burbuja         (i_burbuja),
     .o_control         (control_id_ex)
    );

    REG_BANK 
    #( 
     .DATA_WIDTH        (DATA_WIDTH)
    )
     reg_bank (
     .i_clock           (i_clock),
     .i_reset           (i_reset),
     .i_regwrite        (i_regwrite),
     .i_rs              (i_instruccion[25:21]),
     .i_rt              (i_instruccion[20:16]),
     .i_rd              (i_rt_rd),
     .i_writedata       (i_writedata),
     .i_debug           (i_debug),
     .o_regA            (o_regA),
     .o_regB            (o_regB),
     .o_reg_debug       (o_reg_debug)
    );

    EXTENSOR 
    #( 
     .DATA_WIDTH        (DATA_WIDTH)
    )
     extensor (
     .i_instruccion     (i_instruccion),
     .o_branchoffset    (o_extendido)
    );

    DECODE_ADDER 
    #( 
     .DATA_WIDTH        (DATA_WIDTH)
    )
     decode_adder (
     .i_currentpc       (i_currentpc),
     .i_extendido       (o_extendido),
     .o_pcbranch        (o_pcbranch)
    );

    U_BRANCH
    #( 
     .DATA_WIDTH        (DATA_WIDTH)
    )
     u_branch (
     .i_branch          (o_mem[0]),
     .i_regA            (o_regA),
     .i_regB            (o_regB),
     .i_beq_or_bne      (beq_or_bne),
     .o_branch          (o_branch)
    );

    U_JUMP
      #( 
     .DATA_WIDTH        (DATA_WIDTH)
    )
     u_jump (
     .i_currentpc       (i_currentpc),
     .i_instruccion     (i_instruccion),
     .i_regA            (o_regA),
     .o_pcjump          (o_pcjump),
     .o_return_address  (o_return_address),
     .o_rd_selector     (rd_selector),
     .o_jump            (o_jump),
     .o_return          (o_return)
    );

    MUX_RD_31
     mux_rd_31 (
     .i_rd              (i_instruccion[15:11]),
     .i_rd_selector     (rd_selector),
     .o_rd              (o_rd)
    );
endmodule