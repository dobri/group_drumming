%% Parameters   
global K N f0 f w pulse stim noise kmodel Kc

% Comment in the next line if running the script from command line. Comment
% out if using aFewRuns05.m 
%Kc  = 4.5; % 3, 3.25, 
N   = 4;                        % Number of oscillators
f0  = 2;
f   = f0 + 0.1*[-1.5 -0.5 0.5 1.5]';   % Oscillator frequencies
                                % ... don't use random, makes replication harder
w   = f*2*pi;                   % Radian frequencies
sd  = 3*2*pi; % 4.33* % was 14.5       % Standard deviation on noise (units of phase)  

fs    = 500;                    % Sampling rate of stimulus   
tspan = [0 30];                 % time span of simulation  

pulse.fs = fs;                  % The drum pulse
pulse.t = (0:1/pulse.fs:0.25);
pulse.x = gampdf(pulse.t,1.25,0.02);
pulse.N = length(pulse.t);
%figure(1); plot(pulse.t, pulse.x); drawnow;

%% Stimulus and noise

stim.fs = fs;
stim.t = (tspan(1):1/stim.fs:tspan(end));
stim.N = length(stim.t);
stim.x = zeros(N,stim.N);

noise.fs = fs;
noise.t = stim.t;
noise.x = sd*randn(N, stim.N);
noise.N = stim.N;

%% Simulation
% Comment in the next line if running the script from command line. Comment
% out if using aFewRuns05.m
% kmodel = 0; % zero is original phase coupled model

disp('Solo ... ')
   K = 0;
   run05;
   stdi_0 = stdi;

% Comment in the the figure if running  the script from command line. Comment
% out if using aFewRuns05.m
%     figure(5)    
%         bar([1 2 3], [stdi_0, 0, 0]/2); % 2 is the mean frequency
%         ylabel('CV','Fontsize', 20)
%         set(gca, 'XTickLabel', {'Inds-in-Solo', 'Inds-in-Group', 'Group'}, 'Fontsize',20)
% %         set(gca, 'YLim', [0.02 0.06])
% %         set(gca, 'YLim', [0.00 0.075])
%         xtickangle(45);
%         drawnow;

disp('Group ... ')
   stim.x = zeros(N,stim.N); % reinitialize stimulus
   K = Kc;
   run05;

%% Plot Result

figure(2);
ax1 = subplot(2,1,1);
    plot(t, sum(p));
    title('Drum Pulses');
    xlabel('time t')
    ylabel('Pulses');
    grid

ax2 = subplot(2,1,2);
    plot(t, osc, t, r, 'k', 'LineWidth', 2)
    title('Mean Field & Order Parameter');
    xlabel('time t')
    ylabel('Amplitude');
    grid

linkaxes([ax1 ax2], 'x'); zoom xon;

%
figure(3); 
    plot(stim.t, stim.x)

figure(4)
   plot(stim.t, stim.x, t, sum(p));


figure(5)
    bar([1 2 3], [stdi_0, stdi, stdg]/2); %2 is the mean frequency
    ylabel('CV','Fontsize',20)
    set(gca, 'XTickLabel', {'Inds-in-Solo', 'Inds-in-Group', 'Group'}, 'Fontsize',20)
%     set(gca, 'YLim', [0.02 0.06])
%     set(gca, 'YLim', [0.00 0.075])
    xtickangle(45);
%     
% disp(stdg)
% disp(mean([std1 std2 std3 std4]))
