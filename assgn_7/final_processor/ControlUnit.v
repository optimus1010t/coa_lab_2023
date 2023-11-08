// `include "Datapath.v"
module control_unit (                      // so input is the instruction itself and outputs are the control signals are 
    input wire [5:0] opcode,   
    input wire [5:0] funct,
    input clk,
    output reg PCUpdate,                   // Added this to know when to update the PC ???? dont know whether this is needed
    output reg regDest,
    output reg writeSP,
    output reg readSP,
    output reg writeReg,
    output reg updateSP,
    output reg [3:0] aluOp,
    output reg spmux,
    output reg PM4,
    output reg retMem,
    output reg aluSource,                  // 1 is register, 0 if imm for second operand
    output reg memRead,
    output reg memWrite,
    output reg memReg,
    output reg moveReg,
    output reg jump,
    output reg [1:0] branch,
    output reg retPC,
    output reg haltPC
);
    reg [4:0] curr_state;

    initial begin
        curr_state = 1;
        PCUpdate = 0;
        regDest = 0;
        writeSP = 0;
        readSP = 0;
        writeReg = 0;
        updateSP = 0;
        aluOp = 0;
        spmux = 0;
        PM4 = 0;
        retMem = 0;
        aluSource = 0;
        memRead = 0;
        memWrite = 0;
        memReg = 0;
        moveReg = 0;
        jump = 0;
        branch = 0;
        retPC = 0;
        haltPC = 0;
    end
        
    // ???? add the button press logic to initialise PC for now I am setting it to zero by default
    initial begin
        $dumpvars(0, curr_state);
    end
    always @(posedge clk)
    begin
        case(curr_state) // keep halt one all the time and change it to zero when you wnat to update PC, to remedy updation when you dont want
            0: begin
                PCUpdate = 1;
                curr_state <= 1;                
            end
            // current instruction is in curr_instr
            1: begin                
                PCUpdate = 0;
                regDest = 0;
                writeSP = 0;
                readSP = 0;
                writeReg = 0;
                updateSP = 0;
                aluOp = 0;
                spmux = 0;
                PM4 = 0;
                retMem = 0;
                aluSource = 0;
                memRead = 0;
                memWrite = 0;
                memReg = 0;
                moveReg = 0;
                jump = 0;
                branch = 0;
                retPC = 0;
                curr_state <= 2;
            end
            2: case(opcode)
                6'b000000: begin                    
                    aluSource = 1;
                    spmux = 0;
                    aluOp = funct[3:0];
                    branch = 0;
                    jump = 0;   
                    curr_state <= 3;                        
                end
                6'b000001:begin
                    aluSource = 0;
                    spmux = 0;
                    aluOp = 0;
                    branch = 0;
                    jump = 0;
                    curr_state <= 3;
                end
                6'b000010: begin
                    aluSource = 0;
                    spmux = 0;
                    aluOp = 1;
                    branch = 0;
                    jump = 0;
                    curr_state <= 3;
                end
                6'b000011: begin
                    aluSource = 0;
                    spmux = 0;
                    aluOp = 2;
                    branch = 0;
                    jump = 0;
                    curr_state <= 3;
                end
                6'b000100: begin
                    aluSource = 0;
                    spmux = 0;
                    aluOp = 3;
                    branch = 0;
                    jump = 0;
                    curr_state <= 3;
                end
                6'b000101: begin
                    aluSource = 0;
                    spmux = 0;
                    aluOp = 4;
                    branch = 0;
                    jump = 0;
                    curr_state <= 3;
                end
                6'b000110: begin
                    aluSource = 0;
                    spmux = 0;
                    aluOp = 5;
                    branch = 0;
                    jump = 0;
                    curr_state <= 3;
                end
                6'b000111: begin
                    aluSource = 0;
                    spmux = 0;
                    aluOp = 6;
                    branch = 0;
                    jump = 0;
                    curr_state <= 3;
                end
                6'b001000: begin
                    aluSource = 0;
                    spmux = 0;
                    aluOp = 7;
                    branch = 0;
                    jump = 0;
                    curr_state <= 3;
                end
                6'b001001: begin
                    aluSource = 0;
                    spmux = 0;
                    aluOp = 8;
                    branch = 0;
                    jump = 0;
                    curr_state <= 3;
                end
                6'b001010, 6'b001100: begin
                    aluSource = 0;
                    spmux = 0;
                    aluOp = 0;
                    branch = 0;
                    jump = 0;
                    curr_state <= 3;
                end
                6'b001011, 6'b001101: begin
                    aluSource = 0;
                    spmux = 0;
                    aluOp = 0;
                    branch = 0;
                    jump = 0;
                    curr_state <= 3;
                end
                6'b001110: begin
                    curr_state <= 3;
                end
                6'b001111, 6'b010000, 6'b010001: begin
                    aluSource = 1;
                    spmux = 0;
                    aluOp = 0;
                    branch = 0;
                    jump = 0;
                    curr_state <= 3;
                end
                6'b010111: begin
                    haltPC = 1;
                    curr_state <= 31;
                end
                6'b011000: begin
                    curr_state <= 3;
                end
                6'b010110:begin
                    curr_state <= 3;
                end
                6'b010010: begin
                    readSP = 1;
                    PM4 = 1;
                    spmux = 1;
                    aluOp = 0;
                    retMem = 0;
                    updateSP = 0;
                    curr_state <= 3;                    
                end
                6'b010011: begin
                    readSP = 1;
                    aluSource = 1;
                    spmux = 0;
                    aluOp = 0;
                    retMem = 0;
                    updateSP = 0;
                    memRead = 1;
                    curr_state <= 3;
                end
                6'b010100: begin
                    readSP = 1;
                    PM4 = 1;
                    spmux = 1;
                    retMem = 0;
                    updateSP = 1;
                    curr_state <= 3;
                end
                6'b010101: begin
                    retMem = 1;
                    memRead = 1;
                    readSP = 1;
                    PM4 = 0;
                    curr_state <= 3;
                end
                    

                
            endcase
            
            3: case(opcode)
                6'b000000: curr_state <= 4;                    
                6'b000001: curr_state <= 4;
                6'b000010: curr_state <= 4;
                6'b000011: curr_state <= 4;
                6'b000100: curr_state <= 4;
                6'b000101: curr_state <= 4;
                6'b000110: curr_state <= 4;
                6'b000111: curr_state <= 4;
                6'b001000: curr_state <= 4;
                6'b001001: curr_state <= 4;
                6'b001010, 6'b001100: begin
                    retMem = 0;
                    memRead = 1;
                    curr_state <= 4;
                end
                6'b001011, 6'b001101: begin
                    retMem = 0;
                    updateSP = 0;
                    memWrite = 1;                   //kept it on for two cycles to write the data to memory
                    curr_state <= 4;
                end
                6'b001110: begin
                    branch = 0;
                    jump=1;
                    curr_state <= 4;
                end
                6'b001111: begin
                    branch = 1;
                    jump=0;
                    curr_state <= 4;
                end
                6'b010000: begin
                    branch = 2;
                    jump=0;
                    curr_state <= 4;
                end
                6'b010001: begin
                    branch = 3;
                    jump=0;
                    curr_state <= 4;
                end
                6'b011000: begin
                    curr_state <= 31;
                end
                6'b010110:begin
                    curr_state <= 4;
                end
                6'b010010: begin
                    memWrite=1;
                    writeSP = 1;
                    readSP = 1;
                    curr_state <= 4;                    
                end
                6'b010011: begin
                    readSP = 1;
                    aluSource = 1;
                    spmux = 0;
                    aluOp = 0;
                    retMem = 0;
                    updateSP = 0;
                    memRead = 1;
                    curr_state <= 4;
                end
                6'b010100: begin
                    branch = 0;
                    jump=1;
                    memWrite = 1;
                    curr_state <= 4;
                end
                6'b010101: begin
                    writeSP=1;
                    retMem = 1;
                    memRead = 0;
                    curr_state <= 4;
                end

            endcase
            4: case(opcode)
                6'b000000: begin
                    memReg = 0;
                    moveReg = 0;
                    writeReg = 1;
                    regDest = 1;
                    curr_state <= 5;                  
                end
                6'b000001: begin
                    memReg = 0;
                    moveReg = 0;
                    writeReg = 1;
                    regDest = 0;
                    curr_state <= 5;                  
                end
                6'b000010: begin
                    memReg = 0;
                    moveReg = 0;
                    writeReg = 1;
                    regDest = 0;
                    curr_state <= 5;                  
                end
                6'b000011: begin
                    memReg = 0;
                    moveReg = 0;
                    writeReg = 1;
                    regDest = 0;
                    curr_state <= 5;                  
                end
                6'b000100: begin
                    memReg = 0;
                    moveReg = 0;
                    writeReg = 1;
                    regDest = 0;
                    curr_state <= 5;                  
                end
                6'b000101: begin
                    memReg = 0;
                    moveReg = 0;
                    writeReg = 1;
                    regDest = 0;
                    curr_state <= 5;                  
                end
                6'b000110: begin
                    memReg = 0;
                    moveReg = 0;
                    writeReg = 1;
                    regDest = 0;
                    curr_state <= 5;                  
                end
                6'b000111: begin
                    memReg = 0;
                    moveReg = 0;
                    writeReg = 1;
                    regDest = 0;
                    curr_state <= 5;                  
                end
                6'b001000: begin
                    memReg = 0;
                    moveReg = 0;
                    writeReg = 1;
                    regDest = 0;
                    curr_state <= 5;                  
                end
                6'b001001: begin
                    memReg = 0;
                    moveReg = 0;
                    writeReg = 1;
                    regDest = 0;
                    curr_state <= 5;                  
                end
                6'b001010, 6'b001100: begin
                    retMem = 0;
                    memRead = 1;
                    curr_state <= 5;
                end
                6'b001011, 6'b001101: begin
                    memWrite = 1;
                    curr_state <= 5;
                end
                6'b001110: begin
                    retPC=0;
                    curr_state <= 31;
                end
                6'b001111, 6'b010000, 6'b010001: begin
                    retPC=0;
                    curr_state <= 31;
                end
                6'b010110:begin
                    memReg = 0;
                    moveReg = 1;
                    writeReg = 1;
                    regDest = 1;
                    curr_state <= 5;
                end
                6'b010010: begin
                    memWrite=0;
                    writeSP = 0;
                    readSP = 0;
                    curr_state <= 31;                    
                end
                6'b010011: begin
                    memReg=1;
                    moveReg = 0;
                    regDest = 1;
                    writeReg = 1;
                    PM4 = 0;
                    readSP = 1;
                    writeSP = 1;
                    curr_state <= 5;
                end
                6'b010100: begin
                    branch = 0;
                    jump=1;
                    memWrite = 1;
                    curr_state <= 5;
                end
                
                6'b010101: begin
                    writeSP=0;
                    memReg = 1;
                    retPC = 1;
                    haltPC = 0;
                    PCUpdate = 0;
                    curr_state <= 5;
                end
                
            endcase
            5: case(opcode)
                6'b000000: begin
                    writeReg = 0;
                    curr_state <= 31;                                        
                end
                6'b000001: begin
                    writeReg = 0;
                    curr_state <= 31;                                        
                end
                6'b000010: begin
                    writeReg = 0;
                    curr_state <= 31;                                        
                end
                6'b000011: begin
                    writeReg = 0;
                    curr_state <= 31;                                        
                end
                6'b000100: begin
                    writeReg = 0;
                    curr_state <= 31;                                        
                end
                6'b000101: begin
                    writeReg = 0;
                    curr_state <= 31;                                        
                end
                6'b000110: begin
                    writeReg = 0;
                    curr_state <= 31;                                        
                end
                6'b000111: begin
                    writeReg = 0;
                    curr_state <= 31;                                        
                end
                6'b001000: begin
                    writeReg = 0;
                    curr_state <= 31;                                        
                end
                6'b001001: begin
                    writeReg = 0;
                    curr_state <= 31;                                        
                end
                6'b001010, 6'b001100: begin
                    memRead = 0;
                    memReg = 1;
                    moveReg = 0;
                    writeReg = 1;
                    regDest = 0;
                    curr_state <= 6;                  
                end
                6'b001011, 6'b001101: begin
                    memWrite = 0;
                    curr_state <= 31;
                end
                6'b010110:begin
                    memReg = 0;
                    moveReg = 0;
                    writeReg = 0;
                    regDest = 0;
                    curr_state <= 31;
                end
                6'b010011: begin
                    memReg=1;
                    moveReg = 0;
                    regDest = 0;
                    writeReg = 0;
                    PM4 = 0;
                    readSP = 0;
                    writeSP = 0;
                    curr_state <= 31;
                end
                6'b010100: begin
                    retPC=0;
                    writeSP = 1;
                    memWrite = 0;
                    curr_state <= 6;                    
                end

                6'b010101: begin
                    memReg = 1;
                    retPC = 1;
                    PCUpdate = 1;
                    haltPC = 0;
                    curr_state <= 1;
                end
                
            endcase

            6:case(opcode)
                6'b001010, 6'b001100: begin
                    memReg = 0;
                    writeReg = 0;
                    regDest = 0;
                    curr_state <= 31;                  
                end
                6'b010011: begin
                    memReg=1;
                    moveReg = 0;
                    regDest = 1;
                    writeReg = 1;
                    spmux = 0;
                    aluOp = 0;
                    retMem = 0;
                    updateSP = 0;
                end
                6'b010100: begin
                    retPC=0;
                    writeSP = 0;
                    memWrite = 0;  
                    curr_state <= 31;                  
                end
            endcase

            31: begin
                PCUpdate = 1;                
                regDest = 0;
                writeSP = 0;
                readSP = 0;
                writeReg = 0;
                updateSP = 0;
                aluOp = 0;
                spmux = 0;
                PM4 = 0;
                retMem = 0;
                aluSource = 0;
                memRead = 0;
                memWrite = 0;
                memReg = 0;
                moveReg = 0;
                jump = 0;
                branch = 0;
                retPC = 0;
                // haltPC = 0;
                curr_state <= 0;
            end
        endcase
    end


endmodule