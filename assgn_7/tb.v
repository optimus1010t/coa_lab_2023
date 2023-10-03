module tb;

    //inputs
    reg [31:0] in1;
    reg [31:0] in2;
    reg shamt;
    reg [3:0] func;

    //outputs
    wire [31:0] out;
    wire [2:0] flags;

    alu potato(in1,in2,shamt,func,out,flags);

    initial begin
        $monitor("in1=%d, in2=%d, shamt=%d, func=%d, out=%d, flags=%d", in1, in2, shamt, func, out, flags);
        in1 = 123; in2 = -456; func = 0;
        #100;
        in1 = 123; in2 = 456; func = 1;
        #100;
        in1 = 123; in2 = 456; func = 2;
        #100;
        in1 = 123; in2 = 456; func = 3;
        #100;
        in1 = 123; in2 = 456; func = 4;
        #100;
        in1 = 123; func = 5;
        #100;
        in1 = 123; func = 6;
        #100;
        in1 = 123; func = 7;
        #100;
        in1 = 123; func = 8;
        #100;
        in1 = 123; func = 9;
        #100;
    end
