class mips_seq_item extends uvm_sequence_item;
  //---------------------------------------
  //data and control fields
  //---------------------------------------
  rand bit	[31:0] 	Instr;
  bit	[4:0]	A3;
  bit	[31:0]	WD3;
  bit	[31:0]	ALUResult;
  bit	[31:0]	ALUOut;
  bit  	[3:0]	p_state;
  bit   [31:0]  PC;
  bit	[31:0]	Next_PC;
  bit	[31:0]	B;
  bit			zero;
  bit			RegWrite;

  typedef enum {R,J,sw,beq,addi,lw} opcode;
  
  typedef enum {add = 32, sub = 34, and_ = 36, or_ = 37, slt =42} funct;

  rand opcode op;
  randc funct fn;
  
  //---------------------------------------
  //constraint to distribute the level of appereance of each function
  //---------------------------------------
  constraint op_dist {op dist {R:=5, sw:=4, beq:=3, addi:=5, J:=2, lw:=4};}
  
  //---------------------------------------
  //Utility and Field macros
  //---------------------------------------
  `uvm_object_utils_begin(mips_seq_item)
    `uvm_field_int(Instr,UVM_ALL_ON)
    `uvm_field_int(A3,UVM_ALL_ON)
    `uvm_field_int(WD3,UVM_ALL_ON)
    `uvm_field_int(ALUResult,UVM_ALL_ON)
    `uvm_field_int(ALUOut,UVM_ALL_ON)
    `uvm_field_int(p_state,UVM_ALL_ON)
    `uvm_field_int(PC,UVM_ALL_ON)
    `uvm_field_int(Next_PC,UVM_ALL_ON)
    `uvm_field_int(B,UVM_ALL_ON)
  `uvm_object_utils_end

  //---------------------------------------
  //Constructor
  //---------------------------------------
  function new(string name = "mips_seq_item");
    super.new(name);
  endfunction

  //---------------------------------------
  //constraint, to generate any one among write and read
  //---------------------------------------
  constraint op_values {
    (op == lw) -> Instr[31:26] == 35;
    (op == lw) -> Instr[25:21] inside {[8:25]};    //reg 8-25
    (op == lw) -> Instr[20:16] inside {[8:25]};    //reg 8-25
    (op == lw) -> Instr[15:0]  inside {[0:10],[16'hfffb:16'hffff]};
    
    (op == sw) -> Instr[31:26] == 43;
    (op == sw) -> Instr[25:21] inside {[8:25]};    //reg 8-25
    (op == sw) -> Instr[20:16] inside {[8:25]};    //reg 8-25
    (op == sw) -> Instr[15:0]  inside {[0:10],[16'hfffb:16'hffff]};
    
    (op == beq) -> Instr[31:26] == 4;
    (op == beq) -> Instr[25:21] inside {[8:25]};   //reg 8-25
    (op == beq) -> Instr[20:16] inside {[8:25]};   //reg 8-25
    (op == beq) -> Instr[15:0]  inside {[0:10],[16'hfff0:16'hffff]};
    
    (op == addi) -> Instr[31:26] == 8;
    (op == addi) -> Instr[25:21] inside {[8:25]};   //reg 8-25
    (op == addi) -> Instr[20:16] inside {[8:25]};   //reg 8-25
    (op == addi) -> Instr[15:0]  inside {[0:32],[16'hffe0:16'hffff]}; //Values from -32 to 32*/
    
    (op == J) -> Instr[31:26] == 2;					//j
    (op == J) -> Instr[25:0]  inside{[0:99]};		//addr range[0:99]
    
    (op == R) -> Instr[31:26] == 0;
    (op == R) -> Instr[25:21] inside {[8:25]};     //reg 8-25
    (op == R) -> Instr[20:16] inside {[8:25]};     //reg 8-25
    (op == R) -> Instr[15:11] inside {[8:25]};     //reg 8-25 
    (op == R) -> Instr[10:6]  == 0;                //shamt
    (op == R) -> Instr[5:0]   == fn;               //add,sub,and,or,slt
  }
endclass 
