`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/06/2021 07:02:07 PM
// Design Name: 
// Module Name: UART_TX
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


module UART_TX
#(
   //PARAMETERS
   parameter DATA_WIDTH = 8,
   parameter STOP_WIDTH = 1,
   parameter PARITY_WIDTH = 1
   )
  (
  //INPUTS
   input        i_clock,
   input        i_reset,
   input        i_tick,
   input [DATA_WIDTH - 1:0]  i_data_byte,
   input [PARITY_WIDTH -1:0] i_parity,
   input        i_tx_signal,
   //OUTPUTS
   output          o_done_bit,
   output       o_tx_data,
   output o_available
   );
   
 // One-Hot, One-Cold  
  localparam STATE_IDLE         = 6'b000001;
  localparam STATE_START_BIT    = 6'b000010;
  localparam STATE_TRANSMITTING = 6'b000100;
  localparam STATE_PARITY_BIT   = 6'b001000;
  localparam STATE_STOP_BIT     = 6'b010000;
  localparam STATE_DONE         = 6'b100000;
   
  reg [5:0]                 current_state;  
  reg [5:0]                  next_state;

  reg                       current_tx_data;     
  reg                       next_tx_data;     
  reg                       tx_data; 

  reg [7:0]                 current_tick_counter;  
  reg [7:0]                 next_tick_counter;  

  reg [2:0]                 current_data_index;      //8 bits total
  reg [2:0]                 next_data_index;      //8 bits total

  reg [STOP_WIDTH-1:0]      current_stop_index;      //1 o 2 stop bits
  reg [STOP_WIDTH-1:0]      next_stop_index;      //1 o 2 stop bits

  reg [PARITY_WIDTH -1:0]     current_parity_index;    //1 o 2 parity bits  
  reg [PARITY_WIDTH -1:0]     next_parity_index;    //1 o 2 parity bits 

    reg [PARITY_WIDTH - 1:0]      current_parity;  
  reg [DATA_WIDTH - 1:0]        current_data_byte;
    reg [PARITY_WIDTH - 1:0]      next_parity;  
  reg [DATA_WIDTH - 1:0]        next_data_byte;    

  reg                       current_done_bit;       
  reg                       next_done_bit;       
  reg                       done_bit;

  reg current_available;
  reg next_available;
  reg available;



    assign o_available = available;
   assign  o_done_bit  =  done_bit;
   assign  o_tx_data  =  tx_data;
   
   always @(posedge i_clock) //MEMORIA
    if (i_reset) begin
        current_tx_data        = 1'b1;
        current_tick_counter   = 8'b0;
        current_data_index     = 3'b0;
        current_stop_index     = 0;
        current_parity_index   = 0;
        current_done_bit       = 1'b0;
        current_available      = 1'b1;
        current_data_byte = 0;
        current_parity = 0;
        current_state          <= STATE_IDLE; //ESTADO INICIAL
    end
    else begin
        current_tx_data      <= next_tx_data     ;
        current_tick_counter <= next_tick_counter;
        current_data_index   <= next_data_index  ;
        current_stop_index   <= next_stop_index  ;
        current_parity_index <= next_parity_index;
        current_done_bit     <= next_done_bit    ;
        current_available    <= next_available   ;
        current_data_byte <= next_data_byte;
        current_parity <= next_parity;
        current_state <= next_state; 
    end       
   
   always @(*) begin: next_state_logic
    next_state      = current_state     ;
    next_tx_data      = current_tx_data     ;
    next_tick_counter = current_tick_counter;
    next_stop_index = current_stop_index;
    next_data_index   = current_data_index  ;
    next_parity_index = current_parity_index;
    next_done_bit     = current_done_bit    ;
    next_available    = current_available   ;
    next_data_byte = current_data_byte;
    next_parity = current_parity;
    case (current_state)
        STATE_IDLE:
        begin
            next_data_index = 0;
            next_tick_counter = 0;
            next_stop_index = 0;
            next_parity_index = 0;
            next_tx_data = 1'b1;
            next_done_bit = 0;
            // next_available = 1;
            if(i_tx_signal == 1'b1)
            begin
                next_data_byte = i_data_byte;
                next_parity = i_parity;
                next_available = 0;
                next_state = STATE_START_BIT;
            end
            else
                next_state = STATE_IDLE;
        end
        
        STATE_START_BIT:
        begin
            next_tx_data = 1'b0;
            if(current_tick_counter == 15) begin
                next_tick_counter = 0;
                next_data_index =0;
                next_state = STATE_TRANSMITTING;
            end
        if(i_tick)
        begin
            if(current_tick_counter < 15)
            begin
                 next_tick_counter = current_tick_counter +1; 
                 next_state = STATE_START_BIT;
            end
        end
        end
        
        STATE_TRANSMITTING:
        begin
            if(current_tick_counter == 15) begin
                next_state = STATE_TRANSMITTING;
                next_tick_counter = 0;
                next_data_index = current_data_index + 1;
                if (current_data_index == DATA_WIDTH -1) begin
                    next_parity_index =0;  
                    next_data_index = 0;     
                    next_state = STATE_PARITY_BIT;
                end                                  
            end
        if(i_tick)
        begin
            next_tx_data = current_data_byte[current_data_index];
            if(current_tick_counter < 15)
             begin
                next_tick_counter = current_tick_counter + 1;
                next_state = STATE_TRANSMITTING;
             end
          end
        end
        
        STATE_PARITY_BIT:
        begin
             if(current_tick_counter == 15) begin
                next_state = STATE_PARITY_BIT;
                next_tick_counter = 0;
                next_parity_index = current_parity_index + 1;
                if (current_parity_index == PARITY_WIDTH -1) begin
                    next_stop_index =0;  
                    next_parity_index = 0;     
                    next_state = STATE_STOP_BIT;
                end                                  
            end
        if(i_tick)
        begin
            next_tx_data = current_parity[current_parity_index];
            if(current_tick_counter < 15)
             begin
                next_tick_counter = current_tick_counter + 1;
                next_state = STATE_PARITY_BIT;
             end
          end
        end
        
        STATE_STOP_BIT:
        begin
            next_tx_data = 1'b1;
             if(current_tick_counter == 15) begin
                next_state = STATE_STOP_BIT;
                next_tick_counter = 0;
                next_stop_index = current_stop_index + 1;
                if (current_stop_index == STOP_WIDTH -1) begin
                    next_stop_index = 0;
                    next_done_bit = 1;     
                    next_state = STATE_DONE;
                end                                  
            end
        if(i_tick)
        begin
            if(current_tick_counter < 15)
             begin
                next_tick_counter = current_tick_counter + 1;
                next_state = STATE_STOP_BIT;
             end
          end
        end
        
        STATE_DONE:
        begin
           next_tick_counter = 0;
           next_data_index   = 0;
           next_stop_index   = 0;
           next_parity_index = 0;
           next_tx_data = 1'b1;
           next_done_bit = 0;
           next_available = 1;
           next_state = STATE_IDLE;
        end
              
        default:
        begin
           next_data_index = 0;        
           next_tick_counter = 0;
           next_stop_index = 0;
           next_parity_index = 0;
           next_tx_data = 1'b1;
           next_done_bit = 0;
           next_available = 1;
           next_state = STATE_IDLE;
        end
        
    endcase
    end
    
    
    always @(*) begin: output_logic
        case (current_state)
        STATE_IDLE:
        begin
             tx_data = current_tx_data;
             done_bit = current_done_bit;
            available = 1'b1;
        end
        
        STATE_START_BIT:
        begin
              tx_data = current_tx_data;
             done_bit = current_done_bit;
            available = 1'b0;
        end
        
        STATE_TRANSMITTING:
        begin
             tx_data = current_tx_data;
             done_bit = current_done_bit;
            available = 1'b0;
        end
        
        STATE_PARITY_BIT:
        begin
             tx_data = current_tx_data;
             done_bit = current_done_bit;
            available = 1'b0;
        end
        
        STATE_STOP_BIT:
        begin
            tx_data = current_tx_data;
             done_bit = current_done_bit;
            available = 1'b0;
        end
        
        STATE_DONE:
        begin
            tx_data = current_tx_data;
             done_bit = current_done_bit;
            available = 1'b0;
        end
        
        default:
        begin
              tx_data = current_tx_data;
             done_bit = current_done_bit;
            available = 1'b0;
        end
    endcase
    end
endmodule