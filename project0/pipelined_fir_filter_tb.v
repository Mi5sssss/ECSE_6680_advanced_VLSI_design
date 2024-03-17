`timescale 1ns / 1ps

module fir_filter_tb;

reg clk, rst;
reg signed [15:0] data_in;
wire signed [31:0] data_out;

fir_filter uut (
    .clk(clk),
    .rst(rst),
    .data_in(data_in),
    .data_out(data_out)
);

// Clock generation
initial begin
    clk = 0;
    forever #5 clk = ~clk; // 100MHz clock
end

// Apply a variety of test cases
initial begin
    rst = 1; data_in = 0;
    #10 rst = 0; // Release reset

    // Case 1: Step function
    #20 data_in = 16'sd32767; // Max positive value for 16-bit signed
    #20 data_in = 16'sd0;
    #20 data_in = -16'sd32768; // Max negative value for 16-bit signed
    #20 data_in = 16'sd0;

    // Case 2: Sinusoidal input
    repeat (50) begin // Generate 50 cycles of a sine wave
        data_in = $rtoi($sin($realtime*2*3.14159*1e-9)*32767); // 1Hz sine wave
        #10; // Sampling rate of 100MHz
    end

    // Case 3: Random noise
    repeat (100) begin // Generate 100 samples of random noise
        data_in = $random % 32768; // Random value between 0 and 32767
        #10; // Sampling rate of 100MHz
    end

    // Case 4: Impulse
    data_in = 16'sd32767;
    #10 data_in = 16'sd0;
    repeat (49) #10; // Wait for the filter to settle

    // Finish simulation
    $finish;
end

// Monitor changes to certain signals
initial begin
    $monitor("Time = %t, Reset = %b, Input = %d, Output = %d", $time, rst, data_in, data_out);
end

endmodule
