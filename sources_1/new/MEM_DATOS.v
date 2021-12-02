`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: UNC FCEFyN
// Engineer: Daniele - Gonzalez
// 
// Create Date: 11/17/2021 07:18:09 PM
// Design Name: 
// Module Name: MEM_DATOS
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


module MEM_DATOS
    #(  //PARAMETERS
        parameter DATA_WIDTH = 32
    )
    (   //INPUTS
        input i_clock,
        input i_reset,
        input [DATA_WIDTH - 1:0]    i_address,
        input [DATA_WIDTH - 1:0]    i_datawrite,
        input                       i_memread,
        input                       i_memwrite,
        input                       i_signed,
        input [1:0]                 i_size,
        input                 i_debug,
        //OUTPUTS
        output [DATA_WIDTH - 1:0]   o_dataread,
        output [DATA_WIDTH - 1:0]   o_mem_debug
    );
    //BLOQUE DE MEMORIA
    reg [DATA_WIDTH - 1:0] memoria_datos [DATA_WIDTH - 1:0];
    reg [DATA_WIDTH - 1:0] dataread;
    reg [4:0] debug_counter;

    initial begin
        memoria_datos[2] = 99;
        memoria_datos[31] = 100;
    end

    assign o_dataread = dataread;
    assign o_mem_debug = memoria_datos[debug_counter];

    always @(*) begin
        dataread <= 32'bx; 
        if(i_memread) begin
            case (i_size)
                // byte
                2'b01: begin
                    if(i_signed)
                    dataread <= {{24{memoria_datos[i_address][7]}}, memoria_datos[i_address][7:0]};
                    else
                    dataread <= {24'b0, memoria_datos[i_address][7:0]};
                end
                // halfword
                2'b10: begin
                    if(i_signed)
                    dataread <= {{16{memoria_datos[i_address][15]}}, memoria_datos[i_address][15:0]};
                    else
                    dataread <= {16'b0, memoria_datos[i_address][15:0]};
                end
                default: begin
                    if(i_signed)
                    dataread <= memoria_datos[i_address];
                    else
                    dataread <= memoria_datos[i_address];
                end
            endcase    
        end
    end

    always @(negedge i_clock) begin
        if(i_memwrite) begin
            case (i_size)
                // byte
                2'b01:      memoria_datos[i_address] <= {24'b0 ,i_datawrite[7:0]};
                // halfword
                2'b10:      memoria_datos[i_address] <= {16'b0 ,i_datawrite[15:0]};
                default:    memoria_datos[i_address] <= i_datawrite;
            endcase
        end
    end

    always @(negedge i_clock) begin
        if(i_reset)
            debug_counter = 0;
        else if(i_debug) begin
            debug_counter = debug_counter + 1;
            if(debug_counter == 32) begin
                debug_counter = 0;
            end
        end
    end

endmodule