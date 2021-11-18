function [THETA,t,PSI,EVENTS,OMEGA0,THETA_,DELTA]=sim_pulse_kuramoto_euler(N,K,sigma,gam,omega_center,sr,plotting)

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

OMEGA0 = -inf;
while any(OMEGA0<0)
    OMEGA0 = (randn(1,N))*2*pi*gam+omega_center;
end
    
OMEGA = OMEGA0;
fprintf('%8.2f',OMEGA0./2/pi);fprintf('\n')
% K_critical_theoretical ?

events = zeros(1,N);
EVENTS = cell(1,N);
THETA = nan(len,N);
THETA_= nan(len,N);
DELTA = zeros(len,N);
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
    %Pulse = Pulse./max(Pulse);
    theta = theta + dt*OMEGA + dt*randn(size(theta))*sigma*2*pi;
    %delta = dt*K/N.*(Pulse*(~eye(N).*sin(theta)));
    delta = dt*K/N.*(Pulse*sin(theta'-theta));
    THETA_(c,:) = theta;
    THETA(c,:) = theta + delta;
    theta = THETA(c,:);
    DELTA(c,:) = delta;
    %THETA(c,:) = theta + dt*OMEGA + dt*K/N.*(Pulse*(~eye(N).*sin(theta))) + dt*randn(size(theta))*sigma*2*pi;
    PSI(c)= (1/N)*sum(exp(1i*theta));
    
    for n = 1:N
        % if diff(sign(angle(exp(1i*THETA(c-1:c,n)))))==2 % wraps at 2*pi.
        % if diff(sign(angle(exp(1i*THETA(c-1:c,n)))))==-2 % wraps at +/- pi.
        % if abs(diff(angle(exp(1i*THETA(c-1:c,n)))))>pi % wraps at +/- pi.
        if diff(mod(THETA(c-1:c,n),2*pi))<-pi % wraps at 2*pi.
            % added noise can cause spurious bursts of zero-crossings
            if (t(c)-events(n))>.2
                events(n) = t(c);
                EVENTS{n} = vertcat(EVENTS{n},events(n));
            end
        end
    end
end

if plotting == 1
    figure(112335)
    plot(t,angle(exp(1i*THETA))./pi*.4+(1:size(THETA,2)),'-','linewidth',2)
    hold on
    line([min(t);max(t)].*ones(1,size(THETA,2)),(1:size(THETA,2)).*ones(2,1),'color','k');
    for n = 1:numel(EVENTS)
        line([EVENTS{n}';EVENTS{n}'],[EVENTS{n}'*0+n-.5;EVENTS{n}'*0+n+.5],'color','k');
    end
    plot(t,angle(PSI)./pi*.4+N+1,'-','linewidth',3)
    hold off

    figure(112335+1)
    plot(t,real(exp(1i*THETA))./pi*.4+(1:size(THETA,2)),'-','linewidth',2)
    hold on
    line([min(t);max(t)].*ones(1,size(THETA,2)),(1:size(THETA,2)).*ones(2,1),'color','k');
    for n = 1:numel(EVENTS)
        line([EVENTS{n}';EVENTS{n}'],[EVENTS{n}'*0+n-.5;EVENTS{n}'*0+n+.5],'color','k');
    end
    plot(t,angle(PSI)./pi*.4+N+1,'-','linewidth',3)
    hold off

    figure(112335+2)
    plot(t,DELTA+(1:size(THETA,2)),'-','linewidth',2)
    hold on
    for n = 1:numel(EVENTS)
        line([EVENTS{n}';EVENTS{n}'],[EVENTS{n}'*0-1;EVENTS{n}'*0+1]+mean(DELTA(:,n))+n,'color','k');
    end
    hold off
end
