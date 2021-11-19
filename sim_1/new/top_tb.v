`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/19/2021 05:41:52 PM
// Design Name: 
// Module Name: top_tb
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


module top_tb;
     //PARAMETERS
     parameter DATA_WIDTH = 32;
     parameter SIZEOP = 6;
     parameter SIZESA = 5;

    
    //INPUTS
    reg i_clock;
    reg i_reset;
    reg [DATA_WIDTH - 1:0] i_instruccion;
    reg [DATA_WIDTH - 1:0] i_address;
    reg i_loading;
     //OUTPUTS
    wire [DATA_WIDTH - 1:0] o_result_wb;

    TOP_MIPS 
    #(
     .DATA_WIDTH    (DATA_WIDTH),
     .SIZEOP    (SIZEOP),
     .SIZESA    (SIZESA)
    )
    top_mips (
     .i_clock    (i_clock),
     .i_reset      (i_reset),
     .i_instruccion      (i_instruccion),
     .i_address       (i_address),   
     .i_loading           (i_loading), 
     .o_result_wb           (o_result_wb) 
    );

    initial begin
        i_clock = 1'b0;
        i_reset = 1'b0;
        i_instruccion = 32'b0;
        i_address = 32'b0;
        i_loading = 1'b0;
        #10000
        i_loading = 1'b1;
        i_instruccion = 32'b00000000000000010001000000100001;
        i_reset = 1'b1;
        #10000
        i_reset = 1'b0;
        i_loading = 1'b0;
        #1000000000
        $finish;
    end


    always #200 i_clock = ~i_clock;

endmodule
