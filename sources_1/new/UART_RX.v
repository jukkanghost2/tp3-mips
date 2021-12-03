`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/30/2021 03:29:33 PM
// Design Name: 
// Module Name: UART_RX
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


module UART_RX
#(
   //PARAMETERS
   parameter DATA_WIDTH = 8,
   parameter STOP_WIDTH = 1,
   parameter PARITY_WIDTH = 1
   )
  (
  //INPUTS
   input        i_clock,
   input        i_tick,
   input        i_reset,
   input        i_rx_data_input,
   //OUTPUTS
   output       o_done_bit,
   output [DATA_WIDTH - 1:0] o_data_byte,
   output [PARITY_WIDTH - 1 :0] o_parity
   );
   
    // One-Hot, One-Cold  
  localparam STATE_IDLE         = 6'b000001;
  localparam STATE_START_BIT    = 6'b000010;
  localparam STATE_RECEIVING    = 6'b000100;
  localparam STATE_PARITY_BIT   = 6'b001000;
  localparam STATE_STOP_BIT     = 6'b010000;
  localparam STATE_DONE         = 6'b100000;
  
  reg [5:0]     current_state;
  reg [5:0]     next_state;

  reg           rx_data; 

  reg [7:0]     current_tick_counter;
  reg [7:0]     next_tick_counter;

  reg [2:0]     current_data_index; //8 bits total
  reg [2:0]     next_data_index; //8 bits total

  reg [1:0]       current_stop_index; //1 o 2 stop bits
  reg [1:0]       next_stop_index; //1 o 2 stop bits

  reg [1:0]        current_parity_index; //1 o 2 parity bits
  reg [1:0]        next_parity_index; //1 o 2 parity bits

  reg [PARITY_WIDTH - 1:0]      parity;  
  reg [DATA_WIDTH - 1:0]        data_byte;
    reg [PARITY_WIDTH - 1:0]      current_parity;  
  reg [DATA_WIDTH - 1:0]        current_data_byte;
    reg [PARITY_WIDTH - 1:0]      next_parity;  
  reg [DATA_WIDTH - 1:0]        next_data_byte;

  reg           current_done_bit;
  reg           next_done_bit;
  reg           done_bit;

   assign  o_done_bit  =  done_bit;
   assign  o_data_byte = data_byte;
   assign o_parity = parity;
   
   always @(posedge i_clock) //Incoming data
     rx_data  <=  i_rx_data_input;
   
   always @(posedge i_clock) //MEMORIA
    if (i_reset) begin
        current_tick_counter   = 8'b0;
        current_data_index     = 3'b0;
        current_parity_index   = 0;
        current_stop_index     = 0;
        current_done_bit       = 1'b0;
        current_data_byte = 0;
        current_parity = 0;
        current_state          <= STATE_IDLE; //ESTADO INICIAL
    end
    else begin
        current_tick_counter <= next_tick_counter;
        current_data_index   <= next_data_index  ;
        current_parity_index <= next_parity_index;
        current_stop_index   <= next_stop_index  ;
        current_done_bit     <= next_done_bit    ;
        current_data_byte <= next_data_byte;
        current_parity <= next_parity;
        current_state <= next_state; 
    end       
   
   always @(*) begin: next_state_logic
    next_tick_counter = current_tick_counter;
    next_data_index   = current_data_index  ;
    next_stop_index = current_stop_index;
    next_parity_index = current_parity_index;
    next_done_bit     = current_done_bit    ;
    next_state     = current_state    ;
    next_data_byte = current_data_byte;
    next_parity = current_parity;
    case (current_state)
        STATE_IDLE:
        begin      
            next_data_index = 0;    
            next_tick_counter = 0;
            next_stop_index = 0;
            next_parity_index = 0;
            next_data_byte = 0;
            next_parity = 0;
            next_done_bit = 0;
            if(rx_data == 1'b0) //Start bit detected
             begin
                next_state = STATE_START_BIT;
             end
            else
             begin
                next_state = STATE_IDLE;
             end
        end
        
        STATE_START_BIT:
        begin
            next_data_byte = 0;
            next_parity = 0;
            next_done_bit = 0;
            if(current_tick_counter == 7)
             begin
                if(rx_data == 1'b0) //Start bit still low
                begin
                    next_tick_counter = 0; //(found middle, reset counter)
                    next_state = STATE_RECEIVING;
                end
                else
                begin
                    next_tick_counter = 0;
                    next_state = STATE_IDLE;
                end
             end
          if(i_tick)
          begin
            next_tick_counter = current_tick_counter + 1;
            next_state = STATE_START_BIT;
           end
        end
        
        STATE_RECEIVING:
        begin
            next_parity = 0;
            next_done_bit = 0;
            if(current_tick_counter == 15)
             begin
                next_tick_counter = 0;
                next_data_index = current_data_index + 1;
                next_state = STATE_RECEIVING;
                if(current_data_index == DATA_WIDTH - 1)
                 begin  
                    next_data_index = 0;
                    next_tick_counter = 0;
                    next_state = STATE_PARITY_BIT;
                 end
             end
          if(i_tick)
           begin
            next_data_byte[current_data_index] = rx_data;
            if(current_tick_counter < 15)
             begin
                next_tick_counter = current_tick_counter + 1;
                next_state = STATE_RECEIVING;
             end
            end
        end
        
        STATE_PARITY_BIT:
        begin
            next_done_bit = 0;
            if(current_tick_counter == 15)
             begin
                next_tick_counter = 0;
                next_parity_index = current_parity_index + 1;
                next_state = STATE_PARITY_BIT;
                if(current_parity_index == PARITY_WIDTH - 1)
                 begin  
                    next_parity_index = 0;
                    next_stop_index = 0;
                    next_state = STATE_STOP_BIT;
                 end
             end
          if(i_tick)
           begin
                next_parity[current_parity_index] = rx_data;
            if(current_tick_counter < 15)
             begin
                next_tick_counter = current_tick_counter + 1;
                next_state = STATE_PARITY_BIT;
             end
           end
        end
        
        STATE_STOP_BIT:
        begin
            if(current_tick_counter == 15)
             begin
                if(rx_data == 1'b1) //Stop bit 
                begin
                    next_tick_counter = 0;
                    next_stop_index = current_stop_index + 1;
                    next_state = STATE_STOP_BIT;
                    if(current_stop_index == STOP_WIDTH - 1)
                    begin
                    next_stop_index = 0;
                    next_done_bit = 1;
                    next_state = STATE_DONE;
                    end
                end
                else
                begin
                    next_tick_counter = 0;
                    next_stop_index = 0;
                    next_parity_index = 0;
                    next_data_index = 0;
                    next_state = STATE_IDLE;
                end
             end
          if(i_tick)
           begin
            if(current_tick_counter < 15)
             begin
                next_tick_counter = current_tick_counter + 1;
                next_data_index = 0;
                next_state = STATE_STOP_BIT;
             end
           end
        end
        
        STATE_DONE:
        begin
           next_data_byte = 0;
           next_parity = 0;
           next_done_bit = 0; 
           next_tick_counter = 0;
           next_data_index = 0;
           next_stop_index = 0;
           next_parity_index = 0;
           next_state = STATE_IDLE;
        end
        
        default:
        begin
           next_data_byte = 0;
           next_parity = 0;
           next_done_bit = 0;
           next_tick_counter = 0;
           next_data_index = 0;
           next_stop_index = 0;
           next_parity_index = 0;
           next_state = STATE_IDLE;
        end
    endcase
    end
    
    always @(*) begin: output_logic
        case (current_state)
        STATE_IDLE:
        begin
            data_byte = current_data_byte;
            parity = current_parity;
            done_bit = current_done_bit;
        end
        
        STATE_START_BIT:
        begin
             data_byte = current_data_byte;
            parity = current_parity;
            done_bit = current_done_bit;
        end
        
        STATE_RECEIVING:
        begin
             data_byte = current_data_byte;
            parity = current_parity;
            done_bit = current_done_bit;
        end
        
        STATE_PARITY_BIT:
        begin
              data_byte = current_data_byte;
            parity = current_parity;
            done_bit = current_done_bit;
        end
        
        STATE_STOP_BIT:
        begin
             data_byte = current_data_byte;
            parity = current_parity;
            done_bit = current_done_bit;
        end
        
        STATE_DONE:
        begin
             data_byte = current_data_byte;
            parity = current_parity;
            done_bit = current_done_bit;      
        end
        
        default:
        begin
             data_byte = 0;
            parity = 0;
            done_bit = 0;
        end
        endcase
    end
endmodule