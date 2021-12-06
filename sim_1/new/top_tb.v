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
    reg i_start;
    reg i_step;
     //OUTPUTS
    wire [DATA_WIDTH - 1:0] o_result_wb;
    wire o_finish;

    TOP_MIPS 
    #(
     .DATA_WIDTH    (DATA_WIDTH),
     .SIZEOP    (SIZEOP),
     .SIZESA    (SIZESA)
    )
    top_mips (
     .i_clock    (i_clock),
     .i_reset      (i_reset),
     .i_start      (i_start),
     .i_step      (i_step),
     .i_instruccion      (i_instruccion),
     .i_address       (i_address),   
     .i_loading           (i_loading), 
     .o_result_wb           (o_result_wb),
     .o_finish          (o_finish)
    );

    initial begin
        i_clock = 1'b0;
        i_reset = 1'b0;
        i_instruccion = 32'b0;
        i_address = 32'b0;
        i_loading = 1'b0;
        i_start = 1'b0;
        i_step = 1'b0;
        #10000
        // ADDU R1 CON R2 => R3 = 3
        i_loading = 1'b1;
        i_instruccion = 32'b00000000001000100001100000100001;
        #10000
        // ADDU R3 CON R2 => R1 = 5
        i_address = 32'b1;
        i_instruccion = 32'b00000000011000100000100000100001;
        #10000
        // ADDI R1 CON INMEDIATO 3grande => R2 = 8 grande
        i_address = 32'b10;
        i_instruccion = 32'b00100000001000100000111110111101;
        #10000
        // // STORE (R1 + 0) <= R2 = POS 5 = 2
        // i_address = 32'b11;
        // i_instruccion = 32'b10101100001000100000000000000000;
        // #10000
        // // NOP
        // i_address = 32'b11;
        // i_instruccion = 32'b11100000000000000000000000000000;
        // #10000
        // // NOP
        // i_address = 32'b100;
        // i_instruccion = 32'b11100000000000000000000000000000;
        // #10000
         // STOREBYTE (R1 + 0) <= R2 = POS 5 = 2
        i_address = 32'b11;
        i_instruccion = 32'b10100000001000100000000000000000;
        #10000
        // // ADDI R1 CON INMEDIATO 3 => R4 = 8
        // i_address = 32'b100;
        // i_instruccion = 32'b00100000001001000000000000000011;
        // #10000
        // // LOAD (R1 + 0) => R7  = 2
        // i_address = 32'b100;
        // i_instruccion = 32'b10001100001001110000000000000000;
        // #10000
        // LOAD HALF (R1 + 0) => R7  = 2
        i_address = 32'b100;
        i_instruccion = 32'b10010000001001110000000000000000;
        #10000
        // // JUMP JALR
        // i_address = 32'b101;
        // i_instruccion = 32'b00000000011000001000000000001001;
        // #10000
        // ADD R7 + R1 => R2 = 7
        i_address = 32'b101;
        i_instruccion = 32'b00000000111000010111000000100001;
        #10000
        // ADDU R1 CON R2 => R3 = 12
        i_address = 32'b110;
        i_instruccion = 32'b00000000001000100001100000100001;
        #10000
        // // BNE  R1 != R7 = 1 => PC incr + 4
        // i_address = 32'b1000;
        // i_instruccion = 32'b00010100001001110000000000000001;
        // #10000
        // //nop
        // i_address = 32'b111;
        // i_instruccion = 32'b11100000000000000000000000000000;
        // #10000
        //HALT
        i_address = 32'b111;
        i_instruccion = 32'b11111100000000000000000000000000;
        i_reset = 1'b1;
        #10000
        i_reset = 1'b0;
        i_start = 1'b1;
        i_loading = 1'b0;
        #1000
        i_step = 1'b1;
        #100
        i_step = 1'b0;
        #1000
        i_step = 1'b1;
        #100
        i_step = 1'b0;
        #1000
        i_step = 1'b1;
        #100
        i_step = 1'b0;
        #1000
        i_step = 1'b1;
        #100
        i_step = 1'b0;
        #1000
        i_step = 1'b1;
        #100
        i_step = 1'b0;
        #1000
        i_step = 1'b1;
        #100
        i_step = 1'b0;
        #1000
        i_step = 1'b1;
        #100
        i_step = 1'b0;
        #1000
        i_step = 1'b1;
        #100
        i_step = 1'b0;
        #1000
        i_step = 1'b1;
        #100
        i_step = 1'b0;
        #1000
        i_step = 1'b1;
        #100
        i_step = 1'b0;
        #1000
        i_step = 1'b1;
        #100
        i_step = 1'b0;
        #1000
        i_step = 1'b1;
        #100
        i_step = 1'b0;
        #1000
        i_step = 1'b1;
        #100
        i_step = 1'b0;
        #1000
        i_step = 1'b1;
        #100
        i_step = 1'b0;
        $finish;
    end


    always #100 i_clock = ~i_clock;

endmodule
