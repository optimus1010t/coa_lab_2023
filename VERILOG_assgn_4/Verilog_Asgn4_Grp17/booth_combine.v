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

    
    assign not_in2= ~in2;

    CLA_8bit_adder add_8bit1(.in1(in1),.in2(not_in2),.c_in(c_in),.sum(not_in2_add_in1),.c_out(c_temp));
    CLA_8bit_adder add_8bit2(.in1(not_in2_add_in1),.in2(one),.c_in(c_in),.sum(res),.c_out(c_temp));

endmodule

module SHIFT(
    input [7:0] a,
    input [7:0] q,
    input q_temp,
    output [7:0] newa,
    output [7:0] newq,
    output new_q_temp);

    wire sign;
    assign sign=a[7];
    assign new_q_temp=q[0];
    assign newq=q>>1;
    assign newq[7]=a[0];
    assign newa=a>>1;
    assign a[7]=sign;
    
endmodule



module booth(M,Q,clk,out);
    input [7:0] M,Q;
    input clk;
    output [15:0] out;
    reg [15:0] out;
    wire [7:0] M,Q;
    reg [7:0] a,m,minusm,q;
    reg [3:0] bits;
    reg [2:0] state;
    reg [3:0] count;
    reg sign;
    reg q_temp;
    wire [7:0] afteradd,aftersub,aaftershift,qaftershift,q_tempaftershift;
    wire ignore;
    parameter s1=1, s2=2, s3=3, s4=4;
    ADD a1(a,m,afteradd,ignore);
    SUB sub1(a,m,aftersub);
    // SHIFT shift1(a,q,q_temp,aaftershift,qaftershift.q_tempaftershift);

always @(M or Q)
    begin
        state=7;
    end

always @(posedge clk)
begin
    case(state)
        s1: begin
                q_temp=q[0];
                q=q>>1;
                q[bits]=a[0];
                sign=a[bits];
                a=a>>1;
                a[bits]=sign;
                // q=qaftershift;
                // a=aaftershift;
                // q_temp=q_tempaftershift;
                count=count-1;
                // $display("state=%d, a=%d, q=%d, m=%d, -m=%d, q_temp=%d, count=%d",state,a,q,m,minusm,q_temp,count);
                if(q[0]==q_temp)
                    state=s1;
                else if(q[0]==1)
                    state=s2;
                else
                    state=s3;
                if(count==0)
                    state=s4;
            end
        s2: begin
                a=aftersub;
                q_temp=q[0];
                q=q>>1;
                q[bits]=a[0];
                sign=a[bits];
                a=a>>1;
                a[bits]=sign;
                // q=qaftershift;
                // a=aaftershift;
                // q_temp=q_tempaftershift;
                count=count-1;
                // $display("state=%d, a=%d, q=%d, m=%d, -m=%d, q_temp=%d, count=%d",state,a,q,m,minusm,q_temp,count);
                if(q[0]==q_temp)
                    state=s1;
                else if(q[0]==1)
                    state=s2;
                else
                    state=s3;
                if(count==0)
                    state=s4;
            end
            
        s3: begin
                a=afteradd;
                q_temp=q[0];
                q=q>>1;
                q[bits]=a[0];
                sign=a[bits];
                a=a>>1;
                a[bits]=sign;
                // q=qaftershift;
                // a=aaftershift;
                // q_temp=q_tempaftershift;
                count=count-1;
                // $display("state=%d, a=%d, q=%d, m=%d, -m=%d, q_temp=%d, count=%d",state,a,q,m,minusm,q_temp,count);
                if(q[0]==q_temp)
                    state=s1;
                else if(q[0]==1)
                    state=s2;
                else
                    state=s3;
                if(count==0)
                    state=s4;
            end
        s4: begin
            out=a<<(bits+1);
            out=out+q;
            end
        default: begin
                a=0;
                q=Q;
                m=M;
                q_temp=0;
                count=8;
                bits=7;
                // $display("a=%d, q=%d, m=%d, -m=%d, q_temp=%d, count=%d",a,q,m,minusm,q_temp,count);
                if(q[0]==q_temp)
                    state=s1;
                else if(q[0]==1)
                    state=s2;
                else
                    state=s3;
                if(count==0)
                    state=s4;
                                
            end
        endcase
end
endmodule

module testbench();
    reg [7:0] a,b;
    wire [15:0] out;
    reg clk;
    
    initial
        begin
            clk=0;
            forever begin
                #5 clk = ~clk;
            end
        end
    booth try(a,b,clk,out);
    
    reg out_prev;
    reg [7:0] a_prev,b_prev;

always @(posedge clk) begin
        a_prev <= a;
        b_prev <= b;
end

always @(a or b) begin
    $display($time, " a = %d, b = %d, mult_val = %d", a_prev, b_prev, out);
    a_prev <= a;
    b_prev <= b;
end


    initial
        begin
                #5 a=6; b=1;
            #1000 a=8; b=18;
             #1000 a=10; b=10;
             #1000 a=234; b=12;
             #1000 a=20; b=100;
             #1000 a=24; b=16;
             #1000 a=17; b=90;
             #1000 a=213; b=0;
             #1000 a=1; b=32;
            #1000 a=0; b=0; //buffer
            #1000 $finish;
        end
endmodule