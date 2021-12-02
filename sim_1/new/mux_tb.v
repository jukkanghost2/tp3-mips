`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/11/2021 04:53:07 PM
// Design Name: 
// Module Name: mux_tb
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


module mux_tb;
  parameter DATA_WIDTH = 32;

	//INPUTS
  reg     [DATA_WIDTH - 1:0]    i_a;
  reg     [DATA_WIDTH - 1:0]    i_b;
  reg     [DATA_WIDTH - 1:0]    i_c;
  reg     [DATA_WIDTH - 1:0]    i_d;
  reg     [1:0]                 i_select;
  //OUTPUTS
  wire   [DATA_WIDTH - 1:0]     o_o;

  MUX4 muxito4 (
    .i_a      (i_a), 
    .i_b      (i_b), 
    .i_c      (i_c), 
    .i_d      (i_d), 
    .i_select (i_select), 
    .o_o      (o_o)
  );

    initial begin
        i_a       = 0;
        i_b       = 0;
        i_c       = 0;
        i_d       = 0;
        i_select  = 2'b00;
        #20
        i_a       = 3;
        i_b       = 4;
        i_c       = 5;
        i_d       = 6;
        #20
        i_select  = 2'b01;
        #20
        i_select  = 2'b10;
        #20
        i_select  = 2'b11;
        #20
        $finish;
    end
endmodule