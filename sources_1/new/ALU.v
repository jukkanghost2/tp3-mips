`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/09/2021 04:46:18 PM
// Design Name: 
// Module Name: ALU
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


module ALU
#(
  //PARAMETERS
  parameter     SIZEDATA = 8,
                SIZEOP = 6
)
(
  //INPUTS
  input signed  [SIZEDATA - 1:0]   i_datoa,
  input signed  [SIZEDATA - 1:0]   i_datob,
  input         [SIZEOP - 1:0]     i_opcode,
  //OUTPUTS
  output reg    [SIZEDATA - 1:0]   o_result
);
  
  //OPERATIONS
  //R-TYPE
  localparam [SIZEOP - 1:0]     SLL = 6'b000000;
  localparam [SIZEOP - 1:0]     SRL = 6'b000010;
  localparam [SIZEOP - 1:0]     SRA = 6'b000011;
  localparam [SIZEOP - 1:0]     SLLV = 6'b000100;
  localparam [SIZEOP - 1:0]     SRLV = 6'b000110;
  localparam [SIZEOP - 1:0]     SRAV = 6'b000111;
  localparam [SIZEOP - 1:0]     ADDU = 6'b100001;
  localparam [SIZEOP - 1:0]     SUBU = 6'b100011;
  localparam [SIZEOP - 1:0]     OR  = 6'b100101;
  localparam [SIZEOP - 1:0]     XOR = 6'b100110;
  localparam [SIZEOP - 1:0]     AND = 6'b100100;
  localparam [SIZEOP - 1:0]     NOR = 6'b100111;
  localparam [SIZEOP - 1:0]     SLT = 6'b101010;
  //I-TYPE
  localparam [SIZEOP - 1:0]     ADDI = 6'b001000;
  localparam [SIZEOP - 1:0]     ANDI = 6'b001100;
  localparam [SIZEOP - 1:0]     ORI = 6'b001101;
  localparam [SIZEOP - 1:0]     XORI = 6'b001110;
  localparam [SIZEOP - 1:0]     LUI = 6'b001111;
  localparam [SIZEOP - 1:0]     SLTI = 6'b001010;


  

  always@(*)
    begin
      case(i_opcode)
        SLL: o_result = i_datoa << i_datob;
        SRL: o_result = i_datoa >> i_datob;
        SRA: o_result = i_datoa >>> i_datob;
        SLLV: o_result = i_datoa << i_datob;
        SRLV: o_result = i_datoa >> i_datob;
        SRAV: o_result = i_datoa >>> i_datob;
        ADDU: o_result = i_datoa + i_datob;
        SUBU: o_result = i_datoa - i_datob;
        OR:  o_result = i_datoa | i_datob;
        XOR: o_result = i_datoa ^ i_datob;
        AND: o_result = i_datoa & i_datob;
        NOR: o_result = ~(i_datoa | i_datob);
        SLT: o_result = i_datoa < i_datob;
        ADDI: o_result = i_datoa + i_datob;
        ANDI:  o_result = i_datoa & i_datob;
        ORI: o_result = i_datoa | i_datob;
        XORI: o_result = i_datoa ^ i_datob;
        LUI: o_result = i_datoa << i_datob;
        SLTI: o_result = i_datoa < i_datob;
        default: o_result = 0;
      endcase
    end
endmodule
