`timescale 1ns/1ps

module adaptive_pmic_tb;

    reg clk;
    reg rst;
    reg [3:0] channel_request;
    reg [2:0] mode;
    wire [3:0] channel_enable;

    adaptive_pmic dut (
        .clk(clk),
        .rst(rst),
        .channel_request(channel_request),
        .mode(mode),
        .channel_enable(channel_enable)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("adaptive_pmic.vcd");
        $dumpvars(0, adaptive_pmic_tb);

        clk = 1'b0;
        rst = 1'b1;
        channel_request = 4'b0000;
        mode = 3'b000;

        #12 rst = 1'b0;

        // Test 1: All channels active
        mode = 3'b000;
        channel_request = 4'b1111;
        #10;

        // Test 2: Channels 1 and 3 active
        channel_request = 4'b0101;
        #10;

        // Test 3: Only channel 2 active
        channel_request = 4'b0010;
        #10;

        // Test 4: Standby mode passes requested channels
        mode = 3'b010;
        channel_request = 4'b1010;
        #10;

        // Test 5: Sleep disables all channels in this first version
        mode = 3'b011;
        #10;

        // Test 6: Power-off disables all channels
        mode = 3'b100;
        #10;

        // Test 7: Return to active mode
        mode = 3'b000;
        channel_request = 4'b1111;
        #10;

        $finish;
    end

    initial begin
        $monitor("Time=%0t | Mode=%b | Request=%b | Enable=%b",
                 $time, mode, channel_request, channel_enable);
    end

endmodule
