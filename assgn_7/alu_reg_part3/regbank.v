module regbank (
    input wire clk;
    input wire writeSP, readSP, writeReg, reset;      // added reset to reset the entire reg bank
    input [4:0] sr1, sr2, dr; // source and destination register
    input [31:0] write_data, write_dataSP;                  // implemented as independent inputs for the 32 registers and then the sp
    output reg [31:0] read_data1, read_data2;
)
    reg [31:0] registers [31:0];                           // 32 registers; the register at address 31 is the stack pointer                                              
    if (readSP == 0) begin                                  // read ports are always updated based on the address of the source registers    
        assign read_data1 = registers[sr1];                 // read_data1 is updated based on the address of the source register
    end
    else begin
        assign read_data1 = registers[31];                             // read_data1 is updated based on the stack pointer if readSP is high
    end
    assign read_data2 = registers[sr2];

    assign registers[0] = 32'b0;
    
    // some default values set for the registers
    registers[1]=32'b1; registers[2]=32'b10; registers[3]=32'b11; registers[4]=32'b100; registers[5]=32'b101; registers[6]=32'b110; registers[7]=32'b111; registers[8]=32'b1000;
    registers[9]=32'b1001; registers[10]=32'b1010; registers[11]=32'b1011; registers[12]=32'b1100; registers[13]=32'b1101; registers[14]=32'b1110; registers[15]=32'b1111; registers[16]=32'b10000;

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
            if (writeReg)                     // write to register only when writeReg is high    
                registers[dr] <= write_data;
            if (writeSP)
                registers[31] <= write_dataSP;             // stack pointer is updated only when writeSP is high
        end
    end
endmodule