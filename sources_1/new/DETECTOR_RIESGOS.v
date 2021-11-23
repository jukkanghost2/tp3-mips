`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: UNC FCEFyN
// Engineer: Daniele - Gonzalez
// 
// Create Date: 11/22/2021 12:57:17 PM
// Design Name: 
// Module Name: DETECTOR_RIESGOS
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


module DETECTOR_RIESGOS
    (   //INPUTS
        input [4:0]     i_rs,
        input [4:0]     i_rt,
        input [4:0]     i_id_ex_rt,
        input [2:0]     i_id_ex_mem,
        //OUTPUTS
        output          o_pc_write,
        output          o_if_id_write,
        output          o_mux_zero
    );

    reg pc_write;
    reg if_id_write;
    reg mux_zero;

    assign o_pc_write       = pc_write;
    assign o_if_id_write    = if_id_write;
    assign o_mux_zero       = mux_zero;

    initial begin
        pc_write = 1'b0;
        if_id_write = 1'b0;
        mux_zero = 1'b0;
    end
    
    always @(*) begin
        pc_write    = 1'b0;
        if_id_write = 1'b0;
        mux_zero    = 1'b0;
        if(i_id_ex_mem[2]) begin
            if((i_id_ex_rt == i_rs) || (i_id_ex_rt == i_rt)) begin
                pc_write    = 1'b1;
                if_id_write = 1'b1;
                mux_zero    = 1'b1;
            end
        end
    end
endmodule