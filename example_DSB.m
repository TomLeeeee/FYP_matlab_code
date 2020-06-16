tic;close all;clear;clc
restoredefaultpath
addpath('Audio Files')

N = 8;          % number of mics
d = 0.1;        % spacing
looking_direction = 90;

% specify the name of the input wav files in the string array
% the number of wav files added is not constrained
input_wav = ["ieee01f01.wav" "ieee02f03.wav"];

% define direction of arrival
DOA = [looking_direction 0];    % each element corresponds to each wav file

% read the wav files and store them in the array audio_in
[audio_in,fs] = readwav(input_wav);

% plot the spatial representation of the microphone array
plot_array(N,d);

% simulate the propagation of source signal to the microphone array
% according to their DOA
% x contains the signal received by each microphone
x = array_input(N, d, DOA, audio_in, fs);

% perform the delay-and-sum beamforming to the received signals
[f,W] = DSB_weights(N, d, looking_direction, fs);   % Delay-
y = beamforming(W, x);                              % and-Sum
sound(real(y), fs)      % playback the output of the beamformer


%%%%%% the following functions is irrelavent with the sound signal %%%%%%
%%%%%% all calculations are done using microphone array parameters %%%%%%
% frequency response for all angles
freq_resp = frequency_response_3d(d, f, W, fs, 'AngleResolution', 0.1, 'MinimumAmplitude', -60, 'LogScale', false);

% plot the beampattern at specified frequency
beampattern(freq_resp, 2000, 'LookingDirection', looking_direction);

directivity(freq_resp, looking_direction)   % Directivity Index
front_to_back_ratio(freq_resp)              % Front-to_Back Ratio
compare(audio_in, y, 2, fs);        % Spectrogram and waveform comparison

toc         % measure the CPU time for performance evaluation
