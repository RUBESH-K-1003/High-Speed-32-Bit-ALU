
module SIMD_ALU(
    input [31:0] a, b,
    input [3:0] cin,
    input [15:0] opcode,
    input clk, reset,
    output reg [63:0] out,
    output reg [3:0] carry
);

wire [7:0] sum_result0, sum_result1,sum_result2, sum_result3;
wire sum_carry0, sum_carry1,sum_carry2, sum_carry3;

wire [7:0] sub_result0, sub_result1, sub_result2, sub_result3;
wire sub_borrow0, sub_borrow1,sub_borrow2, sub_borrow3;

wire [15:0] mul_result0,mul_result1,mul_result2,mul_result3;

sparse A1 (.A(a[7:0]), .B(b[7:0]), .Cin(cin[0]), .Sum(sum_result0), .Cout(sum_carry0));
sparse A2 (.A(a[15:8]), .B(b[15:8]), .Cin(cin[1]), .Sum(sum_result1), .Cout(sum_carry1));
sparse A3 (.A(a[23:16]), .B(b[23:16]), .Cin(cin[2]), .Sum(sum_result2), .Cout(sum_carry2));
sparse A4 (.A(a[31:24]), .B(b[31:24]), .Cin(cin[3]), .Sum(sum_result3), .Cout(sum_carry3));

subtractor S1 (.A(a[7:0]), .B(b[7:0]), .Bin(cin[0]), .Diff(sub_result0), .Bout(sub_borrow0));
subtractor S2 (.A(a[15:8]), .B(b[15:8]), .Bin(cin[1]), .Diff(sub_result1), .Bout(sub_borrow1));
subtractor S3 (.A(a[23:16]), .B(b[23:16]), .Bin(cin[2]), .Diff(sub_result2), .Bout(sub_borrow2));
subtractor S4 (.A(a[31:24]), .B(b[31:24]), .Bin(cin[3]), .Diff(sub_result3), .Bout(sub_borrow3));

dadda_multiplier M1 (.a(a[7:0]), .b(b[7:0]), .p(mul_result0));
dadda_multiplier M2 (.a(a[15:8]), .b(b[15:8]), .p(mul_result1));
dadda_multiplier M3 (.a(a[23:16]), .b(b[23:16]), .p(mul_result2));
dadda_multiplier M4 (.a(a[31:24]), .b(b[31:24]), .p(mul_result3));


