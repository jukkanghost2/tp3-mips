`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/16/2021 10:14:09 AM
// Design Name: 
// Module Name: MEM_INSTRUCCIONES
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


module MEM_INSTRUCCIONES
    #(  //PARAMETERS
        parameter DATA_WIDTH = 32
    )
    (   //INPUTS
        input i_clock,
        input [DATA_WIDTH - 1:0] i_pc,
        input [DATA_WIDTH - 1:0] i_instruccion,
        input [DATA_WIDTH - 1:0] i_address,
        input i_loading,
        //OUTPUTS
        output [DATA_WIDTH - 1:0] o_instruccion
    );
    //BLOQUE DE MEMORIA
    reg [DATA_WIDTH - 1:0] memoria_instrucciones [DATA_WIDTH - 1:0];
    reg [DATA_WIDTH - 1:0] instr;

    assign o_instruccion = instr;
    
    always @(posedge i_clock) begin
        if(i_loading)
        memoria_instrucciones[i_address] = i_instruccion;
        else
        instr <= memoria_instrucciones[i_pc];
    end
  
endmodule
