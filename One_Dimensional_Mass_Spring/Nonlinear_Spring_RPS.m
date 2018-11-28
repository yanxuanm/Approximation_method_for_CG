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

combine = collect(combine, E);
equation = strcat("""", string(combine), """")
E0 = strcat(" """, "E^0", """");
E1 = strcat(" """, "E^1", """");
E2 = strcat(" """, "E^2", """");

E_command = [E0, E1, E2];
pert_term = sym(size(E_command))
for i=1:3
    commandStr = strcat("python collect.py ", equation, E_command(i));
    [status, commandOut] = system(commandStr);
 
    pert_term(i) = str2sym(commandOut)
end
