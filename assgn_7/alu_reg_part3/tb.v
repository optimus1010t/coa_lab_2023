`timescale 1ns/1ps

module tb;

    //inputs for alu
    reg signed [31:0] in1;
    reg signed [31:0] in2;
    reg shamt;
    reg [3:0] func;

    //inputs for regbank
    reg clk;
    initial begin
    clk = 0;
    end
    always begin 
    # 5 clk = ~clk;
    end
    reg writeSP, readSP, writeReg, reset;
    reg [4:0] sr1, sr2, dr;
    reg [31:0] write_data, write_dataSP;

    //outputs
    wire signed [31:0] out;
    wire [2:0] flags;
    wire [31:0] read_data1, read_data2;

    regbank reg32(clk, writeSP, readSP, writeReg, reset, sr1, sr2, dr, write_data, write_dataSP, read_data1, read_data2);
    alu potato(in1,in2,shamt,func,out,flags);

    initial begin
        writeReg=0; writeSP=0; readSP=0; reset=0;
        sr1=1; sr2=2; dr=3;
        #100
        in1=read_data1; in2=read_data2; shamt=read_data2[0]; func=0;
        #100
        write_data=out; writeReg=1;
        #100
        writeReg=0;
        sr1=4; sr2=5; dr=6;
        #100
        in1=read_data1; in2=read_data2; shamt=read_data2[0]; func=1;
        #100
        write_data=out; writeReg=1;
        #100
        writeReg=0;
        sr1=7; sr2=8; dr=9;
        #100
        in1=read_data1; in2=read_data2; shamt=read_data2[0]; func=2;
        #100
        write_data=out; writeReg=1;
        #100
        writeReg=0;
        sr1=10; sr2=11; dr=12;
        #100
        in1=read_data1; in2=read_data2; shamt=read_data2[0]; func=3;
        #100
        write_data=out; writeReg=1;
        #100
        writeReg=0;
        sr1=13; sr2=14; dr=15;
        #100
        in1=read_data1; in2=read_data2; shamt=read_data2[0]; func=4;
        #100
        write_data=out; writeReg=1;
        #100
        writeReg=0;
    end

endmodule