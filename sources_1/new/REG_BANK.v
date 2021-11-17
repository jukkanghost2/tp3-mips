`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/16/2021 04:14:21 PM
// Design Name: 
// Module Name: REG_BANK
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


module REG_BANK
    #(  //PARAMETERS
        parameter DATA_WIDTH = 32
    )
    (   //INPUTS
        input i_clock,
        input i_reset,
        input i_write,
        input [DATA_WIDTH - 1:0] i_instruccion,
        input [DATA_WIDTH - 1:0] i_writedata,
        //OUTPUTS
        output [DATA_WIDTH - 1:0] o_regA,
        output [DATA_WIDTH - 1:0] o_regB
    );
    //BANCO DE REGISTROS
    reg [DATA_WIDTH - 1:0] registros [DATA_WIDTH - 1:0];

    reg [DATA_WIDTH - 1:0] rs;
    reg [DATA_WIDTH - 1:0] rt;
    reg [DATA_WIDTH - 1:0] rd;

    assign o_regA = registros[rs];
    assign o_regB = registros[rt];
    
    always @(posedge i_clock) begin
        rs <= i_instruccion[25:21];
        rt <= i_instruccion[20:16];
        rd <= i_instruccion[15:11];
    end

    always @(posedge i_clock) begin
        if (i_write)
        registros[rd] <= i_writedata;
    end
    
endmodule
