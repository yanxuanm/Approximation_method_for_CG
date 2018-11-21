clear; clc; close all; 

syms y(t)

a = 0.05;
m = 10;
k = 5;
eqn = diff(y,t,2) == (-a*diff(y,t) - k*y)/m;
Dy = diff(y,t);
cond = [y(0)==1, Dy(0)==0];
ySol(t) = dsolve(eqn, cond);

fplot(ySol, [0, 250]);
hold on

epsilon = a/(2*sqrt(m*k))

v(t) = cos(t/sqrt(m/k))+epsilon*(sin(t/sqrt(m/k))-t*cos(t/sqrt(m/k)))...
    +epsilon^2*((t/sqrt(m/k))^2/2*cos(t/sqrt(m/k))-(t/sqrt(m/k))/2*sin(t/sqrt(m/k)))

fplot(v, [0, 250]);