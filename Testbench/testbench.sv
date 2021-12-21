//including interfcae and testcase files
`include "interface.sv"
`include "mips_base_test.sv"
`include "mips_test.sv"

module tbench_top;

  //---------------------------------------
  //clock and reset signal declaration
  //---------------------------------------
  bit clk;
  bit reset;
  
  //---------------------------------------
  //clock generation
  //---------------------------------------
  always #5 clk = ~clk;
  
  //---------------------------------------
  //reset Generation
  //---------------------------------------
  initial begin
    reset = 1;
    #5 reset =0;
  end

  //---------------------------------------
  //interface instance
  //---------------------------------------
  mips_if intf(clk,reset);
  
  //---------------------------------------
  //DUT instance
  //---------------------------------------
  MIPS_MC DUT(.clk(intf.clk),
                .reset(intf.reset),
                .Instr(intf.Instr),
                .ALUResult(intf.ALUResult),
                .ALUOut(intf.ALUOut), 
                .p_state(intf.p_state),
                .Next_PC(intf.Next_PC),
                .B(intf.B),
                .zero(intf.zero),
                .PC(intf.PC),
                .A3(intf.A3),
                .RegWrite(intf.RegWrite),
                .WD3(intf.WD3));
                
  //---------------------------------------
  //passing the interface handle to lower heirarchy using set method 
  //and enabling the wave dump
  //---------------------------------------
  initial begin 
    uvm_config_db#(virtual mips_if)::set(uvm_root::get(),"*","vif",intf);
    //enable wave dump
    $dumpfile("dump.vcd"); 
    $dumpvars;
  end
  
  //---------------------------------------
  //calling test
  //---------------------------------------
  initial begin
    clk = 1;
    run_test();
  end
  
endmodule