`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: UNC FCEFyN
// Engineer: Daniele - Gonzalez
// 
// Create Date: 11/16/2021 10:14:09 AM
// Design Name: 
// Module Name: MEM_INSTRUCCIONES
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


module MEM_INSTRUCCIONES
    #(  //PARAMETERS
        parameter DATA_WIDTH = 32,
        parameter SIZEOP = 6
    )
    (   //INPUTS
        input                       i_clock,
        input                       i_reset,
        input [DATA_WIDTH - 1:0]    i_pc,
        input [DATA_WIDTH - 1:0]    i_instruccion,
        input [DATA_WIDTH - 1:0]    i_address,
        input                       i_loading,
        //OUTPUTS
        output [DATA_WIDTH - 1:0]   o_instruccion,
        output                      o_haltsignal
    );

    localparam [SIZEOP - 1:0]       HALT = 6'b111111;

    //BLOQUE DE MEMORIA
    reg [DATA_WIDTH - 1:0]  memoria_instrucciones [DATA_WIDTH - 1:0];
    reg [DATA_WIDTH - 1:0]  instr;
    reg                     haltsignal;

    assign o_instruccion    = instr;
    assign o_haltsignal     = haltsignal;
    
    always @(*) begin
        if(i_loading)
            memoria_instrucciones[i_address] = i_instruccion;
        else if (!haltsignal)
            instr <= memoria_instrucciones[i_pc];
    end

    always @(negedge i_clock) begin
        if (i_reset)
            haltsignal = 1'b0;
        else begin
            if (instr[31:26] == HALT)
                haltsignal = 1'b1;
            else
                haltsignal = 1'b0;
        end
    end
endmodule