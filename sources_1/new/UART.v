`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/21/2021 04:41:47 PM
// Design Name: 
// Module Name: UART
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


module UART
#(
   //PARAMETERS
   parameter DATA_WIDTH = 8,
   parameter STOP_WIDTH = 1,
   parameter PARITY_WIDTH = 1
   )
   (
    //INPUTS
   input                        i_clock,
   input                        i_reset,
   input                        i_rx_data,
   input                        i_tx_signal,
   input  [DATA_WIDTH - 1:0]      i_tx_result,
   input  [PARITY_WIDTH -1 :0]  i_parity,
   //OUTPUT
   output                       o_rx_done,
   output [DATA_WIDTH - 1:0]      o_rx_data,
   output [PARITY_WIDTH-1 :0]   o_parity,
   output                       o_tx_data,
   output                       o_tx_done,
   output o_tx_available
 );
  

  BR_GENERATOR u_br_gen 
  (
    .i_clock           (i_clock),
    .o_tick            (ticks)    
  );
  
  
   UART_RX u_rx (
    .i_clock           (i_clock),
    .i_tick            (ticks),
    .i_reset           (i_reset),
    .i_rx_data_input   (i_rx_data), 
    .o_done_bit        (o_rx_done), 
    .o_data_byte       (o_rx_data),
    .o_parity          (o_parity)
  );
  
    UART_TX u_tx (
    .i_clock           (i_clock),
    .i_tick            (ticks),
    .i_reset           (i_reset),
    .i_data_byte       (i_tx_result),
    .i_parity          (i_parity),
    .i_tx_signal       (i_tx_signal), 
    .o_done_bit        (o_tx_done), 
    .o_tx_data         (o_tx_data),
    .o_available       (o_tx_available)
  );

   
endmodule
