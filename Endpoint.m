%SCOPO FUNZIONE:    Ricerca l'inizio e fine di un evento sonoro in una
% registrazione complessa attraverso un sistema di soglie. Allo scopo usa
% altre due funzioni utili per la taratura delle soglie.
%
% PARAMETRI INPUT:
%               - ITL: soglia di energia minore.
%               - ITU: soglia di energia maggiore.
%               - IZCT: soglia degli zero crossing rate.
%               - energy: vettore energia di ogni frame.
%               - zcr: vettore zero crossing rate di ogni frame.
%
% PARAMETRI OUTPUT:
%               - N1: numero di frame corrispondente all'inizio della
%               parola.
%               - N2: numero di frame corrispondente alla fine della
%               parola.
%
function [N1,N2,index]=Endpoint(ITL,ITU,IZCT,energy,zcr,index)

global Fs;

durata=length(energy);
N1=0; 
N2=durata;
campioni_frame=10e-3*Fs;
%quanti frame da 10 ms sono contenuti in 250 ms di segnale. E'un valore che
%serve per raffinare la scelta degli endpoints basandosi sulla soglia IZCT
%160: numero campioni in un frame di 10 ms se la Fs è pari a 16 kHz.
%4000: numero campioni in 250 ms di segnale se la Fs è pari a 16 kHz.
backoffLength=length(1:campioni_frame:4000-campioni_frame);

flag = 0;
if index == 1
    m=1;
end
if index > 1
   m=index; 
end
% inizio stima endpoint. Cerca il 1o frame la cui energia supera la soglia
% ITL. Se lo trova, controlla che superi anche ITU.
for m=m:durata
   if and(energy(m)>=ITL,~flag)
      for i=m:durata
         if energy(i)<ITL
            break
         else   
            if energy(i)>=ITU
               if ~flag
                  N1=i-(i==m); %indice del frame che supera sia ITL che ITU
                  flag=1;      %se un frame supera entrambe le soglie(i==m)
                               %allora il possibile endpoint si trova nel
                               %frame precedente (scelta conservativa di
                               %Rabiner).
               end
               break
            end
         end
      end
   end   
end

%controllo che abbia trovato qualcosa altrimenti esco
if N1 == 0 
    index = 0;
    startp = 0;
    endp = 0;
    flag_pad = 0;
    return;
end

startID=max(N1-backoffLength,1); %sceglie il frame di inizio su cui valuto
                                 %la soglia dello zero crossing. Se
                                 %N1-backoffLength è < 0, parto dal 1o
                                 %frame.
endID=N1;
M1=sum(zcr(startID:endID)>IZCT); %calcola il numero di frame che superano
                                  %la soglia IZCT.  
if M1>=3                          %se ho trovato più di 3 frame
    %for i=endID:-1:startID
   for i=startID:endID            %allora il primo frame che supera IZCT  
      if zcr(i)>IZCT              %è il frame di inizio parola.  
         N1=i;
         break;
      end      
   end
end







flag=0;
% stima dell'endpoint di fine parola. Vedi sopra tranne che i test li
% faccio partendo dal frame d'inizio parola più 300 cioè 3 sec di suono se
% ci sono, altrimenti da fine suono.
if(durata < startID+150)
    m=durata;
    index=-1;
end
if(durata > startID+150)
    m=startID+150;
    index=m;%salvo il punto da cui incominciare al prossimo giro la lettura
end

for m=m:-1:1
   if and(energy(m)>=ITL,~flag)
      for i=m:-1:1
         if energy(i)<ITL
            break;
         else
            if energy(i)>=ITU
               if ~flag
                  N2=i+(i==m);
                  flag=1;
               end
               break
            end
         end
      end   
   end
end
startID=max(1,N2); 
endID=min(N2+backoffLength,length(zcr)); %scelta del frame finale sui cui
                                         %valuto la soglia dello zcr. Se
                                         %N2+backoffLength supera
                                         %length(zcr), prendo quest'ultimo
                                         %come frame finale.
M2=sum(zcr(startID:endID)>IZCT);
if M2>=3
   for i=startID:endID
   %for i=endID:-1:startID
      if zcr(i)>IZCT
         N2=i;
         break;
      end      
   end
end

%fprintf('OK3, N1=%d, N2=%d\n', N1,N2);

return
end







