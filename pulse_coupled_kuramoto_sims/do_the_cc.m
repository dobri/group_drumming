function rez = do_the_cc(data,raw_plotting)

% raw_plotting = 0;

cfg.maxlag_auto = .8; % seconds
cfg.maxlag = .4;
cfg.binsize = .02;
cfg.debias = 'yes';
cfg.proport = 'poisson_chance';
cfg.plotting = raw_plotting;

rez.async.col_labels={'pp1','pp2','aclag1','meanasync','sdasync','ttestasync'};
rez.async.x = [];

rez.cc.col_labels={'pp1','pp2','lag','p(c)','is_max'};
rez.cc.x = [];

counter = 0;
for r=1:numel(data)
    for c=1:numel(data)
        counter = counter + 1;
        [C,lags] = spike_crossx(data{r}, data{c}, cfg, r==c);
        if cfg.plotting==1
            subplot(1,3,1:2);xlim([10 20])
        end
        ind_max = find(C==max(C),1,'first');
        temp = [ones(numel(C),1)*r ones(numel(C),1)*c lags C ...
            (1:numel(C))'==ind_max];
        rez.cc.x = vertcat(rez.cc.x,temp);
        
        D = data{r}-data{c}'; % All asynchronies
        [~,ind] = min(abs(D),[],2); % Find the closest pairs.
        a1 = ind*nan;
        for i = 1:numel(a1)
            a1(i) = D(i,ind(i));
        end
        [ac,~] = xcov(a1,a1,10,'coeff');
        [acs,lags] = xcov(sign(a1),sign(a1),10,'coeff');
        ac(lags==0)=nan;
        acs(lags==0)=nan;
        if cfg.plotting==1
            title_lab = 'Async AC';
            figure(double(title_lab(1)));
            clf
            plot(lags,ac,'-ok','linewidth',2)
            hold on
            plot(lags,acs,'-ob','linewidth',2);grid on;
            hold off
            grid on
            pause
        end
        acl1=ac(lags==1);
        acs(lags==0)=[];
        ac(lags==0)=[];
        %acl1=acs(lags==1);
        lags(lags==0)=[];
        rez.async.x = vertcat(rez.async.x,[r c acl1 mean(a1) std(a1) ttest(a1)*sign(mean(a1))]);
    end
end

% if cfg.plotting==1
%     pause
% end