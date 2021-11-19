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
        input i_regwrite,
        input [DATA_WIDTH - 1:0] i_writedata,
        input [4:0] i_rs,
        input [4:0] i_rt,
        input [4:0] i_rd,
        //OUTPUTS
        output [DATA_WIDTH - 1:0] o_regA,
        output [DATA_WIDTH - 1:0] o_regB
    );
    //BANCO DE REGISTROS
    reg [DATA_WIDTH - 1:0] registros [DATA_WIDTH - 1:0];

    reg [4:0] rs;
    reg [4:0] rt;
    reg [4:0] rd;
    
    assign o_regA = registros[rs];
    assign o_regB = registros[rt];
    
    initial begin
        registros[0] = 1;
        registros[1] = 2;
    end

    always @(posedge i_clock) begin
        rs <= i_rs;
        rt <= i_rt;
        rd <= i_rd;
    end

    always @(posedge i_clock) begin
        if (i_regwrite)
        registros[rd] <= i_writedata;
    end
    
endmodule
