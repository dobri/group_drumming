function G = get_aligned_asyncs_and_tempos(in,ref,varargin)

if numel(varargin)>0
    n_clusters = varargin{1};
else
    n_clusters = 1;
end
if numel(varargin)>1
    starting_clusters = varargin{2};
else
    starting_clusters = [];
end
if numel(varargin)>2
    plotting = varargin{3};
else
    plotting = 1;
end

cols_remove = [];
xt=nan(numel(ref)-2,size(in,2));
for c = 1:size(in,2)
    if ~isempty(in{c})
        for r=1:size(ref,1)
            [~,ind] = min((ref(r)-in{c}).^2);
            xt(r,c) = in{c}(ind);
        end
    else
        cols_remove = [cols_remove c];
    end
end
xt(:,cols_remove) = [];


% Remove all nan-rows and repeats
dxt=diff(xt);
index1 = sum(isnan(dxt),2)>0;
index2 = sum(dxt==0,2)>0;
xt(find((index1+index2)>0)+1,:)=[];
ref(find((index1+index2)>0)+1,:)=[];
dxt((index1+index2)>0,:)=[];
dxt = 60./dxt;


% Flatten out by using clustering
idx=zeros(size(dxt));
for c=1:size(dxt,2)
    if isempty(starting_clusters)
        [idx(:,c),C(c,1)]=kmeans(log(dxt(:,c)),n_clusters);
    else
        if n_clusters == 1 && numel(starting_clusters)==1
            starting_clusters = median(dxt(:,c));
        end
        try [idx(:,c),C(c,:)]=kmeans(log(dxt(:,c)),n_clusters,'Start',log(starting_clusters));catch me;keyboard;end
    end
end
C = exp(C);
if n_clusters==1
    higher_cutoff = 1.4*max(C,[],2)';
    lower_cutoff = .6*min(C,[],2)';
else
    higher_cutoff = 1.5*max(C,[],2)';
    lower_cutoff = .5*min(C,[],2)';
end


if plotting == 1
    figure(3)
    clf
    for c=1:size(dxt,2)
        subplot(size(dxt,2),1,c)
        plot(xt(2:end,c),dxt(:,c),'-k')
        hold on
        for n=1:n_clusters
            plot(xt([false;idx(:,c)==n],c),dxt(idx(:,c)==n,c),'o')
        end
        plot(ref(2:end),60./diff(ref),'v')
        hold off
    end
end


dxt_warped = dxt;
for c=1:size(dxt_warped,2)
    if n_clusters==3
        dxt_warped(idx(:,c)==1,c) = dxt_warped(idx(:,c)==1,c).*2;
        dxt_warped(idx(:,c)==3,c) = dxt_warped(idx(:,c)==3,c)./2;
    end
end


% Crop skipped beats and such
index = ((sum(dxt_warped<lower_cutoff,2)==0) + (sum(dxt_warped>higher_cutoff,2)==0)) == 2;
idx = idx(index,:);
dxt_warped = dxt_warped(index,:);
xt = xt(find(index)+1,:);
ref = ref(find(index)+1,:);

if plotting == 1
    figure(4)
    clf
    for c=1:size(dxt_warped,2)
        subplot(size(dxt_warped,2),1,c)
        plot(xt(:,c),dxt_warped(:,c),'-k')
        hold on
        for n=1:n_clusters
            plot(xt(idx(:,c)==n,c),dxt_warped(idx(:,c)==n,c),'o')
        end
        % plot(ref(2:end),60./diff(ref),'v')
        hold off
    end
end

if plotting == 1
    pause
end

% Detrend
G.tempos_raw = dxt;
G.tempos = detrend_and_unnan(dxt_warped,dxt_warped(:,end));
G.note_indices = idx;


% Stats for output
G.num_pps = size(G.tempos,2);
G.async=xt-ref;
G.async(abs(G.async)>.3)=nan;
G.masync=nanmean(G.async);
G.sdasync=nanstd(G.async);
G.ttest=ttest(G.async,0).*sign(nanmean(G.async));
G.t=xt;


% XCov, up to lag8.
G.C=xcov(G.tempos,8,'coef');
G.l=(-8:8)';
G.pp = [reshape(meshgrid(1:size(G.tempos,2),1:size(G.tempos,2)),[],1) ...
    reshape(meshgrid(1:size(G.tempos,2),1:size(G.tempos,2))',[],1)];
G.ac = diff(G.pp,[],2)==0;
G.cc = diff(G.pp,[],2)~=0;

end