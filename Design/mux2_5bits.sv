module mux2_5bits (
  input logic [4:0] d0, d1,
  input logic s,
  output logic [4:0] y);
  assign y = s ? d1 : d0;
endmodule