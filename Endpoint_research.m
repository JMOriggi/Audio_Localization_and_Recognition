% SCOPO FUNZIONE:   Inizializzazione delle variabili e soglie necessarie al
% calcolo degli endpoints. Richiama poi la funzione principale di ricerca
% degli endpoints.
%
% PARAMETRI INPUT:
%                   - nome: nome file audio da analizzare.
%                   - index: frame del file audio in cui la ricerca si è fermata.
%                
% PARAMETRI OUTPUT:
%                   - stardp: frame di inizio dell'evento.
%                   - endp: frame di fine dell'evento.
%                   - index
%
function [startp,endp,index] = Endpoint_research(nome, index)

%%%%%%%%%%%%%%%%%%%%%%%% INIZIO VARIABILI GLOBALI %%%%%%%%%%%%%%%%%%%%%%%%%
global ENERGIA          % vettore energie dei frame
global ZCR              % vettore zero crossing rate dei frame

global Fs               % frequenza di campionamento
%global SOGLIA_RUM_ZCR   % soglia per il rumore nel calcolo della zcr
global PUNTI_CZT        % punti per il calcolo della CZT
%%%%%%%%%%%%%%%%%%%%%%%%%% FINE VARIABILI GLOBALI %%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% INIZIO CODICE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%% INIZIALIZZAZIONE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
format long e;
Fs=16000;
PUNTI_CZT=32;
nro_zcr=0;

%SUPPONIAMO FRAME DI DURATA 40 ms -> 16000*40*10^-3 = 640 campioni/frame
%Quando il numero totale di campioni non è un multiplo esatto di 640,
%si otterrà un frame sottodimensionato: per ovviare a ciò, facciamo lo zero
%padding.
durata_frame=40e-3;
nro_camp_frame=Fs*durata_frame;
                    
%Lettura file sonoro
y_orig=(nome).';

%%%%%%%%%%%%%%%%%%%%%%%% PADDING PER L'ENDPOINT %%%%%%%%%%%%%%%%%%%%%%%%%%%
%calcolo della deviazione standard del segnale originale: serve per
%determinare approssimativamente il punto di inizio della parola.
%Il valore 15 trovato sperimentalmente: l'ideale sarebbe trovare un valore
%che dipende dal singolo file sonoro.
dev=std(y_orig)/15;
for i=1:length(y_orig)
    if y_orig(i)>dev 
        break; %mi fermo quando trovo il primo valore che supera dev std/15
    end
end
%se il primo punto maggiore della deviazione standard si trova entro i 100
%ms, vuol dire che il segnale non ha 100 ms iniziali di silenzio e quindi
%vengono aggiunti tramite padding.
if i<=Fs*100e-3
    
    flag_pad = 1;
    %fprintf('Flag_pad: %d\n', flag_pad);
    
    y=zeros(1,length(y_orig)+Fs*100e-3);
    y((Fs*100e-3)+1:length(y))=y_orig;
    fid=fopen('silenzio.raw');
    if  fid == -1
        sprintf('Errore apertura file silenzio.raw')
        return;
    end
    y_sil=(fread(fid,inf,'int16')).'; 
    y_sil=y_sil/32768; %normalizzazione delle ampiezze del segnale
    fclose(fid);
    y(1:Fs*100e-3)=y_sil;
else
    flag_pad = 0;
    y=y_orig;
end
%%%%%%%%%%%%%%%%%%%%%%%% FINE PADDING PER L'ENDPOINT %%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%% CALCOLO NUM INTERO FRAME %%%%%%%%%%%%%%%%%%%%%%%%%
nro_intero_frame=ceil(length(y)/nro_camp_frame); 
campioni_extra=nro_camp_frame*nro_intero_frame;     %nro totale di campioni

%allocazione memoria per gli array contenenti rispettivamente:
%i campioni del segnale - i coefficienti di autocorrelazione
%energia di ogni frame (ordinate in modo crescente e non)
%zero crossing rate di ogni frame - guadagno di ogni frame
V=zeros(1,campioni_extra); 
COEFF_AUTOCORR=zeros(1,campioni_extra); 
ENERGIA=zeros(1,nro_intero_frame); %vettore delle energie dei frame
ZCR=zeros(1,nro_intero_frame); 
frame_gain=zeros(1,nro_intero_frame);
GAIN_COSTANT=zeros(1,nro_intero_frame);
%copio i valori originali delle ampiezze del file sonoro in V
for i=1:length(y)
    V(i)=y(i);
