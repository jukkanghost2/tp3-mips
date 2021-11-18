`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/17/2021 11:04:48 AM
// Design Name: 
// Module Name: ALU_CONTROL
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


module ALU_CONTROL
    #(  //PARAMETERS
        parameter SIZEOP = 6
    )
    (   //INPUTS
        input [1:0] i_aluop,
        input [1:0] i_funct,
        //OUTPUTS
        output [3:0] o_alucontrol
    );

    reg [3:0] alucontrol;

    assign o_alucontrol = alucontrol;

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

//   always @(*) begin
//       case (i_aluop)
//           //LW Y SW
//           2'b00: begin
              
//           end
//           //BEQ 
//           2'b01: begin
              
//           end
//           //R-TYPE 
//           2'b10: begin
//               case (i_funct)
//                   SLL: begin
                      
//                   end 
//                   SRL: begin
                      
//                   end 
//                   SRA: begin
                      
//                   end 
//                   SLLV: begin
                      
//                   end 
//                   SRLV: begin
                      
//                   end 
//                   SRAV: begin
                      
//                   end 
//                   ADDU: begin
                      
//                   end 
//                   SUBU: begin
                      
//                   end 
//                   OR: begin
                      
//                   end 
//                   XOR: begin
                      
//                   end 
//                   AND: begin
                      
//                   end 
//                   NOR: begin
                      
//                   end 
//                   SLT: begin
                      
//                   end 
//                   default: 
//               endcase              
//           end 
//           default: 
//       endcase
//   end


endmodule
