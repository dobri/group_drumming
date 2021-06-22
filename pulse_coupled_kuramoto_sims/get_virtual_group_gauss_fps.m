function [xx,activity_rate] = get_virtual_group_gauss_fps(X,plotting,bpm,varargin)

if ~isempty(varargin)
    n=varargin{1};
else
    n=1;
end
sr=1000; % Hz
winlen=200; % ms
xf=zeros(round((X(end)+1)*sr),1);
t=(1:numel(xf))'./sr;
for x=1:numel(X) % In case there are exact matches, or it would be lost for the sync measures.
    xf(round(X(x)*1e3)+1)=xf(round(X(x)*1e3)+1)+1;
end
kern=gausswin(round(sr/1e3*winlen));
activity_rate = conv(xf,kern,'same')./n;
xfc=smooth(activity_rate,round((60/bpm*sr)/4));
[xfcp,xfcpin]= findpeaks(xfc,'MinPeakDistance',round((60/bpm*sr)/3));
xx=t(xfcpin);
activity_rate = [t(xfcpin) activity_rate(xfcpin)];

if plotting
    %figure(2)
    plot(t,[xf,xfc],'LineWidth',.5)
    hold on
    plot(t(xfcpin),xfcp,'or','LineWidth',1.)
    plot(activity_rate(:,1),activity_rate(:,2),'pm','LineWidth',1.)
    hold off
    pause
    %xlim([0 105])
end

end