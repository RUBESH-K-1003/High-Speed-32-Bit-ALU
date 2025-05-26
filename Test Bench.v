
module tb( );
   reg [31:0] a, b;
   reg [3:0] cin;
   reg [15:0] opcode;
   reg clk, reset;
   wire [63:0] out;
   wire [3:0] carry;
      
    
  SIMD_ALU uut(a ,b, cin, opcode,clk,reset,out,carry);  
    always #5 clk=~clk;
    
    initial begin
    clk=1; reset=1;
    #10 reset =0;  a=32'hff569bac; b=32'haa478df1; cin=0; #5; opcode = 16'h0123;
    #10 opcode = 16'h4567;
    #10 opcode = 16'h8961;
    #10 opcode = 16'haaaa;
    #10 opcode = 16'h0000; $finish;
    
   
    end
    
endmodule
