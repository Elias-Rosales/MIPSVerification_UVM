//MAIN CONTROLLER FSM
module controller(
  input					clk, reset,
  input 		[5:0]	opcode,
  output reg			IRWrite, RegDst, MemtoReg, RegWrite,
  output reg			ALUSrcA, MemWrite, Branch, PCWrite,
  output reg	[1:0]	ALUSrcB, ALUop, PCSrc,
  output reg	[3:0]	present_state);
  
  //Definition of present state and next state
  reg [3:0] state;
  reg [3:0] next_state;
  
  //Controls
  reg [13:0] controls;
  assign {IRWrite, RegDst, MemtoReg, RegWrite, ALUSrcA, ALUSrcB,
          ALUop, MemWrite, PCSrc, Branch, PCWrite} = controls;
  assign present_state = state;
  
  //State Codification
  parameter S0 = 4'b0000;	//Fetch
  parameter S1 = 4'b0001;	//Decode
  parameter S2 = 4'b0010;	//MemAdr
  parameter S3 = 4'b0011;	//MemRead
  parameter S4 = 4'b0100;	//Mem Writeback
  parameter S5 = 4'b0101;	//MemWrite
  parameter S6 = 4'b0110;	//Execute
  parameter S7 = 4'b0111;	//ALU Writeback
  parameter S8 = 4'b1000;	//Branch
  parameter S9 = 4'b1001;	//ADDI Execute
  parameter S10 = 4'b1010;	//ADDI Writeback
  parameter S11 = 4'b1011;	//Jump
  
  //Initial State
  initial begin
    state = S0;
  end
  
  //State Register
  //Assign a state for reset otherwise the next state
  always @(posedge clk, posedge reset)
    begin
      if (reset) state <= S0;
      else 		 state <= next_state;
    end
  
  //Next State Logic
  always @(state)
    begin
      case(state)
        S0: next_state = S1;
        S1: case(opcode)
          		6'b100011,
          		6'b101011: next_state = S2;		// lw and sw
          		6'b000000: next_state = S6;		// R-Type
          		6'b000100: next_state = S8;		// BEQ
          		6'b001000: next_state = S9;		// ADDI
          		6'b000010: next_state = S11;	// J
          		default: next_state = S0;		// invalid opcode
        	endcase
        S2: if(opcode == 6'b100011) next_state = S3;	// lw
          	else next_state = S5;						// sw
        S3: next_state = S4;
        S4: next_state = S0;
        S5: next_state = S0;
        S6: next_state = S7;
        S7: next_state = S0;
        S8: next_state = S0;
        S9: next_state = S10;
        S10: next_state = S0;
        default: next_state = S0; //s11
      endcase
    end
  
  //Output logic
  always @(state)
    begin
      case(state)
      	S0: controls = 14'b10000010000001;
      	S1: controls = 14'b00000110000000;
      	S2: controls = 14'b00001100000000;
      	S3: controls = 14'b00001100000000;
      	S4: controls = 14'b00111100000000;
      	S5: controls = 14'b00001100010000;
      	S6: controls = 14'b00001001000000;
      	S7: controls = 14'b01011001000000;
      	S8: controls = 14'b00001000100110;
      	S9: controls = 14'b00001100000000;
      	S10: controls = 14'b00011100000000;
      	default: controls = 14'b00000110001001; //s11
      endcase
    end
endmodule