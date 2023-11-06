`timescale 1ps/1ps

module tb();
    reg clk;
    reg [31:0] out;
    initial begin
        clk = 0;
    end
    always #5 clk = ~clk;
    processor proce(
        .clk(clk),
        .finalout(out)
    );
endmodule