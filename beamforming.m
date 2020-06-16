function y = beamforming(W, x)
    p = inputParser;
    addRequired(p, 'W');        % weight vector
    addRequired(p, 'x');        % input signal
    parse(p, W, x);
    
    [N,num_freq] = size(W);
    [N2,num_sig] = size(x);

    % check dimensions
    if N ~= N2
        error('Input dimensions do not match')
    end
    
    w = zeros(N, num_freq);
    y_temp = zeros(N, num_sig);

    for i=1:N
        w(i,:) = ifft(W(i,:)');
        %y_temp(i,:) = conv(x(i,:),w(i,:));     % equivalent
        y_temp(i,:) = filter(w(i,:),1,x(i,:));
    end

    y = sum(y_temp);
end
