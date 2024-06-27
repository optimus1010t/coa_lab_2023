module branching_mech (
    input clk,
    input reset,
    input [1:0] branch,
    input [2:0] flags,
    output reg branchf
);
always@(*)begin
if (reset) begin
    branchf = 0;
end
else begin                            
    if (branch == 2'b00) begin
        branchf = 0;
    end
    else if (branch == 2'b01) begin
        branchf = flags[1];
    end
    else if (branch == 2'b10) begin
        branchf = ~flags[1];
    end
    else if (branch == 2'b11) begin
        branchf = flags[0];
    end
end
end
endmodule