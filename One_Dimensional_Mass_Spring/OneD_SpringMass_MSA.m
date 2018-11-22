clear; clc; close all; 

syms y(t)
% Exact analytical solution to 1-D spring-mass damper.
% Try to manipulate these variables, where a is coefficient of velocity, 
% m is mass, and k is stiffness of spring. 
a = 0.5;
m = 10;
k = 5;
eqn = diff(y,t,2) == (-a*diff(y,t) - k*y)/m;
Dy = diff(y,t);
cond = [y(0)==1, Dy(0)==0];
ySol(t) = dsolve(eqn, cond);

fplot(ySol, [0, 150]);
hold on

% Approximate solution by asymptotic expansion. 
% NOTE: need to recover dimention and units of each dimensionaless terms. 
epsilon = a/(2*sqrt(m*k))
v(t) = exp(-epsilon*(t/sqrt(m/k)))*cos(t/sqrt(m/k))*(1-epsilon^2*(...
    epsilon*(t/sqrt(m/k)) + (epsilon*(t/sqrt(m/k)))^2/4)*exp(-epsilon*(t/sqrt(m/k)))) + epsilon*...
    exp(-epsilon*(t/sqrt(m/k)))*sin((t/sqrt(m/k)))*(1+(epsilon*(t/sqrt(m/k)))/2)

fplot(v, [0, 150]);
xlabel('Time')
ylabel('Displacement')
legend('Exact Solution','MSA')
