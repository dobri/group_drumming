function [value,isterminal,direction] = event(t,y)

z = exp(1i*y);  % wrapping theta around the circle
y = angle(z);   % will give you a number between -pi to pi
value = y;
isterminal = zeros(size(y));
direction = ones(size(y));

