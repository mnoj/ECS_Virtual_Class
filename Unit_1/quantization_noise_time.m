close all;
clc;
clear all;

% Parameters
fs = 32000;              % Sampling frequency in Hz (32 kHz)
t = 0:1/fs:0.005-1/fs;   % Time vector for 5 ms duration (sampling interval)
f_signal = 997;          % Signal frequency in Hz (997 Hz sine wave)
V_min = -2.5;            % Minimum voltage (V) for scaling
V_max = 2.5;             % Maximum voltage (V) for scaling
N_bits = [3, 8];         % ADC bit resolutions (3-bit and 8-bit resolutions)

% Generate the continuous-time sine wave signal with 2.5 V amplitude
signal = 2.5 * sin(2 * pi * f_signal * t);

% Loop through each ADC resolution specified in N_bits
for N = N_bits
    % Calculate the total number of quantization levels based on the bit depth
    num_levels = 2^N;
    
    % Calculate the quantization step size (Least Significant Bit, LSB)
    LSB = (V_max - V_min) / num_levels;
    
    % Perform uniform quantization by determining the quantization indices
    quantized_indices = floor((signal - V_min) / LSB);  % Calculate the quantization index for each sample
    quantized_indices = min(quantized_indices, num_levels - 1); % Ensure indices do not exceed the maximum index
    quantized_signal = V_min + (quantized_indices + 0.5) * LSB; % Assign the quantized signal (mid-rise quantization)

    % Calculate the quantization error, which is the difference between the original and quantized signals
    quantization_error = signal - quantized_signal;
    
    % Calculate the power of the signal and the quantization noise using RMS (Root Mean Square)
    signal_power = rms(quantized_signal).^2;  % Compute the signal power (square of RMS value)
    noise_power = rms(quantization_error).^2;  % Compute the noise power (square of RMS value of error)
    
    % Compute the Signal-to-Quantization-Noise Ratio (SQNR) in decibels (dB)
    SQNR = 10 * log10(signal_power / noise_power);
    
    % Theoretical SQNR for uniform quantization, based on the bit depth (N)
    SQNR_theoretical = 6.02 * N + 1.76;  % Theoretical SQNR calculated using the bit depth formula

    % Create a new figure for plotting results for each bit resolution
    figure(N)
    
    % Plot the original (scaled) and quantized signals in the first subplot
    subplot(3, 1, 1);
    plot(t, signal, 'b', 'DisplayName', 'Original Signal');  % Plot the original sine wave
    hold on;
    stem(t, quantized_signal, 'r--', 'DisplayName', sprintf('%d-bit Quantized Signal', N), 'MarkerSize', 3);  % Plot the quantized signal
    title('Original and Quantized Signals');  % Title for the plot
    xlabel('Time (s)');  % X-axis label (Time in seconds)
    ylabel('Amplitude (V)');  % Y-axis label (Voltage in volts)
    legend;  % Display the legend
    grid on;  % Enable grid on the plot
    
    % Plot the quantization error in the second subplot
    subplot(3, 1, 2);
    plot(t, quantization_error, 'k', 'DisplayName', sprintf('Quantization Error (%d-bit)', N));  % Plot quantization error
    title('Quantization Error');  % Title for the plot
    xlabel('Time (s)');  % X-axis label (Time in seconds)
    ylabel('Amplitude (V)');  % Y-axis label (Voltage in volts)
    legend;  % Display the legend
    grid on;  % Enable grid on the plot
    
    % Compute and plot the FFT of the quantized signal in the third subplot
    N_fft = length(quantized_signal);  % Length of the signal
    f = (-fs/2:fs/N_fft:fs/2-fs/N_fft);  % Frequency vector for plotting FFT
    
    % Compute the FFT of the quantized signal and shift zero frequency to center
    quantized_signal_fft = fftshift(abs(fft(quantized_signal)))/length(quantized_signal);
    
    subplot(3, 1, 3);
    plot(f, quantized_signal_fft);  % Plot the magnitude of the FFT
    title('FFT of Quantized Signal');
    xlabel('Frequency (Hz)');  % X-axis label (Frequency in Hz)
    ylabel('Magnitude');  % Y-axis label (Magnitude)
    grid on;  % Enable grid on the plot

    % SNR Calculation in the 0-2 kHz bandwidth
    % Find indices corresponding to 0 Hz and 2 kHz in the frequency vector
    f_min = -8000;  % Min frequency in Hz
    f_max = 8000;  % Max frequency in Hz (2 kHz)
    BW=f_max-f_min;
    signal_band_indices = find(f >= f_min & f <= f_max);  % Indices of signal bandwidth (0-2 kHz)

    N_FFT = length(quantized_signal);     % Number of sample
    signal_fft=fft(quantized_signal);
    noise_fft=fft(quantization_error);

    signal_freq_power = rms(abs(signal_fft))^2;  % Signal power (RMS value squared, only positive frequencies)
    %noise_power = rms(abs(noise_fft))^2;  % Noise power (RMS value squared, only positive frequencies)

    noise_power = sum(abs(noise_fft(signal_band_indices)).^2)/N_FFT;  % Noise power (RMS value squared, only positive frequencies)

    % Calculate the SNR in the 0-2 kHz bandwidth
    SNR_bandwidth = 10 * log10(signal_freq_power / noise_power);
    
    % Display the SNR for the 0-2 kHz bandwidth
    fprintf('Measured %d-bit ADC: SQNR = %.2f dB\n', N, SQNR);
    fprintf('Theoretical SQNR: %.2f dB\n', SQNR_theoretical);
    fprintf('Theoretical SQNR  proccess gain : %.2f dB\n', SQNR_theoretical+10*log10((fs/2)/(BW/2))); % We also use negative frequencies
    fprintf('Measured %d-bit ADC: SNR (0-2 kHz) = %.2f dB\n', N, SNR_bandwidth);

    % Analyze the quantization error at specific time points

    % Specify the time points (in seconds) for error analysis
    time_points = [437.5e-6];  % Example time points: 437.5 µs (0.4375 ms)

    % Convert the time points to sample indices
    indices = round(time_points * fs) + 1;  % Convert time to sample index (1-based indexing in MATLAB)

    % Calculate the quantization errors at the specified sample indices
    quantization_errors = signal(indices) - quantized_signal(indices);

    % Display the quantization error at each specified time point
    for i = 1:length(time_points)
        fprintf('At t = %f s:\n', time_points(i));
        fprintf('  Original Signal Value: %.4f V\n', signal(indices(i)));  % Original signal value at the time point
        fprintf('  Quantized Signal Value: %.4f V\n', quantized_signal(indices(i)));  % Quantized signal value at the time point
        fprintf('  Quantization Error: %.4f V\n\n', quantization_errors(i));  % Quantization error at the time poin
    end
    fprintf("-------------------------------------------\n \n");
end
