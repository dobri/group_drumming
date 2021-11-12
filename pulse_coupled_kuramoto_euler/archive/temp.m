dt = 1e-3;
t = (0:dt:10)';

a = 1.25;
b = .02;
Pt = @(t,a,b)(1./(b^a*gamma(a))*(t.*(t>0)).^(a-1).*exp(-(t.*(t>0))./b));

% default Gamma
pulse.fs = 500;
pulse.t = (0:1/pulse.fs:0.25);
pulse.x = gampdf(pulse.t,a,b);
pulse.N = length(pulse.t);

plot((-1:dt:1),Pt((-1:dt:1),a,b),'-ok')
hold on
plot(pulse.t,pulse.x,'-sr')
hold off

p = t*0;
events = 0;
for k = 2:numel(t)
    % event detector. 
    % this is a shortcut for neural response to an event + short refractory period.
    if (mod(t(k),1)<mod(t(k-1),1)) && ((t(k)-events)>.1)
        events = t(k);
    end
    p(k) = Pt(t(k)-events,a,b);
end
plot(t,p)
