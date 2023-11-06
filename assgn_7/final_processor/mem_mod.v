module data_mem_mod(
    input wire clk,
    input wire memWrite, memRead, reset,      // added reset to reset the entire mem bank
    input [31:0] sr,                           // source register
    input [31:0] write_data,                  // data to write to register in memory bank
    output reg [31:0] read_data
);
    reg [31:0] data_regs [1023:0];            // 1024 registers that act as memory of width 32 bits                                            

    initial begin
        //$readmemb("regs_init_file_data.data",data_regs); // The external file that is used to initialize the RAM needs to be in bit vector form. External files in integer or hex format will not work.
    end                                       // The $readmemb and $readmemh system tasks can be used to initialize block memories. For more information, see:
                                              // Initializing RAM From an External File Coding Examples
                                              // Use $readmemb for binary and $readmemh for hexadecimal representation. To avoid the possible difference between XST and simulator behavior, Xilinx® recommends that you use index parameters in these system tasks. See the following coding example.
                                              // $readmemb("rams_20c.data",ram, 0, 7);
    always @(*) begin
    if (memRead) begin                        // read ports are always updated based on the address of the source registers    
        read_data = data_regs[sr[9:0]];            // read_data1 is updated based on the address of the source register
    end
    end
    // some default values set for the registers
    
    always @(posedge clk)                     // write always happens on posedge of the clock
    begin
        if (reset) begin 
            // setting everything to zero ???? need to update
        end
        else begin                            
            if (memWrite)                     // write to register only when writeReg is high    
                data_regs[sr[9:0]] <= write_data;
        end
    end
endmodule

module instr_mem_mod(
    input wire clk,
    input wire memWriteIM, memReadIM, reset,      // added reset to reset the entire mem bank
    input [31:0] sr,                            // source register
    input [31:0] write_data,                  // data to write to register in memory bank
    output reg [31:0] read_data
);
    reg [31:0] inst_regs [1023:0];            // 1024 registers that act as memory of width 32 bits                                            

    initial begin
        //$readmemb("regs_init_file_instr.data",inst_regs);
        inst_regs[0]=32'b000000 00100 00001 00010 00000 000000;
    end
    always @(*) begin
    if (memRead) begin                        // read ports are always updated based on the address of the source registers    
        read_data = inst_regs[sr[9:0]];            // read_data1 is updated based on the address of the source register
    end
    end
    // some default values set for the registers
    
    always @(posedge clk)                     // write always happens on posedge of the clock
    begin
        if (reset) begin 
            // setting everything to zero ???? need to update
        end
        else begin                            
            if (memWrite)                     // write to register only when writeReg is high    
                inst_regs[sr[9:0]] <= write_data;
        end
    end
endmodule