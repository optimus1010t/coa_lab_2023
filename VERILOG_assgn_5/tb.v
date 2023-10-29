module testbench; 
    reg [31:0] x;
    reg rst1, rst2, clk;
    wire [31:0] y;

    Divby255 divby255(x, rst1, rst2, clk, y);

    always #5 clk = ~clk;

    initial begin 
        // 25500 -> 0000000000000000 0110001110011100
        // 2550 -> 0000000000000000 0000100111110110
        // 255 -> 0000000000000000 0000000011111111
        // clk = 0;
        // rst1 = 1; rst2 = 0; x = 16'b0;
        // #50 rst1 = 0; rst2 = 1; #10 x = 16'b0110001110011100;

        // #50 rst2 = 0; rst3 = 1; rst4 = 0; 
        // $display("y_MSB = %b", y);
        // #50 rst3 = 0; rst4 = 1;  
        // $display("y_LSB = %b", y);

        clk = 0; 

        #0 x=32'b10010111111111011110100110000000; rst1=1;

        // #100 rst3=0;rst4=1;
        #100 $monitor("y = %d",y);

        // #100 rst4=0;rst3=1;
        #100 $monitor("y = %d",y);

    $finish;

    end
endmodule 