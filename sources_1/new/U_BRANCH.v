`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: UNC FCEFyN
// Engineer: Daniele - Gonzalez
// 
// Create Date: 11/21/2021 05:50:06 PM
// Design Name: 
// Module Name: U_BRANCH
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


module U_BRANCH
    #(  //PARAMETERS
        parameter DATA_WIDTH = 32
    )
    (   //INPUTS
        input                       i_branch,
        input [DATA_WIDTH - 1:0]    i_regA,
        input [DATA_WIDTH - 1:0]    i_regB,
        input                       i_beq_or_bne,
        //OUTPUTS
        output                      o_branch
    );

    reg branch;

    assign o_branch = branch;

    initial begin
        branch = 1'b0;
    end

    always @(*) begin
        branch = 1'b0;
        if(i_branch) begin
            if((i_beq_or_bne) && (i_regA == i_regB))
                branch = 1'b1;    
            if((!i_beq_or_bne) && (i_regA != i_regB))
                branch = 1'b1;
        end
    end
endmodule