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
        // ADDU R1 CON R2 => R3
        i_loading = 1'b1;
        i_instruccion = 32'b00000000001000100001100000100001;
        #10000
        // ADDU R3 CON R2 => R1
        i_address = 32'b1;
        i_instruccion = 32'b00000000011000100000100000100001;
        #10000
        // ADDI R1 CON INMEDIATO 3 => R4
        i_address = 32'b10;
        i_instruccion = 32'b00100000001001000000000000000011;
        #10000
        // STORE (R1 + 0) <= R2
        i_address = 32'b11;
        i_instruccion = 32'b10101100001000100000000000000000;
        #10000
        // NOP
        i_address = 32'b100;
        i_instruccion = 32'b11100000000000000000000000000000;
        #10000
        // LOAD (R1 + 0) => R7
        i_address = 32'b101;
        i_instruccion = 32'b10001100001001110000000000000000;
        #10000
        // BNE 
        i_address = 32'b110;
        i_instruccion = 32'b00010100001011110000000000001000;
        #10000
        i_address = 32'b111;
        i_instruccion = 32'b11100000000000000000000000000000;
        #10000
        i_address = 32'b1000;
        i_instruccion = 32'b11111100000000000000000000000000;
        #10000
        i_address = 32'b1001;
        i_instruccion = 32'b0;
        i_reset = 1'b1;
        #10000
        i_reset = 1'b0;
        i_loading = 1'b0;
        #100000
        i_reset = 1'b1;
        #400
        i_reset = 1'b0;
        #100000
        $finish;
    end


    always #200 i_clock = ~i_clock;

endmodule
