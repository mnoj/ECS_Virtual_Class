close all;
clc;
clear all;

% Parameters
fs = 16000;           % Sampling frequency (Hz)
t = 0:1/fs:0.005-1/fs;    % Time vector (5 ms)
f_signal = 997;      % Signal frequency (Hz)
V_min = 0;            % Minimum voltage (V)
V_max = 5;            % Maximum voltage (V)
N_bits = [6, 8];     % ADC bit resolutions

% Generate the continuous-time sine wave signal
signal = sin(2*pi*f_signal*t);

% Scale the signal to the range [0, 2] and remove negative values
scaled_signal = (signal - min(signal)) / (max(signal) - min(signal)) * (V_max - V_min);



% Loop over each ADC resolution
for N = N_bits
    % Calculate the number of quantization levels
    num_levels = 2^N;
    
    % Calculate the quantization step size (LSB)
    LSB = (V_max - V_min) / num_levels;
    
    % Quantize the signal
    quantized_signal = floor((scaled_signal - V_min) / LSB) * LSB + V_min;
    quantized_signal(quantized_signal>LSB*(2^N-1))=LSB*(2^N-1);
    % Calculate the quantization error
    quantization_error = scaled_signal - quantized_signal;
    
    % Compute the Signal-to-Quantization-Noise Ratio (SQNR)
    signal_power = mean(scaled_signal.^2);
    noise_power = mean(quantization_error.^2);
    SQNR = 10 * log10(signal_power / noise_power);

    figure(N)
    
    % Plot the original and quantized signals
    subplot(2, 1, 1);
    plot(t, scaled_signal, 'b', 'DisplayName', 'Original Signal');
    hold on;
    plot(t, quantized_signal, 'r--', 'DisplayName', sprintf('%d-bit Quantized Signal', N));
    title('Original and Quantized Signals');
    xlabel('Time (s)');
    ylabel('Amplitude (V)');
    legend;
    grid on;
    
    % Plot the quantization error
    subplot(2, 1, 2);
    plot(t, quantization_error, 'k', 'DisplayName', sprintf('Quantization Error (%d-bit)', N));
    title('Quantization Error');
    xlabel('Time (s)');
    ylabel('Amplitude (V)');
    legend;
    grid on;
    
    % Display the SQNR
    fprintf('%d-bit ADC: SQNR = %.2f dB\n', N, SQNR);


    %Calculate the error on specific points

    % Specify the time points (in seconds)
    time_points = [250e-6, 437.5e-6];  % Example: 0.1s and 0.5s

    % Convert time points to indices
    indices = round(time_points * fs) + 1;

    % Calculate the quantization errors at these points
    quantization_errors = scaled_signal(indices) - quantized_signal(indices);

    % Display the results
    for i = 1:length(time_points)
        fprintf('At t = %f s:\n', time_points(i));
        fprintf('  Original Signal Value: %.4f V\n', scaled_signal(indices(i)));
        fprintf('  Quantized Signal Value: %.4f V\n', quantized_signal(indices(i)));
        fprintf('  Quantization Error: %.4f V\n\n', quantization_errors(i));
    end


end
