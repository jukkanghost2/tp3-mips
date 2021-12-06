`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: UNC FCEFyN
// Engineer: Daniele - Gonzalez
// 
// Create Date: 11/18/2021 01:09:58 AM
// Design Name: 
// Module Name: TOP_MIPS
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


module TOP_MIPS
    #(  //PARAMETERS
        parameter DATA_WIDTH        = 32,
        parameter SIZEOP            = 6,
        parameter SIZESA            = 5,
        parameter DATA_WIDTH_UART   = 8,
        parameter STOP_WIDTH_UART   = 1,
        parameter PARITY_WIDTH_UART = 1
    )
    (   //INPUTS
        input                               i_clock,
        input                               i_reset,
        // input                               i_reset_clock,
        input                               i_rx_data,
        input  [PARITY_WIDTH_UART - 1:0]    i_rx_parity,
        // input [DATA_WIDTH - 1:0]  i_instruccion,
        // input [DATA_WIDTH - 1:0]  i_address,
        // input                     i_loading,
        // input                     i_start,
        // input                     i_step,
        // input                     i_debug_reg,
        // input                     i_debug_mem,
        //OUTPUTS
        // output [DATA_WIDTH - 1:0]   o_result_wb,
        output                              o_tx_data,
        output  [PARITY_WIDTH_UART - 1:0]   o_tx_parity
        // output                              o_locked
        // output [DATA_WIDTH - 1:0]   o_pc_debug,
        // output [DATA_WIDTH - 1:0]   o_reg_debug,
        // output [DATA_WIDTH - 1:0]   o_mem_debug,
        // output o_finish
    );

    //I_DECODE - I_FETCH
    wire [DATA_WIDTH - 1:0] pc_branch_i_fetch;
    //MEM_WB - I_DECODE
    wire [4:0]              rt_rd_i_decode;
    //MEM_WB - I_DECODE - WB
    wire [1:0]              wb_i_decode_wb;
    //WB - I_DECODE
    wire [DATA_WIDTH - 1:0] mem_or_reg_i_decode;
    //I_FETCH - IF_ID
    wire [DATA_WIDTH - 1:0] instr_if_id;
    wire [DATA_WIDTH - 1:0] pc_if_id;
    // IF_ID - I_DECODE
    wire [DATA_WIDTH - 1:0] instr_i_decode;
    wire [DATA_WIDTH - 1:0] pc_i_decode;
    // I_DECODE - ID_EX
    wire [DATA_WIDTH - 1:0] regA_id_ex;
    wire [DATA_WIDTH - 1:0] regB_id_ex;
    wire [DATA_WIDTH - 1:0] extendido_id_ex;
    wire [SIZEOP - 1:0]     opcode_id_ex;
    wire [4:0]              rs_id_ex;
    wire [4:0]              rt_id_ex;
    wire [4:0]              rd_id_ex;
    wire [3:0]              ex_id_ex;
    wire [2:0]              mem_id_ex;
    wire [1:0]              wb_id_ex;
    wire [1:0]              sizemem_id_ex;
    wire                    signedmem_id_ex;
    wire [DATA_WIDTH - 1:0] return_address_id_ex;
    wire                    return_id_ex;
    wire                    halt_id_ex;
    // ID_EX - EXECUTE
    wire [DATA_WIDTH - 1:0] regA_execute;
    wire [DATA_WIDTH - 1:0] regB_execute;
    wire [DATA_WIDTH - 1:0] extendido_execute;
    wire [SIZEOP - 1:0]     opcode_execute;
    wire [4:0]              rt_execute;
    wire [4:0]              rd_execute;
    wire [3:0]              ex_execute;
    // EXECUTE - EX_MEM
    wire [DATA_WIDTH - 1:0] aluresult_ex_mem;
    wire [DATA_WIDTH - 1:0] regB_ex_mem;
    wire [4:0]              rd_rt_ex_mem;
    // ID_EX - EX_MEM
    wire [2:0]              mem_ex_mem;
    wire [1:0]              wb_ex_mem;
    wire [1:0]              sizemem_ex_mem;
    wire                    signedmem_ex_mem;
    wire [DATA_WIDTH - 1:0] return_address_ex_mem;
    wire                    return_ex_mem;
    wire                    halt_ex_mem;
    // EX_MEM - MEM
    wire [DATA_WIDTH - 1:0] aluresult_mem;
    wire [DATA_WIDTH - 1:0] regB_mem;
    wire [2:0]              mem_mem;
    wire [1:0]              sizemem_mem;
    wire                    signedmem_mem;
    // MEM - MEM_WB
    wire [DATA_WIDTH - 1:0] dataread_mem_wb;
    wire [DATA_WIDTH - 1:0] address_mem_wb;
    wire [4:0]              rd_rt_mem_wb;
    wire [1:0]              wb_mem_wb;
    wire [DATA_WIDTH - 1:0] return_address_mem_wb;
    wire                    return_mem_wb;
    wire                    halt_mem_wb;
    // MEM_WB - WB
    wire [DATA_WIDTH - 1:0] dataread_wb;
    wire [DATA_WIDTH - 1:0] address_wb;
    wire [DATA_WIDTH - 1:0] mem_or_reg_wb;
    wire [DATA_WIDTH - 1:0] return_address_wb;
    wire                    return_wb;
    // ID_EX - CORTOCIRCUITO
    wire [4:0]              rs_cortocircuito;
    // CORTOCIRCUITO - EXECUTE
    wire [1:0]              cortocircuitoA;
    wire [1:0]              cortocircuitoB;
    // DECODE - I_FETCH
    wire [1:0]              select;
    wire [DATA_WIDTH - 1:0] pcjump_i_fetch;
    // RIESGO - I_DECODE
    wire                    burbuja_i_decode;
    // RIESGO - I_FETCH
    wire                    pcburbuja;
    // RIESGO - IF_ID
    wire                    if_id_burbuja;
    // DEBUG
    wire                    finish;
    wire                    step;
    wire                    start;
    wire                    reg_send;
    wire                    mem_send;
    wire                    loading;
    wire [DATA_WIDTH - 1:0] debug_instruccion;
    wire [DATA_WIDTH - 1:0] debug_address;
    wire [DATA_WIDTH - 1:0] reg_debug;
    wire [DATA_WIDTH - 1:0] mem_debug;
    wire [DATA_WIDTH - 1:0] pc_debug;
    // CLOCK
    // wire                    clk_out1;

 
    // assign o_result_wb  = mem_or_reg_i_decode; 

    // clk_wiz_0 inst
    // (
    // // Clock out ports  
    // .clk_out1           (clk_out1),
    // // Status and control signals               
    // .reset              (i_reset_clock), 
    // .locked             (o_locked),
    // // Clock in ports
    // .clk_in1            (i_clock)
    // );

    I_FETCH 
    #( 
     .DATA_WIDTH        (DATA_WIDTH)
    )
    i_fetch (
     .i_clock           (i_clock),
     .i_reset           (i_reset),
     .i_start           (start),
     .i_step            (step),
     .i_pcburbuja       (pcburbuja),
     .i_instruccion     (debug_instruccion),
     .i_address         (debug_address),
     .i_loading         (loading),
     .i_select          (select), // branch predictor
     .i_pc_branch       (pc_branch_i_fetch),
     .i_pc_jump         (pcjump_i_fetch),
     .o_instruccion     (instr_if_id),
     .o_pc_incr         (pc_if_id),
     .o_pc_debug         (pc_debug)
    );

    IF_ID
    #( 
     .DATA_WIDTH        (DATA_WIDTH)
    )
    if_id (
     .i_clock           (i_clock),
     .i_reset           (i_reset),
     .i_start           (start),
     .i_step            (step),
     .i_if_id_burbuja   (if_id_burbuja),
     .i_instruccion     (instr_if_id),
     .i_pc              (pc_if_id),
     .o_instruccion     (instr_i_decode),
     .o_pc              (pc_i_decode)
    );

    I_DECODE
    #( 
     .DATA_WIDTH        (DATA_WIDTH)
    )
    i_decode (
     .i_clock           (i_clock),
     .i_reset           (i_reset),
     .i_regwrite        (wb_i_decode_wb[1]), 
     .i_writedata       (mem_or_reg_i_decode), 
     .i_instruccion     (instr_i_decode), 
     .i_currentpc       (pc_i_decode), 
     .i_rt_rd           (rt_rd_i_decode),
     .i_burbuja         (burbuja_i_decode), 
     .i_debug           (reg_send), 
     .o_regA            (regA_id_ex),
     .o_regB            (regB_id_ex),
     .o_extendido       (extendido_id_ex),
     .o_pcbranch        (pc_branch_i_fetch),
     .o_opcode          (opcode_id_ex),
     .o_rs              (rs_id_ex),
     .o_rt              (rt_id_ex),
     .o_rd              (rd_id_ex),
     .o_ex              (ex_id_ex),
     .o_mem             (mem_id_ex),
     .o_wb              (wb_id_ex),
     .o_branch          (select[0]),
     .o_sizemem         (sizemem_id_ex),
     .o_signedmem       (signedmem_id_ex),
     .o_pcjump          (pcjump_i_fetch),
     .o_jump            (select[1]),
     .o_return_address  (return_address_id_ex),
     .o_return          (return_id_ex),
     .o_halt            (halt_id_ex),
     .o_reg_debug       (reg_debug)
    );

    ID_EX
    #( 
     .DATA_WIDTH        (DATA_WIDTH)
    )
     id_ex (
     .i_clock           (i_clock),
     .i_reset           (i_reset),
     .i_start           (start),
     .i_step            (step),
     .i_regA            (regA_id_ex), 
     .i_regB            (regB_id_ex), 
     .i_extendido       (extendido_id_ex),
     .i_opcode          (opcode_id_ex), 
     .i_rs              (rs_id_ex), 
     .i_rt              (rt_id_ex), 
     .i_rd              (rd_id_ex), 
     .i_ex              (ex_id_ex),
     .i_mem             (mem_id_ex),
     .i_wb              (wb_id_ex),
     .i_sizemem         (sizemem_id_ex),
     .i_signedmem       (signedmem_id_ex),
     .i_return_address  (return_address_id_ex),
     .i_return          (return_id_ex),
     .i_halt            (halt_id_ex),
     .o_regA            (regA_execute),
     .o_regB            (regB_execute),
     .o_extendido       (extendido_execute),
     .o_opcode          (opcode_execute),
     .o_rs              (rs_cortocircuito),
     .o_rt              (rt_execute),
     .o_rd              (rd_execute),
     .o_ex              (ex_execute),
     .o_mem             (mem_ex_mem),
     .o_wb              (wb_ex_mem),
     .o_sizemem         (sizemem_ex_mem),
     .o_signedmem       (signedmem_ex_mem),
     .o_return_address  (return_address_ex_mem),
     .o_return          (return_ex_mem),
     .o_halt            (halt_ex_mem)
    );  

    EXECUTE
    #( 
     .DATA_WIDTH        (DATA_WIDTH),
     .SIZEOP            (SIZEOP),
     .SIZESA            (SIZESA)
    )
    execute (
     .i_regA            (regA_execute),
     .i_regB            (regB_execute),
     .i_extendido       (extendido_execute),
     .i_aluresult       (aluresult_mem),
     .i_reg_mem         (mem_or_reg_i_decode),
     .i_opcode          (opcode_execute), 
     .i_rt              (rt_execute), 
     .i_rd              (rd_execute), 
     .i_ex              (ex_execute), 
     .i_cortocircuitoA  (cortocircuitoA), 
     .i_cortocircuitoB  (cortocircuitoB), 
     .o_aluresult       (aluresult_ex_mem),
     .o_regB            (regB_ex_mem),
     .o_rd_rt           (rd_rt_ex_mem)
    );

    EX_MEM
    #( 
     .DATA_WIDTH        (DATA_WIDTH)
    )
    ex_mem (
     .i_clock           (i_clock),
     .i_reset           (i_reset),
     .i_start           (start),
     .i_step            (step),
     .i_aluresult       (aluresult_ex_mem), 
     .i_regB            (regB_ex_mem), 
     .i_rd_rt           (rd_rt_ex_mem), 
     .i_mem             (mem_ex_mem), 
     .i_wb              (wb_ex_mem), 
     .i_sizemem         (sizemem_ex_mem),
     .i_signedmem       (signedmem_ex_mem),
     .i_return_address  (return_address_ex_mem),
     .i_return          (return_ex_mem),
     .i_halt            (halt_ex_mem),
     .o_aluresult       (aluresult_mem),
     .o_regB            (regB_mem),
     .o_rd_rt           (rd_rt_mem_wb),
     .o_mem             (mem_mem),
     .o_wb              (wb_mem_wb),
     .o_sizemem         (sizemem_mem),
     .o_signedmem       (signedmem_mem),
     .o_return_address  (return_address_mem_wb),
     .o_return          (return_mem_wb),
     .o_halt            (halt_mem_wb)
    );

    MEM
    #( 
     .DATA_WIDTH        (DATA_WIDTH)
    )
    mem (
     .i_clock           (i_clock),
     .i_reset           (i_reset),
     .i_address         (aluresult_mem), 
     .i_datawrite       (regB_mem), 
     .i_mem             (mem_mem), 
     .i_sizemem         (sizemem_mem),
     .i_signedmem       (signedmem_mem),
     .i_debug           (mem_send),
     .o_mem_debug       (mem_debug),
     .o_dataread        (dataread_mem_wb)
    );

    MEM_WB
    #( 
     .DATA_WIDTH        (DATA_WIDTH)
    )
    mem_wb (
     .i_clock           (i_clock),
     .i_reset           (i_reset),
     .i_start           (start),
     .i_step            (step),
     .i_dataread        (dataread_mem_wb), 
     .i_address         (aluresult_mem), 
     .i_rd_rt           (rd_rt_mem_wb), 
     .i_wb              (wb_mem_wb), 
     .i_return_address  (return_address_mem_wb),
     .i_return          (return_mem_wb),
     .i_halt            (halt_mem_wb),
     .o_dataread        (dataread_wb), 
     .o_address         (address_wb),
     .o_rd_rt           (rt_rd_i_decode),
     .o_wb              (wb_i_decode_wb),
     .o_return_address  (return_address_wb),
     .o_return          (return_wb),
     .o_halt            (finish)
    );

    WB
    #( 
     .DATA_WIDTH        (DATA_WIDTH)
    )
    wb (
     .i_dataread        (dataread_wb), 
     .i_address         (address_wb), 
     .i_memtoreg        (wb_i_decode_wb[0]), 
     .i_return_address  (return_address_wb),
     .i_return          (return_wb),
     .o_mem_or_reg      (mem_or_reg_i_decode)
    );

    CORTOCIRCUITO
    #( 
     .DATA_WIDTH        (DATA_WIDTH)
    )
    cortocircuito (
     .i_rd_rt_mem       (rd_rt_mem_wb), 
     .i_rd_rt_wb        (rt_rd_i_decode), 
     .i_rs              (rs_cortocircuito), 
     .i_rt              (rt_execute), 
     .i_wb_mem          (wb_mem_wb), 
     .i_wb_wb           (wb_i_decode_wb), 
     .o_cortocircuitoA  (cortocircuitoA), 
     .o_cortocircuitoB  (cortocircuitoB)
     );

    DETECTOR_RIESGOS
    detector_riesgos (
     .i_rs              (instr_i_decode[25:21]), 
     .i_rt              (instr_i_decode[20:16]), 
     .i_id_ex_rt        (rt_execute), 
     .i_id_ex_mem       (mem_ex_mem), 
     .o_pc_write        (pcburbuja), 
     .o_if_id_write     (if_id_burbuja), 
     .o_mux_zero        (burbuja_i_decode)
    );

    DEBUG_UNIT
    #( 
     .DATA_WIDTH        (DATA_WIDTH),
     .DATA_WIDTH_UART   (DATA_WIDTH_UART),
     .STOP_WIDTH_UART   (STOP_WIDTH_UART),
     .PARITY_WIDTH_UART (PARITY_WIDTH_UART)
    )
    debug_unit (
     .i_clock           (i_clock), 
     .i_reset           (i_reset), 
     .i_rx_data         (i_rx_data), 
     .i_parity          (i_rx_parity), 
     .i_finish          (finish), 
     .i_pc              (pc_debug), 
     .i_reg             (reg_debug), 
     .i_mem             (mem_debug), 
     .o_parity          (o_tx_parity),
     .o_tx_data         (o_tx_data),
     .o_instruccion     (debug_instruccion),
     .o_address         (debug_address),
     .o_loading         (loading),
     .o_start           (start),
     .o_step            (step),
     .o_reg_send        (reg_send),
     .o_mem_send        (mem_send)
     );
endmodule