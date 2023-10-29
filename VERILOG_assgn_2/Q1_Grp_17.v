// Khimasia Krish 21CS10037
// Tanishq Prasad 21CS30054
// Group No. 17

`timescale 1ps/1ps

module myReg(clk, source, destination, move, in, data_in, data_out);
    input wire clk;
    input wire [2:0] source;
    input wire [2:0] destination;
    input wire move, in;
    input wire [15:0] data_in;
    output [15:0] data_out;
    reg [15:0] data_out;
    reg [15:0] registers [7:0];
    always @(posedge clk) begin
        if(in) begin                                // if in is 1, then write to register
            registers[destination] = data_in;
            data_out = 16'bzzzz_zzzz_zzzz_zzzz;
        end
        else begin                                  // if in is 0, then read from register
            data_out = registers[source];
            if(move) begin                          // if move is 1, then move data from source to destination
                registers[destination] = registers[source];
            end
        end
    end
endmodule


module top(clk, source, destination, move, in, data_in, data_out);
    input wire clk;
    input wire [2:0] source;
    input wire [2:0] destination;
    input wire move, in;
    input wire [15:0] data_in;
    output wire [15:0] data_out;
    myReg r(clk, source, destination, move, in, data_in, data_out);
endmodule

module testbench();
    reg [2:0] source;
    reg [2:0] destination;
    reg in,move;
    reg [15:0] data_in;
    wire [15:0] data_out;
    reg clk = 0;
    top test(clk, source, destination, move, in, data_in, data_out);
    
    initial begin clk=0;
        forever #5 clk=~clk;
    end 
    initial begin
        in=1;
        destination=1;
        data_in=21;
        #100;
        $display("destination=%d, data_out=%d",destination,data_out);       // destination=1, data_out=16'bzzzz_zzzz_zzzz_zzzz
        in=1;
        destination=2;
        data_in=253;
        #100;
        $display("destination=%d, data_out=%d",destination,data_out);       // destination=2, data_out=16'bzzzz_zzzz_zzzz_zzzz
        in=0;
        move=1;
        source=1;
        destination=3;
        #100;
        $display("source=%d, destination=%d, data_out=%d",source,destination,data_out);     // move data from register[1] to register[3]
        in=0;
        move=1;
        source=2;
        destination=4;
        #100;
        $display("source=%d, destination=%d, data_out=%d",source,destination,data_out);     // move data from register[2] to register[4]
        in=0;
        move=1;
        source=3;
        destination=5;
        #100;
        $display("source=%d, destination=%d, data_out=%d",source,destination,data_out);     // move data from register[3] to register[5]
        in=0;
        move=0;
        source=1;
        #100;
        $display("source=%d, register[%d]=%d",source,source,data_out);
        in=0;
        move=0;
        source=2;
        #100;
        $display("source=%d, register[%d]=%d",source,source,data_out);
        in=0;
        move=0;
        source=3;
        #100;
        $display("source=%d, register[%d]=%d",source,source,data_out);
        in=0;
        move=0;
        source=4;
        #100;
        $display("source=%d, register[%d]=%d",source,source,data_out);
        in=0;
        move=0;
        source=5;
        #100;
        $display("source=%d, register[%d]=%d",source,source,data_out);
        #100 $finish;
    end

endmodule