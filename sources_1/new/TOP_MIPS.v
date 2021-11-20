`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/18/2021 01:09:58 AM
// Design Name: 
// Module Name: TOP_MIPS
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


module TOP_MIPS
    #(  //PARAMETERS
        parameter DATA_WIDTH = 32,
        parameter SIZEOP = 6,
        parameter SIZESA = 5

    )
    (   //INPUTS
         input i_clock,
        input i_reset,
        input [DATA_WIDTH - 1:0] i_instruccion,
        input [DATA_WIDTH - 1:0] i_address,
        input i_loading,
        //OUTPUTS
        output [DATA_WIDTH - 1:0] o_result_wb
    );
    //I_DECODE - I_FETCH
    wire [DATA_WIDTH - 1:0] pc_branch_i_fetch;
    //MEM_WB - I_DECODE
    wire [4:0] rt_rd_i_decode;
    //MEM_WB - I_DECODE - WB
    wire [1:0] wb_i_decode_wb;
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
    wire [SIZEOP - 1:0] opcode_id_ex;
    wire [4:0] rs_id_ex;
    wire [4:0] rt_id_ex;
    wire [4:0] rd_id_ex;
    wire [3:0] ex_id_ex;
    wire [2:0] mem_id_ex;
    wire [1:0] wb_id_ex;
    // ID_EX - EXECUTE
    wire [DATA_WIDTH - 1:0] regA_execute;
    wire [DATA_WIDTH - 1:0] regB_execute;
    wire [DATA_WIDTH - 1:0] extendido_execute;
    wire [SIZEOP - 1:0] opcode_execute;
    wire [4:0] rt_execute;
    wire [4:0] rd_execute;
    wire [3:0] ex_execute;
    // EXECUTE - EX_MEM
    wire [DATA_WIDTH - 1:0] aluresult_ex_mem;
    wire [DATA_WIDTH - 1:0] regB_ex_mem;
    wire [4:0] rd_rt_ex_mem;
    // ID_EX - EX_MEM
    wire [2:0] mem_ex_mem;
    wire [1:0] wb_ex_mem;
    // EX_MEM - MEM
    wire [DATA_WIDTH - 1:0] aluresult_mem;
    wire [DATA_WIDTH - 1:0] regB_mem;
    wire [2:0] mem_mem;
    // MEM - MEM_WB
    wire [DATA_WIDTH - 1:0] dataread_mem_wb;
    wire [DATA_WIDTH - 1:0] address_mem_wb;
    wire [4:0] rd_rt_mem_wb;
    wire [1:0] wb_mem_wb;
    // MEM_WB - WB
    wire [DATA_WIDTH - 1:0] dataread_wb;
    wire [DATA_WIDTH - 1:0] address_wb;
    wire [DATA_WIDTH - 1:0] mem_or_reg_wb;
    // ID_EX - CORTOCIRCUITO
    wire [4:0] rs_cortocircuito;
    // CORTOCIRCUITO - EXECUTE
    wire [1:0] cortocircuitoA;
    wire [1:0] cortocircuitoB;

      I_FETCH 
    #( 
     .DATA_WIDTH    (DATA_WIDTH)
     )
     i_fetch (
     .i_clock   (i_clock),
     .i_reset       (i_reset),
     .i_instruccion       (i_instruccion),
     .i_address       (i_address),
     .i_loading              (i_loading),
     .i_select       (i_select), // branch predictor
     .i_pc_branch       (pc_branch_i_fetch),
     .i_pc_jump       (i_pc_jump),
     .o_instruccion       (instr_if_id),
     .o_pc_incr       (pc_if_id)
     );

      IF_ID
    #( 
     .DATA_WIDTH    (DATA_WIDTH)
     )
     if_id (
     .i_clock   (i_clock),
     .i_reset       (i_reset),
     .i_instruccion       (instr_if_id),
     .i_pc              (pc_if_id),
     .o_instruccion       (instr_i_decode),
     .o_pc              (pc_i_decode)
     );

  I_DECODE
    #( 
     .DATA_WIDTH    (DATA_WIDTH)
     )
     i_decode (
     .i_clock   (i_clock),
     .i_reset       (i_reset),
     .i_regwrite       (wb_i_decode_wb[1]), 
     .i_writedata       (mem_or_reg_i_decode), 
     .i_instruccion       (instr_i_decode), 
     .i_currentpc       (pc_i_decode), 
     .i_rt_rd       (rt_rd_i_decode), 
     .o_regA       (regA_id_ex),
     .o_regB       (regB_id_ex),
     .o_extendido       (extendido_id_ex),
     .o_pcbranch       (pc_branch_i_fetch),
     .o_opcode      (opcode_id_ex),
     .o_rs       (rs_id_ex),
     .o_rt       (rt_id_ex),
     .o_rd       (rd_id_ex),
     .o_ex       (ex_id_ex),
     .o_mem       (mem_id_ex),
     .o_wb       (wb_id_ex)
     );

      ID_EX
    #( 
     .DATA_WIDTH    (DATA_WIDTH)
     )
     id_ex (
     .i_clock   (i_clock),
     .i_reset       (i_reset),
     .i_regA       (regA_id_ex), 
     .i_regB       (regB_id_ex), 
     .i_extendido       (extendido_id_ex),
     .i_opcode      (opcode_id_ex), 
     .i_rs       (rs_id_ex), 
     .i_rt       (rt_id_ex), 
     .i_rd       (rd_id_ex), 
     .i_ex       (ex_id_ex),
     .i_mem       (mem_id_ex),
     .i_wb       (wb_id_ex),
     .o_regA       (regA_execute),
     .o_regB       (regB_execute),
     .o_extendido       (extendido_execute),
     .o_opcode       (opcode_execute),
     .o_rs       (rs_cortocircuito),
     .o_rt       (rt_execute),
     .o_rd       (rd_execute),
     .o_ex       (ex_execute),
     .o_mem       (mem_ex_mem),
     .o_wb       (wb_ex_mem)
     );

      EXECUTE
    #( 
     .DATA_WIDTH    (DATA_WIDTH),
     .SIZEOP    (SIZEOP),
     .SIZESA    (SIZESA)
     )
     execute (
     .i_regA   (regA_execute),
     .i_regB       (regB_execute),
     .i_extendido       (extendido_execute),
     .i_aluresult       (aluresult_mem),
     .i_reg_mem       (mem_or_reg_i_decode),
     .i_opcode     (opcode_execute), 
     .i_rt       (rt_execute), 
     .i_rd       (rd_execute), 
     .i_ex       (ex_execute), 
     .i_cortocircuitoA       (cortocircuitoA), 
     .i_cortocircuitoB       (cortocircuitoB), 
     .o_aluresult       (aluresult_ex_mem),
     .o_regB       (regB_ex_mem),
     .o_rd_rt       (rd_rt_ex_mem)
     );

     EX_MEM
    #( 
     .DATA_WIDTH    (DATA_WIDTH)
     )
     ex_mem (
     .i_clock   (i_clock),
     .i_reset       (i_reset),
     .i_aluresult       (aluresult_ex_mem), 
     .i_regB       (regB_ex_mem), 
     .i_rd_rt       (rd_rt_ex_mem), 
     .i_mem       (mem_ex_mem), 
     .i_wb       (wb_ex_mem), 
     .o_aluresult       (aluresult_mem),
     .o_regB       (regB_mem),
     .o_rd_rt       (rd_rt_mem_wb),
     .o_mem       (mem_mem),
     .o_wb       (wb_mem_wb)
     );


   MEM
    #( 
     .DATA_WIDTH    (DATA_WIDTH)
     )
     mem (
     .i_clock   (i_clock),
     .i_reset       (i_reset),
     .i_address       (aluresult_mem), 
     .i_datawrite       (regB_mem), 
     .i_mem       (mem_mem), 
     .o_dataread       (dataread_mem_wb)
     );

     MEM_WB
    #( 
     .DATA_WIDTH    (DATA_WIDTH)
     )
     mem_wb (
     .i_clock   (i_clock),
     .i_reset       (i_reset),
     .i_dataread       (dataread_mem_wb), 
     .i_address       (aluresult_mem), 
     .i_rd_rt       (rd_rt_mem_wb), 
     .i_wb       (wb_mem_wb), 
     .o_dataread       (dataread_wb), 
     .o_address       (address_wb),
     .o_rd_rt       (rt_rd_i_decode),
     .o_wb       (wb_i_decode_wb)
     );

     WB
    #( 
     .DATA_WIDTH    (DATA_WIDTH)
     )
     wb (
     .i_clock   (i_clock),
     .i_reset       (i_reset),
     .i_dataread       (dataread_wb), 
     .i_address       (address_wb), 
     .i_memtoreg       (wb_i_decode_wb[0]), 
     .o_mem_or_reg       (mem_or_reg_i_decode)
     );

      CORTOCIRCUITO
    #( 
     .DATA_WIDTH    (DATA_WIDTH)
     )
     cortocircuito (
     .i_rd_rt_mem       (rd_rt_mem_wb), 
     .i_rd_rt_wb       (rt_rd_i_decode), 
     .i_rs       (rs_cortocircuito), 
     .i_rt       (rt_execute), 
     .i_wb_mem       (wb_mem_wb), 
     .i_wb_wb       (wb_i_decode_wb), 
     .o_cortocircuitoA       (cortocircuitoA), 
     .o_cortocircuitoB       (cortocircuitoB)
     );
    

    assign o_result_wb = mem_or_reg_i_decode; 
endmodule
