clear

%% Setting the Stage
%Everything else is defined in 'vimportant'

global N

Nruns = 1e1;                 %Number of runs
% sigma_freqs = .2; % dd
freq_range = .2; % upper and lower range of uniform distribution, where range is propotion of f0.
sigma_phase_noise = 1; % dd
Kc = 5;                      %Coupling strength 4.5

CV1 = NaN + zeros(Nruns,3);  %Create matrix of zeros for covariation
R1 = [];                     %Create matrix for means & stdev
CLAG0 = [];                  %Create empty matrix for lag 0 correlations
CLAG1 = [];                  %Create empty matrix for lag 1 correlations

%% THE BIG LOOP! Pulls from 'vimportant' which pulls 'thefunpart'

% dd
clear cvs mes Ks Ns;
REZ = [];
clear TEs;
counter = 0;
for N = [2 4 8] % dd
    
    for rx = 1:Nruns
        
        disp(rx)
        vimportant
        R1 = [R1, mean(r)];
        CV1(rx,:) = [stdi_0, stdi, stdg]/2;
        
        %correlation_calc % dd
        %CLAG0 = [CLAG0; clag0_trial]; % dd
        %CLAG1 = [CLAG1; clag1_trial]; % dd
%         figure(2)
%         bar([1 2 3], nanmean(CV1));
%         set(gca,'YLim', [0.00 0.06])
%         ylabel('CV','Fontsize',20)
%         set(gca, 'XTickLabel', {'Inds-in-Solo', 'Inds-in-Group', 'Group'}, 'Fontsize',20)
%         xtickangle(45);
%         drawnow
%         disp(nanmean(CV1))
%         disp(mean(R1))
    end
    
    % dd
    for r = 1:size(cvs,1)
        REZ = vertcat(REZ, [[Ns(r,1) Ks(r,1) 0].*ones(numel(mes{r,1}),1) mes{r,1}' cvs{r,1}']);
        REZ = vertcat(REZ, [[Ns(r,1) Ks(r,1) 1].*ones(numel(mes{r,2}),1) mes{r,2}' cvs{r,2}']);
        REZ = vertcat(REZ, [[Ns(r,2) Ks(r,2) 0].*ones(numel(mes{r,3}),1) mes{r,3}' cvs{r,3}']);
        REZ = vertcat(REZ, [[Ns(r,2) Ks(r,2) 1].*ones(numel(mes{r,4}),1) mes{r,4}' cvs{r,4}']);
    end
end
close all
boxplot(REZ(:,5),REZ(:,[2 3]))
boxplot(REZ(:,5),REZ(:,[1 2 3]))

REZ = array2table(REZ);
REZ.Properties.VariableNames = {'N','K','Agg','ITI','cv'};
% writetable(REZ,['pulse_coupled_kuramoto_' datestr(now,'yyyymmdd-HHMMSS') '.csv'],'Delimiter',',')

