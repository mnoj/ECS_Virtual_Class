%% The original code was taken from Software-Defined Radio for Engineers, by Travis F. Collins, Robin Getz, Di Pu, and Alexander M. Wyglinski, 2018, ISBN-13: 978-1-63081-457-1.


clear; clc; close all;

% ==============================
% Plot Parameters
% ==============================
txtsize = 10;
ltxtsize = 9;
pwidth = 4;
pheight = 4;
pxoffset = 0.65;
pyoffset = 0.5;
markersize = 5;

% ==============================
% Sampling and Signal Parameters
% ==============================
deltat = 1e-8;   % Time step (10 ns)
fs = 1/deltat;   % Sampling frequency (100 MHz)
t = 0:deltat:1e-5-deltat; % Time vector (10 us duration)
fundamental = 3959297; % Fundamental frequency (3.96 MHz), chosen as a prime number to reduce harmonics

% ==============================
% Case 1: Original (64-bit Floating Point Signal) Signal
% ==============================
x = sin(2 * pi * fundamental * t); % Generate a pure sine wave
sfdr_value = sfdr(x, fs); % Compute SFDR

% Compute SNR for the original signal (floating-point precision, no quantization noise)
snr_value = snr(x, fs);
fprintf('64-bit Floating Point Signal - SFDR: %.2f dB, SNR: %.2f dB\n', sfdr_value, snr_value);

% Plot SFDR Spectrum
figure(1);
sfdr(x, fs);
ylim([-400 10]);
title('SFDR Spectrum - Original Signal');

% Plot Time-Domain Signal
figure(2);
plot(t * 1e6, x);
xlabel('Time (\mus)');
ylabel('Amplitude');
ylim([-1.1 1.1]');
title('Time Domain - Original Signal');

% ==============================
% Case 2: Quantized Signal (11-bit ADC)
% ==============================
bits = 2^11; % 11-bit ADC (2048 levels, signed representation)
x_quantized = round(bits * sin(2 * pi * fundamental * t)) / bits; % Quantization

sfdr_value = sfdr(x_quantized, fs); % Compute SFDR
snr_value = snr(x_quantized, fs); % Compute SNR
fprintf('Quantized Signal (11-bit) - SFDR: %.2f dB, SNR: %.2f dB\n', sfdr_value, snr_value);

% Plot SFDR Spectrum
figure(3);
sfdr(x_quantized, fs);
ylim([-400 10]);
title('SFDR Spectrum - Quantized Signal');

% Plot Time-Domain Signal
figure(4);
plot(t * 1e6, x_quantized);
xlabel('Time (\mus)');
ylabel('Amplitude');
ylim([-1.1 1.1]');
title('Time Domain - Quantized Signal');

% ==============================
% Case 3: Quantized Signal with FFT Gain
% ==============================
% Extending time duration increases FFT resolution, reducing noise floor
t = 0:deltat:1e-4-deltat; % Increase signal duration to 100 us
x_quantized = round(bits * sin(2 * pi * fundamental * t)) / bits;

sfdr_value = sfdr(x_quantized, fs); % Compute SFDR
snr_value = snr(x_quantized, fs); % Compute SNR
fprintf('Quantized Signal (11-bit) with FFT Gain - SFDR: %.2f dB, SNR: %.2f dB\n', sfdr_value, snr_value);

% Plot SFDR Spectrum
figure(5);
sfdr(x_quantized, fs);
ylim([-400 10]);
title('SFDR Spectrum - Quantized Signal with FFT Gain');

% Plot Time-Domain Signal
figure(6);
plot(t * 1e6, x_quantized);
xlabel('Time (\mus)');
ylabel('Amplitude');
ylim([-1.1 1.1]');
title('Time Domain - Quantized Signal with FFT Gain');

% ==============================
% Case 4: Correlated Quantized Signal
% ==============================
% When the fundamental frequency is an integer multiple of the sampling rate,
% the SFDR spectrum changes due to harmonic interference.
fundamental = 4000000; % 4 MHz (closer to an integer fraction of fs)
x_quantized_high_freq = round(bits * sin(2 * pi * fundamental * t)) / bits;

sfdr_value = sfdr(x_quantized_high_freq, fs); % Compute SFDR
snr_value = snr(x_quantized_high_freq, fs); % Compute SNR
fprintf('Quantized Signal (Correlated) - SFDR: %.2f dB, SNR: %.2f dB\n', sfdr_value, snr_value);

% Plot SFDR Spectrum
figure(7);
sfdr(x_quantized_high_freq, fs);
ylim([-400 10]);
title('SFDR Spectrum - Quantized Signal with Correlated Frequency');

% Plot Time-Domain Signal
figure(8);
plot(t * 1e6, x_quantized_high_freq);
xlabel('Time (\mus)');
ylabel('Amplitude');
ylim([-1.1 1.1]');
title('Time Domain - Quantized Signal with Correlated Frequency');

% ==============================
% Case 5: Quantized Signal with Noise Dithering
% ==============================
% Adding a small amount of random noise (dithering) can improve SFDR
% by reducing harmonic distortion caused by quantization.
ran = rand(1, length(t)) - 0.5; % Uniformly distributed noise [-0.5, 0.5]
x_quantized_noise = round(bits * sin(2 * pi * fundamental * t) + ran) / bits;

sfdr_value = sfdr(x_quantized_noise, fs); % Compute SFDR
snr_value = snr(x_quantized_noise, fs); % Compute SNR
fprintf('Quantized Signal (11-bit with Noise) - SFDR: %.2f dB, SNR: %.2f dB\n', sfdr_value, snr_value);

% Plot SFDR Spectrum
figure(9);
sfdr(x_quantized_noise, fs);
ylim([-400 10]);
title('SFDR Spectrum - Quantized Signal with Noise');

% Plot Time-Domain Signal
figure(10);
plot(t * 1e6, x_quantized_noise);
xlabel('Time (\mus)');
ylabel('Amplitude');
ylim([-1.1 1.1]');
title('Time Domain - Quantized Signal with Noise');
