`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: UNC FCEFyN
// Engineer: Daniele - Gonzalez
// 
// Create Date: 11/17/2021 11:04:48 AM
// Design Name: 
// Module Name: ALU_CONTROL
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


module ALU_CONTROL
    #(  //PARAMETERS
        parameter             SIZEOP = 6
    )
    (   //INPUTS
        input [1:0]           i_aluop,
        input [SIZEOP - 1:0]  i_opcode,
        input [SIZEOP- 1:0]   i_funct,
        //OUTPUTS
        output [3:0]          o_alucontrol
    );

     //OPERATIONS
     //R-TYPE
     localparam [SIZEOP - 1:0]     SLL  = 6'b000000;
     localparam [SIZEOP - 1:0]     SRL  = 6'b000010;
     localparam [SIZEOP - 1:0]     SRA  = 6'b000011;
     localparam [SIZEOP - 1:0]     SLLV = 6'b000100;
     localparam [SIZEOP - 1:0]     SRLV = 6'b000110;
     localparam [SIZEOP - 1:0]     SRAV = 6'b000111;
     localparam [SIZEOP - 1:0]     ADDU = 6'b100001;
     localparam [SIZEOP - 1:0]     SUBU = 6'b100011;
     localparam [SIZEOP - 1:0]     OR   = 6'b100101;
     localparam [SIZEOP - 1:0]     XOR  = 6'b100110;
     localparam [SIZEOP - 1:0]     AND  = 6'b100100;
     localparam [SIZEOP - 1:0]     NOR  = 6'b100111;
     localparam [SIZEOP - 1:0]     SLT  = 6'b101010;
     // J-TYPE
     localparam [SIZEOP - 1:0]     JR   = 6'b001000;
     localparam [SIZEOP - 1:0]     JALR = 6'b001001;
     //I-TYPE
     localparam [SIZEOP - 1:0]     ADDI = 6'b001000;
     localparam [SIZEOP - 1:0]     ANDI = 6'b001100;
     localparam [SIZEOP - 1:0]     ORI  = 6'b001101;
     localparam [SIZEOP - 1:0]     XORI = 6'b001110;
     localparam [SIZEOP - 1:0]     LUI  = 6'b001111;
     localparam [SIZEOP - 1:0]     SLTI = 6'b001010;
     //NOP y HALT
     localparam [SIZEOP - 1:0]     NOP  = 6'b111000;
     localparam [SIZEOP - 1:0]     HALT = 6'b111111;

     reg [3:0] alucontrol;

     assign o_alucontrol = alucontrol;

     always @(*) begin
       case (i_aluop)
           //LW Y SW
          2'b00:              alucontrol = 4'b0110;          
           //BEQ Y BNE
          2'b01:              alucontrol = 4'b1111;  
           //R-TYPE 
          2'b10: begin
               case (i_funct)
                   SLL:       alucontrol = 4'b0000;
                   SRL:       alucontrol = 4'b0001;                   
                   SRA:       alucontrol = 4'b0010;                   
                   SLLV:      alucontrol = 4'b0011;                   
                   SRLV:      alucontrol = 4'b0100;                   
                   SRAV:      alucontrol = 4'b0101;                   
                   ADDU:      alucontrol = 4'b0110;                   
                   SUBU:      alucontrol = 4'b0111;                   
                   OR:        alucontrol = 4'b1000;                   
                   XOR:       alucontrol = 4'b1001;                    
                   AND:       alucontrol = 4'b1010;                   
                   NOR:       alucontrol = 4'b1011;                  
                   SLT:       alucontrol = 4'b1100;                   
                   default:   alucontrol = 4'b1111; // invalido
               endcase              
          end 
          //I_TYPE
          2'b11: begin
               case (i_opcode)
                    ADDI:     alucontrol = 4'b0110;                   
                    ANDI:     alucontrol = 4'b1010;                   
                    ORI:      alucontrol = 4'b1000;                   
                    XORI:     alucontrol = 4'b1001;                   
                    LUI:      alucontrol = 4'b1101;                  
                    SLTI:     alucontrol = 4'b1100;      
                    NOP:      alucontrol = 4'b1111;      
                    HALT:     alucontrol = 4'b1111;      
                    default:  alucontrol = 4'b1111; //invalido
               endcase
           end
          //no contemplado
          default:            alucontrol = 4'b1111; //invalido
          endcase
     end
endmodule