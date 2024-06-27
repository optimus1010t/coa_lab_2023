module tb;

    //inputs
    reg signed [31:0] in1;
    reg signed [31:0] in2;
    reg shamt;
    reg [3:0] func;

    //outputs
    wire signed [31:0] out;
    wire [2:0] flags;

    alu potato(in1,in2,shamt,func,out,flags);

    initial begin
        in1 = -123; in2 = 456; func = 0;
        #100;
        $display("in1=%d, in2=%d, shamt=%d, func=%d, out=%d, flags=%b", in1, in2, shamt, func, out, flags);
        in1 = 0; in2 = 456; func = 1;
        #100;
        $display("in1=%d, in2=%d, shamt=%d, func=%d, out=%d, flags=%b", in1, in2, shamt, func, out, flags);
        in1 = 123; in2 = 456; func = 2;
        #100;
        $display("in1=%d, in2=%d, shamt=%d, func=%d, out=%d, flags=%b", in1, in2, shamt, func, out, flags);
        in1 = 123; in2 = 456; func = 3;
        #100;
        $display("in1=%d, in2=%d, shamt=%d, func=%d, out=%d, flags=%b", in1, in2, shamt, func, out, flags);
        in1 = 123; in2 = 456; func = 4;
        #100;
        $display("in1=%d, in2=%d, shamt=%d, func=%d, out=%d, flags=%b", in1, in2, shamt, func, out, flags);
        in1 = 123; func = 5;
        #100;
        $display("in1=%d, in2=%d, shamt=%d, func=%d, out=%d, flags=%b", in1, in2, shamt, func, out, flags);
        in1 = 123; shamt = 0; func = 6;
        #100;
        $display("in1=%d, in2=%d, shamt=%d, func=%d, out=%d, flags=%b", in1, in2, shamt, func, out, flags);
        in1 = 123; shamt = 1; func = 6;
        #100;
        $display("in1=%d, in2=%d, shamt=%d, func=%d, out=%d, flags=%b", in1, in2, shamt, func, out, flags);
        in1 = 123; func = 7;
        #100;
        $display("in1=%d, in2=%d, shamt=%d, func=%d, out=%d, flags=%b", in1, in2, shamt, func, out, flags);
        in1 = 123; func = 8;
        #100;
        $display("in1=%d, in2=%d, shamt=%d, func=%d, out=%d, flags=%b", in1, in2, shamt, func, out, flags);
        in1 = 123; func = 9;
        #100;
        $display("in1=%d, in2=%d, shamt=%d, func=%d, out=%d, flags=%b", in1, in2, shamt, func, out, flags);
    end

endmodule