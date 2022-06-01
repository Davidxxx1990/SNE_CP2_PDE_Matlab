function [dydt] = ode_para(t,y,params)

	RIGHT = 1;
	LEFT = 2;

	N = params.N;
	L = params.L;
	H = params.H;
	NU = params.NU;
	K = params.K;
	
	dydt = zeros(numel(y),1);
	nuk = (NU * NU) / (K * K);
	
	n = numel(y)/2;
	
	yleft = [];
	yright = [];
	
	labBarrier;
	if numlabs > 1
	   if labindex == 1
		  labSend(y(n), labindex+1, RIGHT);
		  yright = labReceive(labindex+1, LEFT);
	   elseif labindex == numlabs
		  labSend(y(1), labindex-1, LEFT);
		  yleft = labReceive(labindex-1, RIGHT);
	   else
		  labSend(y(n), labindex+1, RIGHT); 
		  labSend(y(1), labindex-1, LEFT);
		  yleft = labReceive(labindex-1, RIGHT);
		  yright = labReceive(labindex+1, LEFT);
	   end

	   
	   if labindex == 1
		  for i=2:n-1
			  dydt(i) = y(i + n);
			  dydt(i + n) = nuk * y(i - 1) - 2 * nuk * y(i) + nuk * y(i+1);
		  end
		  i = n;
		  dydt(i) =  y(i + n);
		  dydt(i + n) = nuk * y(i - 1) - 2 * nuk * y(i) + nuk * yright;
	   elseif labindex == numlabs
		  i = 1;
		  dydt(i) =  y(i + n);
		  dydt(i + n) = nuk * yleft - 2 * nuk * y(i) + nuk * y(i + 1);
		  for i=2:n-1
			  dydt(i) = y(i + n);
			  dydt(i + n) = nuk * y(i - 1) - 2 * nuk * y(i) + nuk * y(i+1);
		  end
	   else
		  i = 1;
		  dydt(i) =  y(i + n);
		  dydt(i + n) = nuk * yleft - 2 * nuk * y(i) + nuk * y(i + 1);
		  for i=2:n-1
			  dydt(i) = y(i + n);
			  dydt(i + n) = nuk * y(i - 1) - 2 * nuk * y(i) + nuk * y(i+1);
		  end
		  
		  i = n;
		  dydt(i) =  y(i + n);
		  dydt(i + n) = nuk * y(i - 1) - 2 * nuk * y(i) + nuk * yright;
	   end
	   
	else
	    for i=2:n-1
		   dydt(i) = y(i + n);
		   dydt(i + n) = nuk * y(i - 1) - 2 * nuk * y(i) + nuk * y(i+1);
	    end
	end
	
	
	
end

