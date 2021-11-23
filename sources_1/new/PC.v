`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/16/2021 10:13:08 AM
// Design Name: 
// Module Name: PC
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


module PC
    #(  //PARAMETERS
        parameter DATA_WIDTH = 32
    )
    (   //INPUTS
        input i_clock,
        input i_reset,
        input i_pcburbuja,
        input [DATA_WIDTH - 1:0] i_pc_mux,
        input i_haltsignal,
        //OUTPUTS
        output [DATA_WIDTH - 1:0] o_pc
    );

    reg [DATA_WIDTH - 1:0] pcout;

    assign o_pc = pcout;
    
    always @(posedge i_clock) begin
        if (i_reset)
        pcout <= 0;
        else if ((!i_haltsignal) && (!i_pcburbuja))
        pcout <= i_pc_mux;
    end

endmodule
