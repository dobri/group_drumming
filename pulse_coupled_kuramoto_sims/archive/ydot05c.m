function dydt = ydot05(t,y)

    global N f0 f w K e pulse stim noise kmodel
    %% Dynamics Pulse Coupling Gamma Distribution
    
    % Mean field
    z = exp(1i*y);  % Wrapping theta around the circle
    y = angle(z);   % Phase, -pi to pi    
    p = gampdf(y/2/pi./f,1.25,0.02); % Rescale parameters to be in terms of 
                                     % time instead of phase, 
                                     % was .45 without scaling 
                                     % (ideal for drum waveform) ./(2*pi*f)
%     Y = repmat(y, 1, N)';
%     P = repmat(p, 1, N);
    
    
    idx = find(abs(stim.t - t) == min(abs(stim.t - t))); idx = idx(1);

    x   = stim.x(:, idx);
    n   = noise.x(:, idx);

    if kmodel == 0
        Y = repmat(y, 1, N);
        dydt = w + (K/N) * sum(sin(Y-Y'))' + n;   % new, to demonstrate original model
    else
        C = ~diag([1 1 1 1]);
%         x, sin(y)', x*sin(y)', C.*(x*sin(y)')
        dydt = w - (K/N) * sum(C.*(x*sin(y)'))' + n;     % Individuals
        % responding to own pulse ... need to fix this
    end
%     dydt = w - (K/N)*sum(x.*sin(Y))' + 14.5*randn(size(y));     % Individuals

end