close all;

% Define signal parameters
bits = 4;  
fundamental = 900e3;  % Frequency of the sine wave (900 kHz)
sampling_rate = 16e6;  % Sampling rate (at least ten times the fundamental)
period = 1 / fundamental;  % Period of the sine wave
num_periods = 60;  % Number of periods to display

% Time vector for 50 periods of the sine wave
t = 0:1/sampling_rate:num_periods*period;  % 50 periods (for better visualization)

% Continuous signal (sinusoidal) without quantization
x_double = 1 * sin(2 * pi * fundamental * t);  % Amplitude scaled to 1

% Function for quantization that only outputs positive values
quantize_signal = @(x, bits) round((x + 1) * (2^bits - 1) / 2) / (2^bits - 1);  % Mapped to [0, 1]

% Quantize the signal using the defined function (map to [0, 1] for positive values)
x_quantized = quantize_signal(x_double, bits);  % Using 1 bit for quantization

% Plot the original and quantized signals
figure;
subplot(2, 1, 1);
plot(t, x_double);
title('Original Signal (Continuous)');
xlabel('Time (seconds)');
ylabel('Amplitude');

subplot(2, 1, 2);
plot(t, x_quantized, 'LineWidth', 2);  % Plot the quantized signal as a line
title('Quantized Signal (1 bit) - Positive Values');
xlabel('Time (seconds)');
ylabel('Amplitude');

% Compute the FFT of both signals
n = length(t);  % Number of samples
f = (-n/2:n/2-1)*(sampling_rate/n);  % Frequency axis (from -fs/2 to fs/2)

% FFT of the original signal
X_double_fft = fft(x_double);
% FFT of the quantized signal
X_fft = fft(x_quantized);

% Shift the FFT to center it at 0 Hz
X_double_fft = fftshift(X_double_fft);
X_fft = fftshift(X_fft);

% Scale the FFT to normalize the magnitude
X_double_fft = abs(X_double_fft/n);
X_fft = abs(X_fft/n);

% Convert to dB (in logarithmic scale)
X_double_fft_dB = 20*log10(X_double_fft + eps);  % Adding eps to avoid log(0)
X_fft_dB = 20*log10(X_fft + eps);

% Normalize the x-axis to MHz
f_MHz = f / 1e6;  % Convert frequency axis to MHz

% Plot the FFT of both signals in dB with normalized frequency axis in MHz
figure;
subplot(2, 1, 1);
plot(f_MHz, X_double_fft_dB);
title('FFT of Original Signal (Continuous) in dB');
xlabel('Frequency (MHz)');
ylabel('Magnitude (dB)');

subplot(2, 1, 2);
plot(f_MHz, X_fft_dB);
title('FFT of Quantized Signal (Discrete) in dB');
xlabel('Frequency (MHz)');
ylabel('Magnitude (dB)');
% Set the y-axis limit for the second subplot
ylim([-100 0]);  % Set y-axis limits from -200 dB to 0 dB