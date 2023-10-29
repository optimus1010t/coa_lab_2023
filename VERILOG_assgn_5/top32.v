module Divby255(
    input [31:0] x,
    input rst1, rst2, clk,
    output reg [31:0] y
    );

    reg [31:0] X;
    reg [7:0] x0, x1, x2, x3;
    reg [7:0] y0, y1, y2, y3;
    wire [3:0] b;
    wire [7:0] d0,d1,d2,d3;
    wire [7:0] zero=0;
    SUB sub0(zero,x0,1'b0,d0,b[0]);
    SUB sub1(y0,x1,b[0],d1,b[1]);
    SUB sub2(y1,x2,b[1],d2,b[2]);
    SUB sub3(y2,x3,b[2],d3,b[3]);

    parameter s0=0; // start state
    parameter s1=1; // state for reading x
    parameter s2=2; // state for starting computation of y
    parameter s3=3; // state for computing y0
    parameter s4=4; // state for computing y1
    parameter s5=5; // state for computing y2
    parameter s6=6; // state for computing y3
    parameter s7=7; // state for writing y

    reg [2:0] curr_state=0, next_state;

    always @(posedge clk)
    begin
        curr_state<=next_state;

        case(curr_state)
        s0: begin
            y<=0;
            // $monitor("starting\n");
            if(rst1)
                next_state<=s1;
        end
        s1: begin
            X<=x;
            // $monitor("reading %d, value loaded is %d\n",x,X);
            next_state<=s2;
        end
        s2: begin
            x3<=X[31:24];
            x2<=X[23:16];
            x1<=X[15:8];
            x0<=X[7:0];
            y3<=0;
            y2<=0;
            y1<=0;
            y0<=0;
            next_state<=s3;
        end
        s3: begin
            y0<=d0;
            // $monitor("y0 = %d\n",y0);
            next_state<=s4;
        end
        s4: begin
            y1<=d1;
            // $monitor("y1 = %d\n",y1);
            next_state<=s5;
        end
        s5: begin
            y2<=d2;
            // $monitor("y2 = %d\n",y2);
            next_state<=s6;
        end
        s6: begin
            y3<=d3;
            // $monitor("y3 = %d\n",y3);
            next_state<=s7;
        end
        s7: begin
            y[31:24]<=y3;
            y[23:16]<=y2;
            y[15:8]<=y1;
            y[7:0]<=y0;
            if(rst2)
                next_state<=0;
            // $monitor("y = %d\n",y);
        end
        endcase
    end

endmodule