clear; clc; close all;

% Create Symbolic Variables
small_time = 2;
big_time = 100;
step = 5;
epsilon = 0.01;
syms E y0(t) y1(t) y2(t)
% This is regular perturbation series of y
pert_series = y0(t) + E*y1(t) + E^2*y2(t);
% This is regular perturbation series of dy/dt
first_diff_pert_series = diff(pert_series, t);
% This is regular perturbation series of d^2y/dt^2
second_diff_pert_series = diff(first_diff_pert_series, t);
% Now substitute above equation to the nonlinear equation
combine = second_diff_pert_series + E*first_diff_pert_series + pert_series^3==0 

% collect function returns an equation which is nicely ordered according to
% different power of E. 
combine = collect(combine, E);
equation = strcat("""", string(combine), """")
E0 = strcat(" """, "E^0", """");
E1 = strcat(" """, "E^1", """");
E2 = strcat(" """, "E^2", """");

E_command = [E0, E1, E2];
sym pert_term
% This for loop using python to collect different perturbation term
% according to the power of E. 
for i=1:3
    commandStr = strcat("python collect.py ", equation, E_command(i));
    [status, commandOut] = system(commandStr);
 
    pert_term(i) = str2sym(commandOut);
end

big_ret = [];
big_diffret = [];
reused_ret = 1;
reused_diffret = 0;
f1 = @(t,y)[y(2); -epsilon*y(2)-y(1)^3];
exact_sol = ode45(f1,[0 big_time],[1 0]);
x = linspace(0,big_time,step*(big_time/small_time));
exact_Y1 = deval(exact_sol,x,1);
exact_Y2 = deval(exact_sol,x,2);

for i = 1:big_time/small_time
    [ret, diffret] = small_time_RPS(small_time, step, epsilon, pert_term, reused_ret, reused_diffret);
    big_ret = [big_ret; ret(1:end-1)];
    big_diffret = [big_diffret; diffret(1:end-1)];
    current_step = size(big_diffret, 1)+1;
    reused_ret = exact_Y1(current_step);
    reused_diffret = exact_Y2(current_step);
    fprintf("iteration step: %d\n", i);
    
end
% current_step = size(big_diffret, 1)+1;
% reused_ret = exact_Y1(current_step);
% reused_diffret = exact_Y2(current_step);
% [ret, diffret] = small_time_RPS(small_time, step, epsilon, pert_term, reused_ret, reused_diffret);
% big_ret = [big_ret; ret(1:end)];
% big_diffret = [big_diffret; diffret(1:end)];


plot(x*step/small_time, exact_Y1, '*r');
hold on
plot(x*step/small_time, exact_Y2, '*b');

total_step = linspace(0, (big_time/small_time)*step-big_time/small_time,...
    (big_time/small_time)*step-big_time/small_time );
plot(total_step, big_ret, '-g')
plot(total_step, big_diffret, '-m')
% title('Solution of d^{2}y/dt^{2}+0.001*dy/dt + y=0')
xlabel('Time')
ylabel('Displacement')
legend('Exact Solution of y','Exact Solution of y''', 'RPS of y', 'RPS of y''')
ylim([-2 2])
xlim([0 (big_time/small_time)*step-big_time/small_time])
% Without using Method of multiple scales, RPS eventually blows up. 

