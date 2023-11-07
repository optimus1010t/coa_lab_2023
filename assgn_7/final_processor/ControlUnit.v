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
            endcase
            
            3: case(opcode)
                6'b000000: begin
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
            endcase
            5: case(opcode)
                6'b000000: begin
                    writeReg = 0;
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
                haltPC = 0;
                curr_state <= 0;
            end
        endcase
    end


endmodule