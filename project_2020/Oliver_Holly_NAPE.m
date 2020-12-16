clear all
close all
% Vyber automobilu, baterii a navrh trakcie
% Hmotnost automobilu, bez spalovacieho motora s elektromotorm a batteriou
m = 1800;

%Celna plocha
% vypocet = sirka auta sirka strechy - priemer * vyska karoserie
% Popisat ako sme k tomu prisli
Sx = 2.3;

% Koeficient odporu vzduchu % Coast down test ?
Cx = 0.26;
g = 9.81;

%Simulacia
sim('jazdny_cyklus.slx')

% Grafy simulacie
figure(1)
tiledlayout(3,1)
nexttile
plot(ans.time, ans.draha)
xlabel('cas [s]')
ylabel('draha [m]')
title('Draha')
nexttile
plot(ans.time, ans.rychlost)
xlabel('cas [s]')
ylabel('rychlost [m*s^-1]')
title('Rychlost')
nexttile
plot(ans.time, ans.zrychlenie)
xlabel('cas [s]')
ylabel('zrychlenie [m*s^-2]')
title('Zrychlenie')



% Vypocet odporov proti pohybu vozidla
% Odpor valenia
Fn = m*g;
dr = 16;                     % 16 palcove koleso
ep = 0.0045;                 % rameno valiveho odporu
r = (dr*0.0254)/2 + 0.205*0.55;   %dynamicky polomer kolesa
Cr = ep/r                 % Koeficien valiveho odporu teoreticky
fvo = 0.025;                 % Koeficien valiveho odporu podla praxe
Of = Fn*fvo;


fvo = 0.025; % Koeficien valiveho odporu 
pm = 1.25;   % Merna hnotnost vzduchu
delta =1.05; %Sucinitel vplyvu rotujucich hmot

Ovzd = 0.5*pm*Sx*Cx*ans.rychlost.^2;  % Odpor vzduchu
Of = m*g*fvo;  % Odpor valenia pneumatiky
Fa=m*ans.zrychlenie*delta;  % Zotravacný odpor
F=[]; % Vysledna sila posobiaca na pneumatiku

for i=1:1:length(ans.zrychlenie)
    if ans.rychlost(i) > 0
        F(i)=Of+Ovzd(i)+Fa(i);
    else
        F(i)=0;
    end
end

figure(2)
plot(ans.time, F);
title('Sila potrebna na kolesach pocas cyklu WLPT')
xlabel('Time [s]');
ylabel('Sila [N]');


draha = ans.draha;
rychlost = ans.rychlost;
zrychlenie = ans.zrychlenie;
time = ans.time;

% Vypocet spotrebovaneho vykonu pocas cyklu
% Vykon pocitame len v kladnom smere, pri zrychlovanie, v pripade brzdenia,
% pocitame s rekuperaciou
EF_MOTORA = 0.9
EF_REKUPERACIE = 0.3
P_SUM_30=0;
for i=1:1:length(zrychlenie)
    if F(i) < 0
        P_IN(i) = 0;
        P_OUT(i) = F(i) * rychlost(i) * EF_REKUPERACIE;
        P_FINAL(i) = P_OUT(i);
    else
        P_IN(i) = F(i) * rychlost(i) / EF_MOTORA;
        P_OUT(i) = 0;
        P_FINAL(i) = P_IN(i);
    end
    P_SUM_30 = P_SUM_30 + P_FINAL(i);
end


figure(3)
plot(ans.time, P_IN, 'r')
hold on;
plot(ans.time, P_OUT, 'g')
title('Vykon spotrebovany/rekuperovany motorom pocas cyklu')
legend('Spotrebovany vykon', 'Rekupreovany vykon')
xlabel('Time [s]')
ylabel('Vykon [W]')


% Uloha 3.d energia ziskana rekuperaciou pri ucinosti 0,10,20,30 %
EF_MOTORA = 0.9
EF_REKUPERACIE_LIST = [0.3 0.2 0.1 0.0]
P_SUM_LIST=[0 0 0 0];
P_IN_SUM_LIST = [0 0 0 0]
P_OUT_SUM_LIST = [0 0 0 0]

for x=1:1:length(EF_REKUPERACIE_LIST)
    for i=1:1:length(zrychlenie)
        if F(i) < 0
            P_IN(i) = 0;
            P_OUT(i) = F(i) * rychlost(i) * EF_REKUPERACIE_LIST(x);
            P_SUM_LIST(x) = P_SUM_LIST(x) + P_OUT(i);
        else
            P_IN(i) = F(i) * rychlost(i) / EF_MOTORA;
            P_OUT(i) = 0;
            P_SUM_LIST(x) = P_SUM_LIST(x) + P_IN(i);
        end
    end
    P_IN_SUM_LIST(x) = sum(P_IN)
    P_OUT_SUM_LIST(x) = sum(P_OUT)
end

d=draha(length(draha))/1000;
draha_celk=100/d;

E_KWH_CYKLUS_LIST = P_SUM_LIST./3600000;
E_KWH_OUT_CYKLUS = P_OUT_SUM_LIST./3600000;
E_KWH_100_LIST = E_KWH_CYKLUS_LIST.*draha_celk;

