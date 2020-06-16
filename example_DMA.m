tic;close all;clear;clc
restoredefaultpath
addpath('Audio Files')

N = 2;              % number of microphone, (N-1)th order of DMA
d = 0.1;                        % spacing
DFTLEN = 2205;                  % length of DFT
alpha = [0.37];    % alpha values

% specify the name of the input wav files in the string array
% the number of wav files added is not constrained
input_wav = ["ieee01f01.wav" "ieee02f03.wav"];

% define direction of arrival
DOA = [0 126];      % each element corresponds to each wav file

% read the wav files and store them in the array audio_in
[audio_in,fs] = readwav(input_wav);

% plot the spatial representation of the microphone array
plot_array(N,d);

% simulate the propagation of source signal to the microphone array
% according to their DOA
% x contains the signal received by each microphone
[x, delay_prop] = array_input(N, d, DOA, audio_in, fs);

% calculate tau from alpha according to definition
tau = (alpha*d/340)./(1-alpha);
% find approximate number of samples to perform the delay of time tau
tau_samp = round(tau*fs);

% perform the beamforming in time domain
y = beamforming_t(tau_samp, x);
sound(real(y), fs)      % playback the output of the beamformer


%%%%%% the following functions is irrelavent with the sound signal %%%%%%
%%%%%% all calculations are done using microphone array parameters %%%%%%
% Find the weight of frequency bins
[f, W] = DMA_weights(N, d, alpha, DFTLEN, fs, 'Equalization', false);

% frequency response for all angles
freq_resp = frequency_response_3d(d, f, W, fs, 'AngleResolution', 1, 'MinimumAmplitude', -60, 'LogScale', false);

% plot the beampattern at specified frequency
[freq, theta, B] = beampattern(freq_resp, 1000);

directivity(freq_resp, 0);          % Directivity Index
front_to_back_ratio(freq_resp)      % Front-to_Back Ratio
compare(audio_in, y, 1, fs);        % Spectrogram and waveform comparison

toc             % measure the CPU time for performance evaluation
