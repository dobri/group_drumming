function dydt = ydotLana(t,y)
%% Dynamics Pulse Coupling Gamma Distribution

% global N f0 f w e pulse stim noise kmodel K
global N w stim noise kmodel K
    
%   Mean field
     z = exp(1i*y);  % Wrapping theta around the circle
     v = angle(z);   % Phase, -pi to pi    
    
%   STIM is a global variable, pulse emited from each drum using events
%       -Computed using ode23
%       -Used to use gampdf but can't define with variable phase over time

    idx = find(abs(stim.t - t) == min(abs(stim.t - t))); idx = idx(1);
    x   = stim.x(:, idx); 
  
%   Noise defined here so the noise stays constant for uncoupled and coupled drummers
    n   = noise.x(:, idx);

    if kmodel == 0  %Using the original Kuramoto model
        Y = repmat(y, 1, N); %each drummer coupled to everyone and self
        dydt = w + (K/N) * sum(sin(Y-Y'))' + n;   
    else
        C = ~diag(ones(1,N)); %each drummer coupled to others, not self
%          x, sin(y)', x*sin(y)', C.*(x*sin(y)')
        dydt = w - (K/N) * sum(C.*(x*sin(y)'))' + n;              
    end
    
end