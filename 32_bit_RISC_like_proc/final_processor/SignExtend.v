module sign_extend_16 (
    input [15:0] in,
    output [31:0] out
);
    assign out = {{16{in[15]}}, in};
endmodule

module sign_extend_26 (
    input [25:0] in,
    output [31:0] out
);
    assign out = {{6{in[25]}}, in};
endmodule