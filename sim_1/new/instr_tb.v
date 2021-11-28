`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.11.2021 18:02:47
// Design Name: 
// Module Name: instr_tb
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


module instr_tb;
    //PARAMETERS
    localparam DATA_WIDTH = 32;
    localparam SIZEOP = 6;
    localparam SIZESA = 5;

    //INPUTS
    reg                     i_clock;
    reg                     i_reset;
    reg [DATA_WIDTH - 1:0]  i_instruccion;
    reg [DATA_WIDTH - 1:0]  i_address;
    reg                     i_loading;
    reg                     i_start;
    reg                     i_step;
    //OUTPUTS
    wire [DATA_WIDTH - 1:0] o_result_wb;
    wire                    o_finish;

    TOP_MIPS 
    #(
     .DATA_WIDTH    (DATA_WIDTH),
     .SIZEOP        (SIZEOP),
     .SIZESA        (SIZESA)
    )
    top_mips (
     .i_clock       (i_clock),
     .i_reset       (i_reset),
     .i_start       (i_start),
     .i_step        (i_step),
     .i_instruccion (i_instruccion),
     .i_address     (i_address),   
     .i_loading     (i_loading), 
     .o_result_wb   (o_result_wb),
     .o_finish      (o_finish)
    );


    initial begin
        i_clock = 1'b0;
        i_reset = 1'b0;
        i_instruccion = 32'b0;
        i_address = 32'b0;
        i_loading = 1'b0;
        i_start = 1'b0;
        i_step = 1'b0;
        #200
        i_reset = 1'b1;
        #400
        i_reset = 1'b0;
        #200
        i_loading = 1'b1;
        #200
        // ADDI $1, $2, 32. -> r1 = 2 + r2 (2) = 4
        i_instruccion = 32'b001000_00010_00001_0000000000000010;
        #400
        i_address = i_address + 1;
        #200
        // ANDI $1, $2, 32. -> r1 = 32 & r2 (2) = 0
        i_instruccion = 32'b001100_00010_00001_0000000000100000;
        #400
        i_address = i_address + 1;
        #200
        // ORI $1, $2, 32. -> r1 = 32 | r2 (2) = 34
        i_instruccion = 32'b001101_00010_00001_0000000000100000;
        #400
        i_address = i_address + 1;
        #200
        // XORI $1, $2, 32. -> r1 = 32 xor r2 (2) = 34
        i_instruccion = 32'b001110_00010_00001_0000000000100000;
        #400
        i_address = i_address + 1;
        #200
        // LUI $1, $2, 32. -> r1 = 32 << 16 = 2097152 REVISAR. RS NO DEBERIA APARECER
        i_instruccion = 32'b001111_00010_00001_0000000000100000;
        #400
        i_address = i_address + 1;
        #200
        // SLTI $1, $2, 32. -> r1 = R2 (2) < 32 = 1
        i_instruccion = 32'b001010_00010_00001_0000000000100000;
        #400
        i_address = i_address + 1;
        #200
        // ADDI $1, $2, 2. -> r1 = 2 + r2 (2) = 4
        i_instruccion = 32'b001000_00010_00001_0000000000000010;
        #400
        i_address = i_address + 1;
        #200
        // XORI $2, $4, 24. -> r2 = 24 xor r1 (4) = 28
        i_instruccion = 32'b001110_00001_00010_0000000000011000;
        #400
        i_address = i_address + 1;
        #200
        // SLLV $3, $1, $2. -> R3 = R2 (28) << R1 (4) = 448 
        i_instruccion = 32'b000000_00001_00010_00011_00000_000100;
        #400
        i_address = i_address + 1;
        #200
        // SRLV $3, $1, $2. -> R3 = R2 (28) >> R1 (4) = 1
        i_instruccion = 32'b000000_00001_00010_00011_00000_000110;
        #400
        i_address = i_address + 1;
        #200
        // SRAV $3, $1, $2. -> R3 = R2 (28) >> (arithmetic) R1 (34) = 1
        i_instruccion = 32'b000000_00001_00010_00011_00000_000111;
        #400
        i_address = i_address + 1;
        #200
        // ADDU $3, $1, $2. -> r3 = r1 (4) + r2 (28) = 32
        i_instruccion = 32'b000000_00001_00010_00011_00000_100001;
        #400
        i_address = i_address + 1;
        #200
        // SUBU $3, $1, $2. -> r3 = r1 (4) - r2 (28) = -24 (4MILLONES UNSIGNED)
        i_instruccion = 32'b000000_00001_00010_00011_00000_100011;
        #400
        i_address = i_address + 1;
        #200
        // XOR $3, $1, $2. -> r3 = r1 (4) xor r2 (28) = 24
        i_instruccion = 32'b000000_00001_00010_00011_00000_100110;
        #400
        i_address = i_address + 1;
        #200
        // OR $3, $1, $2. -> r3 = r1 (4) or r2 (28) = 28
        i_instruccion = 32'b000000_00001_00010_00011_00000_100101;
        #400
        i_address = i_address + 1;
        #200
        // AND $3, $1, $2. -> r3 = r1 (4) and r2 (28) = 4
        i_instruccion = 32'b000000_00001_00010_00011_00000_100100;
        #400
        i_address = i_address + 1;
        #200
        // SLT $3, $1, $2. -> r3 = r1 (4) < r2 (28) = 1
        i_instruccion = 32'b000000_00001_00010_00011_00000_101010;
        #400
        i_address = i_address + 1;
        #200
        // NOR $3, $1, $2. -> r3 = r1 (4) NOR r2 (28) = -29 (4MILLONES UNSIGNED)
        i_instruccion = 32'b000000_00001_00010_00011_00000_100111;
        #400
        i_address = i_address + 1;
        #200
        // BEQ $1, $2, 100. -> SI R1 == R2 -> PC = PC + 104 -> NO
        i_instruccion = 32'b000100_00001_00010_0000000001100100;
        #400
        i_address = i_address + 1;
        #200
        // BNE $1, $2, 100. -> SI R1 != R2 -> PC SIGUE, POR OFFSET 0 -> SI
        i_instruccion = 32'b000101_00001_00010_0000000000000000;
        #400
        i_address = i_address + 1;
        #200
        // SW $1, 8 ($2). -> MEM[R2(28)+8] = R1 = 4;
        i_instruccion = 32'b101011_00010_00001_0000000000001000;
        #400
        i_address = i_address + 1;
        #200
        // LWU $1, 8 ($2). -> R1 = UNSIGNED(MEM[R2(28)+8]) = 4
        i_instruccion = 32'b100111_00010_00001_0000000000001000;
        #400
        i_address = i_address + 1;
        #200
        // LW $1, 8 ($2). -> R1 = SIGNED(MEM[R2(28)+8]) = 4
        i_instruccion = 32'b100011_00010_00001_0000000000001000;
        #400
        i_address = i_address + 1;
        #200
        // LB $1, 8 ($2). -> R1 = SIGNED(MEM[R2(28)+8][7:0]) = 4
        i_instruccion = 32'b100000_00010_00001_0000000000001000;
        #400
        i_address = i_address + 1;
        #200
        // LBU $1, 8 ($2). -> R1 = UNSIGNED(MEM[R2(28)+8][7:0]) = 4
        i_instruccion = 32'b100100_00010_00001_0000000000001000;
        #400
        i_address = i_address + 1;
        #200
        // LH $1, 8 ($2). -> R1 = SIGNED(MEM[R2(28)+8][15:0]) = 4
        i_instruccion = 32'b100001_00010_00001_0000000000001000;
        #400
        i_address = i_address + 1;
        #200
        // LHU $1, 8 ($2). -> R1 = UNSIGNED(MEM[R2(28)+8][15:0]) = 4
        i_instruccion = 32'b100101_00010_00001_0000000000001000;
        #400
        i_address = i_address + 1;
        #200
        // SB $1, 8 ($2). -> MEM[R2(28)+8] = R1[7:0] = 4;
        i_instruccion = 32'b101000_00010_00001_0000000000001000;
        #400
        i_address = i_address + 1;
        #200
        // SH $1, 4 ($2). -> MEM[R2(28)+4] = R1[15:0] = 4;
        i_instruccion = 32'b101001_00110_00001_0000000000000100;
        #400
        i_address = i_address + 1;
        #200
        // JALR $4, $7. -> PC = r7 (x); REG[R4(x)] = pc + 2
        i_instruccion = 32'b000000_00111_00000_00100_00000_001001;
        #400
        i_address = i_address + 1;
        #200
        // JAL 7. -> PC = PC + 1 + (7<<2) = 59
        i_instruccion = 32'b000011_00000000000000000000000111;
        #400
        i_address = i_address + 1;
        #200
        // JR $7. NO LLEGA PORQUE PC SE FUE
        i_instruccion = 32'b000000_00111_000000000000000_001000;
        #400
        i_address = i_address + 1;
        #200
        // J 7. -> PC = PC + 1 + (7<<2)
        i_instruccion = 32'b000010_00000000000000000000000111;
        #400
        i_address = i_address + 1;
        #200
        // NOP 
        i_instruccion = 32'b111000_00000_00000_00000_00000_000000;
        #400
        i_address = i_address + 1;
        #200
        // HALT 
        i_instruccion = 32'b111111_00000_00000_00000_00000_000000;
        #400
        i_address = i_address + 1;
        #200
        i_reset = 1'b1;
        #400
        i_reset = 1'b0;
        i_loading = 1'b0;
        i_start = 1'b1;
        i_step = 1'b1;
        #10000
        $finish;
    end

    always #100 i_clock = ~i_clock;
endmodule