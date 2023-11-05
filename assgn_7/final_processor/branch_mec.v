module branching_mech (
    input clk,
    input reset,
    input [1:0] branch,
    input [2:0] flags,
    output wire branchf
);

if (reset) begin
    assign branchf = 0;
end
else begin                              // check if latch is induced or wire ????
    if (branch == 2'b00) begin
        assign branchf = 0;
    end
    else if (branch == 2'b01) begin
        assign branchf = flags[2];
    end
    else if (branch == 2'b10) begin
        assign branchf = ~flags[2];
    end
    else if (branch == 2'b11) begin
        assign branchf = flags[2];
    end
end

endmodule