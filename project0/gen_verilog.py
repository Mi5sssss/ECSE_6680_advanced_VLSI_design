# Direct Form FIR Filter
# Define the path to your coefficients file
coefficients_path = "coefficients.txt"  # Update this path as necessary

# Read and process the coefficients from the file
with open(coefficients_path, "r") as file:
    coefficients = [float(line.strip()) for line in file]

# Format coefficients to fixed-point representation suitable for Verilog
formatted_coeffs = []
for coeff in coefficients:
    fixed_point_value = int(coeff * 32768)  # Convert to Q15 format
    if coeff >= 0:
        formatted_coeff = "16'sd{}".format(fixed_point_value)
    else:
        formatted_coeff = "-16'sd{}".format(abs(fixed_point_value))
    formatted_coeffs.append(formatted_coeff)

# Begin constructing the Verilog module
verilog_code = """
module fir_filter (
    input wire clk,                 // Clock signal
    input wire rst,                 // Reset signal
    input wire signed [15:0] data_in, // 16-bit signed input data
    output reg signed [31:0] data_out // 32-bit signed output data
);

// Number of taps
localparam TAPS = {0};
""".format(len(formatted_coeffs))

# Add declarations for each coefficient
for i, coeff in enumerate(formatted_coeffs):
    verilog_code += "localparam signed [15:0] COEFF_{0} = {1};\n".format(i, coeff)

# Continue with the module logic and correct the multiply-accumulate loop
verilog_code += """
// Shift register for input samples
reg signed [15:0] shift_reg[TAPS-1:0];
reg signed [31:0] temp_data_out;  // Temporary variable for accumulation

// Multiply and accumulate
integer i;
always @(posedge clk) begin
    if (rst) begin
        // Clear the shift register and temporary accumulator
        for (i = 0; i < TAPS; i = i + 1) begin
            shift_reg[i] <= 0;
        end
        temp_data_out <= 0;
        data_out <= 0;
    end else begin
        // Shift the input sample through the register
        for (i = TAPS-1; i > 0; i = i - 1) begin
            shift_reg[i] <= shift_reg[i - 1];
        end
        shift_reg[0] <= data_in;

        // Initialize the accumulator at the start of each cycle
        temp_data_out = 0;
"""

# Correctly format the dynamic part for coefficient indexing within the multiply-accumulate operation
for i in range(len(formatted_coeffs)):
    verilog_code += "        temp_data_out = temp_data_out + shift_reg[{0}] * COEFF_{0};\n".format(i)

verilog_code += """
        // Update data_out at the end of accumulation using non-blocking assignment
        data_out <= temp_data_out;
    end
end

endmodule
"""

# Optionally, write the generated Verilog code to a file
with open("fir_filter.v", "w") as file:
    file.write(verilog_code)

print("Verilog code has been generated and saved to fir_filter.v.")
