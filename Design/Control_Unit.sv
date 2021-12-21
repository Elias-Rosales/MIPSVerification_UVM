// Control Unit for a MIPS with LW and BEQ instruction
`include "maindec.sv"
`include "aludec.sv"

module Control_Unit(
  input				clk, reset, zero,
  input		[5:0] 	Funct,
  input 	[5:0]	OP,
  output			IRWrite, RegDst, MemtoReg, RegWrite,
  output			ALUSrcA, MemWrite, PCEn,
  output	[1:0]	ALUSrcB, PCSrc,
  output 	[2:0] 	ALUControl,
  output    [3:0]	p_state);
  
  reg [1:0] ALUop;
  wire		Branch,PCWrite;
  
  controller C(clk,reset,OP,IRWrite,RegDst,MemtoReg,RegWrite,
               ALUSrcA,MemWrite,Branch,PCWrite,ALUSrcB,
               ALUop,PCSrc,p_state);
  aludec AD(Funct,ALUop,ALUControl);
  
  assign PCEn = (Branch & zero) | PCWrite;
  
endmodule