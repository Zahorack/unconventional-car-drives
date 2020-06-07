close all
syms v(t);

A=172.5;
B=2.4;
C=0.26;
E=59.9*60*60*1000;
Tt=450;
ng=9.73;
nng=0.90;
m=2254;
r=0.33;
Jnap=0.02;

% ode = diff(v(t),t)== ((Tt*ng*nng)/(m*r))
ode = diff(v(t),t)== ((Tt*ng*nng-r*(A+B*v(t)+C*v(t)^2))/(m*r+Jnap/r))
cond = v(0) == 0;

Solve(t)=dsolve(ode,cond);

ezplot(Solve,[0,6])
xlabel('Čas[s]');
ylabel('Rýchlost [m/s]');
grid on
title('Zrýchlenie z 0 na 100 km/h');
