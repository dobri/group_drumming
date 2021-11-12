function [THETA,t,PSI,EVENTS,OMEGA0]=sim_pulse_kuramoto_euler(N,K,sigma,gam,omega_center,sr,plotting)

start = 0;
stop = 1e2; % seconds
dt = 1/sr;
duration = stop-start;
len = duration/dt;
t = linspace(start,stop,len)';

% Pulse (Gamma) function and parameters.
a = 1.25;
b = .02;
% ¡ remember to set negative t to zero!
Pt = @(t,a,b)(1./(b.^a.*gamma(a)).*t.^(a-1).*exp(-t./b));

% Pulse-coupled Kuramoto Euler fun
%fun=@(pn,dt,om,K,Pt)(pn+dt.*(om+K/numel(Pt).*(Pt*(~eye(numel(Pt)).*sin(-pn)))));

OMEGA0 = (randn(1,N))*2*pi*gam+omega_center;
OMEGA = OMEGA0;
fprintf('%8.2f',OMEGA0./2/pi);fprintf('\n')
% K_critical_theoretical ?

events = zeros(1,N);
EVENTS = cell(1,N);
THETA = nan(len,N);
PSI = nan(len,1);

theta = (randi(N,1,N)./N)*2*pi;

THETA(1,:) = theta;
PSI(1) = (1/N)*sum(exp(1i*theta));
% z = exp(1i*theta);              %Imaginary term
% angle(z);                       %Phase angle from -pi to pi
% mf = (1/N)*sum(z);              %Mean field given from order parameter
% r = abs(mf);                    %Amplitude of the mean field
% angle(mf);                      %Phase of mean field
% osc = real(mf);

for c = 2:len
    % if mod(c,round(len/10))==0;fprintf('%6.0f',c/len*100);end
    % if mod(c,round(len/1))==0;fprintf('\n');end
    
    Pulse = Pt((t(c)-events).*((t(c)-events)>0),a,b);
    % theta = fun(theta,dt,omvec,K(c),Pulse);
    theta = theta + dt*OMEGA + dt*K/N.*(Pulse*(~eye(N).*sin(theta))) + dt*randn(size(theta))*sigma*2*pi;
    THETA(c,:) = theta;
    PSI(c)= (1/N)*sum(exp(1i*theta));
    
    for n = 1:N
        if abs(diff(angle(exp(1i*THETA(c-1:c,n)))))>pi
            % added noise can cause spurious bursts of zero-crossings
            if (t(c)-events(n))>.2
                events(n) = t(c);
                EVENTS{n} = vertcat(EVENTS{n},events(n));
                % OMEGA(n) = OMEGA0(n)+randn*sigma_om;
            end
        end
    end
end

if plotting == 1
    plot(t,angle(exp(1i*THETA))./pi*.4+(1:size(THETA,2)),'-','linewidth',2)
    hold on
    line([min(t);max(t)].*ones(1,size(THETA,2)),(1:size(THETA,2)).*ones(2,1),'color','k');
    plot(t,angle(PSI)./pi*.4+N+1,'-','linewidth',3)
    hold off
end
