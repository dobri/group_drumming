%aFewRuns05.m
global kmodel
Nruns = 1e1;

kmodel = 1;
Kc  = 4.5; %3.0
CV1 = NaN+zeros(Nruns,3);
R1 = [];
% CLAGC0 = [];
% CLAGC1 = [];
for rx = 1:Nruns
    disp(rx)
    testV05
    R1 = [R1, mean(r)];
    CV1(rx,:) = [stdi_0, stdi, stdg]/2;
%     correlation_calc
%     CLAGC0 = [CLAGC0; clagc0_trial];
%     CLAGC1 = [CLAGC1; clagc1_trial];
    figure(6)
        bar([1 2 3], nanmean(CV1));
        set(gca, 'YLim', [0.02 0.06])
        ylabel('CV','Fontsize',20)
        set(gca, 'XTickLabel', {'Inds-in-Solo', 'Inds-in-Group', 'Group'}, 'Fontsize',20)
        xtickangle(45);
        drawnow
%      disp(nanmean(CV1))
%      disp(mean(R1))
end

hold on; errorbar([1 2 3], mean(CV1), std(CV1)/Nruns, 'r.', 'LineWidth',2); hold off

% outputV05

