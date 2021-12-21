`define DRIV_IF vif.DRIVER.driver_cb

class mips_driver extends uvm_driver #(mips_seq_item);
  //--------------------------------------- 
  // Virtual Interface
  //---------------------------------------  
  virtual mips_if vif;
  `uvm_component_utils(mips_driver)

  //--------------------------------------- 
  // Constructor
  //--------------------------------------- 
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  //--------------------------------------- 
  // build phase
  //---------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
     if(!uvm_config_db#(virtual mips_if)::get(this, "", "vif", vif))
       `uvm_fatal("NO_VIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
  endfunction: build_phase

  //---------------------------------------  
  // run phase
  //---------------------------------------
  virtual task run_phase(uvm_phase phase);
    `DRIV_IF.Instr <= 32'h08000020;
    forever begin
      @(posedge vif.DRIVER.clk);
      if (vif.p_state == 4'b1011 | vif.p_state == 4'b0111 | 
          vif.p_state == 4'b0101 | vif.p_state == 4'b0100 |
          vif.p_state == 4'b1000 | vif.p_state == 4'b1010)
      begin
      	seq_item_port.get_next_item(req);
        `DRIV_IF.Instr <= req.Instr;
      	seq_item_port.item_done();
      end
    end
  endtask : run_phase
 
endclass : mips_driver
