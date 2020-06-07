A=172.5;
B=2.4;
C=0.26;
ng=9.73;
nng=0.90;
m=2254;
r=0.33;
Jnap=0.02;

E = 59904

v = [40 50 60 70 80 90 100 110 120 130 140 150]

Pt = (A*(v/3.6)+ B*((v/3.6).^2) + C*((v/3.6).^3))/nng

t = E./Pt

s = (E./Pt).*v

plot(v, s)
title('Závislosť dojazdu od ustálenej rýchlosti');
xlabel('Rýchlost [km/h]');
ylabel('Dojazd [km]');
