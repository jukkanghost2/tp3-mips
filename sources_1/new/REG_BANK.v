`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: UNC FCEFyN
// Engineer: Daniele - Gonzalez
// 
// Create Date: 11/16/2021 04:14:21 PM
// Design Name: 
// Module Name: REG_BANK
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


module REG_BANK
    #(  //PARAMETERS
        parameter DATA_WIDTH = 32
    )
    (   //INPUTS
        input                       i_clock,
        input                       i_reset,
        input                       i_regwrite,
        input [DATA_WIDTH - 1:0]    i_writedata,
        input [4:0]                 i_rs,
        input [4:0]                 i_rt,
        input [4:0]                 i_rd,
        input                       i_debug,
        //OUTPUTS
        output [DATA_WIDTH - 1:0]   o_regA,
        output [DATA_WIDTH - 1:0]   o_regB,
        output [DATA_WIDTH - 1:0]   o_reg_debug
    );

    //BANCO DE REGISTROS
    reg [DATA_WIDTH - 1:0] registros [DATA_WIDTH - 1:0];

    reg [4:0] rs;
    reg [4:0] rt;
    reg [4:0] debug_counter;
    
    assign o_regA       = registros[rs];
    assign o_regB       = registros[rt];
    assign o_reg_debug  = registros[debug_counter];
    
    initial begin
        registros[1]  = 1;
        registros[2]  = 2;
        registros[10] = 4;
        registros[31] = 256;
    end

    always @(*) begin
        rs <= i_rs;
        rt <= i_rt;
    end

    always @(negedge i_clock) begin
        if (i_regwrite) registros[i_rd] <= i_writedata;
    end

    always @(negedge i_clock) begin
        if(i_reset) debug_counter = 0;
        else if(i_debug) begin
            debug_counter = debug_counter + 1;
            if(debug_counter == 32) debug_counter = 0;
        end
    end
endmodule