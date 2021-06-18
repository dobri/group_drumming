%% Run the Function ODE23

[t,y,te,ye,ie] = ode23(@ydotLana,tspan,y0,options); %will only work if define K
                                                    %idx inside not being defined?
    %each drummer is a diff differential equation
    %ie is dimension for each event, defines which drummer event is for
    
t = t';
y = y';

%% Formatting Output

z = exp(1i*y);                  %Imaginary term in oscillator function
theta = angle(z);               %Phase angle from -pi to pi
mf = (1/N)*sum(z);              %Mean field given from order parameter
r = abs(mf);                    %Amplitude of the mean field
psi = angle(mf);                %Phase coherence of mean field
osc = real(mf);                 %Real part of mean field = oscillation

    %To graph pulses using gampdf, not events
    F = repmat(f,1,size(z,2));      
    p = gampdf(theta/2/pi./F,1.25,0.02);
    
%% Computing Variance & Correlation Variables

global diffDE               %Make global variable for correlation calculations

TE = {};                    %Create list of all drummers event times
DE = {};                    %Create list of all drummers event time differences
ME = [];                    %Create matrix of all drummers mean event time differences
STD = [];                   %Create vector of all drummers std of event time differences

%Loop to calculate above for each drummer, explicit so unique for each

for idrummer = 1:N
    TE{idrummer} = te(find(ie == idrummer));   %ie determines which drummer, need to index to N
    DE{idrummer} = diff(TE{idrummer});
    ME{idrummer} = mean(DE{idrummer});
    STD(idrummer) = std(DE{idrummer});
    
    diffDE{idrummer} = DE{1,idrummer} - ME{1,idrummer};
        l = min(cellfun('size',diffDE,1));
    diffDE{idrummer} = diffDE{idrummer}(1:l);
end

% try matDE = cell2mat(diffDE);catch me;keyboard;end % dd

stdi = mean([STD]);         %Define average individual drummer std

%Defining stimulus times 
stim.t = t(1):1/stim.fs:t(end);
group = zeros(size(stim.t));
for tx = 1:length(te)
    tt = te(tx);
    ix = find(abs(stim.t-tt) == min(abs(stim.t-tt)));
    group(ix) = group(ix)+1;
end

%Filtering the output
b = normpdf(-10:10, 0, 2);
fgroup = filtfilt(b, 1, group);
[peaks, locs] = findpeaks(fgroup,stim.t,'MinPeakDistance', .3); % dd

dgroup = diff(locs);
meg = mean(dgroup);
stdg = std(dgroup);



    
