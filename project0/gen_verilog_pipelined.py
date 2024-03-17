# Pipelined FIR Filter
coefficients_path = "coefficients.txt"

with open(coefficients_path, "r") as file:
    coefficients = [float(line.strip()) for line in file]

formatted_coeffs = ["16'sd" + str(int(coeff * 32768)) if coeff >= 0 else "-16'sd" + str(abs(int(coeff * 32768))) for coeff in coefficients]

verilog_code = """
module pipelined_fir_filter (
    input wire clk,
    input wire rst,
    input wire signed [15:0] data_in,
    output reg signed [31:0] data_out
);

localparam TAPS = %d;
""" % (len(formatted_coeffs))

for i, coeff in enumerate(formatted_coeffs):
    verilog_code += "localparam signed [15:0] COEFF_%d = %s;\n" % (i, coeff)

# Add shift register and pipeline stage declarations
verilog_code += "\nreg signed [15:0] shift_reg[TAPS-1:0];\n"
for i in range(len(formatted_coeffs)):
    verilog_code += "reg signed [31:0] pipe_stage_%d[0:0]; // Pipeline stage for COEFF_%d\n" % (i, i)

verilog_code += "\ninteger i;\n"

verilog_code += """
always @(posedge clk) begin
    if (rst) begin
        // Reset logic
        for (i = 0; i < TAPS; i = i + 1) begin
            shift_reg[i] <= 0;
        end
        data_out <= 0;
    end else begin
        // Shift the input data through the register
        for (i = TAPS-1; i > 0; i = i - 1) begin
            shift_reg[i] <= shift_reg[i - 1];
        end
        shift_reg[0] <= data_in;

        // Pipeline processing
"""

for i in range(len(formatted_coeffs)):
    verilog_code += "        pipe_stage_%d[0] = shift_reg[%d] * COEFF_%d;\n" % (i, i, i)

verilog_code += "        data_out = 0;\n"
for i in range(len(formatted_coeffs)):
    verilog_code += "        data_out = data_out + pipe_stage_%d[0];\n" % i

verilog_code += """
    end
end

endmodule
"""

with open("pipelined_fir_filter.v", "w") as file:
    file.write(verilog_code)

print("Pipelined Verilog code has been generated and saved to pipelined_fir_filter.v.")
