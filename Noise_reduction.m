% SCOPO FUNZIONE:   Riduce rumore di fondo e restituisce la matrice con il
% suono "pulito".
%
% PARAMETRI INPUT:
%                   - signal
%                   - Fs1
%                
% PARAMETRI OUTPUT:
%                   - signal
%

%Riduce rumore di fondo e restituisce il risultato
%distanza mic8 e mic7-->9.4cm
%distanza mic8 e mic6-->11.3
%distanza mic8 e mic5-->11.9
%distanza mic8 e mic4-->
%distanza mic8 e mic3-->
%distanza mic8 e mic2-->20.9
%distanza mic8 e mic1-->23

%path = 'C:\Users\Manuel\Desktop\TESI\Forma_lavoro\Salvataggi\noisered1';
%File_name = 'test[00000]';
%File_name = strcat(path, '\', File_name);
%[signal,Fs1,Nb1]=wavread(File_name);

function signal = Noise_reduction(signal, Fs1)

clear noise_signal;
durata_signal = length(signal);

%filtro il segnale per ottenere il segnale rumoroso
Fstop1=1;
Fpass1=10;
Fpass2=90;
Fstop2=100;
Astop1=60;
Apass=1;
Astop2=80;
match='stopband';
d = fdesign.bandpass(Fstop1,Fpass1,Fpass2,Fstop2,Astop1,Apass,Astop2,Fs1);
Hd = design(d,'butter','MatchExactly',match);
noise_signal(:,1) = filter(Hd, signal(:,8));
%noise_signal(:,1) = signal(:,8);

%%%%%%MIC1
c = 343.2; %velocità suono
d = 0.209; %distanza tra mic 8 e 1
tau = d/c;%ritardo tra 2 mic
camp_start = tau*Fs1;%numero campione da cui partire
T = num2str(camp_start,'%.0f');%troncatura risultato
camp_start = str2num(T);
%sottrae il rumore su tutto il segnale
k=camp_start;
for i=1:durata_signal-camp_start 
   signal(i,1)= signal(i,1) - noise_signal(k,1);
   k=k+1;
end
for i=durata_signal-camp_start:durata_signal 
   signal(i,1)= 0;
   i=i+1;
end
%%%%%%MIC1
c = 343.2; %velocità suono
d = 0.23; %distanza tra mic 8 e 1
tau = d/c;%ritardo tra 2 mic
camp_start = tau*Fs1;%numero campione da cui partire
T = num2str(camp_start,'%.0f');%troncatura risultato
camp_start = str2num(T);
%sottrae il rumore su tutto il segnale
k=camp_start;
for i=1:durata_signal-camp_start 
   signal(i,2)= signal(i,2) - noise_signal(k,1);
   k=k+1;
end
for i=durata_signal-camp_start:durata_signal 
   signal(i,2)= 0;
   i=i+1;
end


%Taglio frequenze sopra il 1600HZ cosi da pulire ulteriormente il segnale
Fstop1=1;
Fpass1=10;
Fpass2=1500;
Fstop2=1600;
Astop1=60;
Apass=1;
Astop2=80;
match='stopband';
d = fdesign.bandpass(Fstop1,Fpass1,Fpass2,Fstop2,Astop1,Apass,Astop2,Fs1);
Hd = design(d,'butter','MatchExactly',match);
signal(:,1) = filter(Hd, signal(:,1));
signal(:,2) = filter(Hd, signal(:,2));





%%SPETTRO SIGNAL nonoise
Nsamps = length(signal);
t = (1/Fs1)*(1:Nsamps);          %Prepare time data for plot
%Do Fourier Transform
y_fft = abs(fft(signal(:,1)));            %Retain Magnitude
y_fft = y_fft(1:Nsamps/2);      %Discard Half of Points
f = Fs1*(0:Nsamps/2-1)/Nsamps;   %Prepare freq data for plot
%%SPETTRO NOISE
Nsamps = length(noise_signal);
t = (1/Fs1)*(1:Nsamps);          %Prepare time data for plot
%Do Fourier Transform
y_fft2 = abs(fft(noise_signal(:,1)));            %Retain Magnitude
y_fft2 = y_fft2(1:Nsamps/2);      %Discard Half of Points
f = Fs1*(0:Nsamps/2-1)/Nsamps;   %Prepare freq data for plot
%%SPETTRO SIGNAL noise
Nsamps = length(signal(:,3));
t = (1/Fs1)*(1:Nsamps);          %Prepare time data for plot
%Do Fourier Transform
y_fft3 = abs(fft(signal(:,3)));            %Retain Magnitude
y_fft3 = y_fft3(1:Nsamps/2);      %Discard Half of Points
f = Fs1*(0:Nsamps/2-1)/Nsamps;   %Prepare freq data for plot


%Plot Sound File in Time Domain
%figure
%subplot(3,1,1)
%plot(t, signal(:,3))
%xlabel('Time (s)')
%ylabel('Amplitude')
%title('Signal');

%subplot(3,1,2);
%plot(t, noise_signal(:,1));
%xlabel('Time (s)')
%ylabel('Amplitude')
%title('Noise signal');

%subplot(3,1,3);
%plot(t, signal(:,1));
%xlabel('Time (s)')
%ylabel('Amplitude')
%title('Signal without noise');


figure
subplot(3,1,1);
plot(f, y_fft3)
xlim([0 2000])
xlabel('Frequency (Hz)')
ylabel('Amplitude')
title('FFT signal before noise reduction')

subplot(3,1,2);
plot(f, y_fft2)
xlim([0 2000])
xlabel('Frequency (Hz)')
ylabel('Amplitude')
title('FFT noise signal filtered')

subplot(3,1,3);
plot(f, y_fft)
xlim([0 2000])
xlabel('Frequency (Hz)')
ylabel('Amplitude')
title('FFT signal after noise reduction')



%sound(signal(:,1), Fs1);
%sound(noise_signal(:,1), Fs1, Nb1);
%sound(signal(:,3), Fs1);

end

