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
                SIZEOP = 6,
                SIZESA = 5
)
(
  //INPUTS
  input signed  [SIZEDATA - 1:0]   i_datoa,
  input signed  [SIZEDATA - 1:0]   i_datob,
  input         [SIZESA - 1:0]     i_shamt,
  input         [3:0]     i_alucontrol,
  //OUTPUTS
  output reg    [SIZEDATA - 1:0]   o_result
);
  
  //OPERATIONS
  //R-TYPE
  localparam [SIZEOP - 1:0]     SLL = 4'b0000;
  localparam [SIZEOP - 1:0]     SRL = 4'b0001;
  localparam [SIZEOP - 1:0]     SRA = 4'b0010;
  localparam [SIZEOP - 1:0]     SLLV = 4'b0011;
  localparam [SIZEOP - 1:0]     SRLV = 4'b0100;
  localparam [SIZEOP - 1:0]     SRAV = 4'b0101;
  localparam [SIZEOP - 1:0]     ADDU = 4'b0110;
  localparam [SIZEOP - 1:0]     SUBU = 4'b0111;
  localparam [SIZEOP - 1:0]     OR  = 4'b1000;
  localparam [SIZEOP - 1:0]     XOR = 4'b1001;
  localparam [SIZEOP - 1:0]     AND = 4'b1010;
  localparam [SIZEOP - 1:0]     NOR = 4'b1011;
  localparam [SIZEOP - 1:0]     SLT = 4'b1100;
  //I-TYPE
  localparam [SIZEOP - 1:0]     LUI = 4'b1101;
  // localparam [SIZEOP - 1:0]     ADDI = 6'b001000;
  // localparam [SIZEOP - 1:0]     ANDI = 6'b001100;
  // localparam [SIZEOP - 1:0]     ORI = 6'b001101;
  // localparam [SIZEOP - 1:0]     XORI = 6'b001110;
  // localparam [SIZEOP - 1:0]     SLTI = 6'b001010;

  

  always@(*)
    begin
      case(i_alucontrol)
        SLL: o_result = i_datob << i_shamt;
        SRL: o_result = i_datob >> i_shamt;
        SRA: o_result = i_datob >>> i_shamt;
        SLLV: o_result = i_datob << i_datoa;
        SRLV: o_result = i_datob >> i_datoa;
        SRAV: o_result = i_datob >>> i_datoa;
        ADDU: o_result = i_datoa + i_datob;
        SUBU: o_result = i_datoa - i_datob;
        OR:  o_result = i_datoa | i_datob;
        XOR: o_result = i_datoa ^ i_datob;
        AND: o_result = i_datoa & i_datob;
        NOR: o_result = ~(i_datoa | i_datob);
        SLT: o_result = i_datoa < i_datob;
        // ADDI: o_result = i_datoa + i_datob;
        // ANDI:  o_result = i_datoa & i_datob;
        // ORI: o_result = i_datoa | i_datob;
        // XORI: o_result = i_datoa ^ i_datob;
        LUI: o_result = i_datob << 16;
        // SLTI: o_result = i_datoa < i_datob;
        default: o_result = 0;
      endcase
    end
endmodule
