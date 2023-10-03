//REMOVE THE ??? COMMENTS

// module ADD(
//     input wire [31:0] a,
//     input wire [31:0] b,
//     output [31:0] sum,
//     output carry   
// )
//     assign {carry, sum} = a + b;
// endmodule

// module SUB(
//     input wire [31:0] a,
//     input wire [31:0] b,
//     output [31:0] diff,
//     output borrow   
// )
//     assign {borrow, diff} = a + ~b + 1;
// endmodule

// module COMPLEMENT(
//     input wire [31:0] a,
//     output wire [31:0] nota
// )
//     assign nota = ~a;
// endmodule

// module AND(
//     input wire [31:0] a,
//     input wire [31:0] b,
//     output wire [31:0] and
// )
//     assign and = a & b;
// endmodule

// module OR(
//     input wire [31:0] a,
//     input wire [31:0] b,
//     output wire [31:0] or
// )
//     assign or = a | b;
// endmodule

// module XOR(
//     input wire [31:0] a,
//     input wire [31:0] b,
//     output wire [31:0] xor
// )
//     assign xor = a ^ b;
// endmodule

// module NOT(
//     input wire [31:0] a,
//     output wire [31:0] nota
// )
//     assign nota = ~a;
// endmodule

// module SRL(
//     input wire [31:0] a,
//     output wire [31:0] shiftl
// )
//     assign shiftl = a << 1;
// endmodule

// module SRA(
//     input wire [31:0] a,
//     output wire [31:0] shiftr
// )
//     assign shiftr = a >> 1;
// endmodule

// module SLA(
//     input wire [31:0] a,
//     output wire [31:0] shiftl
// )
//     assign shiftl = a << 1;
// endmodule


module alu(
    input signed [31:0] input1,
    input signed [31:0] input2,     // ??? nisarg had only input1 signed, idk why
    input shamt,  // nisarg had given 5 bits for this, idk why
    input [3:0] func,    // alu function chosen
    output reg [31:0] out,
    output reg [2:0] flags  // carry, sign, zero
    );
    wire [31:0] SUM,DIFF,AND,OR,XOR,NOT,SLA,SRA,SRL;
    wire [31:0] not_input2 = ~input2;

    wire diff_borrow,sum_carry,temp_carry,p1,g1,p2,g2;

    // sum
    CLA_16bit_withLCU cla1(.in1(input1[15:0]), .in2(input2[15:0]), .c_in(1'b0), .sum(SUM[15:0]), .c_out(temp_carry), .p(p1), .g(g1));
    CLA_16bit_withLCU cla2(.in1(input1[31:16]), .in2(input2[31:16]), .c_in(temp_carry), .sum(SUM[31:16]), .c_out(sum_carry), .p(p2), .g(g2));
    
    //diff
    CLA_16bit_withLCU cla3(.in1(input1[15:0]), .in2(not_input2[15:0]), .c_in(1'b1), .sum(DIFF[15:0]), .c_out(temp_carry), .p(p1), .g(g1));
    CLA_16bit_withLCU cla4(.in1(input1[31:16]), .in2(not_input2[31:16]), .c_in(temp_carry), .sum(DIFF[31:16]), .c_out(diff_borrow), .p(p2), .g(g2));

    assign AND = input1 & input2;
    assign OR = input1 | input2;
    assign XOR = input1 ^ input2;
    assign NOT = ~input1;
    assign SLA = input1 << shamt;
    assign SRA = input1 >> shamt;
    assign SRL = input1 >>> shamt;

    always @(*)
    begin
        flags[0] = input1 == 32'b0 ? 1'b1 : 1'b0;
		flags[1] = input1[31] == 1'b1 ? 1'b1 : 1'b0;
        case(func)
            4'b0000:
            begin
                out = SUM;
                flags[2] = sum_carry;
            end
            4'b0001:
            begin
                out = DIFF;
                flags[2] = diff_borrow;
            end
            4'b0010:
            begin
                out = AND;
                flags[2] = 1'b0;
            end
            4'b0011:
            begin
                out = OR;
                flags[2] = 1'b0;
            end
            4'b0100:
            begin
                out = XOR;
                flags[2] = 1'b0;
            end
            4'b0101:
            begin
                out = NOT;
                flags[2] = 1'b0;
            end
            4'b0110:
            begin
                out = SLA;
                flags[2] = 1'b0;
            end
            4'b0111:
            begin
                out = SRA;
                flags[2] = 1'b0;
            end
            4'b1000:
            begin
                out = SRL;
                flags[2] = 1'b0;
            end
            default: out = 32'b0;
        endcase
    end
endmodule