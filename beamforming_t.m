function y = beamforming_t(tau_samp, x)
    p = inputParser;
    addRequired(p, 'tau_samp');     % delay in number of samples
    addRequired(p, 'x');            % input signal
    parse(p, tau_samp, x);
    
    [~, N] = size(tau_samp);
    [M, ~] = size(x);
    
    % check dimensions
    if N ~= M-1
        error('Input dimensions do not match')
    end
    
    x_tmp = x/M;    % attenuate the signal by the factor of number of mics
    M = M-1;
    for i = 1:N
        clear y_tmp;
        for j = 1:M
            y_tmp(j,:) = [x_tmp(j,:) zeros(1,tau_samp(i))] - [zeros(1,tau_samp(i)) x_tmp(j+1,:)];
        end
        x_tmp = y_tmp;
        M = M-1;
    end
    y = y_tmp;
end