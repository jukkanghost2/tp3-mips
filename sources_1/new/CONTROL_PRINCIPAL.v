`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: UNC FCEFyN
// Engineer: Daniele - Gonzalez
// 
// Create Date: 11/16/2021 07:18:59 PM
// Design Name: 
// Module Name: CONTROL_PRINCIPAL
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


module CONTROL_PRINCIPAL
    #(  //PARAMETERS
        parameter DATA_WIDTH    = 32,
        parameter SIZEOP        = 6
    )
    (   //INPUTS
        input   [DATA_WIDTH - 1:0]  i_instruccion,
        //OUTPUTS
        output  [3:0]               o_ex,
        output  [2:0]               o_mem,
        output  [1:0]               o_wb,
        output  [1:0]               o_sizemem,
        output                      o_signedmem,
        output                      o_beq_or_bne,
        output                      o_halt
    );

    //OPERATIONS
    //R-TYPE
    localparam [SIZEOP - 1:0]     R_TYPE    = 6'b000000;
    //I-TYPE
    localparam [SIZEOP - 1:0]     LW        = 6'b100011;
    localparam [SIZEOP - 1:0]     LWU       = 6'b100111;
    localparam [SIZEOP - 1:0]     LB        = 6'b100000;
    localparam [SIZEOP - 1:0]     LBU       = 6'b100100;
    localparam [SIZEOP - 1:0]     LH        = 6'b100001;
    localparam [SIZEOP - 1:0]     LHU       = 6'b100101;
    localparam [SIZEOP - 1:0]     SW        = 6'b101011;
    localparam [SIZEOP - 1:0]     SB        = 6'b101000;
    localparam [SIZEOP - 1:0]     SH        = 6'b101001;
    localparam [SIZEOP - 1:0]     BEQ       = 6'b000100;
    localparam [SIZEOP - 1:0]     BNE       = 6'b000101;
    localparam [SIZEOP - 1:0]     ADDI      = 6'b001000;
    localparam [SIZEOP - 1:0]     ANDI      = 6'b001100;
    localparam [SIZEOP - 1:0]     ORI       = 6'b001101;
    localparam [SIZEOP - 1:0]     XORI      = 6'b001110;
    localparam [SIZEOP - 1:0]     LUI       = 6'b001111;
    localparam [SIZEOP - 1:0]     SLTI      = 6'b001010;
    localparam [SIZEOP - 1:0]     J         = 6'b000010;
    localparam [SIZEOP - 1:0]     JAL       = 6'b000011;
    // J-TYPE
    localparam [SIZEOP - 1:0]     JR        = 6'b001000;
    localparam [SIZEOP - 1:0]     JALR      = 6'b001001;
    //NOP y HALT
    localparam [SIZEOP - 1:0]     NOP       = 6'b111000;
    localparam [SIZEOP - 1:0]     HALT      = 6'b111111;

    reg [SIZEOP - 1:0]  opcode;
    reg [3:0]           ex;
    reg [2:0]           mem;
    reg [1:0]           wb;
    reg [1:0]           sizemem;
    reg                 signedmem;
    reg                 beq_or_bne;
    reg                 halt;
    reg [SIZEOP - 1:0]  funct;
    
    assign o_ex         = ex;
    assign o_mem        = mem;
    assign o_wb         = wb;
    assign o_sizemem    = sizemem;
    assign o_signedmem  = signedmem;
    assign o_beq_or_bne = beq_or_bne;
    assign o_halt       = halt;

    always @(*) begin
        opcode  = i_instruccion[31:26];
        funct   = i_instruccion[5:0];
        case (opcode)
            R_TYPE: begin
                case(funct)
                    JR: begin
                        ex          = 4'bxxxx;
                        mem         = 3'bxxx;
                        wb          = 2'bxx;
                        sizemem     = 2'bxx;
                        signedmem   = 1'bx;
                        beq_or_bne  = 1'b0;
                        halt        = 1'b0;
                    end
                    JALR: begin
                        ex          = 4'b1xxx;
                        mem         = 3'bxxx;
                        wb          = 2'b11;
                        sizemem     = 2'bxx;
                        signedmem   = 1'bx;
                        beq_or_bne  = 1'b0;
                        halt        = 1'b0;
                    end
                    default: begin
                        ex          = 4'b1010;
                        mem         = 3'b000;
                        wb          = 2'b11;
                        sizemem     = 2'bxx;
                        signedmem   = 1'bx;
                        beq_or_bne  = 1'b0;
                        halt        = 1'b0;
                    end
                endcase
            end
            LW: begin
                ex          = 4'b0100;
                mem         = 3'b100;
                wb          = 2'b10;
                sizemem     = 2'b00;
                signedmem   = 1'b1;
                beq_or_bne  = 1'b0;
                halt        = 1'b0;
            end
            LWU: begin
                ex          = 4'b0100;
                mem         = 3'b100;
                wb          = 2'b10;
                sizemem     = 2'b00;
                signedmem   = 1'b0;
                beq_or_bne  = 1'b0;
                halt        = 1'b0;
            end
            LB: begin
                ex          = 4'b0100;
                mem         = 3'b100;
                wb          = 2'b10;
                sizemem     = 2'b01;
                signedmem   = 1'b1;
                beq_or_bne  = 1'b0;
                halt        = 1'b0;
            end
            LBU: begin
                ex          = 4'b0100;
                mem         = 3'b100;
                wb          = 2'b10;
                sizemem     = 2'b01;
                signedmem   = 1'b0;
                beq_or_bne  = 1'b0;
                halt        = 1'b0;
            end
            LH: begin
                ex          = 4'b0100;
                mem         = 3'b100;
                wb          = 2'b10;
                sizemem     = 2'b10;
                signedmem   = 1'b1;
                beq_or_bne  = 1'b0;
                halt        = 1'b0;
            end
            LHU: begin
                ex          = 4'b0100;
                mem         = 3'b100;
                wb          = 2'b10;
                sizemem     = 2'b10;
                signedmem   = 1'b0;
                beq_or_bne  = 1'b0;
                halt        = 1'b0;
            end
            SW: begin
                ex          = 4'bx100;
                mem         = 3'b010;
                wb          = 2'b0x;
                sizemem     = 2'b00;
                signedmem   = 1'bx;
                beq_or_bne  = 1'b0;
                halt        = 1'b0;
            end
            SB: begin
                ex          = 4'bx100;
                mem         = 3'b010;
                wb          = 2'b0x;
                sizemem     = 2'b01;
                signedmem   = 1'bx;
                beq_or_bne  = 1'b0;
                halt        = 1'b0;
            end
            SH: begin
                ex          = 4'bx100;
                mem         = 3'b010;
                wb          = 2'b0x;
                sizemem     = 2'b10;
                signedmem   = 1'bx;
                beq_or_bne  = 1'b0;
                halt        = 1'b0;
            end
            BEQ: begin
                ex          = 4'bx001;
                mem         = 3'b001;
                wb          = 2'b0x;
                sizemem     = 2'bxx;
                signedmem   = 1'bx;
                beq_or_bne  = 1'b1;
                halt        = 1'b0;
            end
            BNE: begin
                ex          = 4'bx001;
                mem         = 3'b001;
                wb          = 2'b0x;
                sizemem     = 2'bxx;
                signedmem   = 1'bx;
                beq_or_bne  = 1'b0;
                halt        = 1'b0;
            end
            ADDI: begin
                ex          = 4'b0111;
                mem         = 3'b000;
                wb          = 2'b11;
                sizemem     = 2'bxx;
                signedmem   = 1'bx;
                beq_or_bne  = 1'b0;
                halt        = 1'b0;
            end
            ANDI: begin
                ex          = 4'b0111;
                mem         = 3'b000;
                wb          = 2'b11;
                sizemem     = 2'bxx;
                signedmem   = 1'bx;
                beq_or_bne  = 1'b0;
                halt        = 1'b0;
            end
            ORI: begin
                ex          = 4'b0111;
                mem         = 3'b000;
                wb          = 2'b11;
                sizemem     = 2'bxx;
                signedmem   = 1'bx;
                beq_or_bne  = 1'b0;
                halt        = 1'b0;
            end
            XORI: begin
                ex          = 4'b0111;
                mem         = 3'b000;
                wb          = 2'b11;
                sizemem     = 2'bxx;
                signedmem   = 1'bx;
                beq_or_bne  = 1'b0;
                halt        = 1'b0;
            end
            LUI: begin
                ex          = 4'b0111;
                mem         = 3'b000;
                wb          = 2'b11;
                sizemem     = 2'bxx;
                signedmem   = 1'bx;
                beq_or_bne  = 1'b0;
                halt        = 1'b0;
            end
            SLTI: begin
                ex          = 4'b0111;
                mem         = 3'b000;
                wb          = 2'b11;
                sizemem     = 2'bxx;
                signedmem   = 1'bx;
                beq_or_bne  = 1'b0;
                halt        = 1'b0;
            end
            J: begin
                ex          = 4'bxxxx;
                mem         = 3'bxxx;
                wb          = 2'bxx;
                sizemem     = 2'bxx;
                signedmem   = 1'bx;
                beq_or_bne  = 1'b0;
                halt        = 1'b0;
            end
           
            JAL: begin
                ex          = 4'b1xxx;
                mem         = 3'bxxx;
                wb          = 2'b11;
                sizemem     = 2'bxx;
                signedmem   = 1'bx;
                beq_or_bne  = 1'b0;
                halt        = 1'b0;
            end
            NOP: begin
                ex          = 4'bxx11;
                mem         = 3'bxxx;
                wb          = 2'bxx;
                sizemem     = 2'bxx;
                signedmem   = 1'bx;
                beq_or_bne  = 1'bx;
                halt        = 1'b0;
            end
            HALT: begin
                ex          = 4'bxx11;
                mem         = 3'bxx;
                wb          = 2'bxx;
                sizemem     = 2'bxx;
                signedmem   = 1'bx;
                beq_or_bne  = 1'bx;
                halt        = 1'b1;
            end
            default: begin
                ex          = 4'b0000;
                mem         = 3'b000;
                wb          = 2'b00;
                sizemem     = 2'bxx;
                signedmem   = 1'bx;
                beq_or_bne  = 1'b0;
                halt        = 1'b0;
            end
        endcase
    end
endmodule