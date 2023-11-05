// `include "PC.v"
// `include "Adder.v"


module datapath (
    input clk,
    input PCUpdate,
    input memReadIM,
    input memWriteIM,
    input regDest,
    input writeSP, readSP, writeReg,
    input aluSource,
    input PM4,
    input retmem,
    input memRead,
    input memWrite,
    input memReg,
    input aluOp,moveReg, jump, branch, retPC, haltPC,

    
    input [5:0] ALUop,
    input [1:0] PCControl,
    input Call,
    input [1:0] RegDst,                 //0 for rs, 1 for rt, 2 for rd
    input ALUSrc1,                      //0 for ReadData1, 1 for ReadSP
    input ALUSrc2,                      //0 for ReadData2, 1 for Immediate32bit
    input RegWrite,                     //1 for Writing to Register, 0 othw
    input SPWrite,                      //1 for Writing to SP, 0 othw
    input [1:0] ZControl,               //Left Bit is for Zin and Right Bit is for Zout
    input MemToOut,                     //0 for ReadDataMem, 1 for ALUResult
    input PCUpdate,                     //0 for PC = PC + 4, 1 for address from data memory
    output [5:0] opcode
);

// wire [31:0] PCoutput;
// wire [31:0] instruction;
// wire [5:0] funct;
// wire [4:0] rs;
// wire [4:0] rt;
// wire [4:0] rd;
// wire [15:0] immediate;
// wire [31:0] readData1;
// wire [31:0] readData2;
// wire [31:0] readDataSP;
// wire [4:0] writeRegister;
// wire [31:0] ALUinput1;
// wire [31:0] ALUinput2;
// wire [5:0] ALUfunct;
// wire [31:0] ALUResult;
// wire [31:0] ZOutput;
// wire [31:0] mux3output;
// wire [31:0] sign_extended_imm_16;
// wire [31:0] adder_input;
// wire [31:0] adder_output;
// wire [31:0] PCinput;
wire [31:0] w_IM_out;             // instruction memory to mux with regDest
wire [4:0] w_mA_RBdest;         // mux with regDest and regbankdest
wire [31:0] PCoutput;
wire [31:0] readData1;
wire [31:0] readData2;
wire [31:0] w_sign_mC;
wire [31:0] w_mH_RB;
wire [31:0] w_mB_addN;
wire [31:0] sign_extended_imm_16;
wire [31:0] w_mC_mD;
wire [31:0] w_mD_ALU;
wire [2:0] alu_flags;
wire [31:0] alu_out;
wire [31:0] w_addK_addH;
wire [31:0] w_addK_mF;
wire [31:0] w_DM_out;
wire [31:0] w_signI_mJ,w_mJ_mK;
wire branchf;


assign w_addk_mF = w_addK_addH;   // output of adder K to mux F for SP
assign w_mB_addN = w_mB_mD;     // output of mux B to adder N for SP 

// muxes are named as mux_<control_signal_driving_them> and each of them is a 2-to-1 mux
// wires are named as w_<source>_<dest>

reg [31:0] treg_aluout1, treg_aluout2;
reg [31:0] treg_readData1_mH, treg_readData1_mH2;
reg [31:0] treg_PC_addH, treg_PC_addH2;
reg [31:0] treg_mJ_mK, treg_mJ_mK2, treg_mJ_mK3;
always @(posedge clk)
begin
    treg_aluout1 <= alu_out;
    treg_aluout2 <= treg_aluout1;
    treg_readData1_mH <= readData1;
    treg_readData1_mH2 <= treg_readData1_mH;
    treg_PC_addH <= PCoutput;
    treg_PC_addH2 <= treg_PC_addH;
    treg_mJ_mK <= w_mJ_mK;
    treg_mJ_mK2 <= treg_mJ_mK;
    treg_mJ_mK3 <= treg_mJ_mK2;
end
PC my_PC (
    .clk(clk),
    .reset(0),                  // default to zero ???? might change later
    .PCinput(PCinput),
    .PCUpdate(PCUpdate),
    .PCoutput(PCoutput)
);

