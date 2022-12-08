function print_step_response_plot(var, t, xd, x, plotname, filename)
    figure('Name', plotname);
    if (isempty(xd) ~= true)
        plot(t, xd); hold on;
    end

    tunit = 's';
    if (t(end) < 1)
        t = t * 1000;
        tunit = 'ms';
    end

    plot(t, x);
    xticks(linspace(t(1), t(end), 11));

    grid on;
    set(gca, 'FontName', 'Euclid', 'FontSize', 12);
    title(plotname, 'FontWeight', 'normal', 'FontSize', 12);

    xname = 'x';
    xunit = 'm';
    switch var
        case 'current'
            xname = 'I';
            xunit = 'A';
        case 'voltage'
            xname = 'U';
            xunit = 'V';
        case 'moment'
            xname = 'M';
            xunit = 'N \cdot m';
        case 'angspeed'
            xname = '\omega';
            xunit = 'rad/s';
        case 'angle'
            xname = '\varphi';
            xunit = 'rad';
        case 'error'
            xname = 'e_\varphi';
            xunit = 'rad';
        case 'speed'
            xname = '\dot{\varphi}';
            xunit = 'rad/s';
        case 'voltaged'
            xname = 'u_d';
            xunit = 'V';
    end

    xlabel(['$t, \rm ', tunit, '$'], 'Interpreter', 'latex', 'FontSize', 12);
    ylabel(['$', xname, '(t), \rm ', xunit, '$'], 'Interpreter', 'latex', 'FontSize', 12);
    if (isempty(xd) ~= true)
        legend(['$', xname,'_d(t)$'], ['$', xname,'(t)$'], 'Interpreter', 'latex', 'FontSize', 10);
    end
    
    if (~exist('../../graphs', 'dir'))
        mkdir('../../graphs');
    end

    print(['../../graphs/', filename], '-dmeta', '-r0');
end