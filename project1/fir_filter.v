
module fir_filter (
    input wire clk,                 // Clock signal
    input wire rst,                 // Reset signal
    input wire signed [15:0] data_in, // 16-bit signed input data
    output reg signed [31:0] data_out // 32-bit signed output data
);

// Number of taps
localparam TAPS = 100;
localparam signed [15:0] COEFF_0 = -16'sd5;
localparam signed [15:0] COEFF_1 = -16'sd14;
localparam signed [15:0] COEFF_2 = -16'sd18;
localparam signed [15:0] COEFF_3 = -16'sd16;
localparam signed [15:0] COEFF_4 = -16'sd6;
localparam signed [15:0] COEFF_5 = 16'sd7;
localparam signed [15:0] COEFF_6 = 16'sd21;
localparam signed [15:0] COEFF_7 = 16'sd30;
localparam signed [15:0] COEFF_8 = 16'sd28;
localparam signed [15:0] COEFF_9 = 16'sd12;
localparam signed [15:0] COEFF_10 = -16'sd13;
localparam signed [15:0] COEFF_11 = -16'sd41;
localparam signed [15:0] COEFF_12 = -16'sd57;
localparam signed [15:0] COEFF_13 = -16'sd52;
localparam signed [15:0] COEFF_14 = -16'sd22;
localparam signed [15:0] COEFF_15 = 16'sd25;
localparam signed [15:0] COEFF_16 = 16'sd75;
localparam signed [15:0] COEFF_17 = 16'sd103;
localparam signed [15:0] COEFF_18 = 16'sd93;
localparam signed [15:0] COEFF_19 = 16'sd39;
localparam signed [15:0] COEFF_20 = -16'sd44;
localparam signed [15:0] COEFF_21 = -16'sd127;
localparam signed [15:0] COEFF_22 = -16'sd174;
localparam signed [15:0] COEFF_23 = -16'sd155;
localparam signed [15:0] COEFF_24 = -16'sd65;
localparam signed [15:0] COEFF_25 = 16'sd72;
localparam signed [15:0] COEFF_26 = 16'sd207;
localparam signed [15:0] COEFF_27 = 16'sd281;
localparam signed [15:0] COEFF_28 = 16'sd249;
localparam signed [15:0] COEFF_29 = 16'sd104;
localparam signed [15:0] COEFF_30 = -16'sd114;
localparam signed [15:0] COEFF_31 = -16'sd327;
localparam signed [15:0] COEFF_32 = -16'sd444;
localparam signed [15:0] COEFF_33 = -16'sd394;
localparam signed [15:0] COEFF_34 = -16'sd165;
localparam signed [15:0] COEFF_35 = 16'sd182;
localparam signed [15:0] COEFF_36 = 16'sd526;
localparam signed [15:0] COEFF_37 = 16'sd720;
localparam signed [15:0] COEFF_38 = 16'sd648;
localparam signed [15:0] COEFF_39 = 16'sd277;
localparam signed [15:0] COEFF_40 = -16'sd312;
localparam signed [15:0] COEFF_41 = -16'sd929;
localparam signed [15:0] COEFF_42 = -16'sd1321;
localparam signed [15:0] COEFF_43 = -16'sd1250;
localparam signed [15:0] COEFF_44 = -16'sd570;
localparam signed [15:0] COEFF_45 = 16'sd704;
localparam signed [15:0] COEFF_46 = 16'sd2387;
localparam signed [15:0] COEFF_47 = 16'sd4154;
localparam signed [15:0] COEFF_48 = 16'sd5622;
localparam signed [15:0] COEFF_49 = 16'sd6454;
localparam signed [15:0] COEFF_50 = 16'sd6454;
localparam signed [15:0] COEFF_51 = 16'sd5622;
localparam signed [15:0] COEFF_52 = 16'sd4154;
localparam signed [15:0] COEFF_53 = 16'sd2387;
localparam signed [15:0] COEFF_54 = 16'sd704;
localparam signed [15:0] COEFF_55 = -16'sd570;
localparam signed [15:0] COEFF_56 = -16'sd1250;
localparam signed [15:0] COEFF_57 = -16'sd1321;
localparam signed [15:0] COEFF_58 = -16'sd929;
localparam signed [15:0] COEFF_59 = -16'sd312;
localparam signed [15:0] COEFF_60 = 16'sd277;
localparam signed [15:0] COEFF_61 = 16'sd648;
localparam signed [15:0] COEFF_62 = 16'sd720;
localparam signed [15:0] COEFF_63 = 16'sd526;
localparam signed [15:0] COEFF_64 = 16'sd182;
localparam signed [15:0] COEFF_65 = -16'sd165;
localparam signed [15:0] COEFF_66 = -16'sd394;
localparam signed [15:0] COEFF_67 = -16'sd444;
localparam signed [15:0] COEFF_68 = -16'sd327;
localparam signed [15:0] COEFF_69 = -16'sd114;
localparam signed [15:0] COEFF_70 = 16'sd104;
localparam signed [15:0] COEFF_71 = 16'sd249;
localparam signed [15:0] COEFF_72 = 16'sd281;
localparam signed [15:0] COEFF_73 = 16'sd207;
localparam signed [15:0] COEFF_74 = 16'sd72;
localparam signed [15:0] COEFF_75 = -16'sd65;
localparam signed [15:0] COEFF_76 = -16'sd155;
localparam signed [15:0] COEFF_77 = -16'sd174;
localparam signed [15:0] COEFF_78 = -16'sd127;
localparam signed [15:0] COEFF_79 = -16'sd44;
localparam signed [15:0] COEFF_80 = 16'sd39;
localparam signed [15:0] COEFF_81 = 16'sd93;
localparam signed [15:0] COEFF_82 = 16'sd103;
localparam signed [15:0] COEFF_83 = 16'sd75;
localparam signed [15:0] COEFF_84 = 16'sd25;
localparam signed [15:0] COEFF_85 = -16'sd22;
localparam signed [15:0] COEFF_86 = -16'sd52;
localparam signed [15:0] COEFF_87 = -16'sd57;
localparam signed [15:0] COEFF_88 = -16'sd41;
localparam signed [15:0] COEFF_89 = -16'sd13;
localparam signed [15:0] COEFF_90 = 16'sd12;
localparam signed [15:0] COEFF_91 = 16'sd28;
localparam signed [15:0] COEFF_92 = 16'sd30;
localparam signed [15:0] COEFF_93 = 16'sd21;
localparam signed [15:0] COEFF_94 = 16'sd7;
localparam signed [15:0] COEFF_95 = -16'sd6;
localparam signed [15:0] COEFF_96 = -16'sd16;
localparam signed [15:0] COEFF_97 = -16'sd18;
localparam signed [15:0] COEFF_98 = -16'sd14;
localparam signed [15:0] COEFF_99 = -16'sd5;

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
        temp_data_out = temp_data_out + shift_reg[0] * COEFF_0;
        temp_data_out = temp_data_out + shift_reg[1] * COEFF_1;
        temp_data_out = temp_data_out + shift_reg[2] * COEFF_2;
        temp_data_out = temp_data_out + shift_reg[3] * COEFF_3;
        temp_data_out = temp_data_out + shift_reg[4] * COEFF_4;
        temp_data_out = temp_data_out + shift_reg[5] * COEFF_5;
        temp_data_out = temp_data_out + shift_reg[6] * COEFF_6;
        temp_data_out = temp_data_out + shift_reg[7] * COEFF_7;
        temp_data_out = temp_data_out + shift_reg[8] * COEFF_8;
        temp_data_out = temp_data_out + shift_reg[9] * COEFF_9;
        temp_data_out = temp_data_out + shift_reg[10] * COEFF_10;
        temp_data_out = temp_data_out + shift_reg[11] * COEFF_11;
        temp_data_out = temp_data_out + shift_reg[12] * COEFF_12;
        temp_data_out = temp_data_out + shift_reg[13] * COEFF_13;
        temp_data_out = temp_data_out + shift_reg[14] * COEFF_14;
        temp_data_out = temp_data_out + shift_reg[15] * COEFF_15;
        temp_data_out = temp_data_out + shift_reg[16] * COEFF_16;
        temp_data_out = temp_data_out + shift_reg[17] * COEFF_17;
        temp_data_out = temp_data_out + shift_reg[18] * COEFF_18;
        temp_data_out = temp_data_out + shift_reg[19] * COEFF_19;
        temp_data_out = temp_data_out + shift_reg[20] * COEFF_20;
        temp_data_out = temp_data_out + shift_reg[21] * COEFF_21;
        temp_data_out = temp_data_out + shift_reg[22] * COEFF_22;
        temp_data_out = temp_data_out + shift_reg[23] * COEFF_23;
        temp_data_out = temp_data_out + shift_reg[24] * COEFF_24;
        temp_data_out = temp_data_out + shift_reg[25] * COEFF_25;
        temp_data_out = temp_data_out + shift_reg[26] * COEFF_26;
        temp_data_out = temp_data_out + shift_reg[27] * COEFF_27;
        temp_data_out = temp_data_out + shift_reg[28] * COEFF_28;
        temp_data_out = temp_data_out + shift_reg[29] * COEFF_29;
        temp_data_out = temp_data_out + shift_reg[30] * COEFF_30;
        temp_data_out = temp_data_out + shift_reg[31] * COEFF_31;
        temp_data_out = temp_data_out + shift_reg[32] * COEFF_32;
        temp_data_out = temp_data_out + shift_reg[33] * COEFF_33;
        temp_data_out = temp_data_out + shift_reg[34] * COEFF_34;
        temp_data_out = temp_data_out + shift_reg[35] * COEFF_35;
        temp_data_out = temp_data_out + shift_reg[36] * COEFF_36;
        temp_data_out = temp_data_out + shift_reg[37] * COEFF_37;
        temp_data_out = temp_data_out + shift_reg[38] * COEFF_38;
        temp_data_out = temp_data_out + shift_reg[39] * COEFF_39;
        temp_data_out = temp_data_out + shift_reg[40] * COEFF_40;
        temp_data_out = temp_data_out + shift_reg[41] * COEFF_41;
        temp_data_out = temp_data_out + shift_reg[42] * COEFF_42;
        temp_data_out = temp_data_out + shift_reg[43] * COEFF_43;
        temp_data_out = temp_data_out + shift_reg[44] * COEFF_44;
        temp_data_out = temp_data_out + shift_reg[45] * COEFF_45;
        temp_data_out = temp_data_out + shift_reg[46] * COEFF_46;
        temp_data_out = temp_data_out + shift_reg[47] * COEFF_47;
        temp_data_out = temp_data_out + shift_reg[48] * COEFF_48;
        temp_data_out = temp_data_out + shift_reg[49] * COEFF_49;
        temp_data_out = temp_data_out + shift_reg[50] * COEFF_50;
        temp_data_out = temp_data_out + shift_reg[51] * COEFF_51;
        temp_data_out = temp_data_out + shift_reg[52] * COEFF_52;
        temp_data_out = temp_data_out + shift_reg[53] * COEFF_53;
        temp_data_out = temp_data_out + shift_reg[54] * COEFF_54;
        temp_data_out = temp_data_out + shift_reg[55] * COEFF_55;
        temp_data_out = temp_data_out + shift_reg[56] * COEFF_56;
        temp_data_out = temp_data_out + shift_reg[57] * COEFF_57;
        temp_data_out = temp_data_out + shift_reg[58] * COEFF_58;
        temp_data_out = temp_data_out + shift_reg[59] * COEFF_59;
        temp_data_out = temp_data_out + shift_reg[60] * COEFF_60;
        temp_data_out = temp_data_out + shift_reg[61] * COEFF_61;
        temp_data_out = temp_data_out + shift_reg[62] * COEFF_62;
        temp_data_out = temp_data_out + shift_reg[63] * COEFF_63;
        temp_data_out = temp_data_out + shift_reg[64] * COEFF_64;
        temp_data_out = temp_data_out + shift_reg[65] * COEFF_65;
        temp_data_out = temp_data_out + shift_reg[66] * COEFF_66;
        temp_data_out = temp_data_out + shift_reg[67] * COEFF_67;
        temp_data_out = temp_data_out + shift_reg[68] * COEFF_68;
        temp_data_out = temp_data_out + shift_reg[69] * COEFF_69;
        temp_data_out = temp_data_out + shift_reg[70] * COEFF_70;
        temp_data_out = temp_data_out + shift_reg[71] * COEFF_71;
        temp_data_out = temp_data_out + shift_reg[72] * COEFF_72;
        temp_data_out = temp_data_out + shift_reg[73] * COEFF_73;
        temp_data_out = temp_data_out + shift_reg[74] * COEFF_74;
        temp_data_out = temp_data_out + shift_reg[75] * COEFF_75;
        temp_data_out = temp_data_out + shift_reg[76] * COEFF_76;
        temp_data_out = temp_data_out + shift_reg[77] * COEFF_77;
        temp_data_out = temp_data_out + shift_reg[78] * COEFF_78;
        temp_data_out = temp_data_out + shift_reg[79] * COEFF_79;
        temp_data_out = temp_data_out + shift_reg[80] * COEFF_80;
        temp_data_out = temp_data_out + shift_reg[81] * COEFF_81;
        temp_data_out = temp_data_out + shift_reg[82] * COEFF_82;
        temp_data_out = temp_data_out + shift_reg[83] * COEFF_83;
        temp_data_out = temp_data_out + shift_reg[84] * COEFF_84;
        temp_data_out = temp_data_out + shift_reg[85] * COEFF_85;
        temp_data_out = temp_data_out + shift_reg[86] * COEFF_86;
        temp_data_out = temp_data_out + shift_reg[87] * COEFF_87;
        temp_data_out = temp_data_out + shift_reg[88] * COEFF_88;
        temp_data_out = temp_data_out + shift_reg[89] * COEFF_89;
        temp_data_out = temp_data_out + shift_reg[90] * COEFF_90;
        temp_data_out = temp_data_out + shift_reg[91] * COEFF_91;
        temp_data_out = temp_data_out + shift_reg[92] * COEFF_92;
        temp_data_out = temp_data_out + shift_reg[93] * COEFF_93;
        temp_data_out = temp_data_out + shift_reg[94] * COEFF_94;
        temp_data_out = temp_data_out + shift_reg[95] * COEFF_95;
        temp_data_out = temp_data_out + shift_reg[96] * COEFF_96;
        temp_data_out = temp_data_out + shift_reg[97] * COEFF_97;
        temp_data_out = temp_data_out + shift_reg[98] * COEFF_98;
        temp_data_out = temp_data_out + shift_reg[99] * COEFF_99;

        // Update data_out at the end of accumulation using non-blocking assignment
        data_out <= temp_data_out;
    end
end

endmodule
