function [f, theta, B_dB] = beampattern(freq_resp, freq, varargin)
    defaultMinAmp = -60;          % minimum amplitude threshold
    defaultLookingDirection = ''; % no looking direction indicator in default
    
    p = inputParser;
    addRequired(p, 'freq_resp', @isstruct);     % frequency response
    addRequired(p, 'freq', @isscalar); % frequency at which the beampattern is plotted
    addParameter(p, 'MinimumAmplitude', defaultMinAmp, @isscalar);
    addParameter(p, 'LookingDirection', defaultLookingDirection, @isscalar);
    parse(p, freq_resp, freq, varargin{:});
    amp_min = p.Results.MinimumAmplitude;
    looking_direction = p.Results.LookingDirection;
    
    f = freq_resp.f(1,:);
    theta = freq_resp.angle(:,1)';
    
    % Find index of frequency bin that closest to the interested frequency
    [~,freq_idx] = min(abs(f-freq));
    freq = f(freq_idx);                 % find the actual frequency
    B_tmp = freq_resp.B(:,freq_idx);    % find the gain at that frequency
    B_dB = 20*log10(abs(B_tmp));
    
    % ignore very small results
    B_capped = B_dB;
    B_capped(B_capped<amp_min) = amp_min;
    
    fig = figure;
    fig.Name = 'Beam Pattern';
    fig.Units = 'normalized';
    fig.OuterPosition = [0 0.1 0.4 0.4];

    % 2D linear Plot
    subplot(1,2,1)
    hold on
    plot(theta, B_capped,'color',[0 0.4470 0.7410])
    xlim([-180 180])
    ylim([amp_min 0])
    if isscalar(looking_direction)
        xline(looking_direction, '--r');
        str = append('Looking direction = $',num2str(looking_direction),'^\circ \rightarrow$');
        text(looking_direction,-5,str,'HorizontalAlignment','right','Interpreter', 'latex')
    end
    str = append('\bf{Beam Pattern at ', num2str(freq), 'Hz}');
    title(str, 'Interpreter', 'latex', 'fontweight', 'bold')
    xlabel('Angle (deg)', 'Interpreter', 'latex')
    ylabel('Magnitude (dB)', 'Interpreter', 'latex')
    grid on

    % 2D polar plot
    subplot(1,2,2)
    polarplot(deg2rad(theta), B_capped)
    thetatickformat('degrees')
    rlim([amp_min 0])
    ax = gca;
    ax.RAxis.Label.String = 'Gain (dB)';
    ax.RAxis.Label.Interpreter = 'latex';
    ax.RAxis.Label.Position = [95 amp_min/3 0];
    ax.ThetaAxis.Label.String = 'Angle (Degree)';
    ax.ThetaAxis.Label.Interpreter = 'latex';
    ax.ThetaLim = [-180 180];
    str = append('\bf{Polar Plot of Beam Pattern at ', num2str(freq), 'Hz}');
    title(str, 'Interpreter', 'latex') 
end