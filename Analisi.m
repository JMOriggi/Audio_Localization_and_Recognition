% SCOPO FUNZIONE:   Richiama l'acquisizione da periferica o l'upload da
% cartella, per ottenere i file necessari all'esecuzione dell'applicazione. 
% Attiva poi un ciclo di analisi del file audio, all'interno del quale
% verranno richiamate tutte le funzioni necessarie allo scopo. In oltre è
% il legame tra interfaccia grafica e algoritmi programmati in matlab.
%
% PARAMETRI INPUT:
%                   - handles: tutte le componenti dell'interfaccia
%                   grafica.
%                
% PARAMETRI OUTPUT:
%
function Analisi(handles)

delete('result.txt');
delete('Rec.wav');

%Execution or test
if handles.dati.EDIT_1 == 1 %Simulazione
   
    
   %Mando in esecuzione il device
   FigHandle = figure;
   set(FigHandle,'Position',[100, 400, 250, 50]);
   axis off
   text(0.1,0.1,'Recording in progress','fontsize',12,'color','r');
   CurrDir = cd; 
   cd C:\ST-Unimi\HmiAVGrabber1.4
   !_run
   cd(CurrDir);
   close(FigHandle);
   
   set(handles.BUTTON_RUN,'Enable','off');
   
   File_name = 'test[00000]'; %nome file rec
   path = 'e:'; %path di dove si trova la cartella con tutto
   File_name = strcat(path, '\', File_name);
   
   %per l'immagine
   File_index_image = 'test.log'; %NON CAMBIA MAI o se cambia cambia con un numero
   PathName_image = path; %il path della cartella che contiene tutto quelo che serve riguardo alla rec
   set(handles.EDIT_path,'string',path);
   
   %per il pattern matching
   path_folder_pattern = 'C:\Origgi\Sound_library'; %NON CAMBIA MAI
   
   eventindex=1;
   index_noisered=0;
   noise_red = 'Off';
end
if handles.dati.EDIT_1 == 0 %test
   
   %start_path = 'C:\Origgi\Salvataggi';
   start_path = 'D:\DATA\UNIMI\TESI\Forma_lavoro\Salvataggi';
   folder_name = uigetdir(start_path);
   path =  folder_name;
   File_name = 'test[00000]';
   File_name = strcat(path, '\', File_name);
   
   
   %per l'immagine
   File_index_image = 'test.log';
   PathName_image = path;
   set(handles.EDIT_path,'string',path);
   
   %per il pattern matching
   path_folder_pattern = 'D:\DATA\UNIMI\TESI\Forma_lavoro\Sound_library'; %NON CAMBIA MAI
   %path_folder_pattern = 'C:\Origgi\Sound_library'; %NON CAMBIA MAI
   
   eventindex=1;
   index_noisered=0;
   noise_red = 'Off';
end


%%%LEGGO SEGNALE che utilizzero in tutto il programma
[signal,Fs1,Nb1]=wavread(File_name);

%STAMPO STREAM AUDIO COMPLETO CON LABEL
axes(handles.axes3);
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





index = 1;
i=1;
while index~=0 %se l'index è 0 vuol dire che sono arrivato alla fine della rec.
    
%%%%%stato e bottoni
    set(handles.BUTTON_P_P,'String','Running');
    set(handles.EDIT_3,'String',handles.dati.EDIT_3);
    
    
%%%%%NOISE REDUCTION    
    a = get(handles.CB_1,'Value');
    if a == 1 && index_noisered == 0
        signal_nonoise = Noise_reduction(signal, Fs1);
        signal(:,1)=signal_nonoise(:,1);
        signal(:,2)=signal_nonoise(:,2);
        noise_red = 'On';
        index_noisered=1;
    end
    
    
%%%%%ENDPOINTS
    [file_ep, index, time, camp_start, camp_end] = Endpoint_start(signal, Fs1, index);
    if index==0
        %esco perché non ho trovato eventi
        break
    end

    
%%%%%POSIZIONAMENTO
    %prende file gestito dai microfoni orizontali
    level = 1;
    b = get(handles.CB_2,'Value');
    c = get(handles.CB_3,'Value');
    if b == 1
        level = 2;
    end
    if c == 1
        level = 3;
    end
    direction_deg1 = Direction_algoritm(file_ep, Fs1, level);
    %prende file gestito dai microfoni verticali
    [z,height_deg] = Height_algoritm(file_ep, Fs1, level);
    
    
%%%%%RICONOSCIMENTO
    soglia = get(handles.EDIT_soglia,'string');
    [res_mm, res_m, res_p, indexsv] = Pattern_matching(path_folder_pattern, File_name, file_ep, soglia);
        
%%%%%STAMPO AXES1 POSIZIONAMENTO GRAFICO
    axes(handles.axes1); 
    z = z; 
    y = direction_deg1;
    %x = randi(3)+1;
    x = 3;
    grid;
    if indexsv == 'V'
        stem3(x,y,z,'b*','MarkerFaceColor','b');
    end
    if indexsv == 'S'
        stem3(x,y,z,'g*','MarkerFaceColor','g');
    end
    axis([0 5 -50 50 0 300]);
    ylabel('Direction (degree)', 'Color','blue', 'FontSize',9,'FontAngle','italic');
    zlabel('Height (cm)', 'Color','blue', 'FontSize',9,'FontAngle','italic');
    xlabel('Depth (m) [not running]', 'Color','blue', 'FontSize',9,'FontAngle','italic');
    text(x+0.05,y-0.05,z+0.05,['\color{blue}',num2str(eventindex)],'FontSize',14);
    
    hold on;
    grid;
    
%%%%%STAMPO NELLA RESULT SUMMARY  
    start = camp_start/Fs1;
    dur = camp_end/Fs1 - start;
    set(handles.EDIT_R_start,'String',start);
    set(handles.EDIT_R_dur,'String',dur);
    set(handles.EDIT_R_match,'String',res_mm);
    set(handles.EDIT_R_diff,'String',res_p);
    set(handles.EDIT_R_numev,'String',eventindex);
    set(handles.EDIT_R_pos,'String',direction_deg1);
    set(handles.EDIT_R_height,'String',height_deg);
    set(handles.EDIT_R_tresh,'String',soglia);
    set(handles.EDIT_R_noise,'String',noise_red);
    set(handles.EDIT_R_loclevel,'String',level);
    
    
%%%%%CREO FILE .txt DOVE SALVO RISULTATI
    fid = fopen('result.txt','at');
    fprintf(fid, strcat('EventID=',num2str(eventindex),'; Start=',num2str(start),'; Length=',num2str(dur),'; Direction=',num2str(direction_deg1),'; Height=',num2str(z),'; Recognized_event=',res_m,'; Matching_degree=',num2str(res_p),';\n','Matching_treshold=',num2str(soglia),'; Fusion=',num2str(level),'; Noise_reduction=',noise_red,';\n'));
    fclose(fid);
    
%%%%%STAMPO EP AXES3
    axes(handles.axes3)
    if findobj(handles.axes3,'Color','g')
        delete(findobj(handles.axes3,'Color','g'));
    end;
    a=camp_start/Fs1;
    b=camp_end/Fs1;
    x = a;
    y = -1:0.001:1;
    plot(x,y, 'b-', 'LineWidth' , 1 );
    hold on;
    x = b;
    y = -1:0.001:1;
    plot(x,y, 'b-', 'LineWidth' , 1 );
    hold on;
    num = num2str(eventindex);
    tx = strcat('Ev',num,':', res_m);
    text (a+0.01,1.2,tx, 'BackgroundColor',[.7 .9 .7])
    
    
%%%%%STAMPO FOTO EVENTO
    axes(handles.axes2);
    dex = extract_index_image(PathName_image, File_index_image, time); 
    set(handles.EDIT_frame,'String',dex);    
    

%%%%%CREO FILE REC
    %[signal,Fs,nbits]=wavread(File_name);
    fl = 'Rec.wav'; 
    wavwrite(file_ep,Fs1,fl);
    
    
%%%%%STATO
    set(handles.EDIT_Numev,'String', eventindex); %stato2
    
%%%%%Bottoni
    set(handles.BUTTON_P_P,'Enable','on');
    set(handles.BUTTON_P_P,'String','Continue');
    set(handles.BUTTON_SAVE,'Enable','on');
    set(handles.BUTTON_LISTEN,'Enable','on');
    
%%%%%PAUSA
    uiwait;
    set(handles.BUTTON_P_P,'Enable','off');
    eventindex = eventindex+1;
    
    if index==-1
        %esco perché non ho raggiunto la fine
        break
    end
end
set(handles.BUTTON_C_D,'Enable','on');
set(handles.BUTTON_P_P,'String','End');
set(handles.BUTTON_RUN,'Enable','on');

end

