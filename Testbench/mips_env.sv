`include "agent.sv"
`include "mips_scoreboard.sv"

class mips_model_env extends uvm_env;
  
  //---------------------------------------
  // agent and scoreboard instance
  //---------------------------------------
  mips_agent      mips_agnt;
  mips_scoreboard mips_scb;

  `uvm_component_utils(mips_model_env)
  
  //--------------------------------------- 
  // constructor
  //---------------------------------------
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  //---------------------------------------
  // build_phase - crate the components
  //---------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    mips_agnt = mips_agent::type_id::create("mips_agnt", this);
    mips_scb  = mips_scoreboard::type_id::create("mips_scb", this);
  endfunction : build_phase

  //---------------------------------------
  // connect_phase - connecting monitor and scoreboard port
  //---------------------------------------
  function void connect_phase(uvm_phase phase);
    mips_agnt.monitor.item_collected_port.connect(mips_scb.item_collected_export);
  endfunction : connect_phase

endclass : mips_model_env