`define MON_IF vif.MONITOR.monitor_cb

class mips_monitor extends uvm_monitor;

  //---------------------------------------
  // Virtual Interface
  //---------------------------------------
  virtual mips_if vif;

  //---------------------------------------
  // analysis port, to send the trans_collected action to scoreboard
  //---------------------------------------
  uvm_analysis_port #(mips_seq_item) item_collected_port;

  //---------------------------------------
  // The following property holds the trans_collectedaction information currently
  // begin captured (by the collect_address_phase and data_phase methods).
  //---------------------------------------
  mips_seq_item trans_collected;

  `uvm_component_utils(mips_monitor)

  //---------------------------------------
  // new - constructor
  //---------------------------------------
  function new (string name, uvm_component parent);
    super.new(name, parent);
    trans_collected = new();
    item_collected_port = new("item_collected_port", this);
  endfunction : new

  //---------------------------------------
  // build_phase - getting the interface handle
  //---------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual mips_if)::get(this, "", "vif", vif))
       `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
  endfunction: build_phase

  //---------------------------------------
  // run_phase - convert the signal level activity to transaction level.
  // i.e, sample the values on interface signal ans assigns to transaction class fields
  //---------------------------------------
  virtual task run_phase(uvm_phase phase);
    forever begin
        @(posedge vif.MONITOR.clk);
        trans_collected.Instr 	    = `MON_IF.Instr;
        trans_collected.ALUResult   = `MON_IF.ALUResult;
        trans_collected.ALUOut 	    = `MON_IF.ALUOut;
        trans_collected.p_state 	= `MON_IF.p_state;
        trans_collected.PC 		    = `MON_IF.PC;
        trans_collected.Next_PC	    = `MON_IF.Next_PC;
        trans_collected.B			= `MON_IF.B;
        trans_collected.zero		= `MON_IF.zero;
        trans_collected.A3		    = `MON_IF.A3;
        trans_collected.WD3		    = `MON_IF.WD3;
        trans_collected.RegWrite	= `MON_IF.RegWrite;
        item_collected_port.write(trans_collected);
    end
  endtask : run_phase
endclass : mips_monitor