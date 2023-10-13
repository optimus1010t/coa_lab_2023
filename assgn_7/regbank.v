module regbank (
    input wire clk, write, reset;
    input [4:0] sr1, sr2, dr; // source and destination register
    input [31:0] write_data;
    output reg [31:0] read_data1, read_data2;
)
    reg [31:0] registers [31:0];
    assign read_data1 = registers[sr1];    // read ports are always updated based on the addresse of the source registers
    assign read_data2 = registers[sr2];

    always @(posedge clk)         // write always happens on posedge of the clock
    begin
        if (reset) begin 
            registers[0] <= 32'h00000000;  registers[1] <= 32'h00000000;   registers[2] <= 32'h00000000;  registers[3] <= 32'h00000000;
            registers[4] <= 32'h00000000;  registers[5] <= 32'h00000000;   registers[6] <= 32'h00000000;  registers[7] <= 32'h00000000;
            registers[8] <= 32'h00000000;  registers[9] <= 32'h00000000;   registers[10] <= 32'h00000000; registers[11] <= 32'h00000000;
            registers[12] <= 32'h00000000; registers[13] <= 32'h00000000;  registers[14] <= 32'h00000000; registers[15] <= 32'h00000000;
            registers[16] <= 32'h00000000; registers[17] <= 32'h00000000;  registers[18] <= 32'h00000000; registers[19] <= 32'h00000000;
            registers[20] <= 32'h00000000; registers[21] <= 32'h00000000;  registers[22] <= 32'h00000000; registers[23] <= 32'h00000000;
            registers[24] <= 32'h00000000; registers[25] <= 32'h00000000;  registers[26] <= 32'h00000000; registers[27] <= 32'h00000000;
            registers[28] <= 32'h00000000; registers[29] <= 32'h00000000;  registers[30] <= 32'h00000000; registers[31] <= 32'h00000000;
        end
        else begin
            if (write)
                registers[dr] <= write_data;
        end
    end
endmodule
