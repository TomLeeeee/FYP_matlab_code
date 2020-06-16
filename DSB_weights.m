function  [f, W] = DSB_weights(N, d, looking_direction, fs, varargin)
    defaultVelocity = 340;          % default speed of sound in m/s
    defaultResolution = 10;         % default resolution of frequency in Hz

    p = inputParser;
    addRequired(p, 'N', @isscalar);     % number of mics
    addRequired(p, 'd', @isscalar);     % spacing
    addRequired(p, 'looking_direction', @isscalar);     % looking direction
    addRequired(p, 'fs', @isscalar);    % sampling frequency
    
    addParameter(p, 'SignalVelocity', defaultVelocity, @isscalar);
    addParameter(p, 'FrequencyResolution', defaultResolution, @isscalar);
    parse(p, N, d, looking_direction, fs, varargin{:});
    c = p.Results.SignalVelocity;           % signal velocity (m/s)
    freq_resln = p.Results.FrequencyResolution;
    
    % generate the frequency array
    f = [0 freq_resln:freq_resln:fs/2 flip(-freq_resln:-freq_resln:-fs/2)];

    % Find propagation delays to mics
    tau = (0:N-1).*d*(cosd(looking_direction))/c; 
    tau = tau + abs(min(tau));
    
    D = zeros(N,numel(f));
    for i = 0:N-1
        % convert delays into exponential form
        D(i+1,:) = exp(2i*pi*f*tau(i+1));    
    end
    
    W = D./N;   % weight
end
