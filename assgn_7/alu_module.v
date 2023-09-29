module ADD(
    input wire [31:0] a,
    input wire [31:0] b,
    output [31:0] sum,
    output carry   
)
    assign {carry, sum} = a + b;
endmodule

module SUB(
    input wire [31:0] a,
    input wire [31:0] b,
    output [31:0] diff,
    output borrow   
)
    assign {borrow, diff} = a + ~b + 1;
endmodule

module COMPLEMENT(
    input wire [31:0] a,
    output wire [31:0] nota
)
    assign nota = ~a;
endmodule

module AND(
    input wire [31:0] a,
    input wire [31:0] b,
    output wire [31:0] and
)
    assign and = a & b;
endmodule

module OR(
    input wire [31:0] a,
    input wire [31:0] b,
    output wire [31:0] or
)
    assign or = a | b;
endmodule

module XOR(
    input wire [31:0] a,
    input wire [31:0] b,
    output wire [31:0] xor
)
    assign xor = a ^ b;
endmodule

module NOT(
    input wire [31:0] a,
    output wire [31:0] nota
)
    assign nota = ~a;
endmodule

module SRL(
    input wire [31:0] a,
    output wire [31:0] shiftl
)
    assign shiftl = a << 1;
endmodule

module SRA(
    input wire [31:0] a,
    output wire [31:0] shiftr
)
    assign shiftr = a >> 1;
endmodule

module SLA(
    input wire [31:0] a,
    output wire [31:0] shiftl
)
    assign shiftl = a << 1;
endmodule

