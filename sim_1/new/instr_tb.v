`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: UNC - FCEFyN
// Engineer: Daniele - Gonzalez
// 
// Create Date: 28.11.2021 18:02:47
// Design Name: 
// Module Name: instr_tb
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
        // #200
        // // NOP
        // i_instruccion = 32'b111000_00000_00000_00000_00000_000000;
        // #400
        // i_address = i_address + 1;
        // #200
        // // NOP
        // i_instruccion = 32'b111000_00000_00000_00000_00000_000000;
        // #400
        // i_address = i_address + 1;
        #200
        // SW $1, 8 ($2). MEM[10] = 1
        i_instruccion = 32'b101011_00010_00001_0000000000001000;
        #400
        i_address = i_address + 1;
        #200
        // SB $2, 8 ($1). MEM[9] = 2
        i_instruccion = 32'b101000_00001_00010_0000000000001000;
        #400
        i_address = i_address + 1;
        #200
        // ADDI $3, $2, 5. R3 = 7
        i_instruccion = 32'b001000_00010_00011_0000000000000101;
        #400
        i_address = i_address + 1;
        #200
        // SH $3, 4 ($1). //mem 5 = 7
        i_instruccion = 32'b101001_00001_00011_0000000000000100;
        #400
        i_address = i_address + 1;
        #200
        //LW $5, 3 ($2). //r5 = 7
        i_instruccion = 32'b100011_00010_00101_0000000000000011;
        #400
        i_address = i_address + 1;
        #200
        // BEQ $1, $2, 1.  //salto si r1 == r2  (1<<2) -> 4 instrucciones (primera vez no, despues si a slti)
        i_instruccion = 32'b000100_00001_00010_0000000000000001;
        #400
        i_address = i_address + 1;
        #200
        // LWU $7, 8 ($2). //r7 = mem 10 = 1 (se ejecuta la primera vez, y la segunda por delay slot)
        i_instruccion = 32'b100111_00010_00111_0000000000001000;
        #400
        i_address = i_address + 1;
        #200
        // SLT $2, $7, $5.  //r2 = r7 < r5 = 1 (se ejecuta la primera vez, y la segunda no)
        i_instruccion = 32'b000000_00111_00101_00010_00000_101010;
        #400
        i_address = i_address + 1;
        #200
        // JR $5. //salto a pc = 7 (r5 = 7) (a beq, ahora va a saltar)
        i_instruccion = 32'b000000_00101_000000000000000_001000;
        #400
        i_address = i_address + 1;
        #200
        //SLTI $1, $2, 32. //se ejecuta en delay slot -> r1 = 1 (r2 < 32) (se ejecuta la primera vez por delay slot y desp normal)
        i_instruccion = 32'b001010_00010_00001_0000000000100000;
        #400
        i_address = i_address + 1;
        #200
        // ORI $1, $2, 32. //r1 = 33
        i_instruccion = 32'b001101_00010_00001_0000000000100000;
        #400
        i_address = i_address + 1;
        #200
        // XORI $2, $1, 24. r2 = 57
        i_instruccion = 32'b001110_00001_00010_0000000000011000;
        #400
        i_address = i_address + 1;
        #200
        // LB $10, 8 ($7). //R10 = MEM 9[7:0] = 2
        i_instruccion = 32'b100000_00111_01010_0000000000001000;
        #400
        i_address = i_address + 1;
        #200
        // SLLV $3, $10, $2. r3 = 228 (57<<2)
        i_instruccion = 32'b000000_01010_00010_00011_00000_000100;
        #400
        i_address = i_address + 1;
        #200
        // SRLV $16, $3, $5. r16 = 0 (7<<228)
        i_instruccion = 32'b000000_00011_00101_10000_00000_000110;
        #400
        i_address = i_address + 1;
        #200
        // SRAV $17, $1, $6. r17 = x (33<<x)
        i_instruccion = 32'b000000_00001_00110_10001_00000_000111;
        #400
        i_address = i_address + 1;
        #200
        // ADDU $22, $1, $7. r22 = 34 (33 + 1)
        i_instruccion = 32'b000000_00001_00111_10110_00000_100001;
        #400
        i_address = i_address + 1;
        #200
        // SUBU $11, $2, $6. r11 = x (57 - x)
        i_instruccion = 32'b000000_00010_00110_01011_00000_100011;
        #400
        i_address = i_address + 1;
        #200
        // JAL 1. //SALTO 4 INSTR, r31 = pc + 2 (23) (revisar, deberia ser 22 porque esta es la instr 20, se ejecuta la sig (21) por delay slot)
        i_instruccion = 32'b000011_00000000000000000000000001;
        #400
        i_address = i_address + 1; //R12 = R5 + 0 = 7
        #200
        // ADDI $12, $5, 0. r12 = 7 (7 + 0) (se ejecuta por delay slot)
        i_instruccion = 32'b001000_00101_01100_0000000000000000;
        #400
        i_address = i_address + 1;
        #200
        //BNE $5, $12, 4. //no se ejecuta
        i_instruccion = 32'b000101_00101_01100_0000000000000100;
        #400
        i_address = i_address + 1;
        #200
        // SRLV $26, $3, $5. //no se ejecuta
        i_instruccion = 32'b000000_00011_00101_11010_00000_000110;
        #400
        i_address = i_address + 1;
        #200
        //SRAV $27, $1, $6. //r27 = x
        i_instruccion = 32'b000000_00001_00110_11011_00000_000111;
        #400
        i_address = i_address + 1;
        #200
        //ADDU $21, $1, $7. r21 = 34 (33 + 1)
        i_instruccion = 32'b000000_00001_00111_10101_00000_100001;
        #400
        i_address = i_address + 1;
        #200
        // J 1 (4 instr).
        i_instruccion = 32'b000010_00000000000000000000000001;
        #400
        i_address = i_address + 1;
        #200
        // SUBU $29, $2, $6. r29 = x (ejecuta por delay slot)
        i_instruccion = 32'b000000_00010_00110_11101_00000_100011;
        #400
        i_address = i_address + 1;
        #200
        // SUBU $25, $2, $6. r25 = x //no se ejecuta
        i_instruccion = 32'b000000_00010_00110_11001_00000_100011;
        #400
        i_address = i_address + 1;
        #200
        // SUBU $25, $2, $6. r25 = x //no se ejecuta
        i_instruccion = 32'b000000_00010_00110_11001_00000_100011;
        #400
        i_address = i_address + 1;
        #200
        // JR $32. salto a r32 = 23 << 2, revisar esto
        i_instruccion = 32'b000000_11111_000000000000000_001000;
        #400
        i_address = i_address + 1;
        #200
        // HALT. se ejecuta por delay slot, ojo revisar porque no para
        i_instruccion = 32'b111111_00000_00000_00000_00000_000000;
        #400
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
