// `include "PC.v"
// `include "Adder.v"


module datapath (
    input clk,
    input PCUpdate,
    input regDest,
    input writeSP, readSP, updateSP, writeReg,
    input aluSource,
    input PM4,spmmux, 
    input retmem,
    input memRead,
    input memWrite,
    input memReg, spmux,
    input moveReg, jump, retPC, haltPC,
    input [1:0] branch,
    input [3:0] aluOp,
    output reg [31:0] IM_out
);

wire [31:0] PCoutput;
wire [31:0] PCinput;
wire [31:0] w_IM_out;               // instruction memory to mux with regDest
wire [4:0] w_mA_RBdest;             // mux with regDest and regbankdest
wire [31:0] readData1;
wire [31:0] readData2;
wire [31:0] w_sign_mC;
wire [31:0] w_mH_RB;
wire [31:0] w_mB_addN;
wire [31:0] w_mB_mD;
wire [31:0] sign_extended_imm_16;
wire [31:0] w_mC_mD;
wire [31:0] w_mD_ALU;
wire [2:0] alu_flags;
wire [31:0] alu_out;
wire [31:0] w_addK_addH;
wire [31:0] w_addK_mF;
wire [31:0] w_DM_out;
wire [31:0] w_mG_mH;
wire [31:0] w_signI_mJ,w_mJ_mK, w_mK_mL, w_mI_mJ;
wire branchf;


assign w_mB_addN = w_mB_mD;         // output of mux B to adder N for SP 

// muxes are named as mux_<control_signal_driving_them> and each of them is a 2-to-1 mux
// wires are named as w_<source>_<dest>

reg [31:0] treg_aluout1, treg_aluout2;
reg [31:0] treg_readData1_mH, treg_readData1_mH2;
reg [31:0] treg_PC_addH, treg_PC_addH2;
reg [31:0] treg_mJ_mK, treg_mJ_mK2;
reg [31:0] treg_signD_mC;
reg [31:0] treg_addK_mF1, treg_addK_mF2, treg_addK_mF3;
reg [31:0] treg_addK_addH1, treg_addK_addH2;
reg [31:0] treg_addH_mI;
reg [31:0] treg_addJ_mJ;
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
    treg_signD_mC <= sign_extended_imm_16;
    treg_addK_mF1 <= w_addK_addH;
    treg_addK_mF2 <= treg_addK_mF1;
    treg_addK_mF3 <= treg_addK_mF2;
    treg_addK_addH1 <= w_addK_addH;
    treg_addK_addH2 <= treg_addK_addH1;
    treg_addH_mI <= w_addH_mI;
    treg_addJ_mJ <= w_addJ_mJ;
end

initial
begin
    $dumpvars(0, treg_aluout1, treg_aluout2, treg_readData1_mH, treg_readData1_mH2, treg_PC_addH, treg_PC_addH2, treg_mJ_mK, treg_mJ_mK2, treg_signD_mC, treg_addK_mF1, treg_addK_mF2, treg_addK_mF3, treg_addK_addH1, treg_addK_addH2, treg_addH_mI, treg_addJ_mJ);
end

always @(*)
begin
    IM_out = w_IM_out;
end

PC my_PC (
    .clk(clk),
    .reset(1'b0),                  // default to zero ???? might change later
    .PCinput(PCinput),
    .PCUpdate(PCUpdate),
    .PCoutput(PCoutput)
);

instr_mem_mod my_IM (
    .clk(clk),
    .memWriteIM(1'b0),
    .memReadIM(1'b1),
    .reset(1'b0),                  // default to zero ???? might change later
    .sr(PCoutput),
    .write_data(32'b0),
    .read_data(w_IM_out)           // default to zero ???? might change later    
);

regbank my_RB (
    .clk(clk),
    .reset(1'b0),                  // default to zero ???? might change later
    .writeSP(writeSP),
    .readSP(readSP),
    .writeReg(writeReg),
    .sr1(w_IM_out[25:21]),
    .sr2(w_IM_out[20:16]),
    .dr(w_mA_RBdest),
    .write_data(w_mH_RB),           // default to zero ???? might change later
    .write_dataSP(0),               // default to zero ???? might change later
    .read_data1(readData1),
    .read_data2(readData2)
);

sign_extend_16 my_SE_16_D (
    .in(w_IM_out[31:16]),
    .out(sign_extended_imm_16)
);

mux_2to1_5bit my_mA_regDest (
    .in1(w_IM_out[20:16]),
    .in2(w_IM_out[15:11]),
    .sel(regDest),
    .out(w_mA_RBdest)
);

mux_2to1_32bit my_mB_PM4 (
    .in1(32'b00000000000000000000000000000001),         // +1 or -1 in our case
    .in2(32'b11111111111111111111111111111111),
    .sel(PM4),
    .out(w_mB_mD)
);

mux_2to1_5bit my_mC_aluSource (
    .in2(readData2),
    .in1(treg_signD_mC),
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
    .shamt(w_IM_out[25]),
    .func(aluOp),        
    .out(alu_out),
    .flags(alu_flags)
);

adder add_K(
    .in1(PCoutput),
    .in2(32'b00000000000000000000000000000001),         // +1 in our case
    .out(w_addK_addH)
);

mux_2to1_32bit my_mF_retmem (
    .in2(treg_addK_mF3),
    .in1(alu_out),
    .sel(regmem),
    .out(w_mF_DM)
);

mux_2to1_32bit my_mE_updateSP (
    .in2(treg_addK_mF3),
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
    .in2(w_DM_out),
    .in1(treg_aluout2),
    .sel(memReg),
    .out(w_mG_mH)
);

mux_2to1_32bit my_mH_moveReg (
    .in1(w_mG_mH),
    .in2(treg_readData1_mH2),
    .sel(moveReg),
    .out(w_mH_RB)
);

sign_extend_26 my_SE_26_I (
    .in(w_IM_out[25:0]),
    .out(w_signI_mJ)
);

adder add_H(
    .in1(sign_extended_imm_16),
    .in2(treg_addK_addH2),
    .out(w_addH_mI)
);

mux_2to1_32bit my_mI_branchf (
    .in1(treg_addK_mF3),
    .in2(treg_addH_mI),
    .sel(branchf),                     
    .out(w_mI_mJ)
);

adder add_J(
    .in1(treg_addK_addH2),
    .in2(w_signI_mJ),
    .out(w_addJ_mJ)
);

mux_2to1_32bit my_mJ_jump (
    .in1(w_mI_mJ),
    .in2(treg_addJ_mJ),
    .sel(jump),
    .out(w_mJ_mK)
);

mux_2to1_32bit my_mK_retPC (
    .in1(treg_mJ_mK2),
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

branching_mech my_BM(
    .clk(clk),
    .reset(0),                  // default to zero ???? might change later
    .branch(branch),
    .flags(alu_flags),
    .branchf(branchf)
);
endmodule