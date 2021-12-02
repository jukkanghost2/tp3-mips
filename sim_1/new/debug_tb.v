`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/24/2021 07:37:57 PM
// Design Name: 
// Module Name: debug_tb
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


module debug_tb;
    //PARAMETERS
    parameter DATA_WIDTH = 32;
    parameter DATA_WIDTH_UART = 8;
    parameter PARITY_WIDTH_UART = 1;
    parameter STOP_WIDTH_UART = 1;

    //INPUTS
    reg                             i_clock;
    reg                             i_reset;
    reg                             i_finish;
    reg                             i_uart_done_rx;
    reg                             i_tx_signal;
    reg [DATA_WIDTH_UART - 1:0]     i_tx_result;
    reg [PARITY_WIDTH_UART - 1:0]   i_parity; 
    reg [DATA_WIDTH - 1:0]          i_pc; 
    reg [DATA_WIDTH - 1:0]          i_reg; 
    reg [DATA_WIDTH - 1:0]          i_mem; 
    //OUTPUTS
    wire [DATA_WIDTH - 1:0]         o_instruccion;
    wire [DATA_WIDTH - 1:0]         o_address;
    wire                            o_loading;
    wire                            o_start;
    wire                            o_step;
    wire                            rx_uart;
    wire [DATA_WIDTH_UART - 1:0]    rx_data;
    wire                            rx_done;

    localparam demora = 12800;

    reg [DATA_WIDTH_UART - 1:0]     result;

    DEBUG_UNIT
    #(
     .DATA_WIDTH    (DATA_WIDTH),
     .DATA_WIDTH_UART    (DATA_WIDTH_UART)
    )
    debug_unit_test (
     .i_clock    (i_clock),
     .i_reset      (i_reset),
     .i_finish      (i_finish),
     .i_rx_data       (tx_data_debug),   
     .i_parity       (parity_debug),   
     .i_pc       (i_pc),   
     .i_reg       (i_reg),   
     .i_mem       (i_mem),   
     .o_parity       (),   
     .o_tx_data       (rx_uart),   
     .o_tx_done       (),   
     .o_instruccion           (o_instruccion), 
     .o_address           (o_address), 
     .o_loading           (o_loading), 
     .o_start           (o_start),
     .o_step          (o_step), 
     .o_reg_send          (o_reg_send), 
     .o_mem_send          (o_mem_send)
    );
    
    UART
    #(
        .DATA_WIDTH    (DATA_WIDTH_UART),
        .STOP_WIDTH    (STOP_WIDTH_UART),
        .PARITY_WIDTH    (PARITY_WIDTH_UART)
    )
    uart_testbench
    (
        .i_clock        (i_clock),
        .i_reset        (i_reset),
        .i_rx_data        (rx_uart),
        .i_tx_signal        (i_tx_signal),
        .i_tx_result        (i_tx_result),
        .i_parity        (i_parity),
        .o_rx_done        (rx_done),
        .o_rx_data        (rx_data),
        .o_parity        (parity_debug),
        .o_tx_data        (tx_data_debug),
        .o_tx_done        (),
        .o_tx_available        ()
    );

    initial begin
        i_clock     = 1'b0;
        i_reset     = 1'b0;
        i_tx_signal = 1'b0;
        i_tx_result = 1'b0;
        i_parity    = 1'b0;  
        i_finish    = 1'b0;
        i_pc        = 32'b10000000111000010111000000100001;
        i_reg       = 32'b10111111111111111111000000100001;
        i_mem       = 32'b10000000000000010111000000100001;
        #200
        i_reset = 1'b1;
        #200
        i_reset = 1'b0;
        #800
        i_tx_result = 8'b11111111;
        i_tx_signal = 1'b1;
        #400
        i_tx_signal = 1'b0;
        #(demora*12)
        i_tx_result = 8'b10;
        i_tx_signal = 1'b1;
        #400
        i_tx_signal = 1'b0;
        #(demora*12)
        i_tx_result = 8'b11;
        i_tx_signal = 1'b1;
        #400
        i_tx_signal = 1'b0;
        #(demora*12)
        i_tx_result = 8'b100;
        i_tx_signal = 1'b1;
        #400
        i_tx_signal = 1'b0;
        #(demora*12)
        
        i_tx_result = 8'b0;
        i_tx_signal = 1'b1;
        #400
        i_tx_signal = 1'b0;
        #(demora*12)
        
        i_tx_result = 8'b0;
        i_tx_signal = 1'b1;
        #400
        i_tx_signal = 1'b0;
        #(demora*12)
        
        i_tx_result = 8'b0;
        i_tx_signal = 1'b1;
        #400
        i_tx_signal = 1'b0;
        #(demora*12)
        
        i_tx_result = 8'b0;
        i_tx_signal = 1'b1;
        #400
        i_tx_signal = 1'b0;
        #(demora*12)
//debug
        i_tx_result = 8'b11111111;
        i_tx_signal = 1'b1;
        #400
        i_tx_signal = 1'b0;
        #(demora*12)
//step
        i_tx_result = 8'b10101010;
        i_tx_signal = 1'b1;
        #400
        i_tx_signal = 1'b0;
        #(demora*12)

        
        #((demora*12)*32*4)
        #((demora*12)*32*4)
        
// //step
//         i_tx_result = 8'b10101010;
//         i_tx_signal = 1'b1;
//         #400
//         i_tx_signal = 1'b0;
//         #(demora*12)

//          #(demora*12)
//         result = rx_data;
//         #(demora*12)
//         result = rx_data;
//         #(demora*12)
//         result = rx_data;
//         #(demora*12)
//         result = rx_data;
        i_finish = 1'b1;
        #((demora*12)*32*4)
        #((demora*12)*32*4)
        #((demora*12)*32*4)
        #10000
        $finish;
    end

always #100 i_clock = ~i_clock;

endmodule