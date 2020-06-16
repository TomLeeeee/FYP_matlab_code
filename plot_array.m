function plot_array(N,d)
    p = inputParser;
    addRequired(p, 'N', @isscalar);     % number of mics
    addRequired(p, 'd', @isscalar);     % spacing
    parse(p, N, d)

    % Generate the uniform linear array
    r = [zeros(1,N);0:d:d*(N-1);zeros(1,N)]';
    % find centre and set it as origin
    r = r - ones(N,1)*sum(r)/N;

    fig = figure;
    fig.Name = 'Array Plot';
    fig.Units = 'normalized';
    fig.OuterPosition = [0 0.5 0.2 0.4];

    plot3(r(:,1), r(:,2), r(:,3), '-o', 'MarkerSize', 12)
    hold on
    for i = 1:N
        txt = ['Mic #' num2str(i) newline ...
            '(' num2str(r(i,1)) ',' num2str(r(i,2)) ',' num2str(r(i,3)) ')'];
        text(r(i,1), r(i,2), r(i,3)-0.15, txt)
    end
    hold off
    axis square
    view(65,25)
    grid on
    xlabel('$x (m)$', 'Interpreter', 'latex')
    ylabel('$y (m)$', 'Interpreter', 'latex')
    zlabel('$z (m)$', 'Interpreter', 'latex')
    title('\bf{Array Plot}', 'Interpreter', 'latex', 'fontweight', 'bold', 'fontsize', 14)
end