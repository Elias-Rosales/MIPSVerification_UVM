module Register_Memory(
  input wire clk,we,reset,
  input wire [4:0] addr1,addr2,addr3,
  input wire [31:0] WD3,
  output reg [31:0] RD1, RD2
  );
  
  reg [31:0] ram[31:0];
  
  initial begin
    $readmemh("reg_memory.list", ram);
  end
  
  always @(*)
    begin
      if(addr1==5'b0 || reset)
        RD1 = 32'b0;
      else if((addr1==addr3) && we)
        RD1 = WD3;
      else
        RD1 = ram[addr1];
    end
  
  always @(*)
    begin
      if(addr2==5'b0 || reset)
        RD2 = 32'b0;
      else if((addr2==addr3) && we)
        RD2 = WD3;
      else
        RD2 = ram[addr2];
    end
  
  always @(posedge clk)
    begin
      if(we && addr3 != 5'b0 && !reset)
        begin
          ram[addr3] <= WD3;
        end
    end
  
  always @(*)
    begin
      $writememh("reg_memory.list",ram);
    end
  
endmodule