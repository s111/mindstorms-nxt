% eksempel p� effekt av filtrering (enkelt f�rste ordens filter)

clear all;close all  % Kommenter bort denne linjen etter f�rste kj�ring
                     % Forandre deretter p� konstanten alfa, og kj�r p� ny.

                     
if ~exist('RealData')       % Dersom ikke dataene eksisterer allerde
    RealData = rand(1,30);  % 30 tilfeldige tall
end
FiltData = [];              % definere FiltData som en tom vektor
FiltData(1) = RealData(1);  % setter f�rste filtrerte verdi lik r�data 

alfa = 0.4;       % JUSTER DENNE MELLOM 0 OG 1 (sjekk effekten)
                  % - dersom alfa=1 -> ingen filtrering
                  % - dersom alfa=0 -> FiltData blir en konstant verdi
                  
for i=2:30                     % kj�rer en for-l�kke for � filtrere
    FiltData(i) = alfa*RealData(i) + (1-alfa)*FiltData(i-1);
end

figure(1)
set(gcf,'Position',[150 700 1600 400])
plot(RealData,'k')
hold on
plot(FiltData,'r')
text(15,FiltData(15),['alfa=',num2str(alfa)])
legend('Virkelig data','Filtrert data')

