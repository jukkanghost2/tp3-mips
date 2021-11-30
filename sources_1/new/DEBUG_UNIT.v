 `timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/24/2021 05:54:28 PM
// Design Name: 
// Module Name: DEBUG_UNIT
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


module DEBUG_UNIT
    #(  //PARAMETERS
        parameter DATA_WIDTH = 32,
        parameter DATA_WIDTH_UART = 8,
        parameter STOP_WIDTH_UART = 1,
        parameter PARITY_WIDTH_UART = 1
    )
     (   //INPUTS
        input                     i_clock,
        input                     i_reset,
        input                     i_rx_data,
        input  [PARITY_WIDTH_UART -1 :0]  i_parity,
        input i_finish,
        input [DATA_WIDTH - 1:0] i_pc,
        input [DATA_WIDTH - 1:0] i_reg,
        input [DATA_WIDTH - 1:0] i_mem,
        //OUTPUTS
        output [PARITY_WIDTH_UART -1 :0]   o_parity,
        output                       o_tx_data,
        output [DATA_WIDTH - 1:0]   o_instruccion,
        output [DATA_WIDTH - 1:0]   o_address,
        output o_loading,
        output o_start,
        output o_step,
        output o_reg_send,
        output o_mem_send
    );

        wire [DATA_WIDTH_UART - 1:0]   instruccion_uart_debug;
        wire uart_done_rx;
        reg tx_signal;
        reg [DATA_WIDTH_UART - 1:0]  tx_send_byte;
        wire tx_done_debug;
        wire tx_available_debug;


    UART
    #(
        .DATA_WIDTH    (DATA_WIDTH_UART),
        .STOP_WIDTH    (STOP_WIDTH_UART),
        .PARITY_WIDTH    (PARITY_WIDTH_UART)
    )
    uart_debug
    (
        .i_clock        (i_clock),
        .i_reset        (i_reset),
        .i_rx_data        (i_rx_data),
        .i_tx_signal        (tx_signal),
        .i_tx_result        (tx_send_byte),
        .i_parity        (i_parity),
        .o_rx_done        (uart_done_rx),
        .o_rx_data        (instruccion_uart_debug),
        .o_parity        (o_parity),
        .o_tx_data        (o_tx_data),
        .o_tx_done        (tx_done_debug),
        .o_tx_available        (tx_available_debug)
    );


    reg [DATA_WIDTH - 1:0] instruccion;
    reg [DATA_WIDTH - 1:0] current_instruccion;
    reg [DATA_WIDTH - 1:0] next_instruccion;
    reg [DATA_WIDTH - 1:0] address;
    reg [DATA_WIDTH - 1:0] current_address;
    reg [DATA_WIDTH - 1:0] next_address;
    reg loading;
    reg current_loading;
    reg next_loading;
    reg start;
    reg step;
    reg current_step;
    reg next_step;
    reg [5:0] current_state;
    reg [5:0] next_state;
     reg [2:0] next_byte_counter; // byte a mandar de la instruccion
    reg [2:0] current_byte_counter; // byte a mandar de la instruccion

    reg current_pc_counter;
    reg next_pc_counter;

    reg [4:0] current_reg_counter;
    reg [4:0] next_reg_counter;
    reg reg_send;
    reg current_reg_send;
    reg next_reg_send;
    
    reg [4:0] current_mem_counter;
    reg [4:0] next_mem_counter;
    reg mem_send;
    reg current_mem_send;
    reg next_mem_send;

    reg current_pc_send_flag;
    reg next_pc_send_flag;
    reg current_reg_send_flag;
    reg next_reg_send_flag;
    reg current_mem_send_flag;
    reg next_mem_send_flag;

    assign o_instruccion = instruccion;
    assign o_loading = loading;
    assign o_start = start;
    assign o_step = step;
    assign o_address = address;
    assign o_reg_send = reg_send;
    assign o_mem_send = mem_send;

    // One-Hot, One-Cold  
  localparam STATE_RECEIVING_INSTRUCTION  = 6'b000001;
  localparam STATE_RECEIVE_MODE    = 6'b000010;
  localparam STATE_DEBUG         = 6'b000100;
  localparam STATE_DEBUG_SEND         = 6'b001000;
  localparam STATE_CONTINUE     = 6'b010000;
  localparam STATE_FINISH         = 6'b100000;


always @(posedge i_clock) //MEMORIA
    if (i_reset) begin
            current_instruccion = 8'b0;
            current_byte_counter = 3'b0;
            current_address = 32'b0;
            current_loading = 1'b0;
            current_step = 1'b0;
            current_pc_counter = 1'b0;
            current_reg_counter = 0;
            current_mem_counter = 0;
            current_pc_send_flag  = 0;
            current_reg_send_flag = 0;
            current_mem_send_flag = 0;
            current_reg_send = 0;
            current_mem_send = 0;
            current_state <= STATE_RECEIVING_INSTRUCTION; //ESTADO INICIAL
    end 
    else begin
        current_address <= next_address;
        current_byte_counter <= next_byte_counter;
        current_instruccion <= next_instruccion;
        current_state <= next_state; 
        current_loading <= next_loading; 
        current_step <= next_step; 
        current_pc_counter <= next_pc_counter; 
        current_pc_send_flag <= next_pc_send_flag; 
        current_reg_counter <= next_reg_counter; 
        current_reg_send_flag <= next_reg_send_flag; 
        current_reg_send <= next_reg_send; 
        current_mem_counter <= next_mem_counter; 
        current_mem_send_flag <= next_mem_send_flag; 
        current_mem_send <= next_mem_send; 
    end        


    always @(*) begin: next_state_logic
    next_address = current_address;
    next_byte_counter = current_byte_counter;
    next_instruccion = current_instruccion;
    next_state = current_state;
    next_loading = current_loading;
    next_step = current_step;
    next_pc_counter = current_pc_counter;
    next_pc_send_flag = current_pc_send_flag;
    next_reg_counter = current_reg_counter;
    next_reg_send_flag = current_reg_send_flag;
    next_reg_send = current_reg_send;
    next_mem_counter = current_mem_counter;
    next_mem_send_flag = current_mem_send_flag;
    next_mem_send = current_mem_send;
    case (current_state)
        STATE_RECEIVING_INSTRUCTION: begin
            if(current_loading) begin
                next_loading = 1'b0;
                next_address = current_address + 1;
            end
            if (uart_done_rx) begin
                if(current_byte_counter == 0)
                    next_instruccion[7:0] = instruccion_uart_debug;
                if(current_byte_counter == 1)
                    next_instruccion[15:8] = instruccion_uart_debug;
                if(current_byte_counter == 2)
                    next_instruccion[23:16] = instruccion_uart_debug;
                next_byte_counter = current_byte_counter + 1;
                next_state = STATE_RECEIVING_INSTRUCTION;
                if(current_byte_counter == 3) begin
                    next_instruccion[31:24] = instruccion_uart_debug;
                    next_byte_counter = 0;
                    if(next_instruccion == 32'b0) begin
                        next_state = STATE_RECEIVE_MODE;
                    end
                    else begin
                        next_loading = 1'b1;
                    end
                end
            end
            else begin
                next_state = STATE_RECEIVING_INSTRUCTION;
            end
        end
        STATE_RECEIVE_MODE: begin
            if(uart_done_rx) begin
                if(instruccion_uart_debug == 8'b11111111) begin
                    next_state = STATE_DEBUG;
                end
                else if(instruccion_uart_debug == 8'b00000000) begin
                    next_state = STATE_CONTINUE;
                end
                else begin
                    next_state = STATE_RECEIVE_MODE;
                end
            end
            else begin
                next_state = STATE_RECEIVE_MODE;
            end
        end
        STATE_DEBUG: begin
            next_step = 1'b0;
            next_state = STATE_DEBUG;
            if(uart_done_rx) begin
                if(instruccion_uart_debug == 8'b10101010) begin
                    next_step = 1'b1;
                    next_pc_send_flag = 1'b1;
                    next_state = STATE_DEBUG_SEND;
                end
            end
            if(i_finish) begin
                next_pc_send_flag = 1'b1;
                next_state = STATE_FINISH;
            end
        end
        STATE_DEBUG_SEND: begin
            tx_signal = 1'b0;
            next_step = 1'b0;
            next_state = STATE_DEBUG_SEND;
            if(current_pc_send_flag) begin
                if (tx_available_debug) begin
                    if(current_byte_counter == 0)
                        tx_send_byte = i_pc[7:0];
                    if(current_byte_counter == 1)
                        tx_send_byte = i_pc[15:8];
                    if(current_byte_counter == 2)
                        tx_send_byte = i_pc[23:16];
                    next_byte_counter = current_byte_counter + 1;
                    if(current_byte_counter == 3) begin
                        tx_send_byte = i_pc[31:24];
                        next_byte_counter = 0;
                        next_pc_counter = 1;
                    end
                    tx_signal = 1'b1;
                end
                if(current_pc_counter == 1) begin
                    next_pc_counter = 0;
                    next_pc_send_flag = 0;
                    next_reg_send_flag = 1;
                end
            end
            if(current_reg_send_flag) begin
                next_reg_send = 1'b0;
                    if (tx_available_debug) begin
                        if(current_byte_counter == 0)
                            tx_send_byte = i_reg[7:0];
                        if(current_byte_counter == 1)
                            tx_send_byte = i_reg[15:8];
                        if(current_byte_counter == 2)
                            tx_send_byte = i_reg[23:16];
                        next_byte_counter = current_byte_counter + 1;
                        next_state = STATE_DEBUG_SEND;
                        if(current_byte_counter == 3) begin
                            tx_send_byte = i_reg[31:24];
                            next_byte_counter = 0;
                            next_reg_counter = current_reg_counter + 1;
                            next_reg_send = 1'b1;
                            next_state = STATE_DEBUG_SEND;
                        end
                        tx_signal = 1'b1;
                    end
                if(current_reg_counter == 31) begin
                        next_reg_send = 0;
                        next_reg_counter = 0;
                        next_reg_send_flag = 0;
                        next_mem_send_flag = 1;
                        next_state = STATE_DEBUG_SEND;
                end
            end
            if(current_mem_send_flag) begin
                next_mem_send = 1'b0;
                    if (tx_available_debug) begin
                        if(current_byte_counter == 0)
                            tx_send_byte = i_mem[7:0];
                        if(current_byte_counter == 1)
                            tx_send_byte = i_mem[15:8];
                        if(current_byte_counter == 2)
                            tx_send_byte = i_mem[23:16];
                        next_byte_counter = current_byte_counter + 1;
                        next_state = STATE_DEBUG_SEND;
                        if(current_byte_counter == 3) begin
                            tx_send_byte = i_mem[31:24];
                            next_byte_counter = 0;
                            next_mem_counter = current_mem_counter + 1;
                            next_mem_send = 1'b1;
                            next_state = STATE_DEBUG_SEND;
                        end
                        tx_signal = 1'b1;
                    end
                if(current_mem_counter == 31) begin
                        next_mem_send = 1'b0;
                        next_mem_counter = 0;
                        next_mem_send_flag = 0;
                        next_pc_send_flag = 1;
                        next_state = STATE_DEBUG;
                end
            end
            else begin
                next_state = STATE_DEBUG_SEND;
            end
        end
        STATE_CONTINUE: begin
            if(i_finish) begin
                next_pc_send_flag = 1'b1;
                next_state = STATE_FINISH;
            end
            else begin
                next_state = STATE_CONTINUE;
            end
        end
        STATE_FINISH: begin
            tx_signal = 1'b0;
            next_step = 1'b0;
            next_state = STATE_FINISH;
            if(current_pc_send_flag) begin
                if (tx_available_debug) begin
                    if(current_byte_counter == 0)
                        tx_send_byte = i_pc[7:0];
                    if(current_byte_counter == 1)
                        tx_send_byte = i_pc[15:8];
                    if(current_byte_counter == 2)
                        tx_send_byte = i_pc[23:16];
                    next_byte_counter = current_byte_counter + 1;
                    if(current_byte_counter == 3) begin
                        tx_send_byte = i_pc[31:24];
                        next_byte_counter = 0;
                        next_pc_counter = 1;
                    end
                    tx_signal = 1'b1;
                end
                if(current_pc_counter == 1) begin
                    next_pc_counter = 0;
                    next_pc_send_flag = 0;
                    next_reg_send_flag = 1;
                end
            end
            if(current_reg_send_flag) begin
                next_reg_send = 1'b0;
                    if (tx_available_debug) begin
                        if(current_byte_counter == 0)
                            tx_send_byte = i_reg[7:0];
                        if(current_byte_counter == 1)
                            tx_send_byte = i_reg[15:8];
                        if(current_byte_counter == 2)
                            tx_send_byte = i_reg[23:16];
                        next_byte_counter = current_byte_counter + 1;
                        next_state = STATE_FINISH;
                        if(current_byte_counter == 3) begin
                            tx_send_byte = i_reg[31:24];
                            next_byte_counter = 0;
                            next_reg_counter = current_reg_counter + 1;
                            next_reg_send = 1'b1;
                            next_state = STATE_FINISH;
                        end
                        tx_signal = 1'b1;
                    end
                if(current_reg_counter == 31) begin
                        next_reg_send = 0;
                        next_reg_counter = 0;
                        next_reg_send_flag = 0;
                        next_mem_send_flag = 1;
                        next_state = STATE_FINISH;
                end
            end
            if(current_mem_send_flag) begin
                next_mem_send = 1'b0;
                    if (tx_available_debug) begin
                        if(current_byte_counter == 0)
                            tx_send_byte = i_mem[7:0];
                        if(current_byte_counter == 1)
                            tx_send_byte = i_mem[15:8];
                        if(current_byte_counter == 2)
                            tx_send_byte = i_mem[23:16];
                        next_byte_counter = current_byte_counter + 1;
                        next_state = STATE_FINISH;
                        if(current_byte_counter == 3) begin
                            tx_send_byte = i_mem[31:24];
                            next_byte_counter = 0;
                            next_mem_counter = current_mem_counter + 1;
                            next_mem_send = 1'b1;
                            next_state = STATE_FINISH;
                        end
                        tx_signal = 1'b1;
                    end
                if(current_mem_counter == 31) begin
                        next_mem_send = 1'b0;
                        next_mem_counter = 0;
                        next_mem_send_flag = 0;
                        next_pc_send_flag = 1;
                        next_state = STATE_RECEIVING_INSTRUCTION;
                end
            end
            else begin
                next_state = STATE_FINISH;
            end
        end
        default: begin
            next_address =       0;
            next_byte_counter =  0;
            next_instruccion =   0;
            next_loading =       0;
            next_step =          0;
            next_pc_counter =    0;
            next_pc_send_flag =  0;
            next_reg_counter =   0;
            next_reg_send_flag = 0;
            next_reg_send =      0;
            next_mem_counter =   0;
            next_mem_send_flag = 0;
            next_mem_send =      0;
            next_state = STATE_RECEIVING_INSTRUCTION;
        end
    endcase
    end
    
    always @(*) begin: output_logic
    case (current_state)
        STATE_RECEIVING_INSTRUCTION: begin
            loading = current_loading;
            instruccion = current_instruccion;
            address = current_address;
            start = 1'b0;
            step = 1'b0;
            reg_send = 1'b0;
            mem_send = 1'b0;
        end
        STATE_RECEIVE_MODE: begin
            start = 1'b0;
            step = 1'b0;
            reg_send = 1'b0;
            mem_send = 1'b0;
        end
        STATE_DEBUG: begin
            start = 1'b1;
            step = current_step;
            reg_send = 1'b0;
            mem_send = 1'b0;
        end
        STATE_DEBUG_SEND: begin
            start = 1'b1;
            step = current_step;
            reg_send = current_reg_send;
            mem_send = current_mem_send;
        end
        STATE_CONTINUE: begin
            start = 1'b1;
            step = 1'b1;
            reg_send = 1'b0;
            mem_send = 1'b0;
        end
        STATE_FINISH: begin
            start = 1'b0;
            step = 1'b0;
            reg_send = current_reg_send;
            mem_send = current_mem_send;
        end
        default: begin
            loading = 0;
            instruccion = 0;
            address = 0;
            start = 1'b0;
            step = 1'b0;
            reg_send = 1'b0;
            mem_send = 1'b0;
        end
    endcase
    end
    
endmodule
