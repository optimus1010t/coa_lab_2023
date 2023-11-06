`timescale 1ns/1ps

module tb();
    reg clk;
    wire [31:0] out;
    initial begin
        clk = 0;
    end
    always #5 clk = ~clk;
    processor proce(
        .clk(clk),
        .finalout(out)
    );

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb);
        #100000
        $finish;
    end
endmodule