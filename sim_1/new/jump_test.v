`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/02/2021 05:47:36 PM
// Design Name: 
// Module Name: jump_test
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


module jump_test;
  //PARAMETERS
        parameter DATA_WIDTH = 32;
        parameter DATA_WIDTH_UART = 8;
        parameter PARITY_WIDTH_UART = 1;
        parameter STOP_WIDTH_UART = 1;
        parameter SIZEOP = 6;
        parameter SIZESA = 5;

      //INPUTS
    reg i_clock;
    reg i_clock_uart;
    reg i_reset;
    reg i_reset_clock;
    reg [DATA_WIDTH_UART - 1:0] i_tx_byte;
    reg i_tx_signal;
    reg [PARITY_WIDTH_UART - 1:0] i_tx_parity;
    //outputs
    wire [DATA_WIDTH_UART - 1:0] o_rx_byte_from_top;
    wire o_rx_done_uart;
    wire o_tx_done_uart;
    wire o_tx_available_uart;
    wire [PARITY_WIDTH_UART - 1:0] o_rx_parity;
    wire o_locked;


    //conexiones uart con top
    wire                     tx_data_uart_debug;
    wire                     tx_done_uart_debug;
    wire                     tx_available_uart_debug;

    wire                     rx_data_uart_debug;
    wire                     rx_done_uart_debug;
    
    TOP_MIPS 
    #(
        .DATA_WIDTH    (DATA_WIDTH),
        .SIZEOP    (SIZEOP),
        .SIZESA    (SIZESA),
        .DATA_WIDTH_UART    (DATA_WIDTH_UART),
        .STOP_WIDTH_UART    (STOP_WIDTH_UART),
        .PARITY_WIDTH_UART    (PARITY_WIDTH_UART)
    )
    top_mips
    (
        .i_clock        (i_clock),
        .i_reset        (i_reset),
        .i_reset_clock        (i_reset_clock),
        .i_rx_data        (tx_data_uart_debug),
        .o_tx_data        (rx_data_uart_debug),
        .o_locked        (o_locked)
    );


    UART
    #(
        .DATA_WIDTH    (DATA_WIDTH_UART),
        .STOP_WIDTH    (STOP_WIDTH_UART),
        .PARITY_WIDTH    (PARITY_WIDTH_UART)
    )
    uart_test
    (
        .i_clock        (i_clock_uart),
        .i_reset        (i_reset),
        .i_rx_data        (rx_data_uart_debug),
        .i_tx_signal        (i_tx_signal),
        .i_tx_result        (i_tx_byte),
        .i_parity        (i_tx_parity),
        .o_rx_done        (o_rx_done_uart),
        .o_rx_data       (o_rx_byte_from_top),
        .o_parity        (o_rx_parity),
        .o_tx_data        (tx_data_uart_debug),
        .o_tx_done        (o_tx_done_uart),
        .o_tx_available        (o_tx_available_uart)
    );

    reg [DATA_WIDTH - 1:0] instrucciones [DATA_WIDTH - 1: 0];
    reg [DATA_WIDTH - 1:0] registros [DATA_WIDTH - 1: 0];
    reg [DATA_WIDTH - 1:0] memoria [DATA_WIDTH - 1: 0];
    reg [DATA_WIDTH - 1:0] pc;
    reg [5:0] reg_counter;
    reg [5:0] mem_counter;
    reg [2:0] byte_counter;
    reg pc_receive_flag;
    reg reg_receive_flag;
    reg mem_receive_flag;
    localparam demora = 12800;

  

    initial begin
    instrucciones[0] = 32'b000000_00001_00010_00011_00000_101010;
    instrucciones[1] = 32'b000000_00001_00011_00100_00000_100011;
    instrucciones[2] = 32'b000000_00100_00010_00100_00000_100101;
    instrucciones[3] = 32'b000000_00000_00100_00010_00010_000000;
    instrucciones[4] = 31'b111000_00000_00000_00000_00000_000000;
    instrucciones[5] = 32'b000000_00100_000000000000000_001000;
    instrucciones[6] = 32'b001000_00100_01010_0000000000000010;
    instrucciones[7] = 32'b111000_00000_00000_00000_00000_000000;
    instrucciones[8] = 32'b111000_00000_00000_00000_00000_000000;
    instrucciones[9] = 32'b000000_00100_00010_01000_00000_100110;
    instrucciones[10] = 32'b000011_00000000000000000000000100;
    instrucciones[11] = 32'b000000_00100_00001_00111_00000_000110;
    instrucciones[12] = 32'b001000_00100_01011_0000000000000010;
    instrucciones[13] = 32'b111111_00000_00000_00000_00000_000000;
    instrucciones[14] = 32'b000000_11111_000000000000000_001000;
    instrucciones[15] = 32'b000000_00000_00000_00000_00000_000000;
    // instrucciones[15] = 32'b000000_00001_00110_10001_00000_000111;
    // instrucciones[16] = 32'b000000_00001_00111_10110_00000_100001;
    // instrucciones[17] = 32'b000000_00010_00110_01011_00000_100011;
    // instrucciones[18] = 32'b000011_00000000000000000000000001;
    // instrucciones[19] = 32'b001000_00101_01100_0000000000000000;
    // instrucciones[20] = 32'b000101_00101_01100_0000000000000100;
    // instrucciones[21] = 32'b000000_00011_00101_11010_00000_000110;
    // instrucciones[22] = 32'b000000_00001_00110_11011_00000_000111;
    // instrucciones[23] = 32'b000000_00001_00111_10101_00000_100001;
    // instrucciones[24] = 32'b000010_00000000000000000000000001;
    // instrucciones[25] = 32'b000000_00010_00110_11101_00000_100011;
    // instrucciones[26] = 32'b000000_00010_00110_11001_00000_100011;
    // instrucciones[27] = 32'b000000_00010_00110_11001_00000_100011;
    // instrucciones[28] = 32'b000000_11111_000000000000000_001000;
    // instrucciones[29] = 32'b111111_00000_00000_00000_00000_000000;
    // instrucciones[30] = 32'b000000_00000_00000_00000_00000_000000;
        i_clock = 1'b0;
        i_clock_uart = 1'b0;
        i_reset = 1'b0;
        i_reset_clock = 1'b0;
        i_tx_byte = 1'b0;
        i_tx_signal = 1'b0;
        i_tx_parity = 1'b0;
        pc_receive_flag = 1;
        reg_receive_flag = 0;
        mem_receive_flag = 0;
        byte_counter = 0;
        reg_counter = 0;
        mem_counter = 0;
        #400
        i_reset_clock = 1'b1;
        #400
        i_reset_clock = 1'b0;
        #2000

        
        if(!o_locked) begin
            $display("error locked\n");
            $finish;
        end

        i_reset = 1'b1;
        #400
        i_reset = 1'b0;
        #200
        for(integer instruccion_counter = 0; instruccion_counter < 16; instruccion_counter = instruccion_counter + 1) begin
            i_tx_byte = instrucciones[instruccion_counter][7:0];
            i_tx_signal = 1'b1; 
            #200
            i_tx_signal = 1'b0;
            #(demora*12)
            i_tx_byte = instrucciones[instruccion_counter][15:8];
            i_tx_signal = 1'b1; 
            #200
            i_tx_signal = 1'b0;
            #(demora*12)
            i_tx_byte = instrucciones[instruccion_counter][23:16];
            i_tx_signal = 1'b1; 
            #200
            i_tx_signal = 1'b0;
            #(demora*12)
            i_tx_byte = instrucciones[instruccion_counter][31:24];
            i_tx_signal = 1'b1; 
            #200
            i_tx_signal = 1'b0;
            #(demora*12);
        end
        #(demora*12)
        i_tx_byte = 8'b00000000;
        i_tx_signal = 1'b1;
        #200
        i_tx_signal = 1'b0;
        #((demora*12)*32*4)
        #((demora*12)*32*4)
        #(demora*12)

        $finish;
    end

always @(posedge i_clock_uart) begin
    if(pc_receive_flag) begin
        if (o_rx_done_uart) begin
            if(byte_counter == 0)
                pc[7:0]   =o_rx_byte_from_top;
            if(byte_counter == 1)
                pc[15:8]  =o_rx_byte_from_top;
            if(byte_counter == 2)
                pc[23:16] =o_rx_byte_from_top;
            if(byte_counter == 3) begin
                pc[31:24] =o_rx_byte_from_top;
            end
            byte_counter = byte_counter + 1;
            if(byte_counter == 4) begin
                byte_counter = 0;
                pc_receive_flag = 0;
                reg_receive_flag = 1;
            end
        end
    end
    else if(reg_receive_flag) begin
        if (o_rx_done_uart) begin
            if(byte_counter == 0)
                registros[reg_counter][7:0]   =o_rx_byte_from_top;
            if(byte_counter == 1)
                registros[reg_counter][15:8]  =o_rx_byte_from_top;
            if(byte_counter == 2)
                registros[reg_counter][23:16] =o_rx_byte_from_top;
            if(byte_counter == 3) begin
                registros[reg_counter][31:24] =o_rx_byte_from_top;
            end
            byte_counter = byte_counter + 1;
            if(byte_counter == 4) begin
                byte_counter = 0;
                reg_counter = reg_counter + 1;
            end
            if(reg_counter == 32) begin
                    reg_counter = 0;
                    reg_receive_flag = 0;
                    mem_receive_flag = 1;
            end
        end
    end
    else if(mem_receive_flag) begin
        if (o_rx_done_uart) begin
            if(byte_counter == 0)
                memoria[mem_counter][7:0]   =o_rx_byte_from_top;
            if(byte_counter == 1)
                memoria[mem_counter][15:8]  =o_rx_byte_from_top;
            if(byte_counter == 2)
                memoria[mem_counter][23:16] =o_rx_byte_from_top;
            if(byte_counter == 3) begin
                memoria[mem_counter][31:24] =o_rx_byte_from_top;
            end
            byte_counter = byte_counter + 1;
            if(byte_counter == 4) begin
                byte_counter = 0;
                mem_counter = mem_counter + 1;
            end
            if(mem_counter == 32) begin
                    mem_counter = 0;
                    mem_receive_flag = 0;
                    // pc_receive_flag = 1;
                    #200
                    $finish;
            end
        end
    end
end

always #5 i_clock = ~i_clock;
always #25 i_clock_uart = ~i_clock_uart;

endmodule


