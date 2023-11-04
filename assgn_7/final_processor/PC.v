module PC(
    input clk,
    input reset,
    input [9:0] PCinput,
    input PCUpdate,
    output [9:0] PCoutput
);
    reg [9:0] PC;
    initial begin
        PC = 0;
    end
    always @(posedge clk) begin
        if (reset) begin
            PC <= 0;
        end
        else begin
            if (PCUpdate) begin                 // PC is being updated by PCinput so if PC+1 should be passed to PCInput to get to next instruction; 1 as the instruction memory is word addressable
                PC <= PCinput;
            end
        end
    end
    assign PCoutput = PC;
endmodule