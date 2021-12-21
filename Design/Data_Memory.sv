`include "parameters.vh"
module Data_Memory(
  input clk,reset,
  input wire MemWrite,
  input wire [31:0] addr, WD,
  output reg [31:0] RD );
  
  reg [31:0] ram[DMEMORY_WIDTH-1:0];
  
  initial begin
    $readmemh("data_memory.list",ram);
  end
  
  always @(*)
    begin
      if(reset)
        RD = 32'b0;
      else if((addr==WD) && MemWrite && addr >= 0 && addr < DMEMORY_WIDTH)
        RD = WD;
      else if(addr >= 0 && addr < DMEMORY_WIDTH)
        RD = ram[addr];
      else
        RD = 32'b0;
    end
  
  always @(posedge clk)
    begin
      if(MemWrite && addr >= 0 && addr < DMEMORY_WIDTH)
        ram[addr][31:0] <= WD;
    end
  
  always @(*)
    begin
      $writememh("data_memory.list",ram);
    end
  
endmodule