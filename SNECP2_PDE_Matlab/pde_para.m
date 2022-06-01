
tic;

N = 500;
L = 0.5;
H = 0.05;
dt = 0.001;
Tend = 10;
NU = 0.06;


y = zeros((N+1)*2,1);

for i=1:N/2
   y(i+1) = 2.0 * H / N * i; 
end
for i=N/2 : N
   y(i+1) = 2.0 * H * (1 - i / N); 
end


spmd
    
	params.N = N;
	params.L = L;
	params.H = H;
	params.NU = NU;
	params.K = L/N;
    
    lsize = fix((N+1) / numlabs);
    
    if(mod(N+1,numlabs) > 0 && (numlabs - mod(N+1,numlabs)) < labindex)
	  lsize = lsize + 1; 
    end
    
    imin = fix((N+1) / numlabs) * (labindex-1) + 1;
    for i=1:labindex-1
		if(mod(N+1,numlabs) > 0 && (numlabs - mod(N+1,numlabs)) < i)
			imin = imin + 1;
		end
    end
    imax = imin + lsize - 1; 
    
    y0 = zeros(lsize*2,1);
    y0 = [y(imin:imax); y(imin+(N+1):imax+(N+1))];
    
    
   
    t=0;
    utL2l=[];
    if imin <= N/2+1 && N/2+1 <= imax
		utL2l = [y(N/2+1)];
    end
    ut3L4l=[];
    if imin <= 3*N/4 + 1 && 3*N/4 + 1 <= imax
		ut3L4l = [y(3*N/4+1)];
    end
    y = y0;
    for steps=1:numel(0:dt:Tend)-1
		labBarrier;
		[tstep, ystep] = rk4_step('ode_para', t, dt, y, params);
		t = tstep;
		y = ystep;
		if steps == fix(5.0/dt)+1
			ux_t5l = ystep(1:lsize);
		end
		if steps == fix(8.0/dt)+1
			ux_t8l = ystep(1:lsize);
		end

		if imin <= N/2+1 && N/2+1 <= imax
			utL2l = [utL2l, ystep(N/2+1-imin+1)];
		end
		if imin <= 3*N/4 + 1 && 3*N/4 + 1 <= imax
			ut3L4l = [ut3L4l, ystep(3*N/4+1-imin+1)];
		end
	end
    
end

ux_t5=[];
ux_t8=[];
utL2=[utL2l{:}];
ut3L4=[ut3L4l{:}];

for i=1:length(ux_t5l)
   ux_t8 = [ux_t8; ux_t8l{i}];
   ux_t5 = [ux_t5; ux_t5l{i}];
end

t = toc;

