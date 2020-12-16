Pnom = 335000;
Tnom = 450;
i = 9.73;
r = 0.33;

wnom = Pnom/Tnom
vnom = (1/i)*wnom*r

v1 = 0:0.5:vnom
v2 = vnom:0.5:50

Kp = Pnom/vnom;
P1 = v1.*Kp
P2 = Pnom.*v2.^0

T1 = (1/i)*r.*(P1./v1)
T2 = (1/i)*r.*(P2./v2)

v1=v1.*3.6;
v2=v2.*3.6;
vnom=vnom*3.6;

figure(1)
hold on
yyaxis left
P1=P1./1000;
P2=P2./1000;
plot(v1, P1,'linewidth',2)
plot(v2, P2,'linewidth',2)
title('Priebehy P a T pre EMG v zavislosti od rychlosti')
ylabel('Vykon P [kW]')
xlabel('Rychlost v [Km/h]')
xline(vnom, '--g')

hold on
yyaxis right
plot(v1, T1,'linewidth',2)
plot(v2, T2,'linewidth',2)
ylabel('Moment T [Nm]')
ylim([0 500])
legend('P(v < vnom)', 'P(v > vnom)', 'vnom','T(v < vnom)', 'T(v > vnom)', 'Location','southEast' )
