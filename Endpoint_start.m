% SCOPO FUNZIONE:   Prepara il file audio per l'individuazione degli endpoints
% e crea una matrice con solo l'evento sonoro corrente  ritagliato grazie ai
% risultati forniti dalla funzione di individuazione degli endpoints.
%
% PARAMETRI INPUT:
%                   - signal: segnale originale acquisito. 
%                   - fs1: frequenza campionamento.
%                   - index: frame del file audio in cui la ricerca si è fermata.
%                
% PARAMETRI OUTPUT:
%                   - file_ep: matrice con solo l'evento sonoro individuato.
%                   - index
%                   - time: tempo di inizio evento in ms.
%                   - camp_start: campione di inizio evento.
%                   - camp_end: campione di fine evento.
%
function [file_ep, index, time, camp_start, camp_end] = Endpoint_start(signal, fs1, index)
    
    Fs=16000;
    NBITS=16;
    
    orig = signal;
        
    %trasforma in mono
    mono = orig(:,1);
    x=mono;
        
    %se la Fs è diversa da 16000 la trasforma in 16000
    if fs1~=Fs
       y=resample(x,Fs,fs1);
       x=y;
    end    
    
    [startp, endp, index] = Endpoint_research(x, index);
    
if index~=0 
    %end point in campioni adattato alla frequenza fs1
    camp_start = startp*(fs1*0.010);
    camp_end = endp*(fs1*0.010);
    
    %tempo in ms utile poi per stampare l'immagine
    time = ((camp_start/fs1)*1000);
    
    %Creo il vettore corrispondente solo all'intervallo trovato dagli
    %endpoints.
    k=1;
    for i=camp_start: camp_end
        file_ep(k,1) = orig(i,1);
        file_ep(k,2) = orig(i,2);
        file_ep(k,3) = orig(i,6);
        file_ep(k,4) = orig(i,5);
        file_ep(k,5) = orig(i,8);
        file_ep(k,6) = orig(i,7);
        
        k=k+1;
    end
end 

if index==0
    time=0;
    file_ep = 0;
    camp_start = 0;
    camp_end =0;
end    



end
  