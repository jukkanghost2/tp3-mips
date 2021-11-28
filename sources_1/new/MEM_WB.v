`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: UNC FCEFyN
// Engineer: Daniele - Gonzalez
// 
// Create Date: 11/17/2021 07:30:49 PM
// Design Name: 
// Module Name: MEM_WB
// Project Name: MIPS
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
        input                       i_clock,
        input                       i_reset,
        input                       i_start,
        input                       i_step,
        input [DATA_WIDTH - 1:0]    i_dataread,
        input [DATA_WIDTH - 1:0]    i_address,
        input [4:0]                 i_rd_rt,
        input [1:0]                 i_wb,
        input [DATA_WIDTH - 1:0]    i_return_address,
        input                       i_return,
        input                       i_halt,
        //OUTPUTS
        output [DATA_WIDTH - 1:0]   o_dataread,
        output [DATA_WIDTH - 1:0]   o_address,
        output [4:0]                o_rd_rt,
        output [1:0]                o_wb,
        output [DATA_WIDTH - 1:0]   o_return_address,
        output                      o_return,
        output                      o_halt
    );

    reg [DATA_WIDTH - 1:0]  dataread;
    reg [DATA_WIDTH - 1:0]  address;
    reg [4:0]               rd_rt;
    reg [1:0]               wb;
    reg [DATA_WIDTH - 1:0] return_address;
    reg return;
    reg halt;

    assign o_dataread   = dataread;
    assign o_address    = address;
    assign o_rd_rt      = rd_rt;
    assign o_wb         = wb;
    assign o_return_address = return_address;
    assign o_return = return;
    assign o_halt = halt;

    always @(posedge i_clock) begin
        if (i_reset) begin
            dataread         <= 0;
            address          <= 0;
            rd_rt            <= 0;
            wb               <= 0;
            return           <= 0;
            return_address   <= 0;
            halt   <= 0;
        end
        else if (i_start && i_step) begin
            dataread         <= i_dataread;
            address          <= i_address;
            rd_rt            <= i_rd_rt;
            wb               <= i_wb;
            return           <= i_return;
            return_address   <= i_return_address;
            halt   <= i_halt;
        end
    end
endmodule