module ALU(
  input 		[31:0] 	A, B,
  input			 [2:0]	ALUControl,
  output 				zero,
  output reg 	[31:0]	y);
  
  always_comb
    case(ALUControl)
      3'b000: y = A & B;					//A and B
      3'b001: y = A | B;					//A or  B
      3'b010: y = A + B;					//A +   B
      3'b011: y = A + B;					//Not used
      3'b100: y = A & ~B;					//A and B'
      3'b101: y = A | ~B;					//A or  B'
      3'b110: y = A - B;					//A -   B
      default: y = (A < B) ? 32'b1: 32'b0;	//SLT
    endcase
  
  assign zero = (y==32'b0) ? 1'b1:1'b0;
  
endmodule