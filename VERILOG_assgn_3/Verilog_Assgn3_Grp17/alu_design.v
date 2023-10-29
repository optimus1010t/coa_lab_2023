module CLA_4bit(
    input [3:0] in1,
    input [3:0] in2,
    input c_in,
    output [3:0] sum,
    output c_out
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
	assign c_out = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]) | (P[3] & P[2] & P[1] & P[0] & carry[0]);
	
	// calculate final sum using propagate and carries
	assign sum = P ^ carry;

endmodule


module CLA_8bit_adder(
    input [7:0] in1,
    input [7:0] in2,
    input c_in,
    output [7:0] sum,
    output c_out
    );
	
	wire carry; // wires for rippling internal carries
	
	// 8 bit adder by cascading 2 4bit CLAs and ripple the carry
	CLA_4bit cla1(.in1(in1[3:0]), .in2(in2[3:0]), .c_in(c_in), .sum(sum[3:0]), .c_out(carry));
	CLA_4bit cla2(.in1(in1[7:4]), .in2(in2[7:4]), .c_in(carry), .sum(sum[7:4]), .c_out(c_out));

endmodule

module ADD(
    input [7:0] in1,
    input [7:0] in2,
    output [7:0] res,
    output xtra
    );
    wire c_in = 0;

    CLA_8bit_adder add_8bit(.in1(in1),.in2(in2),.c_in(c_in),.sum(res),.c_out(xtra));

endmodule

module SUB(
    input [7:0] in1,
    input [7:0] in2,
    output [7:0] res
    );
    wire c_in = 0;
    wire c_temp;
    wire [7:0] one = 1;
    wire [7:0] not_in2;
    wire [7:0] not_in2_add_in1;

    NOT not_in2_calc (.in1(in2), .res(not_in2));

    CLA_8bit_adder add_8bit1(.in1(in1),.in2(not_in2),.c_in(c_in),.sum(not_in2_add_in1),.c_out(c_temp));
    CLA_8bit_adder add_8bit2(.in1(not_in2_add_in1),.in2(one),.c_in(c_in),.sum(res),.c_out(c_temp));

endmodule

module ASSIGN(
    input [7:0] in1,
    output [7:0] res
);

    assign res = in1;

endmodule

module LEFT_SHIFT(
    input [7:0] in1,
    output [7:0] res
    );

    assign res[0] = 0;
    assign res[1] = in1[0];
    assign res[2] = in1[1];
    assign res[3] = in1[2];
    assign res[4] = in1[3];
    assign res[5] = in1[4];
    assign res[6] = in1[5];
    assign res[7] = in1[6];

endmodule

module RIGHT_SHIFT(
    input [7:0] in1,
    output [7:0] res
    );

    assign res[0] = in1[1];
    assign res[1] = in1[2];
    assign res[2] = in1[3];
    assign res[3] = in1[4];
    assign res[4] = in1[5];
    assign res[5] = in1[6];
    assign res[6] = in1[7];
    assign res[7] = 0;

endmodule

module AND(
    input [7:0] in1,
    input [7:0] in2,
    output [7:0] res
    );

    assign res[0] = in1[0] & in2[0];
    assign res[1] = in1[1] & in2[1];
    assign res[2] = in1[2] & in2[2];
    assign res[3] = in1[3] & in2[3];
    assign res[4] = in1[4] & in2[4];
    assign res[5] = in1[5] & in2[5];
    assign res[6] = in1[6] & in2[6];
    assign res[7] = in1[7] & in2[7];

endmodule

module NOT(
    input [7:0] in1,
    output [7:0] res
    );

    assign res[0] = ~ in1[0];
    assign res[1] = ~ in1[1];
    assign res[2] = ~ in1[2];
    assign res[3] = ~ in1[3];
    assign res[4] = ~ in1[4];
    assign res[5] = ~ in1[5];
    assign res[6] = ~ in1[6];
    assign res[7] = ~ in1[7];

endmodule

module OR(
    input [7:0] in1,
    input [7:0] in2,
    output [7:0] res
    );

    assign res[0] = in1[0] | in2[0];
    assign res[1] = in1[1] | in2[1];
    assign res[2] = in1[2] | in2[2];
    assign res[3] = in1[3] | in2[3];
    assign res[4] = in1[4] | in2[4];
    assign res[5] = in1[5] | in2[5];
    assign res[6] = in1[6] | in2[6];
    assign res[7] = in1[7] | in2[7];

endmodule

module ALU(
    input [7:0] in1,
    input [7:0] in2,
    input [2:0] choice,
    output reg [7:0] final,
    output reg xtra,
    input clk
    );

    wire [7:0] res [7:0];
    wire tempxtra;
    parameter s0 = 0, s1 = 1, s2 = 2, s3 = 3, s4 = 4, s5 = 5, s6 = 6, s7 = 7;
    ADD callADD (.in1(in1), .in2(in2), .res(res[0]), .xtra(tempxtra));
    SUB callSUB (.in1(in1), .in2(in2), .res(res[1]));
    ASSIGN callASSIGN (.in1(in1), .res(res[2]));
    LEFT_SHIFT callLEFT_SHIFT (.in1(in1), .res(res[3]));
    RIGHT_SHIFT callRIGHT_SHIFT (.in1(in1), .res(res[4]));
    AND callAND (.in1(in1), .in2(in2), .res(res[5]));
    NOT callNOT (.in1(in1), .res(res[6]));
    OR callOR (.in1(in1), .in2(in2), .res(res[7]));

    always @(posedge clk)
    begin
        case(choice)
            s0: begin
                    final=res[0];
                    xtra=tempxtra;
                end

            s1: begin
                    final=res[1];
                end

            s2: begin
                    final=res[2];
                end
 
            s3: begin
                    final=res[3];
                end

            s4: begin
                    final=res[4];
                end
 
            s5: begin
                    final=res[5];
                end
 
            s6: begin
                    final=res[6];
                end
 
            s7: begin
                    final=res[7];
                end
 
            default: begin
                    $display("invalid input");
                end
            endcase
    end
endmodule


