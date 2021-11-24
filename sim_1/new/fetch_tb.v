`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: UNC FCEFyN
// Engineer: Daniele - Gonzalez
// 
// Create Date: 11/20/2021 05:05:55 PM
// Design Name: 
// Module Name: fetch_tb
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


module fetch_tb;
      //PARAMETERS
        parameter DATA_WIDTH = 32;
        parameter SIZEOP = 6;
    
      //INPUTS
        reg                     i_clock;
        reg                     i_reset;
        reg [1:0]               i_select;
        reg [DATA_WIDTH - 1:0]  i_instruccion;
        reg [DATA_WIDTH - 1:0]  i_address;
        reg [DATA_WIDTH - 1:0]  i_pc_branch;
        reg [DATA_WIDTH - 1:0]  i_pc_jump;
        reg                     i_loading;

        reg                     i_regwrite;
        reg [DATA_WIDTH - 1:0]  i_writedata;
        reg [4:0]               i_rt_rd;
        //OUTPUTS
        wire [DATA_WIDTH - 1:0] o_instruccion;
        wire [DATA_WIDTH - 1:0] o_pc_incr;

        wire [DATA_WIDTH - 1:0] o_instruccion_if_id;
        wire [DATA_WIDTH - 1:0] o_pc_incr_if_id;

        wire [DATA_WIDTH - 1:0] o_regA;
        wire [DATA_WIDTH - 1:0] o_regB;
        wire [DATA_WIDTH - 1:0] o_extendido;
        wire [DATA_WIDTH - 1:0] o_pcbranch;
        wire [SIZEOP - 1:0]     o_opcode;
        wire [4:0]              o_rs;
        wire [4:0]              o_rt;
        wire [4:0]              o_rd;
        wire [3:0]              o_ex;
        wire [2:0]              o_mem;
        wire [1:0]              o_wb;
    
    I_FETCH 
    #( 
     .DATA_WIDTH    (DATA_WIDTH)
    )
    i_fetch (
     .i_clock       (i_clock),
     .i_reset       (i_reset),
     .i_instruccion (i_instruccion),
     .i_address     (i_address),
     .i_loading     (i_loading),
     .i_select      (i_select), // branch predictor
     .i_pc_branch   (i_pc_branch),
     .i_pc_jump     (i_pc_jump),
     .o_instruccion (o_instruccion),
     .o_pc_incr     (o_pc_incr)
    );

    IF_ID
    #( 
     .DATA_WIDTH    (DATA_WIDTH)
    )
    if_id (
     .i_clock       (i_clock),
     .i_reset       (i_reset),
     .i_instruccion (o_instruccion),
     .i_pc          (o_pc_incr),
     .o_instruccion (o_instruccion_if_id),
     .o_pc          (o_pc_incr_if_id)
    );

    I_DECODE
    #( 
     .DATA_WIDTH    (DATA_WIDTH)
    )
    i_decode (
     .i_clock       (i_clock),
     .i_reset       (i_reset),
     .i_regwrite    (i_regwrite), 
     .i_writedata   (i_writedata), 
     .i_instruccion (o_instruccion_if_id), 
     .i_currentpc   (o_pc_incr_if_id), 
     .i_rt_rd       (i_rt_rd), 
     .o_regA        (o_regA),
     .o_regB        (o_regB),
     .o_extendido   (o_extendido),
     .o_pcbranch    (o_pcbranch),
     .o_opcode      (o_opcode),
     .o_rs          (o_rs),
     .o_rt          (o_rt),
     .o_rd          (o_rd),
     .o_ex          (o_ex),
     .o_mem         (o_mem),
     .o_wb          (o_wb)
    );

      initial begin
        i_clock = 1'b0;
        i_reset = 1'b0;
        i_instruccion = 32'b0;
        i_address = 32'b0;
        i_loading = 1'b0;
        #10000
        i_loading = 1'b1;
        i_instruccion = 32'b00000000001000100001100000100001;
        i_reset = 1'b1;
        #10000
        i_reset = 1'b0;
        i_loading = 1'b0;
        #1000000000
        $finish;
      end

      always #200 i_clock = ~i_clock;  
endmodule