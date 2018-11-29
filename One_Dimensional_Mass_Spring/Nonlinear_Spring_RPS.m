clear; clc; close all;

% Create Symbolic Variables
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
 
    pert_term(i) = str2sym(commandOut)
end

V = odeToVectorField(pert_term(1));
F = matlabFunction(V,'vars',{'t','Y'});
sol = ode45(F,[0 3],[1 0]);
x = linspace(0,3,20);
first_y = deval(sol,x,1);
first_diffy = deval(sol,x,2);
plot(x,first_y);


% dim_matrix = zeros(size(pert_term, 2), size(sol.y, 2))
% temp_pert_term = sym(size(dim_matrix))
sym replace_y0
for i = 1:size(first_y, 2)
    replace_y0(i) = subs(pert_term(2), diff(y0(t), t), first_diffy(i))
end


sym second_per
for i = 1:size(replace_y0, 2)
    second_per(i) = subs(replace_y0(i), y0(t), first_y(i))
end

Y2 = zeros(size(first_y));
diff_Y2 = zeros(size(first_y));
for i = 1:size(second_per, 2)
    
    V2 = odeToVectorField(second_per(i));
    F2 = matlabFunction(V2,'vars',{'t','Y'});
    sol2 = ode45(F2,[0 3],[1 0]);
    x = linspace(0,3,20);
    Y2(i, :) = deval(sol2,x,1);
    diff_Y2(i, :) = deval(sol2,x,2);

end
figure(2)
plot(x,diag(Y2));

second_y = diag(Y2);
second_diffy = diag(diff_Y2);

sym replace_y1
for i = 1:size(first_y, 2)
    replace_y1(i) = subs(pert_term(3), diff(y1(t), t), second_diffy(i))
end

sym replace_y1_y0
for i = 1:size(first_y, 2)
    replace_y1_y0(i) = subs(replace_y1(i), y0(t), first_y(i))
end

sym third_per
for i = 1:size(replace_y0, 2)
    third_per(i) = subs(replace_y1_y0(i), y1(t), second_y(i))
end

Y3 = zeros(size(first_y));
diff_Y3 = zeros(size(first_y));
for i = 1:size(third_per, 2)
    
    V3 = odeToVectorField(third_per(i));
    F3 = matlabFunction(V3,'vars',{'t','Y'});
    sol3 = ode45(F3,[0 3],[1 0]);
    x = linspace(0,3,20);
    Y3(i, :) = deval(sol3,x,1);
    diff_Y3(i, :) = deval(sol3,x,2);

end
figure(3)
plot(x,diag(Y3));

third_y = diag(Y3);
third_diffy = diag(diff_Y3);

epsilon = 0.001

ret = first_y' + epsilon.*second_y + epsilon^2.*third_y;
figure(4)
plot(x, ret)

diffret = first_diffy' + epsilon.*second_diffy + epsilon^2.*third_diffy;
figure(5)
plot(x, diffret)
