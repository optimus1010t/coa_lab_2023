module pos_edge_det (input sig, // Input signal for which positive edge has to be detected
                     input clk, // Input signal for clock
                     output pe); // Output signal that gives a pulse when a positive edge occurs

   reg sig_dly; // Internal signal to store the delayed version of signal

   // This always block ensures that sig_dly is exactly 1 clock behind sig
   always @ (posedge clk) begin
      sig_dly <= sig;
   end

   // Combinational logic where sig is AND with delayed, inverted version of sig
   // Assign statement assigns the evaluated expression in the RHS to the internal net pe
   assign pe = sig & ~sig_dly;
endmodule

module top(
    input [15:0] in,
    input nxt,
    input clk,
    output reg [15:0] out
);

    reg [31:0] in1,in2;
    wire [31:0] alu_out;
    reg [3:0] func;
    wire[2:0] flags;
    reg shamt;
    reg [3:0] state;
    wire pe;
    pos_edge_det detector(nxt,clk,pe);
    alu potato(in1,in2,shamt,func,alu_out,flags);
    always @(posedge clk)
    begin
    if(pe==1)
    begin
        case(state)
        0:
        begin
            in1[15:0]=in;
            state=1;
            out=state;
        end
        1:
        begin
            in1[31:16]=in;
            state=2;
            out=state;
        end
        2:
        begin
            in2[15:0]=in;
            state=3;
            out=state;
        end
        3:
        begin
            in2[31:16]=in;
            state=4;
            out=state;
        end
        4:
        begin
            func=in[15:12];
            shamt=in[0];
            state=5;
            out=state;
        end
        5:
        begin
            out=alu_out[15:0];
            state=6;
//            out=state;
        end
        6:
        begin
            out=alu_out[31:16];
            state=7;
//            out=state;
        end
        default:
        begin
            state=0;
            out=0;
        end
        endcase
        end
    end

endmodule