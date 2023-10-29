    module top(
    input [2:0] regAdd,
    input [3:0] memAdd,
    input [3:0] data,
    input [1:0] op,
    input clk,
    output reg [3:0] out
    );
    reg [3:0] regs [7:0];
    wire [3:0] temp_out;
    reg e=0,w=0;
    reg [3:0]ma,dt;
//   blk_mem_gen_0 your_instance_name (
//  .clka(clka),    // input wire clka
//  .ena(ena),      // input wire ena
//  .wea(wea),      // input wire [0 : 0] wea
//  .addra(addra),  // input wire [3 : 0] addra
//  .dina(dina),    // input wire [3 : 0] dina
//  .douta(douta)  // output wire [3 : 0] douta
//);
    blk_mem_gen_0 mem_bank (
  .clka(clk),    // input wire clka
  .ena(e),      // input wire ena
  .wea(w),      // input wire [0 : 0] wea
  .addra(ma),  // input wire [3 : 0] addra
  .dina(dt),    // input wire [3 : 0] dina
  .douta(temp_out)  // output wire [3 : 0] douta
   );
    parameter s0=0; // state to read a 4-bit data and store it into a specified memory location with 4-bit address
    parameter s1=1; // state to transfer data from register to memory
    parameter s2=2; // state to transfer data from memory to register
    parameter s3=3; // state to display the contents of the memory location

    initial
    begin
        regs[0]=0;
        regs[1]=1;
        regs[2]=2;
        regs[3]=3;
        regs[4]=4;
        regs[5]=5;
        regs[6]=6;
        regs[7]=7;
    end

    always @(posedge clk) begin
        case(op)
        s0: begin
            e=1;
            w=1;
            dt=data;
            ma=memAdd;
            #20 w=0;
            #20 e=0;
        end

        s1: begin
            e=1;
            w=1;
            dt=regs[regAdd];
            ma=memAdd;
            #20 w=0;
            #20 e=0;
            // e=0;
            // w=0;
        end

        s2: begin
            e=1;
            w=0;
            ma=memAdd;
            regs[regAdd] = temp_out;
            #20 w=0;
            #20 e=0;
            // e=0;
            // w=0;
        end

        s3: begin
            e=1;
            w=0;
            ma=memAdd;
            out=temp_out;
            #20 w=0;
            #20 e=0;
            // e=0;
            // w=0;
        end
        endcase                
    end
endmodule

