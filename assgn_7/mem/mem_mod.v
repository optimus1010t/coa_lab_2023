module data_mem_mod(
    input wire clk,
    input wire memWrite, memRead, reset,      // added reset to reset the entire mem bank
    input [4:0] sr                            // source register
    input [31:0] write_data,                  // data to write to register in memory bank
    output reg [31:0] read_data
);
    reg [31:0] registers [1023:0];            // 1024 registers that act as memory of width 32 bits                                            

    initial begin
        // get the values from .txt file using mem add functionale that is only synthesisable in case of initial blocks
        // ???? need to add the code for initialising the mem bank
    end
    always @(*) begin
    if (memRead) begin                        // read ports are always updated based on the address of the source registers    
        read_data = registers[sr];            // read_data1 is updated based on the address of the source register
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
                registers[sr] <= write_data;
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
    reg [31:0] registers [1023:0];            // 1024 registers that act as memory of width 32 bits                                            

    initial begin
        // get the values from .txt file using mem add functionale that is only synthesisable in case of initial blocks
        // ???? need to add the code for initialising the mem bank
    end
    always @(*) begin
    if (memRead) begin                        // read ports are always updated based on the address of the source registers    
        read_data = registers[sr];            // read_data1 is updated based on the address of the source register
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
                registers[sr] <= write_data;
        end
    end
endmodule