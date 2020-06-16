function  [f, W] = DMA_weights(N, d, alpha, DFTLEN, fs, varargin)
    defaultVelocity = 340;              % m/s
    defaultEqualization = false;        % default equalization logic
    p = inputParser;
    addRequired(p, 'N', @isscalar);         % number of mics
    addRequired(p, 'd', @isscalar);         % spacing
    addRequired(p, 'alpha', @isvector);     % alpha value(s)
    addRequired(p, 'DFTLEN', @isscalar)     % length of DFT
    addRequired(p, 'fs', @isscalar);        % sampling frequency
    addParameter(p, 'SignalVelocity', defaultVelocity, @isscalar);
    addParameter(p, 'Equalization', defaultEqualization, @islogical)
    parse(p, N, d, alpha, DFTLEN, fs, varargin{:});
    c = p.Results.SignalVelocity;           % signal velocity (m/s)
    EQ = p.Results.Equalization;            % whether doing equalization
    
    % generate the frequency array
    f = [fs*(0.5:1:0.5*DFTLEN-0.5)/DFTLEN -fs*(0.5*DFTLEN-0.5:-1:0.5)/DFTLEN];
    
    if N-1 ~= numel(alpha)
        error('Number of mics does not match the number of alpha values')
    end
    
    % calculate tau from alpha according to definition
    tau = (alpha*d/c)./(1-alpha);
    fc = 1./(2*(tau+d/c));      % corner frequency
    
    num_of_f = numel(f);        % number of frequency bins
    W = ones(num_of_f,1);       % initialization
    for i = 1:N-1
        W_tmp = W;
        W(:,i+1) = ones(num_of_f,1);
        tmp = [ones(1,num_of_f); -exp(2i*pi*f*tau(i))]'/2;
        for j = 1:num_of_f
            W(j,:) = conv(W_tmp(j,:),tmp(j,:));
        end
    end
    W = W';
    
    % Equalization
    if EQ
        for i = 1:N-1
            f_logic = f(floor(1:DFTLEN/2))<fc(i);
            W(:,f_logic) = W(:,f_logic)./sin(pi/2*f(f_logic)/fc(i));
        end
    end
end
