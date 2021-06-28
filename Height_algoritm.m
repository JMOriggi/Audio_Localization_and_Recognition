% SCOPO FUNZIONE:   Funzione di calcolo dell'altezza della sorgente sonora
% rispetto all'evento.
%
% PARAMETRI INPUT:
%                   - file_ep: matrice con solo l'evento sonoro individuato.
%                   - Fs: frequenza campionamento segnale originale.
%                
% PARAMETRI OUTPUT:
%                   - height_deg: grado di incidenza del fronte d'onda sui 
%                    microfoni verticali.
%                   - z: grado di incidenza approssimato in cm.
%
function [z,height_deg] = Height_algoritm(file_ep, Fs, level)



d = 0.0475;                       % microphones distance (m)
c = 343.2;                     % sound speed in the air (20°C)
FrameIndex = 1;               % simulation only 
TauLogIndex = 1;
DirectionLogIndex = 1;

    
% start of the process 

    %[signal,Fs,Nbits]=wavread(file_name);
    signal = file_ep;
    signal1=signal(:,3);
    signal2=signal(:,4);
    AudioRecordLenght=length(signal);
    clear signal;




%%%%%%%%%%%%%Inizio calcoli posizionamento%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% calculate the crosscorrelation of two noisy signal;
    cccorrelation=xcorr(signal1,signal2);

% CC method:find the peak position of the crosscorrelation;
    [ccmaximum cctime]=max(cccorrelation);
    ccestimation=abs(AudioRecordLenght-cctime);

if level==2 || level==3    
% GCC method; using the PHAT filter;
    gcc=zeros((AudioRecordLenght*2-1),1);
    phatfilter=zeros((AudioRecordLenght*2-1),1);
    crossspectrum=fft(cccorrelation);
    for n=1:(AudioRecordLenght*2-1);
        phatfilter(n)=abs(crossspectrum(n));
        gcc(n)=crossspectrum(n)/phatfilter(n);
    end
    gcccorrelation=ifft(gcc);
% GCC method:find the peak postion of the filtered crosscorrelation;
    for n=1:(AudioRecordLenght*2-1);
        gcccorrelation(n)=abs(gcccorrelation(n));
    end
    [gccmaximum,gcctime]=max(gcccorrelation);
    gccestimation=abs(AudioRecordLenght-gcctime);

    
    if level==3
    
    % Maximum Likelihood method:using the ML filter;
    %coherence=cohere(signal1,signal2);
    coherence=mscohere(signal1,signal2);
    mlcoherence=zeros((AudioRecordLenght*2-1),1);
    coherencelength=length(coherence);
    coherencenumber=(AudioRecordLenght*2-1)/coherencelength;
    p=fix(coherencenumber);
    if p<coherencenumber;
        for n=1:coherencelength;
            for m=1:p;
                mlcoherence(m+(n-1)*p)=coherence(n);
            end
        end
    end
    for n=((coherencelength*p+1):(AudioRecordLenght*2-1));
        mlcoherence(n)=coherence(coherencelength);
    end
    if p==coherencenumber;
        for n=1:coherencelength;
            for m=1:coherencenumber;
                mlcoherence(m+(n-1)*coherencenumber)=coherence(n);
            end
        end
    end
    for n=1:(AudioRecordLenght*2-1);
        squaremlcoherence(n)=(abs(mlcoherence(n))).^2;
        ml(n)=squaremlcoherence(n)*crossspectrum(n)/(phatfilter(n)*(1-squaremlcoherence(n)));
    end
    mlcorrelation=ifft(ml);
    % ML method:find the peak postion of ML correlation;
    for n=1:(AudioRecordLenght*2-1);
        mlcorrelation(n)=abs(mlcorrelation(n));
    end
    [mlmaximum,mltime]=max(mlcorrelation);
    mlestimation=abs(AudioRecordLenght-mltime);
    end
end

% show the SNR, and the three estimated time delay value;
% snr,ccestimation,gccestimation,mlestimation
% plot the three crosscorrelation;
    lag=zeros((AudioRecordLenght*2-1),1);
    for n=1:(AudioRecordLenght*2-1);
        lag(n)=AudioRecordLenght-n;
    end
    timescale=zeros((AudioRecordLenght*2-1),1);
    for n=1:(AudioRecordLenght*2-1);
        lag(n)=AudioRecordLenght-n;
    end

    Ts=1/Fs;

    [a,b]=max(cccorrelation);
    tau1=AudioRecordLenght-b;
    IndexCcMax=b;
    if level==2 || level==3
    [a,b]=max(gcccorrelation(IndexCcMax-2:IndexCcMax+2));
    tau2=tau1+(3-b);
        if level==3
        [a,b]=max(mlcorrelation(IndexCcMax-2:IndexCcMax+2));
        tau3=tau1+(3-b);
        end
    end
    
    tau=tau1;                %(only CrossCorrelation information is used)
    if level==2 || level==3
        tau=(tau1+tau2)/2;       %(CrossCorrelation and GCC information is to be used)
    end
    if level==3
        tau=(tau1+tau2+tau3)/3;  %(CrossCorrelation, GCC and MLC information is to be used)
    end
    
    maximum=tau+50;
    minimum=tau-50;
    timescale=zeros((AudioRecordLenght*(FrameIndex)),1);
    for n=1:(AudioRecordLenght*FrameIndex);
        timescale(n)=(n-1)/Fs;
    end
    
  
    direction_rad=asin(tau*Ts*c/d);
    direction_deg=(360/(2*pi))*direction_rad;
    TauLog(TauLogIndex)=tau;
    TauLogIndex=TauLogIndex+1;
    DirectionLog(DirectionLogIndex)=direction_deg;
    DirectionLogIndex=DirectionLogIndex+1;
    
%%%%%%%%%%%%%Fine calcoli posizionamento%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    height_deg = direction_deg;

    if height_deg > 0
        z = 130;
        if height_deg > 10
            z = 175;
        end
        if height_deg > 30
            z = 200;
        end
    end    
    if height_deg == 0
       z = 80;
    end
    if height_deg < 0
        z = 60;
        if height_deg < -10
            z = 40;
        end 
        if height_deg < -30
            z = 5;
        end 
    end

end

