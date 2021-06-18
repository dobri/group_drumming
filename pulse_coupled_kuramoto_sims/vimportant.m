%% Setting the Stage

% dd
global f0 f w pulse stim noise kmodel K

%dd
% N = 8;                       %Number of oscillators/drummers

f0 = 2;                      %Mean natural freq of oscillators, 2Hz tapping
f = f0 + sigma*randn(N,1);     %Each drummer's freq, even distribution around f0, SD = .05 % dd
w = f*2*pi;                  %Each drummer's radian freq  (omega)

fs = 500;                    %Stimulus sampling rate, 500Hz/sec
tspan = [0 30];              %Time span in seconds

%Defining the drum PULSE using gamma pdf parameters
pulse.fs = fs;
pulse.t = (0:1/pulse.fs:0.25);
pulse.x = gampdf(pulse.t,1.25,0.02);
pulse.N = length(pulse.t);

    %Plot the drum pulse
% dd
%     figure(1);
%     plot(pulse.t,pulse.x);
    
%Defining the STIMULUS with empty function to be filled by defined variables in ode23
stim.fs = fs;
stim.t = (tspan(1):1/stim.fs:tspan(end));
stim.N = length(stim.t);
stim.x = zeros(N,stim.N);

%Defining the NOISE
% dd
sd = the_other_sigma*2*pi;                    %Define SD of noise (in units of phase)
noise.fs = fs;
noise.t = stim.t;
noise.x = sd*randn(N, stim.N);  %Diff noise for each drummer to length of stimulus
noise.N = stim.N;

%Set initial conditions for function
y0 = 2*pi*rand(N,1) - pi;

%Define event options for ode23
options = odeset('MaxStep',1/stim.fs,'Events',@EventsLana);

    %Modified ode23 code by Ed:
        %lines 76-77 make PULSE and STIM global 
        %lines 353-374 generates pulse function and iterative addition to stimulus

%% Running the Simulation

disp('Calculating solo...')
    K = 0;                      %run with no coupling, solo condition
    thefunpart;                 %runs the actual ode integrator
    stdi_0 = stdi;
    
    % dd
    cvs{rx,1} = STD./cell2mat(ME);
    cvs{rx,2} = stdg/meg;
    mes{rx,1} = cell2mat(ME);
    mes{rx,2} = meg;
    Ks(rx,1) = K;
    Ns(rx,1) = N;

disp('Calculating group...')
    stim.x = zeros(N,stim.N);   %reinitialize stimulus from previous solo
    K = Kc;                     %redefine coupling so influenced by group
    thefunpart;
    
    % dd
    cvs{rx,3} = STD./cell2mat(ME);
    cvs{rx,4} = stdg/meg;
    mes{rx,3} = cell2mat(ME);
    mes{rx,4} = meg;
    Ks(rx,2) = K;
    Ns(rx,2) = N;
    
