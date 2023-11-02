module data_mem_mod(
    input wire clk,
    input wire memWrite, memRead, reset,      // added reset to reset the entire mem bank
    input [4:0] sr                            // source register
    input [31:0] write_data,                  // data to write to register in memory bank
    output reg [31:0] read_data
);
    reg [31:0] data_regs [1023:0];            // 1024 registers that act as memory of width 32 bits                                            

    initial begin
        $readmemb("rams_init_file_data.data",data_regs); // The external file that is used to initialize the RAM needs to be in bit vector form. External files in integer or hex format will not work.
    end
    always @(*) begin
    if (memRead) begin                        // read ports are always updated based on the address of the source registers    
        read_data = data_regs[sr];            // read_data1 is updated based on the address of the source register
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
                data_regs[sr] <= write_data;
        end
    end
endmodule

module instr_mem_mod(
    input wire clk,
    input wire memWrite, memRead, reset,      // added reset to reset the entire mem bank
    input [4:0] sr                            // source register
    input [31:0] write_data,                  // data to write to register in memory bank
    output reg [31:0] read_data
);
    reg [31:0] inst_regs [1023:0];            // 1024 registers that act as memory of width 32 bits                                            

    initial begin
        $readmemb("rams_init_file_data.data",inst_regs);
    end
    always @(*) begin
    if (memRead) begin                        // read ports are always updated based on the address of the source registers    
        read_data = inst_regs[sr];            // read_data1 is updated based on the address of the source register
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
                inst_regs[sr] <= write_data;
        end
    end
endmodule