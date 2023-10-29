`timescale 1ns/1ns

module testbench; 
    reg [2:0] regAdd;
    reg [3:0] memAdd;
    reg[3:0] data;
    reg [1:0] op;
    reg clk;
    wire [3:0] out;

    top try(regAdd,memAdd,data,op,clk,out);

    always #5 clk = ~clk;

    initial begin 

        clk = 0; 
        $monitor("output is %d", out);
        #0 op=0; memAdd=5; data=9;
        #200 op=1; regAdd=3; memAdd=13;
        #200 op=2; memAdd=13; regAdd=6;
        #200 op=3; memAdd=5; regAdd=6;
        #200 op=3; memAdd=5;
        

    $finish;

    end
endmodule 