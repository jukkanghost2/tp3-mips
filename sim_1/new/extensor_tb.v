`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/16/2021 04:40:02 PM
// Design Name: 
// Module Name: extensor_tb
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


module extensor_tb;
 parameter DATA_WIDTH = 32;
 parameter IMM_WIDTH = 16;

	//INPUTS
  reg     [DATA_WIDTH - 1:0]    i_instruccion;
  //OUTPUTS
  wire   [DATA_WIDTH - 1:0]    o_branchoffset;

  EXTENSOR extensorcito (
    .i_instruccion      (i_instruccion), 
    .o_branchoffset     (o_branchoffset)
  );
    
  initial begin
      i_instruccion = 32'b00000000000000001001001001000000;
      #20
      i_instruccion = 32'b00000000000000000001001001000000;
      #20
      $finish;
  end
endmodule