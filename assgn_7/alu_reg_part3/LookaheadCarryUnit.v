module LookaheadCarryUnit(
    input c_in,
    input [3:0] P,
    input [3:0] G,
    output [4:1] carry,
    output P_out,
    output G_out
    );

	// calculate the lookahead carries using block propagate and generate from previous level
	assign carry[1] = G[0] | (P[0] & c_in);
	assign carry[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & c_in);
	assign carry[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & c_in);
	assign carry[4] = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]) | (P[3] & P[2] & P[1] & P[0] & c_in);
	
	// calculate the block propagate and generate for the next level
	assign P_out = P[3] & P[2] & P[1] & P[0];
	assign G_out = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]);

endmodule