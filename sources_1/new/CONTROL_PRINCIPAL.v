`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/16/2021 07:18:59 PM
// Design Name: 
// Module Name: CONTROL_PRINCIPAL
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


module CONTROL_PRINCIPAL
    #(  //PARAMETERS
        parameter DATA_WIDTH = 32,
        parameter SIZEOP = 6
    )
    (   //INPUTS
        input [DATA_WIDTH - 1:0] i_instruccion,
        //OUTPUTS
        output [3:0] o_ex,
        output [2:0] o_mem,
        output [1:0] o_wb
    );

     //OPERATIONS
  //R-TYPE
  localparam [SIZEOP - 1:0]     R_TYPE = 6'b000000;
  localparam [SIZEOP - 1:0]     LW = 6'b100011;
  localparam [SIZEOP - 1:0]     SW = 6'b101011;
  localparam [SIZEOP - 1:0]     BEQ = 6'b000100;

    reg [SIZEOP - 1:0] opcode;
    reg [3:0] ex;
    reg [2:0] mem;
    reg [1:0] wb;

    always @(*) begin
        opcode = i_instruccion[31:26];
        case (opcode)
            R_TYPE: begin
                ex = 4'b1010;
                mem = 3'b000;
                wb = 2'b11;
            end
            LW: begin
                ex = 4'b0100;
                mem = 3'b100;
                wb = 2'b10;
            end
            SW: begin
                ex = 4'bx100;
                mem = 3'b010;
                wb = 2'b0x;
            end
            BEQ: begin
                ex = 4'bx001;
                mem = 3'b001;
                wb = 2'b0x;
            end
            default: begin
                ex = 4'b0000;
                mem = 3'b000;
                wb = 2'b00;
            end
        endcase
    end
    
endmodule