% Tabulka
SPOTREBA_KWH_CYKLUS = E_KWH_CYKLUS_LIST';
SPOTREBA_KWH_NA_100KM = E_KWH_100_LIST';
REKUPERACIA_KWH_CYKLUS = abs(E_KWH_OUT_CYKLUS');

ROW_NAMES = {'Rekuperacia 30%';'Rekuperacia 20%';'Rekuperacia 10%';'Rekuperacia 0%'}
T = table(ROW_NAMES, SPOTREBA_KWH_CYKLUS, REKUPERACIA_KWH_CYKLUS, SPOTREBA_KWH_NA_100KM)



% Uloha 6 - sklon vozovky
for i=1:1:length(zrychlenie)
    if i<200
        SKLON(1, i)=5;
    elseif i<500
        SKLON(1, i)=0;
    elseif i<650
        SKLON(1, i)=-9;
    elseif i<1200
        SKLON(1, i)=0;
    elseif i<1400
        SKLON(1, i)=6;
    elseif i<2200
        SKLON(1, i)=-4;
    elseif i<2500
        SKLON(1, i)=3;
    elseif i<2750
        SKLON(1, i)=0;
    elseif i<3050
        SKLON(1, i)=-9;
    elseif i<3300
        SKLON(1, i)=4;
    else 
        SKLON(1, i)=-1;
    end
end

for i=1:1:length(zrychlenie)
    if i<250
        SKLON(2, i)=-8;
    elseif i<750
        SKLON(2, i)=0;
    elseif i<1500
        SKLON(2, i)=4;
    elseif i<1650
        SKLON(2, i)=0;
    elseif i<1850
        SKLON(2, i)=-6;
    elseif i<2250
        SKLON(2, i)=0;
    elseif i<3300
        SKLON(2, i)=2;
    else 
        SKLON(2, i)=0;
    end
end

for i=1:1:length(zrychlenie)
    if i<450
        SKLON(3, i)=0;
    elseif i<650
        SKLON(3, i)=8;
    elseif i<1100
        SKLON(3, i)=-4;
    elseif i<1700
        SKLON(3, i)=3;
    elseif i<2000
        SKLON(3, i)=-9;
    elseif i<2500
        SKLON(3, i)=0;
    elseif i<2700
        SKLON(3, i)=7;
    elseif i<2950
        SKLON(3, i)=0;
    elseif i<3150
        SKLON(3, i)=-3;
    elseif i<3250
        SKLON(3, i)=-4;
    elseif i<3350
        SKLON(3, i)=-6;
    else 
        SKLON(3, i)=2;
    end
end


Os(:,:)=m*g*sin(atan(SKLON(:,:)./100));
Off(:,:) = m*g*fvo*cos(atan(SKLON(:,:)./100)); % Valivy odpor
Ovzd = 0.5*pm*Sx*Cx*rychlost.^2;  % Odpor vzduchu
Fa=m*zrychlenie.*delta;  % Zotravacný odpor

EF_MOTORA = 0.9
EF_REKUPERACIE = 0.3;
P_SUM_LIST=[0 0 0];
P_IN_SUM_LIST = [0 0 0];
P_OUT_SUM_LIST = [0 0 0];
P_IN_LIST = [0 0 0];
P_OUT_LIST = [0 0 0];

for x=1:1:3
    for i=1:1:length(zrychlenie)
        if rychlost(i) > 0
            F(x, i) = Off(x,i) + Ovzd(i) + Fa(i) + Os(x, i);
        else
            F(x, i)=0;
        end
    end
    
    for i=1:1:length(zrychlenie)
        if F(x, i) < 0
            P_IN_LIST(x, i) = 0;
            P_OUT_LIST(x, i) = F(x, i) * rychlost(i) * EF_REKUPERACIE;
            P_SUM_LIST(x) = P_SUM_LIST(x) + P_OUT_LIST(x, i);
        else
            P_IN_LIST(x, i) = F(x, i) * rychlost(i) / EF_MOTORA;
            P_OUT_LIST(x, i) = 0;
            P_SUM_LIST(x) = P_SUM_LIST(x) + P_IN_LIST(x, i);
        end
    end
    P_IN_SUM_LIST(x) = sum(P_IN_LIST(x, :))
    P_OUT_SUM_LIST(x) = sum(P_OUT_LIST(x,:))
end




for x=1:1:3
    figure(4 + x)
    plot(time,P_OUT_LIST(x, :)./1000,'g')
    hold on
    plot(time,P_IN_LIST(x, :)./1000,'r')
    xlabel('Time [s]')
    ylabel('Vykon [kW]')
    ylim([-80 80])
    yyaxis right
    plot(time, SKLON(x,:), 'color', 'blue');
    ylabel('Sklon vozovky [%]')
    ylim([-20 20])
    legend('Rekuperovany vykon','Spotrebovany vykon','Sklon vozovky');
    title(sprintf('Vykon vozidla pocas jazdneho cyklu. Sklon vozovky %d', x))
end


d=draha(length(draha))/1000;
draha_celk=100/d;

E_KWH_CYKLUS_LIST = P_SUM_LIST./3600000;
E_KWH_OUT_CYKLUS = P_OUT_SUM_LIST./3600000;
E_KWH_100_LIST = E_KWH_CYKLUS_LIST.*draha_celk;

% Tabulka
SPOTREBA_KWH_CYKLUS = E_KWH_CYKLUS_LIST';
SPOTREBA_KWH_NA_100KM = E_KWH_100_LIST';
REKUPERACIA_KWH_CYKLUS = abs(E_KWH_OUT_CYKLUS');

ROW_NAMES = {'Sklon vozovky 1';'Sklon vozovky 2';'Sklon vozovky 3';}
T = table(ROW_NAMES, SPOTREBA_KWH_CYKLUS, REKUPERACIA_KWH_CYKLUS, SPOTREBA_KWH_NA_100KM)

