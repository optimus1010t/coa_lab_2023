module data_mem_mod(
    input wire clk,
    input wire memWrite, memRead, reset,      // added reset to reset the entire mem bank
    input [31:0] sr,                          // source register
    input [31:0] write_data,                  // data to write to register in memory bank
    output reg [31:0] read_data
);
    reg [31:0] data_regs [1023:0];            // 1024 registers that act as memory of width 32 bits                                            

    initial begin
        $dumpvars(0, data_regs[0], data_regs[1], data_regs[2], data_regs[3], data_regs[4], data_regs[5], data_regs[1020], data_regs[1021], data_regs[1022], data_regs[1023],data_regs[10], data_regs[11], data_regs[12], data_regs[13], data_regs[14], data_regs[15], data_regs[16], data_regs[17], data_regs[18], data_regs[19]);
    end
    initial begin
        //$readmemb("regs_init_file_data.data",data_regs); // The external file that is used to initialize the RAM needs to be in bit vector form. External files in integer or hex format will not work.
        data_regs[0]=32'b00;
        data_regs[1]=32'b010010;
        data_regs[2]=32'b010100;
        data_regs[3]=32'b111;
        data_regs[10]=32'b110;
        data_regs[11]=32'b010;
        data_regs[12]=32'b001;
        data_regs[13]=32'b011;
        data_regs[14]=32'b000;
        data_regs[15]=32'b101;
        data_regs[16]=32'b110;
        data_regs[17]=32'b111;
        data_regs[18]=32'b100;
        data_regs[19]=32'b101;
        data_regs[1022]=32'b101;
    end                                       // The $readmemb and $readmemh system tasks can be used to initialize block memories. For more information, see:
                                              // Initializing RAM From an External File Coding Examples
                                              // Use $readmemb for binary and $readmemh for hexadecimal representation. To avoid the possible difference between XST and simulator behavior, Xilinx® recommends that you use index parameters in these system tasks. See the following coding example.
                                              // $readmemb("rams_20c.data",ram, 0, 7);
    always @(*) begin
    if (memRead) begin                        // read ports are always updated based on the address of the source registers    
        read_data = data_regs[sr[9:0]];       // read_data1 is updated based on the address of the source register
    end
    end
    // some default values set for the registers
    
    always @(posedge clk)                     // write always happens on posedge of the clock
    begin
        if (reset) begin 
            // setting everything to zero need to update
        end
        else begin                            
            if (memWrite)                     // write to register only when writeReg is high    
                data_regs[sr[9:0]] = write_data;
        end
    end
endmodule

module instr_mem_mod(
    input wire clk,
    input wire memWriteIM, memReadIM, reset,        // added reset to reset the entire mem bank
    input [31:0] sr,                                // source register
    input [31:0] write_data,                        // data to write to register in memory bank
    output reg [31:0] read_data
);
    reg [31:0] inst_regs [1023:0];                  // 1024 registers that act as memory of width 32 bits                                            

    initial begin

// for sorting
// inst_regs[0]= 32'b00000100000000010000000000001010;
// inst_regs[1]= 32'b00000100001000010000000000001001;
// inst_regs[2]= 32'b00000100000000100000000000000000;
// inst_regs[3]= 32'b00000100000000110000000000001010;
// inst_regs[4]= 32'b00101000011001000000000000000000;
// inst_regs[5]= 32'b00101000011001010000000000000001;
// inst_regs[6]= 32'b00000000100001010111100000000001;
// inst_regs[7]= 32'b00111101111000000000000000000011;
// inst_regs[8]= 32'b00000100000000100000000000000001;
// inst_regs[9]= 32'b00101100011001000000000000000001;
// inst_regs[10]= 32'b00101100011001010000000000000000;
// inst_regs[11]= 32'b00000100011000110000000000000001;
// inst_regs[12]= 32'b00000000011000010111000000000001;
// inst_regs[13]= 32'b01000101110000000000000000000001;
// inst_regs[14]= 32'b00111011111111111111111111110101;
// inst_regs[15]= 32'b01000100010000000000000000000001;
// inst_regs[16]= 32'b00111011111111111111111111110001;
// inst_regs[17]= 32'b01011100000000000000000000000000;

// for gcd
// inst_regs[0]= 32'b00101000000000010000000000000001;
// inst_regs[1]= 32'b00101000000000100000000000000010;
// inst_regs[2]= 32'b00000000001000100001100000000001;
// inst_regs[3]= 32'b01000000011000000000000000000011;
// inst_regs[4]= 32'b01011000001000000001100000000000;
// inst_regs[5]= 32'b01011000010000000000100000000000;
// inst_regs[6]= 32'b01011000011000000001000000000000;
// inst_regs[7]= 32'b01000100010000000000000000000010;
// inst_regs[8]= 32'b00000000001000100000100000000001;
// inst_regs[9]= 32'b00111011111111111111111111111000;
// inst_regs[10]= 32'b01011000001000000111100000000000;
// inst_regs[11]= 32'b01011100000000000000000000000000;

    end
    always @(*) begin
    if (memReadIM) begin                            // read ports are always updated based on the address of the source registers    
        read_data = inst_regs[sr[9:0]];             // read_data1 is updated based on the address of the source register
    end
    end
    // some default values set for the registers
    
    always @(posedge clk)                           // write always happens on posedge of the clock
    begin
        if (reset) begin 
        // setting everything to zero need to update
        end
        else begin                            
            if (memWriteIM)                         // write to register only when writeReg is high    
                inst_regs[sr[9:0]] = write_data;
        end
    end
endmodule