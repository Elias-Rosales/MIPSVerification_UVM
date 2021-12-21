class mips_sequencer extends uvm_sequencer#(mips_seq_item);

  `uvm_component_utils(mips_sequencer) 

  //---------------------------------------
  //constructor
  //---------------------------------------
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction
  
endclass