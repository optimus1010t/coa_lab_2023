module control_unit (
    input [5:0] opcode,
    input clk,
    output reg [1:0] PCControl,             //Left Bit is for PCin and Right Bit is for PCout
    output reg Call,                        //Call is 1 for call and 0 otherwise
    output reg [5:0] ALUop,
    output reg [1:0] RegDst,                 //0 for rs, 1 for rt, 2 for rd
    output reg RegWrite,                     //1 for Writing to Register, 0 othw
    output reg ALUSrc1,                      //0 for ReadData1, 1 for ReadSP
    output reg ALUSrc2,                      //0 for ReadData2, 1 for Immediate32bit
    output reg SPWrite,                      //1 for Writing to SP, 0 othw
    output reg [1:0] ZControl,               //Left Bit is for Zin and Right Bit is for Zout
    output reg MemToOut,                      //0 for ReadDataMem, 1 for ALUResult
    output reg PCUpdate                      //0 for PC = PC + 4, 1 for address from data memory
);
    reg [1:0] cu_state;
    reg [4:0] instr_state;

    initial begin
        cu_state = 0;
        instr_state = 0;
        PCControl = 0;
        Call = 0;
        ALUop = 0;
        RegDst = 0;
        ALUSrc1 = 0;
        ALUSrc2 = 0;
        RegWrite = 0;
        SPWrite = 0;
        ZControl = 0;
        MemToOut = 0;
        PCUpdate = 0;
    end
    always @(posedge clk) begin
        case (cu_state)
            0: begin
                PCControl = 2'b01;
                cu_state = 1;
            end
            1: begin
                case (opcode)
                    6'b000000: begin                    //R-type
                        case (instr_state)
                            0: begin
                                PCControl = 2'b00;
                                PCUpdate = 0;
                                Call = 0;
                                RegDst = 2;
                                ALUop = opcode;
                                ALUSrc1 = 0;
                                ALUSrc2 = 0;
                                ZControl = 2'b10;
                                instr_state = 1;
                            end
                            1: begin
                                ZControl = 2'b01;
                                MemToOut = 1;
                                RegWrite = 1;
                                instr_state = 2;
                            end
                            2: begin
                                RegWrite = 0;
                                MemToOut = 0;
                                ZControl = 2'b00;
                                instr_state = 3;
                            end
                            3: begin
                                cu_state = 0;
                                instr_state = 0;
                                PCControl = 2'b10;
                            end
                        endcase
                    end
                    6'b000001: begin                //ADDI
                        case (instr_state)
                            0: begin
                                PCControl = 2'b00;
                                PCUpdate = 0;
                                Call = 0;
                                RegDst = 0;
                                ALUop = opcode;
                                ALUSrc1 = 0;
                                ALUSrc2 = 1;                //Input Immediate32bit to ALU
                                ZControl = 2'b10;
                                instr_state = 1;
                            end
                            1: begin
                                ZControl = 2'b01;
                                MemToOut = 1;
                                RegWrite = 1;
                                instr_state = 2;
                            end
                            2: begin
                                RegWrite = 0;
                                MemToOut = 0;
                                ZControl = 2'b00;
                                instr_state = 3;
                            end
                            3: begin
                                cu_state = 0;
                                instr_state = 0;
                                PCControl = 2'b10;
                            end
                        endcase
                    end
                    6'b000010: begin                    //SUBI
                        case (instr_state)
                            0: begin
                                PCControl = 2'b00;
                                PCUpdate = 0;
                                Call = 0;
                                RegDst = 0;
                                ALUop = opcode;
                                ALUSrc1 = 0;
                                ALUSrc2 = 1;                //Input Immediate32bit to ALU
                                ZControl = 2'b10;
                                instr_state = 1;
                            end
                            1: begin
                                ZControl = 2'b01;
                                MemToOut = 1;
                                RegWrite = 1;
                                instr_state = 2;
                            end
                            2: begin
                                RegWrite = 0;
                                MemToOut = 0;
                                ZControl = 2'b00;
                                instr_state = 3;
                            end
                            3: begin
                                cu_state = 0;
                                instr_state = 0;
                                PCControl = 2'b10;
                            end
                        endcase
                    end                                 
                    6'b000011: begin                        //ANDI
                        case (instr_state)
                            0: begin
                                PCControl = 2'b00;
                                PCUpdate = 0;
                                Call = 0;
                                RegDst = 0;
                                ALUop = opcode;
                                ALUSrc1 = 0;
                                ALUSrc2 = 1;                //Input Immediate32bit to ALU
                                ZControl = 2'b10;
                                instr_state = 1;
                            end
                            1: begin
                                ZControl = 2'b01;
                                MemToOut = 1;
                                RegWrite = 1;
                                instr_state = 2;
                            end
                            2: begin
                                RegWrite = 0;
                                MemToOut = 0;
                                ZControl = 2'b00;
                                instr_state = 3;
                            end
                            3: begin
                                cu_state = 0;
                                instr_state = 0;
                                PCControl = 2'b10;
                            end
                        endcase
                    end
                    6'b000100: begin                    //ORI
                        case (instr_state)
                            0: begin
                                PCControl = 2'b00;
                                PCUpdate = 0;
                                Call = 0;
                                RegDst = 0;
                                ALUop = opcode;
                                ALUSrc1 = 0;
                                ALUSrc2 = 1;                //Input Immediate32bit to ALU
                                ZControl = 2'b10;
                                instr_state = 1;
                            end
                            1: begin
                                ZControl = 2'b01;
                                MemToOut = 1;
                                RegWrite = 1;
                                instr_state = 2;
                            end
                            2: begin
                                RegWrite = 0;
                                MemToOut = 0;
                                ZControl = 2'b00;
                                instr_state = 3;
                            end
                            3: begin
                                cu_state = 0;
                                instr_state = 0;
                                PCControl = 2'b10;
                            end
                        endcase
                    end
                    6'b000101: begin                        //XORI
                        case (instr_state)
                            0: begin
                                PCControl = 2'b00;
                                PCUpdate = 0;
                                Call = 0;
                                RegDst = 0;
                                ALUop = opcode;
                                ALUSrc1 = 0;
                                ALUSrc2 = 1;                //Input Immediate32bit to ALU
                                ZControl = 2'b10;
                                instr_state = 1;
                            end
                            1: begin
                                ZControl = 2'b01;
                                MemToOut = 1;
                                RegWrite = 1;
                                instr_state = 2;
                            end
                            2: begin
                                RegWrite = 0;
                                MemToOut = 0;
                                ZControl = 2'b00;
                                instr_state = 3;
                            end
                            3: begin
                                cu_state = 0;
                                instr_state = 0;
                                PCControl = 2'b10;
                            end
                        endcase
                    end
                    6'b000110: begin                        //NOTI
                        case (instr_state)
                            0: begin
                                PCControl = 2'b00;
                                PCUpdate = 0;
                                Call = 0;
                                RegDst = 0;
                                ALUop = opcode;
                                ALUSrc1 = 0;
                                ALUSrc2 = 1;                //Input Immediate32bit to ALU
                                ZControl = 2'b10;
                                instr_state = 1;
                            end
                            1: begin
                                ZControl = 2'b01;
                                MemToOut = 1;
                                RegWrite = 1;
                                instr_state = 2;
                            end
                            2: begin
                                RegWrite = 0;
                                MemToOut = 0;
                                ZControl = 2'b00;
                                instr_state = 3;
                            end
                            3: begin
                                cu_state = 0;
                                instr_state = 0;
                                PCControl = 2'b10;
                            end
                        endcase
                    end
                    6'b000111: begin                        //SLLI
                        case (instr_state)
                            0: begin
                                PCControl = 2'b00;
                                PCUpdate = 0;
                                Call = 0;
                                RegDst = 0;
                                ALUop = opcode;
                                ALUSrc1 = 0;
                                ALUSrc2 = 1;                //Input Immediate32bit to ALU
                                ZControl = 2'b10;
                                instr_state = 1;
                            end
                            1: begin
                                ZControl = 2'b01;
                                MemToOut = 1;
                                RegWrite = 1;
                                instr_state = 2;
                            end
                            2: begin
                                RegWrite = 0;
                                MemToOut = 0;
                                ZControl = 2'b00;
                                instr_state = 3;
                            end
                            3: begin
                                cu_state = 0;
                                instr_state = 0;
                                PCControl = 2'b10;
                            end
                        endcase
                    end
                    6'b001000: begin                    //SRLI
                        case (instr_state)
                            0: begin
                                PCControl = 2'b00;
                                PCUpdate = 0;
                                Call = 0;
                                RegDst = 0;
                                ALUop = opcode;
                                ALUSrc1 = 0;
                                ALUSrc2 = 1;                //Input Immediate32bit to ALU
                                ZControl = 2'b10;
                                instr_state = 1;
                            end
                            1: begin
                                ZControl = 2'b01;
                                MemToOut = 1;
                                RegWrite = 1;
                                instr_state = 2;
                            end
                            2: begin
                                RegWrite = 0;
                                MemToOut = 0;
                                ZControl = 2'b00;
                                instr_state = 3;
                            end
                            3: begin
                                cu_state = 0;
                                instr_state = 0;
                                PCControl = 2'b10;
                            end
                        endcase
                    end
                    6'b001001: begin                        //SRAI
                        case (instr_state)
                            0: begin
                                PCControl = 2'b00;
                                PCUpdate = 0;
                                Call = 0;
                                RegDst = 0;
                                ALUop = opcode;
                                ALUSrc1 = 0;
                                ALUSrc2 = 1;                //Input Immediate32bit to ALU
                                ZControl = 2'b10;
                                instr_state = 1;
                            end
                            1: begin
                                ZControl = 2'b01;
                                MemToOut = 1;
                                RegWrite = 1;
                                instr_state = 2;
                            end
                            2: begin
                                RegWrite = 0;
                                MemToOut = 0;
                                ZControl = 2'b00;
                                instr_state = 3;
                            end
                            3: begin
                                cu_state = 0;
                                instr_state = 0;
                                PCControl = 2'b10;
                            end
                        endcase
                    end
                    6'b001010: begin                        //LD
                        case (instr_state)
                            0: begin
                                PCControl = 2'b00;
                                PCUpdate = 0;
                                Call = 0;
                                RegDst = 1;
                                ALUop = opcode;
                                ALUSrc1 = 0;
                                ALUSrc2 = 1;                //Input Immediate32bit to ALU
                                ZControl = 2'b10;
                                instr_state = 1;
                            end
                        endcase
                    end
                    default: begin
                        PCControl = 2'b00;
                    end
                endcase
            end
        endcase
    end
endmodule