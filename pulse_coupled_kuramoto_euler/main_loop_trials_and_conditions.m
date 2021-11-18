clear

plotting = 0;
ntrials = 1e2;

% condition parameters
Ns = [2 4 8];
Ks = [0 6]; % [0 5]
%Ks = 6; % 6 at 1e2

% fixed parameters
sr = 1e2;
sigma = 2;
gammain = .5;
center_omega = 2*2*pi;

REZ = [];
counter = 0;
for N = Ns
    for K = Ks
        for tr = 1:ntrials
            [THETA,t,PSI,EVENTS]=sim_pulse_kuramoto_euler(N,K,sigma,gammain,center_omega,sr,plotting);
            if plotting == 1;pause;end
            for c = 1:numel(EVENTS)
                counter = counter + 1;
                REZ(counter,:) = [N K 0 mean(diff(EVENTS{c})) std(diff(EVENTS{c}))/mean(diff(EVENTS{c}))];
            end
            EVENTSGR = group_cluster_events(t,EVENTS);
            counter = counter + 1;
            REZ(counter,:) = [N K 1 mean(diff(EVENTSGR)) std(diff(EVENTSGR))/mean(diff(EVENTSGR))];
        end
    end
end

boxplot(REZ(:,5),REZ(:,[1 2 3]))

REZ = array2table(REZ);
REZ.Properties.VariableNames = {'N','K','Agg','ITI','cv'};
% writetable(REZ,['pulse_coupled_kuramoto_euler_' datestr(now,'yyyymmdd-HHMMSS') '.csv'],'Delimiter',',')
