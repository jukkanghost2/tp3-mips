`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/09/2021 05:48:54 PM
// Design Name: 
// Module Name: alu_tb
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


`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.09.2021 08:40:25
// Design Name: 
// Module Name: ALU_tb
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


module alu_tb;
  parameter SIZEDATA = 8;
  parameter SIZEOP = 6;
  parameter N_OPS = 19;

	//INPUTS
  reg signed    [SIZEDATA - 1:0]    i_datoa;
  reg signed    [SIZEDATA - 1:0]    i_datob;
  reg           [SIZEOP - 1:0]      i_opcode;
  	//OUTPUTS
  wire  signed [SIZEDATA - 1:0]    o_result;
  reg [SIZEOP-1:0] OPS[0:N_OPS-1];

  
 
   // duration for each bit = 20 * timescale = 20 * 1 ns  = 20ns
  localparam                        period = 20;
 //OPERATIONS
  //R-TYPE
  localparam [SIZEOP - 1:0]     SLL = 6'b000000;
  localparam [SIZEOP - 1:0]     SRL = 6'b000010;
  localparam [SIZEOP - 1:0]     SRA = 6'b000011;
  localparam [SIZEOP - 1:0]     SLLV = 6'b000100;
  localparam [SIZEOP - 1:0]     SRLV = 6'b000110;
  localparam [SIZEOP - 1:0]     SRAV = 6'b000111;
  localparam [SIZEOP - 1:0]     ADDU = 6'b100001;
  localparam [SIZEOP - 1:0]     SUBU = 6'b100011;
  localparam [SIZEOP - 1:0]     OR  = 6'b100101;
  localparam [SIZEOP - 1:0]     XOR = 6'b100110;
  localparam [SIZEOP - 1:0]     AND = 6'b100100;
  localparam [SIZEOP - 1:0]     NOR = 6'b100111;
  localparam [SIZEOP - 1:0]     SLT = 6'b101010;
  //I-TYPE
  localparam [SIZEOP - 1:0]     ADDI = 6'b001000;
  localparam [SIZEOP - 1:0]     ANDI = 6'b001100;
  localparam [SIZEOP - 1:0]     ORI = 6'b001101;
  localparam [SIZEOP - 1:0]     XORI = 6'b001110;
  localparam [SIZEOP - 1:0]     LUI = 6'b001111;
  localparam [SIZEOP - 1:0]     SLTI = 6'b001010;

  ALU alu_test (
    .i_datoa      (i_datoa), 
    .i_datob      (i_datob), 
    .i_opcode     (i_opcode), 
    .o_result     (o_result)
  );
     
    initial // initial block executes only once
        begin
        OPS[0] = SLL;
        OPS[1] = SRL;
        OPS[2] = SRA;
        OPS[3] = SLLV;
        OPS[4] = SRLV;
        OPS[5] = SRAV;
        OPS[6] = ADDU;
        OPS[7] = SUBU;
        OPS[8] = OR;
        OPS[9] = XOR;
        OPS[10] = AND;
        OPS[11] = NOR;
        OPS[12] = SLT;
        OPS[13] = ADDI;
        OPS[14] = ANDI;
        OPS[15] = ORI;
        OPS[16] = XORI;
        OPS[17] = LUI;
        OPS[18] = SLTI;
            
                      
        i_datoa = 8'b0;
        i_datob = 8'b0;
        i_opcode = 6'b0;
        #10
        
            
        
     for(integer i = 0; i < N_OPS; i = i+1) 
		     begin
		     #(period)
		       i_datoa =  $urandom; 
		      
		       #(period*2);
		       
		        i_datob = $urandom;
		       if( i > 5) i_datob = 3; //PARA OPS SRA Y SRL
		
		       #(period*2);
                
                
		      i_opcode = OPS[i]; 
		       #(period*2);
		       case(i)
		          0: if((i_datoa << i_datob) != o_result) $display("%d %d %d %d error en sll", i_datoa, i_datob, o_result, i_datoa << i_datob);
		          1: if((i_datoa >> i_datob) != o_result) $display("%d %d %d %d error en srl", i_datoa, i_datob, o_result, i_datoa >> i_datob);
		          2: if((i_datoa >>> i_datob) != o_result) $display("%b %b %b %b error en sra", i_datoa, i_datob, o_result, i_datoa >>> i_datob);
		          3: if((i_datoa << i_datob) != o_result) $display("%b %b %b %b error en sllv", i_datoa, i_datob, o_result, i_datoa << i_datob);
		          4: if((i_datoa >> i_datob) != o_result) $display("%b %b %b %b error en srlv", i_datoa, i_datob, o_result, i_datoa >> i_datob);
		          5: if((i_datoa >>> i_datob) != o_result) $display("%b %b %b %b error en srav", i_datoa, i_datob, o_result, i_datoa >>> i_datob);
		          6: if((i_datoa + i_datob) != o_result) $display("%b %b %b %b error en addu", i_datoa, i_datob, o_result, i_datoa + i_datob);
		          7: if((i_datoa - i_datob) != o_result) $display("%b %b %b %b error en subu", i_datoa, i_datob, o_result, i_datoa - i_datob);
		          8: if((i_datoa | i_datob) != o_result) $display("%b %b %b %b error en or", i_datoa, i_datob, o_result, i_datoa | i_datob);
		          9: if((i_datoa  ^ i_datob) != o_result) $display("%b %b %b %b error en xor", i_datoa, i_datob, o_result, i_datoa ^ i_datob);
		          10: if((i_datoa & i_datob) != o_result) $display("%b %b %b %b error en and", i_datoa, i_datob, o_result, i_datoa & i_datob);
		          11: if(~(i_datoa | i_datob) != o_result) $display("%b %b %b %b error en nor", i_datoa, i_datob, o_result, ~(i_datoa | i_datob));
		          12: if((i_datoa < i_datob) != o_result) $display("%b %b %b %b error en slt", i_datoa, i_datob, o_result, i_datoa < i_datob);
		          13: if((i_datoa + i_datob) != o_result) $display("%b %b %b %b error en addi", i_datoa, i_datob, o_result, i_datoa + i_datob);
		          14: if((i_datoa & i_datob) != o_result) $display("%b %b %b %b error en andi", i_datoa, i_datob, o_result, i_datoa & i_datob);
		          15: if((i_datoa | i_datob) != o_result) $display("%b %b %b %b error en ori", i_datoa, i_datob, o_result, i_datoa | i_datob);
		          16: if((i_datoa ^ i_datob) != o_result) $display("%b %b %b %b error en xori", i_datoa, i_datob, o_result, i_datoa ^ i_datob);
		          17: if((i_datoa << i_datob) != o_result) $display("%b %b %b %b error en lui", i_datoa, i_datob, o_result, i_datoa << i_datob);
		          18: if((i_datoa < i_datob) != o_result) $display("%b %b %b %b error en slti", i_datoa, i_datob, o_result, i_datoa < i_datob);
		       endcase
		       
		      end
		      #(period);

            $finish;
        
            
     end
       
endmodule

