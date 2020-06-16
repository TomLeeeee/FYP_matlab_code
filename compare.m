function compare(x, y, sel_channel, fs, varargin)
    defaultLogScale = false;        % log scale in frequency axis
    
    p = inputParser;
    addRequired(p, 'y', @ismatrix);     % output from beamformer
    addRequired(p, 'x', @ismatrix);     % input signals
    addRequired(p, 'sel_channel', @isscalar);   % selected channel for input signals
    addRequired(p, 'fs', @isscalar);
    addParameter(p, 'LogScale', defaultLogScale, @islogical);
    parse(p, x, y, sel_channel, fs, varargin{:});
    log_scale = p.Results.LogScale;
    
    % zero padding at the end of x to make sure that x and y have the same length
    [row, col] = size(x);
    x = [x zeros(row, numel(y)-col)];
    duration = (numel(y)-1)/fs;     % duration of the signal (in samples)
    orig_state = warning;           % store original warning status
    warning('off')                  % ignore warning messages
    
    % spectrogram plots for selected input, mixed input and output from beamformer
    fig = figure;
    str = append('Waveform and Spectrogram of Input Signal in Channel ', num2str(sel_channel));
    fig.Name = str;
    fig.Units = 'normalized';
    fig.OuterPosition = [0.5 0 0.4 0.4];
    
    subplot(2,1,1,'position',[0.05 0.72 0.877 0.25])
    plot(0:1/fs:duration,x(sel_channel,:))
    xlim([0 duration])
    set(gca, 'xticklabel', [])
    ylabel('Amplitude','Interpreter', 'latex', 'fontsize', 14)
    subplot(2,1,2,'position',[0.05 0.11 0.92 0.6])
    spectrogram(x(sel_channel,:),512,480,512,fs,'yaxis','MinThreshold', -100);
    xlabel('Time (s)', 'Interpreter', 'latex', 'fontsize', 14)
    ylabel('Frequency (kHz)', 'Interpreter', 'latex', 'fontsize', 14)
    colormap(jet);
    if log_scale
        h = gca;
        set(h,'yscale','log')
    end
    c = colorbar;
    c.Label.String = 'Power/Frequency (dB/Hz)';
    c.Label.Interpreter = 'latex';
    c.Label.FontSize = 14;
    
    fig = figure;
    fig.Name = 'Waveform and Spectrogram of Mixed Signal';
    fig.Units = 'normalized';
    fig.OuterPosition = [0.5 0.3 0.4 0.4];
    
    subplot(2,1,1,'position',[0.05 0.72 0.877 0.25])
    plot(0:1/fs:duration,sum(x))
    xlim([0 duration])
    set(gca, 'xticklabel', [])
    ylabel('Amplitude','Interpreter', 'latex', 'fontsize', 14)
    subplot(2,1,2,'position',[0.05 0.11 0.92 0.6])
    spectrogram(sum(x),512,480,512,fs,'yaxis','MinThreshold', -100);
    xlabel('Time (s)', 'Interpreter', 'latex', 'fontsize', 14)
    ylabel('Frequency (kHz)', 'Interpreter', 'latex', 'fontsize', 14)
    colormap(jet);
    if log_scale
        h = gca;
        set(h,'yscale','log')
    end
    c = colorbar;
    c.Label.String = 'Power/Frequency (dB/Hz)';
    c.Label.Interpreter = 'latex';
    c.Label.FontSize = 14;
    
    fig = figure;
    fig.Name = 'Waveform and Spectrogram of Output Signal';
    fig.Units = 'normalized';
    fig.OuterPosition = [0.5 0.6 0.4 0.4];
    
    subplot(2,1,1,'position',[0.05 0.72 0.877 0.25])
    plot(0:1/fs:duration,y)
    xlim([0 duration])
    set(gca, 'xticklabel', [])
    ylabel('Amplitude','Interpreter', 'latex', 'fontsize', 14)
    subplot(2,1,2,'position',[0.05 0.11 0.92 0.6])
    spectrogram(y,512,480,512,fs,'yaxis','MinThreshold', -100);
    xlabel('Time (s)', 'Interpreter', 'latex', 'fontsize', 14)
    ylabel('Frequency (kHz)', 'Interpreter', 'latex', 'fontsize', 14)
    colormap(jet);
    if log_scale
        h = gca;
        set(h,'yscale','log')
    end
    c = colorbar;
    c.Label.String = 'Power/Frequency (dB/Hz)';
    c.Label.Interpreter = 'latex';
    c.Label.FontSize = 14;
    
    warning(orig_state)     % restore the warning status
end