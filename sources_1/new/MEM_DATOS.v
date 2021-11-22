`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/17/2021 07:18:09 PM
// Design Name: 
// Module Name: MEM_DATOS
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


module MEM_DATOS
    #(  //PARAMETERS
        parameter DATA_WIDTH = 32
    )
    (   //INPUTS
        input i_clock,
        input [DATA_WIDTH - 1:0] i_address,
        input [DATA_WIDTH - 1:0] i_datawrite,
        input i_memread,
        input i_memwrite,
        //OUTPUTS
        output [DATA_WIDTH - 1:0] o_dataread
    );
    //BLOQUE DE MEMORIA
    reg [DATA_WIDTH - 1:0] memoria_datos [DATA_WIDTH - 1:0];
    reg [DATA_WIDTH - 1:0] dataread;

    assign o_dataread = dataread;

    always @(*) begin
        if(i_memread)
        dataread <= memoria_datos[i_address];
    end

    always @(posedge i_clock) begin
        if(i_memwrite)
        memoria_datos[i_address] <= i_datawrite;
    end
    
endmodule
