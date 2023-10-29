// Khimasia Krish 21CS10037
// Tanishq Prasad 21CS30054
// Group No. 17

`timescale 1ps/1ps

module gcd(a,b,clk,out);
    input [7:0] a,b;
    input clk;
    output [7:0] out;
    reg [7:0] out;
    wire [7:0] a,b;
    reg [7:0] c,d;
    reg [7:0] t;
    reg [1:0] state;
    parameter s1=1, s2=2, s3=3;

always @(a or b)
    begin
        state=4;
    end

always @(posedge clk)
begin
    case(state)
        s1: begin
                out=c;
            end
        s2: begin
                c = c-d;
                if(c<d) begin
                    state=3;
                end
                if(c>d) begin
                    state=2;
                end
                if(c==d)
                    state=1;
            end
            
        s3: begin
                d = d-c;
                if(c<d) begin
                    state=3;
                end
                if(c>d) begin
                    state=2;
                end
                if(c==d)
                    state=1;
            end
        default: begin
                c=a;
                d=b;
                if(c<d) begin
                    t=c;
                    c=d;
                    d=t;
                end
                state=2;
                if(c==d)
                       state=1;
                if(d==0)
                       state=1;
            end
        endcase
end
endmodule

module testbench();
    reg [7:0] a,b;
    wire [7:0] out;
    reg clk;
    
    initial
        begin
            clk=0;
            forever begin
                #5 clk = ~clk;
            end
        end
    gcd try(a,b,clk,out);
    
    reg out_prev;
    reg [7:0] a_prev,b_prev;

always @(posedge clk) begin
        a_prev <= a;
        b_prev <= b;
end

always @(a or b) begin
    $display($time, " a = %d, b = %d, gcd = %d", a_prev, b_prev, out);
    a_prev <= a;
    b_prev <= b;
end


    initial
        begin
            #5 a=4; b=6;
            #100 a=8; b=18;
            #200 a=10; b=10;
            #300 a=234; b=12;
            #400 a=20; b=100;
            #500 a=24; b=16;
            #650 a=17; b=90;
            #800 a=213; b=0;
            #900 a=1; b=32;
            #90000 a=0; b=0; //buffer
            #100000 $finish;
        end
endmodule