end
%%%%%%%%%%%%%%%%%%%%%%%% FINE CALCOLO NUM INTERO FRAME %%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%% CALCOLO ENERGIA E ZCR PER OGNI FRAME%%%%%%%%%%%%%%%%%%%%
d=1;    %variabile per scorrere il segnale
k=1;    %indice per allocare l'energia e lo zcr di un singolo frame
delta_en_zcr=nro_camp_frame-1; %spiazzamento per suddivisione in frame
for i=1:delta_en_zcr+1:length(V)-delta_en_zcr
    %Calcola energia del singolo frame
    ENERGIA(k)=calcolo_en(V(d:d+delta_en_zcr));
    %Calcola zero crossing rate del singolo frame
    %ZCR(k)=calcolo_zcr(d,d+delta_en_zcr);
    ZCR(k)=calcolo_zcr(V(d:d+delta_en_zcr));
    k=k+1;
    d=d+delta_en_zcr+1; %aggiorno d al 1o elemento del frame successivo
end
%%%%%%%%%%%%%%%%% FINE CALCOLO ENERGIA E ZCR PER OGNI%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%% ENDPOINT DETECTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%NOTA BENE: frame di 10 ms!!!
durata_sil=100e-3;             % durata del silenzio iniziale in ms 
dim_fin_virt=10e-3;            % durata frame in ms
camp_fin_virt=dim_fin_virt*Fs; % numero campioni in un frame di 10 ms
% vettore energia di ogni frame
energy=zeros(1,ceil(length(y)/camp_fin_virt));
% vettore zero crossing rate di ogni frame
zcr=zeros(1,ceil(length(y)/camp_fin_virt));
k=1;
%calcolo energia e zcr per ogni frame di 10 ms
for i=1:camp_fin_virt:length(y)-camp_fin_virt
    energy(k)=sum(abs(y(i:i+camp_fin_virt-1)));
    zcr(k)=calcolo_zcr(y(i:i+camp_fin_virt-1));
    k=k+1;
end
%calcolo energia media in dB dei primi 100 ms di segnale: è una soglia usata
%per il calcolo delle soglie di energie effettive. Tale soglia la chiamo
%IMN (vedi Rabiner "An algorithm for determing the endpoints....")
somma=0;
for i=1:durata_sil/dim_fin_virt
    somma=somma+energy(i);
end
imn=somma/i;
%calcolo zcr medio dei primi 100 ms di segnale: è una soglia usata per il
%calcolo della soglia effettiva dello zcr. La chiamo IZC
%(vedi Rabiner "An algorithm for determing the endpoints....")
somma=0;
for i=1:durata_sil/dim_fin_virt
    somma=somma+zcr(i);
end
izc=somma/i;
%calcolo della deviazione standard dello zcr dei primi 100 ms di segnale.
%(vedi Rabiner "An algorithm for determing the endpoints....")
somma=0;
for i=1:durata_sil/dim_fin_virt
    somma=somma+((zcr(i)-izc)*(zcr(i)-izc));
end
somma=somma/i;
std_zcr_sil=sqrt(somma);
    
%calcolo IZCT (vedi Rabiner "An algorithm for determing the endpoints....")
%Per Rabiner la soglia IF vale 25 crossing per 10 ms di segnale se la Fs è
%pari a 10 kHz. Avendo noi una Fs pari a 16 kHz, la soglia è ricalcolata in
%base a questa nuova Fs.
IF=(((25*dim_fin_virt*10e3)/10)/10000)*Fs;
izct=min(IF,izc+2*std_zcr_sil);

%calcolo IMX: energia massima del segnale.
imx=energy(1);
for i=2:length(energy)
    if energy(i)>imx
        imx=energy(i);
    end
end
%calcolo ITL e ITU
itl=min(0.03*(imx-imn)+imn,4*imn);
itu=5*itl;

[startp,endp,index]=Endpoint(itl,itu,izct,energy,zcr,index);
if endp*camp_fin_virt > length(y) 
    endp=length(y)/camp_fin_virt;
end

end


% SCOPO FUNZIONE:   Calcolo dello zero crossing rate in un frame.
%
% PARAMETRI INPUT:
%                   - xin: campioni del frame.
%                
% PARAMETRI OUTPUT:
%                  - zcr: valore dello zero crossing rate nel frame.
%
function zcr = calcolo_zcr(xin)

%global SOGLIA_RUM_ZCR; 

tot_zcr=0;
for i=length(xin):-1:2
    if xin(i)< 0 %-SOGLIA_RUM_ZCR)
        if xin(i-1)>=0
            tot_zcr=tot_zcr+1;
        end
    elseif xin(i-1)<0
        tot_zcr=tot_zcr+1;
    end
end
zcr=tot_zcr;
return;
end





% SCOPO FUNZIONE:    Calcolo energia di un frame.
%
% PARAMETRI INPUT:
%                   - xin: campioni del frame.
%                
% PARAMETRI OUTPUT:
%                  - en: valore dell'energia nel frame.
%
function en = calcolo_en(xin)

en=0;
for i=1:length(xin)
    en=en+xin(i)*xin(i);   %Fare l'offset???
end
if en == 0                 %se en è 0, il log di zero non esiste. Quindi uso 
    en=10*log10(eps);      %eps.
else
    en=10*log10(en);    %Calcolo energia in decibel.
                        %Aggiungere fattore di correzione ???
end
return;
end


