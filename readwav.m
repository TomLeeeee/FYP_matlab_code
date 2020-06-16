function [audio_in,fs] = readwav(input_wav)
    p = inputParser;
    addRequired(p, 'input_wav', @isvector);     % only 1 dimension is allowed
    parse(p,input_wav);
    
    num_wav = numel(input_wav); % number of wav files that should read from
    [x0, fs0] = audioread(input_wav(1));    % read the first wav file
    audio_len = numel(x0');                 % length of the wav data
    
    % loop until all wav files are read
    for i = 1:num_wav
        clear x;
        [x, fs] = audioread(input_wav(i));
        x = x';
        
        if fs ~= fs0
            error('Wav files contain different sampling rate')
        else
            fs0 = fs;
        end
        
        x_len = numel(x);
        if x_len > audio_len
            audio_in = [audio_in zeros(i, x_len-audio_len)];
        end
        
        audio_in(i,:) = [x zeros(1, audio_len-x_len)];
        audio_len = numel(audio_in(i,:));
    end
end