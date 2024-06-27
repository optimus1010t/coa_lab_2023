module CLA_4bit_augmented(
    input [3:0] in1,
    input [3:0] in2,
    input c_in,
    output [3:0] sum,
    output p,
    output g
    );
	 

	wire [3:0] G, P, carry; // wires for bitwise generate, propagate and carries
	
	// calculate bitwise generate and propagate
	assign G = in1 & in2;
	assign P = in1 ^ in2;
	
	// calculate subsequent carries using generates and propagates
	assign carry[0] = c_in;
	assign carry[1] = G[0] | (P[0] & carry[0]);
	assign carry[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & carry[0]);
	assign carry[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & carry[0]);
	
	// calculate final sum using propagate and carries
	assign sum = P ^ carry;
	
	// calculate block propagate and generate for next level
	assign p = P[3] & P[2] & P[1] & P[0];
	assign g = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]);


endmodule