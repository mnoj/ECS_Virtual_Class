% Parameters
X_min = 0;  % Minimum value of the analog signal
X_max = 5;  % Maximum value of the analog signal
N = 8;      % Number of bits

% Generate a sine wave input signal with offset
fs = 1000;   % Sampling frequency
t = linspace(0, 1, fs);  % Time vector (1 second duration)
x = 2.5*sin(2 * pi * 5 * t)+2.5; % Shifted sine wave to be in [0,5]




% Quantization parameters
L = 2^N;                     % Number of quantization levels
Delta = (X_max - X_min) / L;  %  LSB

% Perform uniform quantization
quantized_indices = floor((x - X_min) / Delta);  % Get quantization index
quantized_indices2 = min(quantized_indices, L-1); % Ensure max index is L-1
x_quantized = X_min + (quantized_indices + 0.5) * Delta; % Mid-rise quantization levels
x_quantized2=Delta+floor(x./Delta+1/2)
% Plot original and quantized signals
figure;
subplot(2,1,1);
plot(t, x, 'b', 'LineWidth', 1.5); hold on;
stem(t, x_quantized, 'r', 'MarkerFaceColor', 'r', 'MarkerSize', 3);
xlabel('Time (s)');
ylabel('Amplitude');
title('Uniform Quantization of a Shifted Sine Wave');
legend('Original Signal', 'Quantized Signal');
grid on;

% Plot quantization error
subplot(2,1,2);
plot(t, x - x_quantized, 'k');
xlabel('Time (s)');
ylabel('Quantization Error');
title('Quantization Error');
grid on;
