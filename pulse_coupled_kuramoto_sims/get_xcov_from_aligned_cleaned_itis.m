plotting = 1;

%% Virtual aggregate group. 
% Use that as reference against which to align the individual drum hits.
fprintf('\t%s\n','Constructing the virtual group.')
for tr = 1:size(TEs.te,1)
    fprintf('Trial%4.0f\n',tr)
    temp = [];
    for col = 1:size(TEs.te{tr},2)
        temp = [temp;TEs.te{tr}{col}];
    end
    bpm_arg = mean(60./diff(TEs.te{tr}{1}));
    TEs.group_te{tr} = get_virtual_group_gauss_fps(sort(temp),plotting,bpm_arg,size(TEs.te{tr},2));
end

%% Get aligned, cleaned tempos and xcov.
fprintf('\t%s\n','Align tempos')
for tr = 1:size(TEs.te,1)
    fprintf('Trial%4.0f\n',tr)
    bpm_arg = mean(60./diff(TEs.group_te{tr}));
    TEs.CC{tr,1} = get_aligned_asyncs_and_tempos(TEs.te{tr},TEs.group_te{tr},1,bpm_arg,plotting);
end

% Pivot into one table in the long format.
CC = [];
for tr = 1:size(TEs.CC,1)
    for l = 1:size(TEs.CC{tr}.C,1)
        CC = [CC; [[TEs.cond(tr,:) TEs.CC{tr}.l(l)].*ones(numel(TEs.CC{tr}.C(l,:)),1) TEs.CC{tr}.pp TEs.CC{tr}.ac TEs.CC{tr}.cc TEs.CC{tr}.C(l,:)']];
    end
end

CC01 = CC(CC(:,2)>0 & CC(:,8)==1 & (CC(:,4)==0 | CC(:,4)==1),:);
AC01 = CC(CC(:,2)>0 & CC(:,7)==1 & CC(:,4)==1,:);

subplot(1,2,1)
boxplot(CC01(:,9),CC01(:,[1 4]))
subplot(1,2,2)
boxplot(AC01(:,9),AC01(:,[1 4]))


%% Get ccs, method 2.
fprintf('\t%s\n','Spike-based method')
for tr = 1:size(TEs.te,1)
    fprintf('Trial%4.0f\n',tr)
    TEs.CCS{tr,1} = do_the_cc(TEs.te{tr},0);
end

CCAS = [];
CCS = [];
for tr = 1:size(TEs.CCS,1)
    temp = TEs.CCS{tr}.async.x;
    temp(temp(:,1)==temp(:,2),:)=[];
    CCAS = [CCAS; [[TEs.cond(tr,:) 1].*ones(size(temp,1),1) temp]];
    % AC on the asynchronies:
    % N K run lag1
    % col_labels: {'pp1'  'pp2'  'aclag1'  'meanasync'  'sdasync'  'ttestasync'}
    
    temp = TEs.CCS{tr}.cc.x(TEs.CCS{tr}.cc.x(:,end)==1,:);
    temp(temp(:,1)==temp(:,2),:)=[];
    CCS = [CCS; [TEs.cond(tr,:).*ones(size(temp,1),1) temp]];
    % CC with optimal delay
    % N K run
    % col_labels: {'pp1'  'pp2'  'lag'  'p(c)'  'is_max'}
end

boxplot(CCAS(:,7),CCAS(:,1))