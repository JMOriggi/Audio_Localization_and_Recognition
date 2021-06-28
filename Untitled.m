%%%LEGGO SEGNALE che utilizzero in tutto il programma
[signal,Fs1,Nb1]=wavread('ciao.wav');
%STAMPO STREAM AUDIO COMPLETO
%calcolo variabili necessarie
AudioRecordLenght=length(signal);
timescale=zeros((AudioRecordLenght*2-1),1);
for n=1:(AudioRecordLenght*2-1);
    lag(n)=AudioRecordLenght-n;
end
timescale=zeros((AudioRecordLenght),1);
for n=1:(AudioRecordLenght);
    timescale(n)=(n-1)/Fs1;
end
%stampo grafico
plot(timescale, signal(1:AudioRecordLenght), 'r');
axis([0 AudioRecordLenght*(1/Fs1) -inf inf]);
xlabel ('Time (sec)');
hold on;
x = 0;
y = -1:0.001:1;
plot(x,y, 'b-', 'LineWidth' , 1 );
hold on;
x = AudioRecordLenght*(1/Fs1);
y = -1:0.001:1;
plot(x,y, 'b-', 'LineWidth' , 1 );
hold on;