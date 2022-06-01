function [t, dydt] = rk4_step(fun,t0,h,y0,params)

	dydt = zeros(numel(y0), 1);
	t = t0;

	k1 = h * feval(fun,t,y0,params);
	k2 = h * feval(fun,t+h/2,y0 + k1./2, params);
	k3 = h * feval(fun,t+h/2,y0 + k2./2, params);
	k4 = h * feval(fun,t+h,y0 + k3, params);

	dydt = y0 + (k1 + 2 * k2 + 2 * k3 + k4) / 6;
	t =t+h;
end

