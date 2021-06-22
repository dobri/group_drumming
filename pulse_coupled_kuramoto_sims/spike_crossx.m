function [C,lags] = spike_crossx(tX,tY,cfg,varargin)
% This is the spike xcorr code from fieldtrip.

if ~isempty(varargin)
    auto_flag = logical(varargin{1});
else
    auto_flag = false;
end

if auto_flag
    nLags = round(cfg.maxlag_auto/cfg.binsize);
else
    nLags = round(cfg.maxlag/cfg.binsize);
end
lags = (-nLags:nLags)*cfg.binsize;
lags = ((lags(2:end)+lags(1:end-1))/2)';

nbins = nLags*2+1;

tX = sort(tX(:));
tY = sort(tY(:));

mostNegativeLag = - cfg.binsize * (nbins-1) / 2;
j = 0:nbins-1;
B = mostNegativeLag + j * cfg.binsize;
tX(tX<(tY(1)+mostNegativeLag) | tX>(tY(end)-mostNegativeLag))   = [];
if isempty(tX)
    C = zeros(1,length(B)-1);
    return;
end
tY(tY>(tX(end)-mostNegativeLag) | tY<(tX(1)+mostNegativeLag)) = [];
if isempty(tY)
    C = zeros(1,length(B)-1);
    return;
end
nX = length(tX); nY = length(tY);

% compute all distances at once using a multiplication trick
if (nX*nY)<2*10^7  % allow matrix to grow to about 150 MB, should always work
    D = log(exp(-tX(:))*exp(tY(:)'));
    D = D(:);
    D(abs(D)>abs(mostNegativeLag)) = [];
    C = histc(D,B);
    C(end) = [];
else
    % break it down in pieces such that nX*nY<2*10*7
    k   = 2;
    nXs = round(nX/k);
    while (nXs*nY)>=(2*10^7)
        k = k+1;
        nXs = round(nX/k);
    end
    
    % get the indices
    steps = round(nX/k);
    begs = 1:steps:steps*k;
    ends = begs+(steps-1);
    rm   = begs>nX;
    begs(rm) = [];
    ends(rm) = [];
    ends(end) = nX;
    nSteps    = length(begs);
    
    D = [];
    C = zeros(1,length(B));
    for iStep = 1:nSteps
        d = log(exp(-tX(begs(iStep):ends(iStep)))*exp(tY(:)'));
        d = d(:);
        d(abs(d)>abs(mostNegativeLag)) = [];
        C = C + histc(d,B)';
    end
    C(end) = [];
end

if isempty(C)
    C = zeros(1,length(B)-1);
end


% remove the center peaks from the auto-correlogram
if auto_flag
    C(nLags:nLags+1) = nan;
end


% debias
if strcmp(cfg.debias,'yes')
    T = max(tX(end),tY(end))-min(tX(1),tY(1));
    sc = (T./(T-abs(lags(:))));
    sc = length(sc)*sc./sum(sc);
    C  = C(:).*sc(:);
end

% proportion. This is confusing.
% proportional to what?
if strcmp(cfg.proport,'normalized')
    C = C./nansum(C);
end
if strcmp(cfg.proport,'trial_time')
    T = max(tX(end),tY(end))-min(tX(1),tY(1));
    chance_rate = nX*nY/(T/cfg.binsize);
    C = C./chance_rate;
end
if strcmp(cfg.proport,'window_time')
    T = max(tX(end),tY(end))-min(tX(1),tY(1));
    chance_rate = nX*nY/(T/cfg.binsize)*(cfg.maxlag*2/T);
    C = C./chance_rate;
end
if strcmp(cfg.proport,'total_count')
    C = C./(nX*nY);
end
if strcmp(cfg.proport,'poisson_chance')
    T = min(tX(end),tY(end))-max(tX(1),tY(1));
    chance_rate = nX*nY/(T/cfg.binsize);
    C = (C-chance_rate)./chance_rate^.5;
end

% plotting
if cfg.plotting == 1
    title_lab = 'Rasters';
    figure(double(title_lab(1)));
    clf
    
    subplot(1,3,1:2)
    line((tX*[1 1])',(tX*0+[0 1])','color','m','linewidth',2,'linestyle','-')
    line((tY*[1 1])',(tY*0+[0 1])','color','b','linewidth',2,'linestyle','-')
    title(title_lab)
    
    subplot(1,3,3)
    plot(lags,C,'-s','linewidth',2)
    xlabel('Lags')
    ylabel('Count*')
end