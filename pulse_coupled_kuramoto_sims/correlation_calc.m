
global diffDE Kc Nruns

%% Auto correlations

%Works when Nruns=3+

Clag0_across_trials = [];
Clag1_across_trials = [];

%for i = 1:length(diffDE)

    
clag0_trial = [];
clagc0_trial = [];
for pp1=1:size(matDE,2)
    for pp2=1:size(matDE,2)
        if pp1 > pp2
            [C,lags] = xcov(matDE(:,pp1),matDE(:,pp2),'coeff');
            ind = find(lags == 0);
            clag0_trial = [clag0_trial; [0 pp1 pp2 C(ind)]];
            clagc0_trial = [clagc0_trial, C(ind)];
        end
    end
end

Clag0_across_trials = [Clag0_across_trials;clag0_trial];

clag1_trial = [];
clagc1_trial = [];
for pp1=1:size(matDE,2)
    for pp2=1:size(matDE,2)
        if pp1==pp2
            [C,lags] = xcov(matDE(:,pp1),matDE(:,pp2),'coeff');
            ind = find(lags == 1);
            clag1_trial = [clag1_trial; [1 pp1 pp2 C(ind)]];
            clagc1_trial = [clagc1_trial, C(ind)];
        end
    end
end

Clag1_across_trials = [Clag1_across_trials;clag1_trial];


%% Final Matrix

%COR = [Clag1_across_trials;Clag0_across_trials];

% %% Graphing
% 
% auto1 = COR(1:4,5);
% auto2 = COR(5:8,5);
% auto3 = COR(9:12,5);
% autoavg = [mean(auto1) mean(auto2) mean(auto3)];
% disp('Auto Correlation Mean:')
% mean(autoavg)
% figure(7)
%     bar(autoavg)
%     title('Auto Correlation Averaged Over Participants at Lag 1')
%     ylabel('COV','Fontsize',20)
%     set(gca, 'XTickLabel', {'Trial 1', 'Trial 2', 'Trial 3'}, 'Fontsize',12)
% 
% cross1 = COR(13:18,5);
% cross2 = COR(19:24,5);
% cross3 = COR(25:30,5);
% crossavg = [mean(cross1) mean(cross2) mean(cross3)];
% disp('Cross Correlation Mean Across Trials:')
% mean(crossavg)
% figure(8)
%     bar(crossavg)
%     title('Cross Correlation Averaged Over Participants at Lag 0')
%     ylabel('COV','Fontsize',20)
%     set(gca, 'XTickLabel', {'Trial 1', 'Trial 2', 'Trial 3'}, 'Fontsize',12)
% 
% figure(9)
%     bar([1 2],[mean(cross1), mean(auto1)])
%     ylabel('COV','Fontsize',20)
%     set(gca, 'XTickLabel', {'Cross Average, Lag 0', 'Auto Average, Lag 1'}, 'Fontsize',12)
