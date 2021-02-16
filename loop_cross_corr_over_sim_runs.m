nsims = 9;

Clag0_across_trials = [];
for n = 1:nsims
    
%     t = (0:100)'./10*2*pi;
%     
%     DE(:,1) = sin(t)+randn(size(t));
%     DE(:,2) = sin(t+pi/4)+randn(size(t));
%     DE(:,3) = sin(t+pi/2)+randn(size(t));
%     DE(:,4) = sin(t+pi/3)+randn(size(t));
    DE = run_one_simulation();
    
    clag0_trial = [];
    for pp1=1:size(DE,2)
        for pp2=1:size(DE,2)
            if pp1 > pp2
                counter = counter + 1;
                [C,lags] = xcov(DE(:,pp1),DE(:,pp2),'coeff');
                ind = find(lags == 0);
                clag0_trial = [clag0_trial; [n 0 pp1 pp2 C(ind)]];
            end
        end
    end
    
    Clag0_across_trials = [Clag0_across_trials;clag0_trial];
end

% plot(lags,C(:,1))