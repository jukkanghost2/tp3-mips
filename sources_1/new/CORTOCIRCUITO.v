`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/20/2021 01:32:03 PM
// Design Name: 
// Module Name: CORTOCIRCUITO
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


module CORTOCIRCUITO
    #(  //PARAMETERS
        parameter DATA_WIDTH = 32
    )
    (   //INPUTS
        input [4:0] i_rd_rt_mem,
        input [4:0] i_rd_rt_wb,
        input [4:0] i_rs,
        input [4:0] i_rt,
        input [1:0] i_wb_mem,
        input [1:0] i_wb_wb,
        //OUTPUTS
        output [1:0] o_cortocircuitoA,
        output [1:0] o_cortocircuitoB
    );

    reg [1:0] cortocircuitoA;
    reg [1:0] cortocircuitoB;

    assign o_cortocircuitoA = cortocircuitoA;
    assign o_cortocircuitoB = cortocircuitoB;

    always @(*) begin
        cortocircuitoA = 2'b00;
        cortocircuitoB = 2'b00;
        //RIESGO EX
        //SI EX_MEM.REGWRITE Y EX_MEM.RD != 0
        if((i_wb_mem[1]) && (i_rd_rt_mem != 0)) begin
            //SI EX_MEM.RD == ID_EX.RS
            if(i_rd_rt_mem == i_rs) begin
                cortocircuitoA = 2'b10;
            end
            //SI EX_MEM.RD == ID_EX.RT
            if(i_rd_rt_mem == i_rt) begin
                cortocircuitoB = 2'b10;
            end
        end
        //RIESGO MEM
        //SI MEM_WB.REGWRITE Y MEM_WB.RD != 0
        if((i_wb_wb[1]) && (i_rd_rt_wb != 0)) begin
            //SI EX_MEM.RD != ID_EX.RS y SI MEM_WB.RD == ID_EX.RS
            if((i_rd_rt_mem != i_rs) && (i_rd_rt_wb == i_rs)) begin
                cortocircuitoA = 2'b01;
            end
            //SI EX_MEM.RD != ID_EX.RT y SI MEM_WB.RD == ID_EX.RT
            if((i_rd_rt_mem != i_rt) && (i_rd_rt_wb == i_rt)) begin
                cortocircuitoB = 2'b01;
            end
        end
    end


endmodule
