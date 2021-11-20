`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/18/2021 12:38:14 AM
// Design Name: 
// Module Name: EXECUTE
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


module EXECUTE
    #(  //PARAMETERS
        parameter DATA_WIDTH = 32,
        parameter SIZEOP = 6,
        parameter SIZESA = 5
    )
    (   //INPUTS
        input [DATA_WIDTH - 1:0] i_regA,
        input [DATA_WIDTH - 1:0] i_regB,
        input [DATA_WIDTH - 1:0] i_extendido,
        input [DATA_WIDTH - 1:0] i_aluresult,
        input [DATA_WIDTH - 1:0] i_reg_mem,
        input [SIZEOP - 1:0] i_opcode,
        input [4:0] i_rt,
        input [4:0] i_rd,
        input [3:0] i_ex,
        input [1:0] i_cortocircuitoA,
        input [1:0] i_cortocircuitoB,
        //OUTPUTS
        output [DATA_WIDTH - 1:0] o_aluresult,
        output [DATA_WIDTH - 1:0] o_regB,
        output [4:0] o_rd_rt
    );

    wire [DATA_WIDTH - 1:0] datoAAlu;
    wire [DATA_WIDTH - 1:0] datoBAlu;
    wire [DATA_WIDTH - 1:0] mux_ex_regb_result;
    wire [3:0] alucontrol;
    
    assign o_regB = i_regB;

     ALU 
    #( 
     .SIZEDATA    (DATA_WIDTH),
     .SIZEOP    (SIZEOP),
     .SIZESA    (SIZESA)
     )
     alu (
     .i_datoa   (datoAAlu),
     .i_datob       (datoBAlu),
     .i_shamt       (i_extendido[10:6]),
     .i_alucontrol       (alucontrol),
     .o_result       (o_aluresult)
     );

     ALU_CONTROL
    #( 
     .SIZEOP    (SIZEOP)
     )
     alu_control (
     .i_aluop   (i_ex[1:0]),
     .i_opcode   (i_opcode),
     .i_funct       (i_extendido[5:0]),
     .o_alucontrol       (alucontrol)
     );

     MUX_RT_RD 
    #( 
     .DATA_WIDTH    (DATA_WIDTH)
     )
     mux_rt_rd (
     .i_rt   (i_rt),
     .i_rd       (i_rd),
     .i_regdst       (i_ex[3]),
     .o_rt_rd       (o_rd_rt)
     );

     MUX_2_1_EX
    #( 
     .DATA_WIDTH    (DATA_WIDTH)
     )
     mux_2_1_ex (
     .i_mux_ex_regb_result_mem   (mux_ex_regb_result),
     .i_extendido       (i_extendido[15:0]),
     .i_alusrc       (i_ex[2]),
     .o_datoBAlu       (datoBAlu)
     );

      MUX_EX_REGA_RESULT_MEM
    #( 
     .DATA_WIDTH    (DATA_WIDTH)
     )
     mux_ex_rega_result_mem (
     .i_regA   (i_regA),
     .i_datawrite       (i_reg_mem),
     .i_aluresult       (i_aluresult),
     .i_cortocircuitoA       (i_cortocircuitoA),
     .o_datoAAlu       (datoAAlu)
     );
     
      MUX_EX_REGB_RESULT_MEM
    #( 
     .DATA_WIDTH    (DATA_WIDTH)
     )
     mux_ex_regb_result_mem (
     .i_regB   (i_regB),
     .i_datawrite       (i_reg_mem),
     .i_aluresult       (i_aluresult),
     .i_cortocircuitoB       (i_cortocircuitoB),
     .o_datoBAlu       (mux_ex_regb_result)
     );
    
endmodule
