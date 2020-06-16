function [y, delay_prop] = array_input(N,d,DOA,audio_in,fs,varargin)
    defaultVelocity = 340;          % default speed of sound in m/s
    p = inputParser;
    addRequired(p, 'N');            % number of mics
    addRequired(p, 'd');            % spacing
    addRequired(p, 'DOA');          % DOA (direction of arrival)
    addRequired(p, 'audio_in');     % array of input signal
    addRequired(p, 'fs');           % sampling frequency
    
    % may specify the speed of sound other than default value
    addParameter(p, 'SignalVelocity', defaultVelocity, @isscalar);
    
    parse(p,N,d,DOA,audio_in,fs,varargin{:});
    c = p.Results.SignalVelocity;

    
    [s,l] = size(audio_in);
    if s ~= numel(DOA)
        error('Number of sources does not match with number of DOA')
    end
    
    % calculate propagation delay in samples
    delay_prop = zeros(N,s);
    for i = 1:N
        delay_prop(i,:) = round((i-1)*d*cosd(DOA')*fs/c);
    end
    for i = 1:s
        delay_prop(:,i) = delay_prop(:,i) + abs(min(delay_prop(:,i)));
    end
    
    % maximum delay for each microphone
    max_delay = max(max(delay_prop));       
    
    % the output array should have the maximum array size among all inputs
    y = zeros(N,l+max_delay);
    
    % perform the signal propagation simulation
    for i = 1:N
        for j = 1:s
            y(i,:) = y(i,:) + [zeros(1,delay_prop(i,j)) audio_in(j,:) zeros(1,max_delay-delay_prop(i,j))];
        end
    end
end