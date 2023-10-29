// module SUB(
//     input [7:0] in1,
//     input [7:0] in2,
//     input c_in,
//     output reg [7:0] sum,
//     output reg c_out
//     );

//     wire [7:0] G, P, carry; // wires for bitwise generate, propagate and carries
// 	wire [7:0] in22s = ~in2 + 1; // 2's complement of in2
    

// 	// calculate bitwise generate and propagate
// 	assign G = in1 & in22s;
// 	assign P = in1 ^ in22s;
	
// 	// calculate subsequent carries using generates and propagates
// 	assign carry[0] = c_in;
// 	assign carry[1] = G[0] | (P[0] & carry[0]);
// 	assign carry[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & carry[0]);
// 	assign carry[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & carry[0]);
//     assign carry[4] = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]) | (P[3] & P[2] & P[1] & P[0] & carry[0]);
//     assign carry[5] = G[4] | (P[4] & G[3]) | (P[4] & P[3] & G[2]) | (P[4] & P[3] & P[2] & G[1]) | (P[4] & P[3] & P[2] & P[1] & G[0]) | (P[4] & P[3] & P[2] & P[1] & P[0] & carry[0]);
//     assign carry[6] = G[5] | (P[5] & G[4]) | (P[5] & P[4] & G[3]) | (P[5] & P[4] & P[3] & G[2]) | (P[5] & P[4] & P[3] & P[2] & G[1]) | (P[5] & P[4] & P[3] & P[2] & P[1] & G[0]) | (P[5] & P[4] & P[3] & P[2] & P[1] & P[0] & carry[0]);
//     assign carry[7] = G[6] | (P[6] & G[5]) | (P[6] & P[5] & G[4]) | (P[6] & P[5] & P[4] & G[3]) | (P[6] & P[5] & P[4] & P[3] & G[2]) | (P[6] & P[5] & P[4] & P[3] & P[2] & G[1]) | (P[6] & P[5] & P[4] & P[3] & P[2] & P[1] & G[0]) | (P[6] & P[5] & P[4] & P[3] & P[2] & P[1] & P[0] & carry[0]);
//     always @(in1 or in2 or c_in)
//     begin
//         sum = P^carry;
//         c_out = G[7] | (P[7] & G[6]) | (P[7] & P[6] & G[5]) | (P[7] & P[6] & P[5] & G[4]) | (P[7] & P[6] & P[5] & P[4] & G[3]) | (P[7] & P[6] & P[5] & P[4] & P[3] & G[2]) | (P[7] & P[6] & P[5] & P[4] & P[3] & P[2] & G[1]) | (P[7] & P[6] & P[5] & P[4] & P[3] & P[2] & P[1] & G[0]) | (P[7] & P[6] & P[5] & P[4] & P[3] & P[2] & P[1] & P[0] & carry[0]);
//     end
// 	// assign c_out = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]) | (P[3] & P[2] & P[1] & P[0] & carry[0]);
	
// 	// calculate final sum using propagate and carries
// 	// assign sum = P ^ carry;
// endmodule


// // module CLA_8bit_adder(
// //     input [7:0] in1,
// //     input [7:0] in2,
// //     input c_in,
// //     output [7:0] sum,
// //     output c_out
// //     );
	
// // 	wire carry; // wires for rippling internal carries
	
// // 	// 8 bit adder by cascading 2 4bit CLAs and ripple the carry
// // 	CLA_4bit cla1(.in1(in1[3:0]), .in2(in2[3:0]), .c_in(c_in), .sum(sum[3:0]), .c_out(carry));
// // 	CLA_4bit cla2(.in1(in1[7:4]), .in2(in2[7:4]), .c_in(carry), .sum(sum[7:4]), .c_out(c_out));
// // endmodule

// // module SUB(
// //     input [7:0] in1,
// //     input [7:0] in2,
// //     input b_in,
// //     output [7:0] res,
// //     output b_out
// //     );

// //     wire [7:0] not_in2=~in2;
// //     wire [7:0] not_in2_add_in1;
// //     wire [7:0] one=1;

// //     CLA_8bit_adder add_8bit1(.in1(in1),.in2(not_in2),.c_in(b_in),.sum(not_in2_add_in1),.c_out(b_temp));
// //     CLA_8bit_adder add_8bit2(.in1(not_in2_add_in1),.in2(one),.c_in(b_temp),.sum(res),.c_out(b_out));
// // endmodule

module SUB(A, B, Bin, out, Bout);
    input [7:0] A, B;
    input Bin;
    output reg Bout;
    reg [8:0] diff;
    output reg signed [7:0] out;

    always @(A, B, Bin) begin
        diff = A - B - Bin;
        out = diff[7:0];
        Bout = diff[8];
    end
endmodule