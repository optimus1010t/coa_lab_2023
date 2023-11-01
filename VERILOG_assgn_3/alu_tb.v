`timescale 1ps / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.08.2023 14:34:37
// Design Name: 
// Module Name: alu_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module testbench();
    reg [7:0] a,b;
    reg [2:0] choice;
    wire [7:0] res;
    wire xtra;
    reg clk;
    
    initial
        begin
            clk=0;
            forever begin
                #5 clk = ~clk;
            end
        end
//    always
//        #5 clk = ~clk;
//    initial
//        clk=0;
    ALU try(a,b,choice,res,xtra,clk);
    
    initial
        begin
            #1 a=255;b=20;choice=0;
            #100 $display($time, " a=%d, b=%d, a+b=%d, carry=%d",a,b,res,xtra);
            #100 a=5;b=7;choice=1;
            #100 $display($time, " a=%d, b=%d, a-b=%d (in 2's complement form)",a,b,res);
            #100 a=3;choice=2;
            #100 $display($time, " a=%d, res=%d (assign operation)",a,res);
            #100 a=255;choice=3;
            #100 $display($time, " a=%d, a<<1=%d",a,res);
            #100 a=123;choice=4;
            #100 $display($time, " a=%d, a>>1=%d",a,res);
            #100 a=23;b=12;choice=5;
            #100 $display($time, " a=%d, b=%d, a&b=%d",a,b,res);
            #100 a=43;b=25;choice=6;
            #100 $display($time, " a=%d, ~a=%d",a,res);
            #100 a=42;b=22;choice=7;
            #100 $display($time, " a=%d, b=%d, a|b=%d",a,b,res);
            #10000 $finish;
        end
endmodule
          

