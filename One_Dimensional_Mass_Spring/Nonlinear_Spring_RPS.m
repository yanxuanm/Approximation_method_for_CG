clear; clc; close all;

% Create Symbolic Variables
time = 3.1;
step = 50;
epsilon = 0.01;
syms E y0(t) y1(t) y2(t)
% This is regular perturbation series of y
pert_series = y0(t) + E*y1(t) + E^2*y2(t);
% This is regular perturbation series of dy/dt
first_diff_pert_series = diff(pert_series, t);
% This is regular perturbation series of d^2y/dt^2
second_diff_pert_series = diff(first_diff_pert_series, t);
% Now substitute above equation to the nonlinear equation
combine = second_diff_pert_series + E*first_diff_pert_series + pert_series^2==0 

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

% Solve differential equation of first perturbation term
V = odeToVectorField(pert_term(1));
F = matlabFunction(V,'vars',{'t','Y'});
sol = ode45(F,[0 time],[1 0]);
x = linspace(0,time,step);
first_y = deval(sol,x,1);
first_diffy = deval(sol,x,2);
plot(x,first_y);


% To solve second perturbation term, need to substitute results of first
% term
sym replace_y0
for i = 1:size(first_y, 2)
    replace_y0(i) = subs(pert_term(2), diff(y0(t), t), first_diffy(i));
end


sym second_per
for i = 1:size(replace_y0, 2)
    second_per(i) = subs(replace_y0(i), y0(t), first_y(i));
end

Y2 = zeros(size(first_y));
diff_Y2 = zeros(size(first_y));
for i = 1:size(second_per, 2)
    
    V2 = odeToVectorField(second_per(i));
    F2 = matlabFunction(V2,'vars',{'t','Y'});
    sol2 = ode45(F2,[0 time],[1 0]);
    x = linspace(0,time,step);
    Y2(i, :) = deval(sol2,x,1);
    diff_Y2(i, :) = deval(sol2,x,2);

end
figure(2)
plot(x,diag(Y2));

second_y = diag(Y2);
second_diffy = diag(diff_Y2);

% To solve third perturbation term, need to substitute results of first
% and second term
sym replace_y1
for i = 1:size(first_y, 2)
    replace_y1(i) = subs(pert_term(3), diff(y1(t), t), second_diffy(i));
end

sym replace_y1_y0
for i = 1:size(first_y, 2)
    replace_y1_y0(i) = subs(replace_y1(i), y0(t), first_y(i));
end

sym third_per
for i = 1:size(replace_y0, 2)
    third_per(i) = subs(replace_y1_y0(i), y1(t), second_y(i));
end

Y3 = zeros(size(first_y));
diff_Y3 = zeros(size(first_y));
for i = 1:size(third_per, 2)
    
    V3 = odeToVectorField(third_per(i));
    F3 = matlabFunction(V3,'vars',{'t','Y'});
    sol3 = ode45(F3,[0 time],[1 0]);
    x = linspace(0,time,step);
    Y3(i, :) = deval(sol3,x,1);
    diff_Y3(i, :) = deval(sol3,x,2);

end
figure(3)
plot(x,diag(Y3));

figure(4)
% compare with exact solution
f1 = @(t,y)[y(2); -epsilon*y(2)-y(1)^2];
exact_sol = ode45(f1,[0 time],[1 0]);
x = linspace(0,time,step);
exact_Y1 = deval(exact_sol,x,1);
exact_Y2 = deval(exact_sol,x,2);
plot(x, exact_Y1, '*r');
hold on
plot(x, exact_Y2, '*b');
third_y = diag(Y3);
third_diffy = diag(diff_Y3);


ret = first_y' + epsilon.*second_y + epsilon^2.*third_y;
plot(x, ret)

diffret = first_diffy' + epsilon.*second_diffy + epsilon^2.*third_diffy;
plot(x, diffret)
title('Solution of d^{2}y/dt^{2}+0.001*dy/dt + y=0')
xlabel('Time')
ylabel('Displacement')
legend('Exact Solution of y','Exact Solution of y''', 'RPS of y', 'RPS of y''')
% Without using Method of multiple scales, RPS eventually blows up. 

