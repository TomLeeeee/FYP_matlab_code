function freq_resp = frequency_response_3d(d, f, W, fs, varargin)
    defaultVelocity = 340;          % default speed of sound in m/s
    defaultAngResolution = 1;       % default angle resolution
    defaultPlot = true;             % whether plot the frequency response
    defaultMinAmp = -60;            % minimum amplitude threshold
    defaultLogScale = false;        % log scale on frequency axis

    p = inputParser;
    validInput = @(x) ismatrix(x) || isvector(x);
    addRequired(p, 'd', @isscalar);         % spacing
    addRequired(p, 'f', validInput);        % frequency bin array
    addRequired(p, 'W', validInput);        % weight vector
    addRequired(p, 'fs', @isscalar);        % sampling frequency
    addParameter(p, 'SignalVelocity', defaultVelocity, @isscalar);
    addParameter(p, 'AngleResolution', defaultAngResolution, @isscalar);
    addParameter(p, 'Plot', defaultPlot, @islogical);
    addParameter(p, 'MinimumAmplitude', defaultMinAmp, @isscalar);
    addParameter(p, 'LogScale', defaultLogScale, @islogical);
    parse(p, d, f, W, fs, varargin{:});
    c = p.Results.SignalVelocity;
    angle_resolution = p.Results.AngleResolution;
    amp_min = p.Results.MinimumAmplitude;
    log_scale = p.Results.LogScale;

    num_freq = numel(f);
    [N, num_freq_W] = size(W);
    if num_freq ~= num_freq_W
        error('Number of frequency bins does not match')
    end
    num_angle = 360/angle_resolution+1; % calculate the number of angles
    
    % Ignore frequency components above Nyquist Frequency
    f = f(f>0);
    num_freq = numel(f);
    W = W(:,1:num_freq);
    
    % Calculate the frequency response for all angles
    theta = zeros(1,num_angle);
    parfor i = 1:num_angle      % using parallel computation to speed up
        theta(i) = -180+angle_resolution*(i-1);
        
        % reset sums
        D = zeros(N,num_freq);
        for j = 0:N-1
            delay_prop = j*d*(cosd(theta(i)))/c;
            D(j+1,:) = exp(2i*pi*f*delay_prop);
        end
        B(i,:) = sum(W.*D);         % Equivalent with W'*D but faster
    end
    B_dB = 20*log10(abs(B));
    [f, angle] = meshgrid(f,theta);
    freq_resp = struct('f',f,'angle',angle,'B',B);

    % surface plot
    if p.Results.Plot
        fig = figure;
        fig.Name = 'Frequency Response';
        fig.Units = 'normalized';
        fig.OuterPosition = [0.2 0.5 0.25 0.5];
        
        s = surf(f,angle,B_dB);
        title('\bf{Frequency Response}', 'Interpreter', 'latex', 'fontweight', 'bold', 'fontsize', 16)
        ylabel('Angle (Degree)', 'Interpreter', 'latex', 'fontsize', 14)
        xlabel('Frequency (Hz)', 'Interpreter', 'latex', 'fontsize', 14)
        zlabel('Gain (dB)','Interpreter', 'latex', 'fontsize', 14)

        s.EdgeColor = 'none';
        h = gca;
        if log_scale
            set(h,'xscale','log')
        end
        c = colorbar;
        c.Label.String = 'dB';
        c.Label.Interpreter = 'latex';
        c.Label.FontSize = 14;
        caxis([amp_min 0]);
        xlim([0 fs/2])
        ylim([-180 180])
        zlim([amp_min 10]);
        view(-60,40)
        
        fig = figure;
        fig.Name = 'Frequency Response Topdown';
        fig.Units = 'normalized';
        fig.OuterPosition = [0.2 0.2 0.25 0.45];
        
        s = surf(f,angle,B_dB);
        title('\bf{Frequency Response}', 'Interpreter', 'latex', 'fontweight', 'bold', 'fontsize', 14)
        ylabel('Angle (Degree)', 'Interpreter', 'latex', 'fontsize', 14)
        xlabel('Frequency (Hz)', 'Interpreter', 'latex', 'fontsize', 14)
        zlabel('Gain (dB)','Interpreter', 'latex', 'fontsize', 14)

        s.EdgeColor = 'none';
        if log_scale
            h = gca;
            set(h,'xscale','log')
        end
        c = colorbar;
        c.Label.String = 'Gain (dB)';
        c.Label.Interpreter = 'latex';
        c.Label.FontSize = 14;
        caxis([amp_min 0]);
        xlim([0 fs/2])
        ylim([-180 180])
        zlim([amp_min 10]);
        view(-90,90)
    end
end
