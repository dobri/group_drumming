%% Define where there is an event (when pulse occurs)

function [value,isterminal,direction] = event(t,y)

z = exp(1i*y);  % wrapping theta (phases) around the unit circle
y = angle(z);   % will give you a number between -pi to pi on the circle
value = y;      % value is the phase angle
isterminal = zeros(size(y));
direction = ones(size(y));    %when y value goes from negative to positive, generate event (gamma pdf pulse)

