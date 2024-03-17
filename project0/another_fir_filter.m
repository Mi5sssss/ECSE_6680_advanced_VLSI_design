% MATLAB code to design a 100-tap low-pass filter

% Filter specifications
numTaps = 100;
cutoffFrequency = 0.2; % Normalized cutoff frequency (0.2 corresponds to 0.2*pi rad/sample)
transitionStart = 0.2;
transitionStop = 0.23;
desiredAttenuationDb = 80;

% Design the filter using the FIR1 function with a Hamming window
coefficients = fir1(numTaps-1, cutoffFrequency, 'low', hamming(numTaps));

% Frequency response analysis
[H, F] = freqz(coefficients, 1, 1024, 'half');
amplitudeResponseDb = 20*log10(abs(H));

% Check if stopband attenuation meets the requirement
stopbandFreqs = F >= transitionStop * pi;
stopbandAttenuationDb = min(amplitudeResponseDb(stopbandFreqs));

% Plot the amplitude response
figure;
plot(F/pi, amplitudeResponseDb);
title('Amplitude Response of the Designed Filter');
xlabel('Normalized Frequency (\times\pi rad/sample)');
ylabel('Amplitude (dB)');
grid on;
hold on;
line([transitionStart transitionStart], ylim, 'Color', 'r', 'LineStyle', '--');
line([transitionStop transitionStop], ylim, 'Color', 'r', 'LineStyle', '--');
line(xlim, [-desiredAttenuationDb -desiredAttenuationDb], 'Color', 'g', 'LineStyle', '--');
hold off;

% If the filter meets the specifications, write the coefficients to a file
if stopbandAttenuationDb <= -desiredAttenuationDb
    fileId = fopen('coefficients.txt', 'w');
    fprintf(fileId, '%f\n', coefficients);
    fclose(fileId);
    disp(['Coefficients saved to coefficients.txt. Stopband attenuation: ', num2str(stopbandAttenuationDb), ' dB']);
else
    disp(['Stopband attenuation did not meet the requirement. Attenuation: ', num2str(stopbandAttenuationDb), ' dB']);
end
% Quantize the coefficients to Q15 format
coefficientsQ15 = round(coefficients * 32768);
% Clamp the values to ensure they fit in Q15 format
coefficientsQ15(coefficientsQ15 > 32767) = 32767;
coefficientsQ15(coefficientsQ15 < -32768) = -32768;

% Frequency response analysis of the quantized filter
[Hq, Fq] = freqz(coefficientsQ15/32768, 1, 1024, 'half');
amplitudeResponseDbQ15 = 20*log10(abs(Hq));

% Plot the amplitude response of the quantized filter
figure;
plot(Fq/pi, amplitudeResponseDbQ15);
title('Amplitude Response of the Quantized Filter');
xlabel('Normalized Frequency (\times\pi rad/sample)');
ylabel('Amplitude (dB)');
grid on;
hold on;
line([transitionStart transitionStart], ylim, 'Color', 'r', 'LineStyle', '--');
line([transitionStop transitionStop], ylim, 'Color', 'r', 'LineStyle', '--');
line(xlim, [-desiredAttenuationDb -desiredAttenuationDb], 'Color', 'g', 'LineStyle', '--');
hold off;

% Optionally, save the quantized coefficients to a file
fileIdQ15 = fopen('coefficients_q15.txt', 'w');
fprintf(fileIdQ15, '%d\n', coefficientsQ15);
fclose(fileIdQ15);
disp('Quantized coefficients saved to coefficients_q15.txt.');