always @(posedge clk or posedge reset) begin
    if (reset) begin
        out <= 63'b0;
        carry <= 4'b0;
        
    end else begin
        case (opcode[3:0])  //16 bit for this from 15-0   4 hexa decimal
            4'b0000: begin out[7:0] <= sum_result0; carry[0] <= sum_carry0; end
            4'b0001: begin out[7:0] <= sub_result0;  carry[0] <= sub_borrow0; end
            4'b0010: begin out[15:0]  <=mul_result0; end
            4'b0011:  out[7:0]<= a[7:0]/b[7:0];
            4'b0100: out[7:0]<= a[7:0]&b[7:0];
            4'b0101: out[7:0]<= a[7:0]|b[7:0];
            4'b0110: out[7:0]<= a[7:0]^b[7:0];
            4'b0111: out[7:0]<= ~a[7:0];
            4'b1000: out[7:0]<= a[7:0]>>1;
            4'b1001: out[7:0]<= a[7:0]<<1;
            4'b1010: begin out[15:12] <= (a[7:6] * b[31:30]) + (a[5:4] * b[23:22]) + (a[3:2] * b[15:14]) + (a[1:0] * b[7:6]);
                           out[11:8]  <= (a[7:6] * b[29:28]) + (a[5:4] * b[21:20]) + (a[3:2] * b[13:12]) + (a[1:0] * b[5:4]);
                           out[7:4]   <= (a[7:6] * b[27:26]) + (a[5:4] * b[19:18]) + (a[3:2] * b[11:10]) + (a[1:0] * b[3:2]);
                           out[3:0]   <= (a[7:6] * b[25:24]) + (a[5:4] * b[17:16]) + (a[3:2] * b[9:8])  + (a[1:0] * b[1:0]);end           
            default: begin out[15:0] <= 16'b0; carry[0] <= 1'b0;  end
        endcase


         case (opcode[7:4])    //16 bit for this from 31-16   4 hexa decimal
            4'b0000: begin out[23:16] <= sum_result1; carry[1] <= sum_carry1; end
            4'b0001: begin out[23:16] <= sub_result1;  carry[1] <= sub_borrow1; end
            4'b0010: begin out[31:16]  <=mul_result1; end
            4'b0011:  out[23:16]<= a[15:8]/b[15:8];
            4'b0100: out[23:16]<= a[15:8]&b[15:8];
            4'b0101: out[23:16]<= a[15:8]|b[15:8];
            4'b0110: out[23:16]<= a[15:8]^b[15:8];
            4'b0111: out[23:16]<= ~a[15:8];
            4'b1000: out[23:16]<= a[15:8]>>1;
            4'b1001: out[23:16]<= a[15:8]<<1;
            4'b1010: begin  out[31:28] <= (a[15:14] * b[31:30]) + (a[13:12] * b[23:22]) + (a[11:10] * b[15:14]) + (a[9:8] * b[7:6]);
                            out[27:24] <= (a[15:14] * b[29:28]) + (a[13:12] * b[21:20]) + (a[11:10] * b[13:12]) + (a[9:8] * b[5:4]);
                            out[23:20] <= (a[15:14] * b[27:26]) + (a[13:12] * b[19:18]) + (a[11:10] * b[11:10]) + (a[9:8] * b[3:2]);
                            out[19:16] <= (a[15:14] * b[25:24]) + (a[13:12] * b[17:16]) + (a[11:10] * b[9:8])  + (a[9:8] * b[1:0]);end

            default: begin out[31:16] <= 16'b0; carry[1] <= 1'b0;  end
        endcase
        
        case (opcode[11:8])    //16 bit for this from 47-32   4 hexa decimal
                    4'b0000: begin out[39:32] <= sum_result2; carry[2] <= sum_carry2; end
                    4'b0001: begin out[39:32] <= sub_result2;  carry[2] <= sub_borrow2; end
                    4'b0010: begin out[47:32]  <=mul_result2; end
                    4'b0011:  out[39:32]<= a[23:16]/b[23:16];
                    4'b0100: out[39:32]<= a[23:16]&b[23:16];
                    4'b0101: out[39:32]<= a[23:16]|b[23:16];
                    4'b0110: out[39:32]<= a[23:16]^b[23:16];
                    4'b0111: out[39:32]<= ~a[23:16];
                    4'b1000: out[39:32]<= a[23:16]>>1;
                    4'b1001: out[39:32]<= a[23:16]<<1;
                    4'b1010: begin  out[47:44] = (a[23:22] * b[31:30]) + (a[21:20] * b[23:22]) + (a[19:18] * b[15:14]) + (a[17:16] * b[7:6]);
                                    out[43:40] = (a[23:22] * b[29:28]) + (a[21:20] * b[21:20]) + (a[19:18] * b[13:12]) + (a[17:16] * b[5:4]);
                                    out[39:36] = (a[23:22] * b[27:26]) + (a[21:20] * b[19:18]) + (a[19:18] * b[11:10]) + (a[17:16] * b[3:2]);
                                    out[35:32] = (a[23:22] * b[25:24]) + (a[21:20] * b[17:16]) + (a[19:18] * b[9:8])  + (a[17:16] * b[1:0]); end
                    default: begin out[47:32] <= 16'b0; carry[2] <= 1'b0;  end
                endcase
 
 case (opcode[15:12])    //16 bit for this from 63 -48  4 hexa decimal
                   4'b0000: begin out[55:48] <= sum_result3; carry[3] <= sum_carry3; end
                   4'b0001: begin out[55:48] <= sub_result3;  carry[3] <= sub_borrow3; end
                   4'b0010: begin out[63:48]  <=mul_result3; end
                   4'b0011: out[55:48]<= a[31:24]/b[31:24];
                   4'b0100: out[55:48]<= a[31:24]&b[31:24];
                   4'b0101: out[55:48]<= a[31:24]|b[31:24];
                   4'b0110: out[55:48]<= a[31:24]^b[31:24];
                   4'b0111: out[55:48]<= ~a[31:24];
                   4'b1000: out[55:48]<= a[31:24]>>1;
                   4'b1001: out[55:48]<= a[31:24]<<1;
                   4'b1010: begin out[63:60] <= (a[31:30] * b[31:30]) + (a[29:28] * b[23:22]) + (a[27:26] * b[15:14]) + (a[25:24] * b[7:6]);
                                  out[59:56] <= (a[31:30] * b[29:28]) + (a[29:28] * b[21:20]) + (a[27:26] * b[13:12]) + (a[25:24] * b[5:4]);
                                  out[55:52] <= (a[31:30] * b[27:26]) + (a[29:28] * b[19:18]) + (a[27:26] * b[11:10]) + (a[25:24] * b[3:2]);
                                  out[51:48] <= (a[31:30] * b[25:24]) + (a[29:28] * b[17:16]) + (a[27:26] * b[9:8])  + (a[25:24] * b[1:0]); end
                   default: begin out[63:48] <= 16'b0; carry[3] <= 1'b0;  end
endcase       
 

 end
end

endmodule
