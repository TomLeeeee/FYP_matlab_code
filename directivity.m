function directivity(freq_resp, phi)
    p = inputParser;
    addRequired(p, 'freq_resp', @isstruct);     % frequency response
    addRequired(p, 'phi', @isscalar); % direction at which the directivity is calculated
    parse(p, freq_resp, phi);
    
    [num_phi, ~] = size(freq_resp.angle);   % number of angles in frequency response
    [~, phi_idx] = min(abs(phi-freq_resp.angle(:,1)));      % find the angle index
    
    num = abs(freq_resp.B(phi_idx,:)).^2;       % numerator
    den = sum(abs(freq_resp.B)/num_phi).^2;     % denominator
    D = 20*log10(num./den);                     % directivity Index
    
    % Plot of directivity index vs frequency
    fig = figure;
    fig.Name = 'Directivity Index';
    fig.Units = 'normalized';
    fig.OuterPosition = [0.4 0.1 0.2 0.4];
    
    plot(freq_resp.f(1,:), D);
    str = append('\bf{Directivity at the Angle of ',num2str(phi),'$^\circ$}');
    title(str, 'Interpreter', 'latex', 'fontweight', 'bold', 'fontsize', 16)
    ylabel('Directivity Index (dB)', 'Interpreter', 'latex', 'fontsize', 14)
    xlabel('Frequency (Hz)', 'Interpreter', 'latex', 'fontsize', 14)
    xlim([0 freq_resp.f(1,end)])
    grid on
end





