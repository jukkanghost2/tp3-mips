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
 //I-TYPE
  localparam [SIZEOP - 1:0]     LW = 6'b100011;
  localparam [SIZEOP - 1:0]     SW = 6'b101011;
  localparam [SIZEOP - 1:0]     BEQ = 6'b000100;
  localparam [SIZEOP - 1:0]     ADDI = 6'b001000;
  localparam [SIZEOP - 1:0]     ANDI = 6'b001100;
  localparam [SIZEOP - 1:0]     ORI = 6'b001101;
  localparam [SIZEOP - 1:0]     XORI = 6'b001110;
  localparam [SIZEOP - 1:0]     LUI = 6'b001111;
  localparam [SIZEOP - 1:0]     SLTI = 6'b001010;
  //NOP y HALT
  localparam [SIZEOP - 1:0]     NOP = 6'b111000;
  localparam [SIZEOP - 1:0]     HALT = 6'b111111;


    reg [SIZEOP - 1:0] opcode;
    reg [3:0] ex;
    reg [2:0] mem;
    reg [1:0] wb;

    assign o_ex = ex;
    assign o_mem = mem;
    assign o_wb = wb;

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
            ADDI: begin
                ex = 4'bx011;
                mem = 3'b001;
                wb = 2'b0x;
            end
            ANDI: begin
                ex = 4'bx011;
                mem = 3'b001;
                wb = 2'b0x;
            end
            ORI: begin
                ex = 4'bx011;
                mem = 3'b001;
                wb = 2'b0x;
            end
            XORI: begin
                ex = 4'bx011;
                mem = 3'b001;
                wb = 2'b0x;
            end
            LUI: begin
                ex = 4'bx011;
                mem = 3'b001;
                wb = 2'b0x;
            end
            SLTI: begin
                ex = 4'bx011;
                mem = 3'b001;
                wb = 2'b0x;
            end
            NOP: begin
                ex = 4'b0011;
                mem = 3'b000;
                wb = 2'b00;
            end
            HALT: begin
                ex = 4'b0011;
                mem = 3'b000;
                wb = 2'b00;
            end
            default: begin
                ex = 4'b0000;
                mem = 3'b000;
                wb = 2'b00;
            end
        endcase
    end
    
endmodule
