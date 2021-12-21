module Register(
  input clk,reset,enable,
  input [31:0] A_p,
  output reg [31:0] A);
  
  always @(posedge clk)
    begin
      if(reset) begin
        A <= 32'h0;
      end
      else begin
        if(enable)
          A <= A_p;
        else
          A <= A;
      end
    end
  
  initial
    begin
      A = 32'h0;
    end
  
endmodule