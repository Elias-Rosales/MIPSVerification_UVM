interface mips_if(input logic clk,reset);
  
  //---------------------------------------
  //declaring the signals
  //---------------------------------------
  logic	[31:0] 	Instr;
  logic [31:0]	ALUResult;
  logic [31:0]	ALUOut;
  logic [31:0]	WD3;
  logic [4:0]	A3;
  logic [3:0]	p_state;
  logic [31:0]  PC;
  logic	[31:0]	Next_PC;
  logic	[31:0]	B;
  logic			zero;
  logic			RegWrite;
  
  //---------------------------------------
  //driver clocking block
  //---------------------------------------
  clocking driver_cb @(posedge clk);
    // skew
    default input #100ps output #100ps;
    // PORTS
    output 	Instr;
	input	ALUResult;
    input	ALUOut;
    input	p_state;
    output	PC;			
    input	Next_PC;
    input	B;
    input	zero;
    input	WD3;
    input	A3;
    input	RegWrite;
  endclocking
  
  //---------------------------------------
  //monitor clocking block
  //---------------------------------------
 clocking monitor_cb @(posedge clk);
    // skew
    default input #100ps output #100ps;
    // PORTS
    input 	Instr;
	input	ALUResult;
    input	ALUOut;
    input	p_state;
    input   PC;
    input	Next_PC;
    input	B;
    input	zero;
    input	WD3;
    input	A3;
    input	RegWrite;
  endclocking
  
  //---------------------------------------
  //driver modport
  //---------------------------------------
  modport DRIVER  (clocking driver_cb,input clk,reset);
  
  //---------------------------------------
  //monitor modport  
  //---------------------------------------
  modport MONITOR (clocking monitor_cb,input clk,reset);
    
endinterface
    