// `include "PC.v"
// `include "Adder.v"


module datapath (
    input clk,
    input PCUpdate,
    input memReadIM,
    input memWriteIM,
    input regDest,
    input wire writeSP, readSP, writeReg,
    
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
// wire [31:0] sign_extended_immediate;
// wire [31:0] adder_input;
// wire [31:0] adder_output;
// wire [31:0] PCinput;
wire [31:0] w_IM_out;             // instruction memory to mux with regDest
wire [4:0] w_mA_RBdest;         // mux with regDest and regbankdest
wire [9:0] PCoutput;
wire [31:0] readData1;
wire [31:0] readData2;

// muxes are named as mux_<control_signal_driving_them> and each of them is a 2-to-1 mux
// wires are named as w_<source>_<dest>

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
    .write_data(w_IM_out),
    .read_data(0)               // default to zero ???? might change later    
);

mux_2to1_5bit my_mux_regDest (
    .in1(w_IM_out[11:15]),
    .in2(w_IM_out[16:20]),
    .sel(regDest),
    .out(w_mA_RBdest)
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
    .write_data(0),             // default to zero ???? might change later
    .write_dataSP(0),           // default to zero ???? might change later
    .read_data1(readData1),
    .read_data2(readData2)
);






// program_counter pc_module (
//     .PCControl(PCControl),
//     .PCinput(PCinput),
//     .PCoutput(PCoutput)
// );

// instruction_memory imem_module (
//     .address(PCoutput),
//     .instruction(instruction)
// );

// instruction_decoder idec_module (
//     instruction,
//     opcode,
//     rs,
//     rt,
//     rd,
//     funct,
//     immediate
// );

// mux_3to1 mux3to1_module (
//     .rs(rs),
//     .rt(rt),
//     .rd(rd),
//     .sel(RegDst),
//     .out(writeRegister)
// );


// sign_extend sign_extend_module (
//     .in(immediate),
//     .out(sign_extended_immediate)
// );

// mux_2to1_32bit mux2to1_32bit_module_1 (         //Mux for ALU input 1
//     .in1(readData1),
//     .in2(readDataSP),
//     .sel(ALUSrc1),
//     .out(ALUinput1)
// );

// mux_2to1_32bit mux2to1_32bit_module_2 (         //Mux for ALU input 2
//     .in1(readData2),
//     .in2(sign_extended_immediate),
//     .sel(ALUSrc2),
//     .out(ALUinput2)
// );

// alu_controller alucon_module (
//     .ALUop(ALUop),
//     .funct(funct),
//     .ALUfunct(ALUfunct)           //Funct Performed By the ALU
// );

// alu alu_module (
//     .A(ALUinput1),
//     .B(ALUinput2),
//     .ALUfunct(ALUfunct),
//     .out(ALUResult),
//     .flagZ(),
//     .flagS()
// );

// z_register z_module (
//     .ZControl(ZControl),
//     .ZInput(ALUResult),
//     .ZOutput(ZOutput)
// );

// mux_2to1_32bit mux2to1_32bit_module_3 (         //Mux to choose between ReadDataMem and ALUResult
//     .in1(0),
//     .in2(ZOutput),
//     .sel(MemToOut),
//     .out(mux3output)
// );

// mux_4_vs_in2 mux4vsin2_module (
//     .in2(sign_extended_immediate),
//     .sel(Call),                                 //Temporarily using Call as sel
//     .out(adder_input)
// );

// adder adder_module (
//     .in1(PCoutput),
//     .in2(adder_input),
//     .out(adder_output)
// );

// mux_2to1_32bit mux2to1_32bit_module_4 (         //Mux to choose between adder_output and mux3output
//     .in1(adder_output),
//     .in2(mux3output),
//     .sel(PCUpdate),
//     .out(PCinput)
);



endmodule