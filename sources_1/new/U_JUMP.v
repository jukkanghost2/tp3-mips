`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/24/2021 03:25:55 PM
// Design Name: 
// Module Name: U_JUMP
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


module U_JUMP
    #(  //PARAMETERS
        parameter DATA_WIDTH = 32,
        parameter SIZEOP = 6
    )
    (   //INPUTS
        input [DATA_WIDTH - 1:0]    i_currentpc,
        input [DATA_WIDTH - 1:0]    i_instruccion,
        input [DATA_WIDTH - 1:0]    i_regA,
        //OUTPUTS
        output [DATA_WIDTH - 1:0]   o_pcjump,
        output [DATA_WIDTH - 1:0]   o_return_address,
        output o_rd_selector,
        output o_jump,
        output o_return
    );

    initial begin
        rd_selector = 1'b0;
        jump = 1'b0;
    end

    localparam [SIZEOP - 1:0]     J         = 6'b000010;
    localparam [SIZEOP - 1:0]     JAL       = 6'b000011;
    // J-TYPE
    localparam [SIZEOP - 1:0]     JR = 6'b001000;
    localparam [SIZEOP - 1:0]     JALR = 6'b001001;

    reg [DATA_WIDTH - 1:0] pcjump;
    reg [DATA_WIDTH - 1:0] return_address;
    reg jump;
    reg rd_selector;
    reg return;

    assign o_pcjump = pcjump;
    assign o_jump = jump;
    assign o_return_address = return_address;
    assign o_rd_selector = rd_selector;
    assign o_return = return;
    
    always @(*) begin
        rd_selector = 1'b0;
        jump = 1'b0;
        return = 1'b0;
        if(i_instruccion[31:26] == J) begin
            pcjump = i_currentpc + (i_instruccion[25:0] << 2);
            rd_selector = 1'b0;
            return = 1'b0;
            jump = 1'b1;
        end
        if(i_instruccion[31:26] == JAL) begin
            pcjump = i_currentpc + (i_instruccion[25:0] << 2);
            return_address = i_currentpc + 2;
            rd_selector = 1'b1;
            return = 1'b1;
            jump = 1'b1;
        end
        if(i_instruccion[31:26] == 6'b000000) begin
            if(i_instruccion[5:0] == JR) begin
                pcjump = i_regA;
                rd_selector = 1'b0;
                return = 1'b0;
                jump = 1'b1;
            end
            if(i_instruccion[5:0] == JALR) begin
                pcjump = i_regA;
                return_address = i_currentpc + 2;
                rd_selector = 1'b0;
                return = 1'b1;
                jump = 1'b1;
            end
        end
    end
endmodule
