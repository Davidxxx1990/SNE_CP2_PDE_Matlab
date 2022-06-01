function [t, ux_t5, ux_t8, utL2, ut3L4] = run(location, n)

	if(location == "local")
		fprintf("run local with %d Worker(s)\n", n); 
		pool = parpool(n);
		pde_para;
		delete(pool);
		
	elseif(location == "cluster")
	    fprintf("run on cluster with %d Worker(s)\n", n);
	    cluster = parcluster('Seneca');
	    job = batch(cluster,	'pde_para','Pool', n, ...
						'AttachedFiles', 'rk4_step' ,...
						'AttachedFiles', 'ode_para' ,...
						'AutoAddClientPath',false);
		wait(job);
		load(job, 't');
		load(job, 'ux_t5');
		load(job, 'ux_t8');
		load(job, 'utL2');
		load(job, 'ut3L4');
		load(job, 'L');
		load(job, 'N');
		load(job, 'Tend');
		load(job, 'dt');
		
		delete(job);
	end
	fprintf("Elapsed time is %f seconds\n", t);
	
	plot(0:L/N:L, ux_t5); hold on;
	plot(0:L/N:L, ux_t8);

	figure
	plot(0:dt:Tend, utL2); hold on;
	plot(0:dt:Tend, ut3L4);
end

