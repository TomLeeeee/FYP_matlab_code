function front_to_back_ratio(freq_resp)
    p = inputParser;
    addRequired(p, 'freq_resp', @isstruct);     % frequency response
    parse(p, freq_resp);
    
    [~, phi0_idx] = min(abs(0-freq_resp.angle(:,1)));     % index of angle phi=0
    [~, phi90_idx] = min(abs(90-freq_resp.angle(:,1)));   % index of angle phi=90
    [~, phi180_idx] = min(abs(180-freq_resp.angle(:,1))); % index of angle phi=180
    
    num_front = abs(phi90_idx-phi0_idx)+1;  % number of angle in the front half
    num_back = abs(phi180_idx-phi90_idx)+1; % number of angle in the back half   
    
    % total gain in the front half
    front =  sum(abs(freq_resp.B(phi0_idx:phi90_idx,:)./num_front)).^2;
    % total gain in the back half
    back = sum(abs(freq_resp.B(phi90_idx:phi180_idx,:)./num_back)).^2;
    FBR = 20*log10(front./back);    % front-to-back ratio
    
    % Plot of front-to-back ratio vs frequency
    fig = figure;
    fig.Name = 'Front-to-Back Ratio';
    fig.Units = 'normalized';
    fig.OuterPosition = [0.4 0.6 0.2 0.4];
    
    plot(freq_resp.f(1,:), FBR);
    title('\bf{Front-to-Back Ratio}', 'Interpreter', 'latex', 'fontweight', 'bold', 'fontsize', 16)
    ylabel('Front-to-Back Ratio (dB)', 'Interpreter', 'latex', 'fontsize', 14)
    xlabel('Frequency (Hz)', 'Interpreter', 'latex', 'fontsize', 14)
    xlim([0 freq_resp.f(1,end)])
    grid on
end