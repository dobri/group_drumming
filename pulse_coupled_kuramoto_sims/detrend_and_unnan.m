function y = detrend_and_unnan(y,y_trendy)
x=(1:size(y,1))';
% Detrend, but do not remove the intercept.
%trend = (sum(([ones(numel(x),1) x]\y_trendy)'.*[ones(numel(x),1) x],2));
trend = (sum(([ones(numel(x),1) x.^1 x.^2 x.^3 x.^4]\y_trendy)'.*[zeros(numel(x),1) x.^1 x.^2 x.^3 x.^4],2));
y=y-trend;
end