instr_mem_mod my_IM (
    .clk(clk),
    .memWriteIM(memWriteIM),
    .memReadIM(memReadIM),
    .reset(0),                  // default to zero ???? might change later
    .sr(PCoutput),
    .write_data(0),
    .read_data(w_IM_out)               // default to zero ???? might change later    
);

regbank my_RB (
    .clk(clk),
    .reset(0),                  // default to zero ???? might change later
    .writeSP(writeSP),
    .readSP(readSP),
    .writeReg(writeReg),
    .sr1(w_IM_out[6:10]),
    .sr2(w_IM_out[11:15]),
    .dr(w_mA_RBdest),
    .write_data(w_mH_RB),             // default to zero ???? might change later
    .write_dataSP(0),           // default to zero ???? might change later
    .read_data1(readData1),
    .read_data2(readData2)
);

sign_extend_16 my_SE_16_D (
    .in(w_IM_out[16:31]),
    .out(sign_extended_imm_16)
);

mux_2to1_5bit my_mA_regDest (
    .in1(w_IM_out[11:15]),
    .in2(w_IM_out[16:20]),
    .sel(regDest),
    .out(w_mA_RBdest)
);

mux_2to1_32bit my_mB_PM4 (
    .in1(32b'00000000000000000000000000000100),
    .in2(32b'11111111111111111111111111111100),
    .sel(PM4),
    .out(w_mB_mD)
);

mux_2to1_5bit my_mC_aluSource (
    .in1(readData2),
    .in2(sign_extended_imm_16),
    .sel(aluSource),
    .out(w_mC_mD)
);

mux_2to1_32bit my_mD_spmux (
    .in1(w_mC_mD),
    .in2(w_mB_mD),
    .sel(spmux),
    .out(w_mD_ALU)
);


alu my_ALU (
    .input1(readData1),
    .input2(w_mD_ALU),
    .shamt(w_IM_out[25])
    .func(alu_Op),        
    .out(alu_out),
    .flags(alu_flags)
);

adder add_K(
    .in1(PCoutput),
    .in2(32b'00000000000000000000000000000100),
    .out(w_addK_addH)
);

mux_2to1_32bit my_mF_retmem (
    .in1(w_addK_mF),
    .in2(alu_out),
    .sel(regmem),
    .out(w_mF_DM)
);

mux_2to1_32bit my_mE_updateSP (
    .in2(w_addK_mF),
    .in1(readData2),
    .sel(updateSP),
    .out(w_mE_DM)
);

data_mem_mod DM(
    .clk(clk),
    .memWrite(memWrite),
    .memRead(memRead),
    .reset(0),                  // default to zero ???? might change later
    .sr(w_mF_DM),
    .write_data(w_mE_DM),
    .read_data(w_DM_out)               // default to zero ???? might change later    
);

mux_2to1_32bit my_mG_memReg (
    .in1(w_DM_out),
    .in2(treg_aluout2),
    .sel(memReg),
    .out(w_mG_mH)
);

mux2to1_32bit my_mH_moveReg (
    .in1(w_mG_mH),
    .in2(treg_readData1_mH2),
    .sel(moveReg),
    .out(w_mH_RB)
);

sign_extend_28 my_SE_26_I (
    .in(w_IM_out[6:31]),
    .out(w_signI_mJ)
);

adder add_H(
    .in1(treg_readData1_mH2),
    .in2(w_addK_addH),
    .out(w_addH_mI)
);

mux_2to1_32bit my_mI_branchf (
    .in1(w_addH_mI),
    .in2(PCoutput),
    .sel(branchf),                     // write teh code for branching mechanism????
    .out(w_mI_mJ)
);

adder add_J(
    .in1(PCoutput),
    .in2(w_signI_mJ),
    .out(w_addJ_mJ)
);

mux_2to1_32bit my_mJ_jump (
    .in1(w_mI_mJ),
    .in2(w_addJ_mJ),
    .sel(jump),
    .out(w_mJ_mK)
);

mux_2to1_32bit my_mK_retPC (
    .in1(treg_mJ_mK3),
    .in2(w_mG_mH),
    .sel(retPC),
    .out(w_mK_mL)
);

mux_2to1_32bit my_mL_haltPC (
    .in1(w_mK_mL),
    .in2(PCoutput),
    .sel(haltPC),
    .out(PCinput)
);
endmodule