function EVENTSGR = group_cluster_events(t,EVENTS)

x = t*0;
for c = 1:numel(EVENTS)
    if numel(EVENTS{c})>1
        x = x + sum(t==EVENTS{c}',2);
    end
end

%Filter the output. Or you could convolve with a Gaussian kernel.
sr = round(1/mean(diff(t)));
b = normpdf(-(sr/3):(sr/3), 0, 4);
xf = filtfilt(b, 1, x); % plot(t,x,t,xf);
[~,locs] = findpeaks(xf, t, 'MinPeakDistance', .3);
EVENTSGR = locs;