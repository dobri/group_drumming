%% run05: Pulse as stimulus, variance in phase
%% Run the simulation

y0  = 2*pi*rand(N,1) - pi;
options = odeset('MaxStep', 1/stim.fs, 'Events', @events05);

% in ydot05c, oscillator does not respond to it's own pulses, 
% in ydot05, it does!
[t, y, te, ye, ie] = ode23(@ydot05c, tspan, y0, options); %
t = t';
y = y';

%% Various forms of the output

z     = exp(1i*y);                  % Give an oscillation (analytic)
theta = angle(z);                   % Phase, -pi to pi
mf    = (1/N)*sum(z);               % Mean field (the order parameter)
r     = abs(mf);                    % Amplitude of the mean field 
psi   = angle(mf);                  % Phase of the mean field
F     = repmat(f, 1, size(z,2));
p     = gampdf(theta/2/pi./F,1.25,0.02);  % using this to graph pulses

osc = real(mf);


%% Compute the variance, etc

te1 = te(find(ie == 1)); de1 = diff(te1); me1 = mean(de1); std1 = std(de1);
te2 = te(find(ie == 2)); de2 = diff(te2); me2 = mean(de2); std2 = std(de2);
te3 = te(find(ie == 3)); de3 = diff(te3); me3 = mean(de1); std3 = std(de3);
te4 = te(find(ie == 4)); de4 = diff(te4); me4 = mean(de1); std4 = std(de4);
stdi= mean([std1 std2 std3 std4]);

de1c = de1-mean(de1); de2c = de2-mean(de2); de3c = de3-mean(de3); de4c = de4-mean(de4);

%Calculate min length of ac's for cross corr
LenVec = [length(de1c) length(de2c) length(de3c) length(de4c)];
l = min(LenVec);
de1c = de1c(1:l);
de2c = de2c(1:l);
de3c = de3c(1:l);
de4c = de4c(1:l);

global DE
DE = [de1c,de2c,de3c,de4c];

stim.t = t(1):1/stim.fs:t(end);
group = zeros(size(stim.t));
for tx = 1:length(te)
    tt = te(tx);
    ix = find(abs(stim.t-tt) == min(abs(stim.t-tt)));
    group(ix) = group(ix)+1;
end

b = normpdf(-10:10, 0, 2);
fgroup = filtfilt(b, 1, group);
[peaks, locs] = findpeaks(fgroup,stim.t, 'MinPeakDistance', .3);

dgroup = diff(locs); meg = mean(dgroup); stdg = std(dgroup);


