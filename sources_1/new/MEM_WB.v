`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/17/2021 07:30:49 PM
// Design Name: 
// Module Name: MEM_WB
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


module MEM_WB
    #(  //PARAMETERS
        parameter DATA_WIDTH = 32
    )
    (   //INPUTS
        input i_clock,
        input i_reset,
        input [DATA_WIDTH - 1:0] i_dataread,
        input [DATA_WIDTH - 1:0] i_address,
        input [4:0] i_rd_rt,
        input [1:0] i_wb,
        //OUTPUTS
        output [DATA_WIDTH - 1:0] o_dataread,
        output [DATA_WIDTH - 1:0] o_address,
        output [4:0] o_rd_rt,
        output [1:0] o_wb
    );

    reg [DATA_WIDTH - 1:0] dataread;
    reg [DATA_WIDTH - 1:0] address;
    reg [4:0] rd_rt;
    reg [1:0] wb;

    assign o_dataread = dataread;
    assign o_address = address;
    assign o_rd_rt = rd_rt;
    assign o_wb = wb;

    always @(posedge i_clock) begin
        dataread <= i_dataread;
        address <= i_address;
        rd_rt <= o_rd_rt;
        wb <= i_wb;
    end
    
endmodule
