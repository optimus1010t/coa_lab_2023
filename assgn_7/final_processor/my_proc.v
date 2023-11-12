// `include "ControlUnit.v"
// `include "Datapath.v"

module processor(
    input clk,
    // input INT,
    output [31:0] finalout
);

// ???? need to check shift imm and not imm operations
// ???? check alu operations once again

wire [5:0] opcode;
wire [5:0] func;
wire [31:0] im_out;
wire [3:0] aluOp;

wire PCUpdate;                   // Added this to know when to update the PC ???? dont know whether this is needed
wire regDest;
wire writeSP;
wire readSP;
wire writeReg;
wire updateSP;
wire spmux;
wire PM4;
wire retMem;
wire aluSource;                  // 1 is register; 0 if imm for second operand
wire memRead;
wire memWrite;
wire memReg;
wire moveReg;
wire jump;
wire [1:0] branch;
wire retPC;
wire haltPC;

control_unit cu_roll(
    .opcode(im_out[31:26]),
    .funct(im_out[5:0]),
    .clk(clk),
    .PCUpdate(PCUpdate),
    .regDest(regDest),
    .writeSP(writeSP),
    .readSP(readSP),
    .writeReg(writeReg),
    .updateSP(updateSP),
    .aluOp(aluOp),
    .spmux(spmux),
    .PM4(PM4),
    .retMem(retMem),
    .aluSource(aluSource),
    .memRead(memRead),
    .memWrite(memWrite),
    .memReg(memReg),
    .moveReg(moveReg),
    .jump(jump),
    .branch(branch),
    .retPC(retPC),
    .haltPC(haltPC)
);

datapath dete(
    .clk(clk),
    .PCUpdate(PCUpdate),
    .regDest(regDest),
    .writeSP(writeSP),
    .readSP(readSP),
    .writeReg(writeReg),
    .aluSource(aluSource),
    .updateSP(updateSP),
    .PM4(PM4),
    .spmux(spmux), 
    .retMem(retMem),
    .memRead(memRead),
    .memWrite(memWrite),
    .memReg(memReg),
    .aluOp(aluOp),
    .moveReg(moveReg),
    .jump(jump),
    .retPC(retPC),
    .haltPC(haltPC),
    .branch(branch),
    .IM_out(im_out)        
);

endmodule