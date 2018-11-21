clear; clc; close all; 

syms y(t)
% Exact analytical solution to 1-D spring-mass damper.
% Try to manipulate these variables, where a is coefficient of velocity, 
% m is mass, and k is stiffness of spring. 
a = 0.05;
m = 10;
k = 5;
eqn = diff(y,t,2) == (-a*diff(y,t) - k*y)/m;
Dy = diff(y,t);
cond = [y(0)==1, Dy(0)==0];
ySol(t) = dsolve(eqn, cond);

fplot(ySol, [0, 250]);
hold on

% Approximate solution by asymptotic expansion. 
% NOTE: need to recover dimention and units of each dimensionaless terms. 
epsilon = a/(2*sqrt(m*k))
v(t) = cos(t/sqrt(m/k))+epsilon*(sin(t/sqrt(m/k))-t*cos(t/sqrt(m/k)))...
    +epsilon^2*((t/sqrt(m/k))^2/2*cos(t/sqrt(m/k))-(t/sqrt(m/k))/2*sin(t/sqrt(m/k)))

fplot(v, [0, 250]);

% This RPS gives a very good approximation when epsilon is much less than
% 1. The main effect of small damping is to reduce the amplitude of the  
% oscillation exponentially in time. The frequency shift is only important 
% once eplison^2*t ~ 1, and on that long time the amplitude of the residual
% oscillation is exponentially small (~exp(-1/2*epsilon)). So we don?t 
% worry too much about the frequency shift. However, if time is arbitrarily
% large, or epsilon is large, RPS will fail. Slowly accumulated error is called
% secular error.