module fir_filter #(
    parameter INTEGER_BIT_WIDTH = 16, // Define the integer bit width
    parameter DECIMAL_BIT_WIDTH = 16, // Define the decimal bit width
    parameter COEFFICIENTS_WIDTH = 100 // Number of coefficients
)(
    input wire clk, // Clock signal
    input wire rst, // Reset signal
    input wire signed [INTEGER_BIT_WIDTH+DECIMAL_BIT_WIDTH-1:0] data_in, // Input data
    output reg signed [INTEGER_BIT_WIDTH+DECIMAL_BIT_WIDTH-1:0] data_out // Output data
);

// Coefficient array - Replace with actual quantized coefficients from MATLAB
localparam signed [INTEGER_BIT_WIDTH+DECIMAL_BIT_WIDTH-1:0] COEFFICIENTS[COEFFICIENTS_WIDTH-1:0] = '{ /* ... */ };

// Internal signal declarations
reg signed [INTEGER_BIT_WIDTH+DECIMAL_BIT_WIDTH-1:0] shift_reg[COEFFICIENTS_WIDTH-1:0];
wire signed [2*INTEGER_BIT_WIDTH+DECIMAL_BIT_WIDTH-1:0] mults[COEFFICIENTS_WIDTH-1:0];
reg signed [2*INTEGER_BIT_WIDTH+2*DECIMAL_BIT_WIDTH-2:0] accumulator;

// Pipelined stages for multiplication results
reg signed [2*INTEGER_BIT_WIDTH+DECIMAL_BIT_WIDTH-1:0] pipeline[COEFFICIENTS_WIDTH-1:0];

// FIR filter tap multiplication
integer i;
always @(posedge clk) begin
    if (rst) begin
        for (i = 0; i < COEFFICIENTS_WIDTH; i = i + 1) begin
            shift_reg[i] <= 0;
            pipeline[i] <= 0;
        end
        accumulator <= 0;
        data_out <= 0;
    end else begin
        // Shift the samples through the delay line
        shift_reg[0] <= data_in;
        for (i = 1; i < COEFFICIENTS_WIDTH; i = i + 1) begin
            shift_reg[i] <= shift_reg[i - 1];
        end
        
        // Multiplication of input samples by coefficients with pipelining
        for (i = 0; i < COEFFICIENTS_WIDTH; i = i + 1) begin
            pipeline[i] <= shift_reg[i] * COEFFICIENTS[i];
        end
        
        // Accumulate the multiplication results
        accumulator <= 0; // Reset the accumulator at each clock cycle
        for (i = 0; i < COEFFICIENTS_WIDTH; i = i + 1) begin
            accumulator <= accumulator + pipeline[i];
        end
        
        // Output the final accumulated value with proper bit truncation to match output bit width
        data_out <= accumulator[2*INTEGER_BIT_WIDTH+2*DECIMAL_BIT_WIDTH-2:DECIMAL_BIT_WIDTH];
    end
end

endmodule


// module fir_filter (
//     input wire clk,                 // Clock signal
//     input wire rst,                 // Reset signal
//     input wire [15:0] data_in,      // 16-bit input data
//     output reg [31:0] data_out      // 32-bit output data (due to accumulation)
// );

// // Coefficient parameters - example values, replace with your actual coefficients
// parameter signed [15:0] COEFF_0 = 16'sh0A3D;
// parameter signed [15:0] COEFF_1 = 16'sh1B6E;
// // ... Add parameters for COEFF_2 to COEFF_98
// parameter signed [15:0] COEFF_99 = 16'sh07FA;

// // Internal signal for the delay line
// reg [15:0] shift_reg [0:99];

// // Multiply and accumulate
// reg [31:0] mult [0:99];  // Output of the multipliers
// reg [31:0] accumulator;  // Accumulator for the adder tree

// integer i;

// always @(posedge clk) begin
//     if (rst) begin
//         // Clear the shift register and accumulator on reset
//         accumulator <= 0;
//         for (i = 0; i < 100; i = i + 1) begin
//             shift_reg[i] <= 0;
//             mult[i] <= 0;
//         end
//         data_out <= 0;
//     end else begin
//         // Shift the input sample through the register
//         for (i = 99; i > 0; i = i - 1) begin
//             shift_reg[i] <= shift_reg[i - 1];
//         end
//         shift_reg[0] <= data_in;

//         // Multiply each tap by its coefficient
//         mult[0] <= shift_reg[0] * COEFF_0;
//         mult[1] <= shift_reg[1] * COEFF_1;
//         // ... Add multiplication for mult[2] to mult[98]
//         mult[99] <= shift_reg[99] * COEFF_99;

//         // Reset accumulator
//         accumulator <= 0;

//         // Accumulate the multiplication results
//         for (i = 0; i < 100; i = i + 1) begin
//             accumulator <= accumulator + mult[i];
//         end

//         // Output the accumulated result
//         data_out <= accumulator;
//     end
// end

// endmodule
