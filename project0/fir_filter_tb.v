`timescale 1ns / 1ps

module fir_filter_tb;

// Testbench uses the same bit widths as the FIR filter module
reg clk, rst;
reg signed [15:0] data_in;
wire signed [31:0] data_out;

// Instantiate the FIR filter module
fir_filter uut (
    .clk(clk),
    .rst(rst),
    .data_in(data_in),
    .data_out(data_out)
);

// Clock generation
initial begin
    clk = 0;
    forever #5 clk = ~clk; // Generate a clock with a period of 10 ns
end

// Test stimulus
initial begin
    // Initialize inputs
    rst = 1;
    data_in = 0;

    // Reset the system
    #10;
    rst = 0;

    // Apply test vectors
    #10 data_in = 16'sd1000; // Example input
    #10 data_in = 16'sd-1000; // Another example input
    #10 data_in = 16'sd500;
    #10 data_in = 16'sd-500;

    // Add more test inputs as needed
    // ...

    // Finish simulation
    #100;
    $finish;
end

// Optionally, monitor changes to certain signals
initial begin
    $monitor("Time = %t, Reset = %b, Input = %d, Output = %d", $time, rst, data_in, data_out);
end

endmodule
