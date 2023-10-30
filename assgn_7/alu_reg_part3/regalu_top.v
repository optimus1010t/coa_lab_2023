module pos_edge_det (input sig, // Input signal for which positive edge has to be detected
                     input clk, // Input signal for clock
                     output pe); // Output signal that gives a pulse when a positive edge occurs

    reg sig_dly; // Internal signal to store the delayed version of signal

    // This always block ensures that sig_dly is exactly 1 clock behind sig
    always @ (posedge clk) begin
        sig_dly <= sig;
    end

    // Combinational logic where sig is AND with delayed, inverted version of sig
    // Assign statement assigns the evaluated expression in the RHS to the internal net pe
    assign pe = sig & ~sig_dly;
endmodule

module top(
    input [15:0] in,
    input nxt,
    input clk,
    output reg [15:0] out
);

    reg [4:0] srcreg1,srcreg2,destreg;
    reg writeSP, readSP, writeReg, reset;
    reg [31:0] write_data, write_dataSP;
    wire [31:0] read_data1, read_data2;

    reg [3:0] func;
    wire[2:0] flags;
    reg shamt;
    reg [31:0] in1,in2;
    wire [31:0] alu_out;

    reg [3:0] state;

    wire pe;
    pos_edge_det detector(nxt,clk,pe);

    alu potato(in1,in2,shamt,func,alu_out,flags);
    regbank reg32(clk, writeSP, readSP, writeReg, reset, srcreg1, srcreg2, destreg, write_data, write_dataSP, read_data1, read_data2);
    always @(posedge clk)
    begin
    if(pe==1)
    begin
        case(state)
        0:
        begin
            writeReg=0;
            writeSP=0;
            srcreg1=in[4:0];
            srcreg2=in[9:5];
            destreg=in[14:10];
            state=1;
            out=state;
        end
        1:
        begin
            func=in[3:0];
            in1=read_data1;
            in2=read_data2;
            shamt=in2[0];
            state=2;
            out=state;
        end
        2:
        begin
            write_data=alu_out;
            writeReg=1;
            state=3;
            out=alu_out[15:0];
        end
        3:
        begin
            state=4;
            out=alu_out[31:16];
        end
        4:
        begin
            state=5;
            out=destreg;
        end
        default:
        begin
            state=0;
            out=0;
        end
        endcase
        end
    end

endmodule