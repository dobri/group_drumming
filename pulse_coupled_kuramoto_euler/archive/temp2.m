dt = 1e-3;
N = round(1/dt)*10;
t = zeros(N,4);
t(1,:) = 0:.1:.3;

% Pulse (Gamma) function and parameters.
a = 1.25;
b = .02;
% ¡ remember to set negative t to zero!
Pt = @(t,a,b)(1./(b.^a.*gamma(a)).*t.^(a-1).*exp(-t./b));


p = t*0;
events = zeros(size(t,2),1);
for n = 2:size(t,1)
    t(n,:) = t(n-1,:) + dt;
    % event detector.
    % this is a shortcut for neural response to a zero-crossing event + short refractory period.
    for c = 1:numel(events)
        if (mod(t(n,c),1)<mod(t(n-1,c),1)) && ((t(n,c)-events(c))>.1)
            events(c) = t(n,c);
        end
    end
    p(n,:) = Pt((t(n,:)-events').*((t(n,:)-events')>0),a,b);
end
plot(t,p)
