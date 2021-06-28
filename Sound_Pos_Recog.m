function varargout = Sound_Pos_Recog(varargin)
% SOUND_POS_RECOG MATLAB code for Sound_Pos_Recog.fig
%      SOUND_POS_RECOG, by itself, creates a new SOUND_POS_RECOG or raises the existing
%      singleton*.
%
%      H = SOUND_POS_RECOG returns the handle to a new SOUND_POS_RECOG or the handle to
%      the existing singleton*.
%
%      SOUND_POS_RECOG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SOUND_POS_RECOG.M with the given input arguments.
%
%      SOUND_POS_RECOG('Property','Value',...) creates a new SOUND_POS_RECOG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Sound_Pos_Recog_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Sound_Pos_Recog_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Sound_Pos_Recog

% Last Modified by GUIDE v2.5 09-Feb-2015 16:26:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Sound_Pos_Recog_OpeningFcn, ...
                   'gui_OutputFcn',  @Sound_Pos_Recog_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT
end




% --- Executes just before Sound_Pos_Recog is made visible.
function Sound_Pos_Recog_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Sound_Pos_Recog (see VARARGIN)

% Choose default command line output for Pos_sound_recog
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Pos_sound_recog wait for user response (see UIRESUME)
% uiwait(handles.figure1);

initialize_gui(handles);


end

% --- Outputs from this function are returned to the command line.
function varargout = Sound_Pos_Recog_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end

% --- Executes on button press in BUTTON_RUN.
function BUTTON_RUN_Callback(hObject, eventdata, handles)
% hObject    handle to BUTTON_RUN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

Run(hObject, handles)

end

% --- Executes on button press in BUTTON_CANCEL.
function BUTTON_CANCEL_Callback(hObject, eventdata, handles)
% hObject    handle to BUTTON_CANCEL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

initialize_gui(handles)

end

% --- Executes on button press in BUTTON_P_P.
function BUTTON_P_P_Callback(hObject, eventdata, handles)
% hObject    handle to BUTTON_P_P (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


handles.dati.EDIT_3='V or S + filename';
set(handles.EDIT_3,'String',handles.dati.EDIT_3);

uiresume;
 

end

% --- Executes on button press in BUTTON_SAVE.
function BUTTON_SAVE_Callback(hObject, eventdata, handles)
% hObject    handle to BUTTON_SAVE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%path = 'C:\Origgi'; %path di dove si trova il file rec
path ='D:\DATA\UNIMI\TESI\Forma_lavoro';

file_name = get(handles.EDIT_3,'String');
[y,Fs,Nbits]=wavread('Rec');
wavwrite(y,Fs,file_name);

source = strcat(path, '\', file_name, '.wav');
destination = strcat(path, '\Sound_library');

movefile(source, destination);

handles.dati.EDIT_3='saved';
set(handles.EDIT_3,'String',handles.dati.EDIT_3);


set(handles.BUTTON_SAVE,'Enable','off');

end

% --- Executes on button press in BUTTON_LISTEN.
function BUTTON_LISTEN_Callback(hObject, eventdata, handles)
% hObject    handle to BUTTON_LISTEN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%path = 'C:\Origgi'; %path di dove si trova il file rec
path ='D:\DATA\UNIMI\TESI\Forma_lavoro\Salvataggi';

File_name = 'Rec.wav';%test uploddo file
File_name = strcat(path, '\', File_name);

[y,Fs] = audioread(File_name);
sound(y(:,1), Fs);


end

% --- Executes on button press in BUTTON_C_D.
function BUTTON_C_D_Callback(hObject, eventdata, handles)
% hObject    handle to BUTTON_C_D (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

a = get(handles.RADB_1,'Value');
b = get(handles.RADB_2,'Value');
x = strcmp(get(handles.BUTTON_P_P,'String'), 'End');
%fprintf('%d, %s\n', x, get(handles.BUTTON_P_P,'String') );

%%SOLO PER ESECUZIONI
if a == 1 && b == 0
  if  x == 1
    pathFile = 'e:'; 
    pathFolderA = 'C:\Origgi';
    pathFolderB = 'C:\Origgi\Salvataggi'; 

    %Creo la cartella in salvataggi
    folderName = get(handles.EDIT_2,'String');
    mkdir(pathFolderB, folderName);
    pathFolder = strcat(pathFolderB, '\', folderName, '\');

    %seleziona file.jpg da salvare e copia nella nuova cartella
    source = strcat(pathFile,'\*.jpg');
    destination = pathFolder;
    copyfile(source,destination);

    %seleziona file.log da salvare e copia nella nuova cartella
    source = strcat(pathFile,'\*.log');
    destination = pathFolder;
    copyfile(source,destination);

    %seleziona file.wav da salvare e copia nella nuova cartella
    source = strcat(pathFile,'\*.wav');
    destination = pathFolder;
    copyfile(source,destination);
    
    %seleziona file.wav da salvare e copia nella nuova cartella
    source = strcat(pathFolderA,'\result.txt');
    destination = pathFolder;
    copyfile(source,destination);
    
    handles.dati.EDIT_2='Created';
    set(handles.EDIT_2,'String',handles.dati.EDIT_2);
  end
  if x == 0
      handles.dati.EDIT_2= 'Process not ended';
      set(handles.EDIT_2,'String',handles.dati.EDIT_2);
  end    
end

if b == 1 && a == 0 ||  b == 0 && a == 0
    handles.dati.EDIT_2='Not Possible';
    set(handles.EDIT_2,'String',handles.dati.EDIT_2);
end


end

% --- Executes on button press in BUTTON_task.
function BUTTON_task_Callback(hObject, eventdata, handles)
% hObject    handle to BUTTON_task (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

start_path = 'C:\';
%start_path = 'D:\DATA\UNIMI\TESI\Forma_lavoro';

[file_name, path_name]= uigetfile(start_path);
source = strcat(path_name,'\',file_name);
CurrDir = cd;

cd(path_name);
[token, end_file] = strtok(file_name, '.');

if strcmp(end_file, '.exe') == 1
    movefile(file_name, 'runfile.exe');
    !runfile
    movefile('runfile.exe', file_name);
end
if strcmp(end_file, '.bat') == 1
    movefile(file_name, 'runfile.bat');
    !runfile
    movefile('runfile.bat', file_name);
end

cd(CurrDir);

end


% --- Executes on button press in RADB_1.
function RADB_1_Callback(hObject, eventdata, handles)
% hObject    handle to RADB_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of RADB_1
end

% --- Executes on button press in RADB_2.
function RADB_2_Callback(hObject, eventdata, handles)
% hObject    handle to RADB_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of RADB_2
end


% --- Executes on button press in BUTTON_frame1.
function BUTTON_frame1_Callback(hObject, eventdata, handles)
% hObject    handle to BUTTON_frame1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

axes(handles.axes2);

frame = get(handles.EDIT_frame, 'string');
frame = str2num(frame);

if frame > 0
    frame=frame-1;
    numindex = frame;
    frame = num2str(frame);
    set(handles.EDIT_frame,'String',frame);

    path = get(handles.EDIT_path, 'string');
    token = 'test';

    if(numindex < 10)    
        index = strcat(token,'[000000000',frame,']'); 
    end    
    if(numindex > 9 && numindex < 100 )
        index = strcat(token,'[00000000',frame,']');
    end    
    if(numindex > 99 && numindex < 1000)
        index = strcat(token,'[0000000',frame,']');
    end    
    if(numindex > 999 && numindex < 10000)
        index = strcat(token,'[000000',frame,']');
    end    



    %ESTRAGGO E STAMPO IMAGE
    image_name = strcat(index,'.jpg');
    imageFileName = fullfile(path,image_name);

    rgb = imread(imageFileName);
    image(rgb);
    axis off
    axis image
    
    
    
    
    frame = str2num(frame);
    PathFileName = fullfile(path,'\test.log');
    [time] = textread(PathFileName, '%d',1,'headerlines', frame);
    
   
    
    axes(handles.axes3);
    if findobj(handles.axes3,'Color','g')
        delete(findobj(handles.axes3,'Color','g'));
    end
    x = time/1000;
    y = -1:0.001:1;
    plot(x,y, 'g-', 'LineWidth' , 1 );
end
end

% --- Executes on button press in BUTTON_frame2.
function BUTTON_frame2_Callback(hObject, eventdata, handles)
% hObject    handle to BUTTON_frame2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


axes(handles.axes2);

frame = get(handles.EDIT_frame, 'string');
frame = str2num(frame);

if frame > 0
    frame=frame+1;
    numindex = frame;
    frame = num2str(frame);
    set(handles.EDIT_frame,'String',frame);

    path = get(handles.EDIT_path, 'string');
    token = 'test';

    if(numindex < 10)    
        index = strcat(token,'[000000000',frame,']'); 
    end    
    if(numindex > 9 && numindex < 100 )
        index = strcat(token,'[00000000',frame,']');
    end    
    if(numindex > 99 && numindex < 1000)
        index = strcat(token,'[0000000',frame,']');
    end    
    if(numindex > 999 && numindex < 10000)
        index = strcat(token,'[000000',frame,']');
    end    



    %ESTRAGGO E STAMPO IMAGE
    image_name = strcat(index,'.jpg');
    imageFileName = fullfile(path,image_name);

    rgb = imread(imageFileName);
    image(rgb);
    axis off
    axis image
    
    
    
    
    frame = str2num(frame);
    PathFileName = fullfile(path,'\test.log');
    [time] = textread(PathFileName, '%d',1,'headerlines', frame);
    
   
    
    axes(handles.axes3);
    if findobj(handles.axes3,'Color','g')
        delete(findobj(handles.axes3,'Color','g'));
    end
    x = time/1000;
    y = -1:0.001:1;
    plot(x,y, 'g-', 'LineWidth' , 1 );
   
end

end








function EDIT_Status_Callback(hObject, eventdata, handles)
% hObject    handle to EDIT_Status (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EDIT_Status as text
%        str2double(get(hObject,'String')) returns contents of EDIT_Status as a double
end

% --- Executes during object creation, after setting all properties.
function EDIT_Status_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EDIT_Status (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function EDIT_Numev_Callback(hObject, eventdata, handles)
% hObject    handle to EDIT_Numev (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EDIT_Numev as text
%        str2double(get(hObject,'String')) returns contents of EDIT_Numev as a double
end

% --- Executes during object creation, after setting all properties.
function EDIT_Numev_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EDIT_Numev (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function EDIT_3_Callback(hObject, eventdata, handles)
% hObject    handle to EDIT_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EDIT_3 as text
%        str2double(get(hObject,'String')) returns contents of EDIT_3 as a double
end

% --- Executes during object creation, after setting all properties.
function EDIT_3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EDIT_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function EDIT_2_Callback(hObject, eventdata, handles)
% hObject    handle to EDIT_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EDIT_2 as text
%        str2double(get(hObject,'String')) returns contents of EDIT_2 as a double
end

% --- Executes during object creation, after setting all properties.
function EDIT_2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EDIT_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function EDIT_1_Callback(hObject, eventdata, handles)
% hObject    handle to EDIT_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EDIT_1 as text
%        str2double(get(hObject,'String')) returns contents of EDIT_1 as a double
end

% --- Executes during object creation, after setting all properties.
function EDIT_1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EDIT_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function EDIT_R_numev_Callback(hObject, eventdata, handles)
% hObject    handle to EDIT_R_numev (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EDIT_R_numev as text
%        str2double(get(hObject,'String')) returns contents of EDIT_R_numev as a double
end

% --- Executes during object creation, after setting all properties.
function EDIT_R_numev_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EDIT_R_numev (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function EDIT_R_pos_Callback(hObject, eventdata, handles)
% hObject    handle to EDIT_R_pos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EDIT_R_pos as text
%        str2double(get(hObject,'String')) returns contents of EDIT_R_pos as a double
end

% --- Executes during object creation, after setting all properties.
function EDIT_R_pos_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EDIT_R_pos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function EDIT_R_match_Callback(hObject, eventdata, handles)
% hObject    handle to EDIT_R_match (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EDIT_R_match as text
%        str2double(get(hObject,'String')) returns contents of EDIT_R_match as a double
end

% --- Executes during object creation, after setting all properties.
function EDIT_R_match_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EDIT_R_match (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function EDIT_R_diff_Callback(hObject, eventdata, handles)
% hObject    handle to EDIT_R_diff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EDIT_R_diff as text
%        str2double(get(hObject,'String')) returns contents of EDIT_R_diff as a double
end

% --- Executes during object creation, after setting all properties.
function EDIT_R_diff_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EDIT_R_diff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function EDIT_R_start_Callback(hObject, eventdata, handles)
% hObject    handle to EDIT_R_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EDIT_R_start as text
%        str2double(get(hObject,'String')) returns contents of EDIT_R_start as a double
end

% --- Executes during object creation, after setting all properties.
function EDIT_R_start_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EDIT_R_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end



function EDIT_R_dur_Callback(hObject, eventdata, handles)
% hObject    handle to EDIT_R_dur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EDIT_R_dur as text
%        str2double(get(hObject,'String')) returns contents of EDIT_R_dur as a double

end
% --- Executes during object creation, after setting all properties.
function EDIT_R_dur_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EDIT_R_dur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function EDIT_R_height_Callback(hObject, eventdata, handles)
% hObject    handle to EDIT_R_height (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EDIT_R_height as text
%        str2double(get(hObject,'String')) returns contents of EDIT_R_height as a double
end

% --- Executes during object creation, after setting all properties.
function EDIT_R_height_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EDIT_R_height (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function EDIT_soglia_Callback(hObject, eventdata, handles)
% hObject    handle to EDIT_soglia (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EDIT_soglia as text
%        str2double(get(hObject,'String')) returns contents of EDIT_soglia as a double
end

% --- Executes during object creation, after setting all properties.
function EDIT_soglia_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EDIT_soglia (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end



% --- Executes on button press in CB_1.
function CB_1_Callback(hObject, eventdata, handles)
% hObject    handle to CB_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CB_1
end


function EDIT_R_tresh_Callback(hObject, eventdata, handles)
% hObject    handle to EDIT_R_tresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EDIT_R_tresh as text
%        str2double(get(hObject,'String')) returns contents of EDIT_R_tresh as a double
end

% --- Executes during object creation, after setting all properties.
function EDIT_R_tresh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EDIT_R_tresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end

function EDIT_R_noise_Callback(hObject, eventdata, handles)
% hObject    handle to EDIT_R_noise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EDIT_R_noise as text
%        str2double(get(hObject,'String')) returns contents of EDIT_R_noise as a double

end
% --- Executes during object creation, after setting all properties.
function EDIT_R_noise_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EDIT_R_noise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


% --- Executes on button press in CB_2.
function CB_2_Callback(hObject, eventdata, handles)
% hObject    handle to CB_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CB_2
end

% --- Executes on button press in CB_3.
function CB_3_Callback(hObject, eventdata, handles)
% hObject    handle to CB_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CB_3
end


function EDIT_R_loclevel_Callback(hObject, eventdata, handles)
% hObject    handle to EDIT_R_loclevel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EDIT_R_loclevel as text
%        str2double(get(hObject,'String')) returns contents of EDIT_R_loclevel as a double
end

% --- Executes during object creation, after setting all properties.
function EDIT_R_loclevel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EDIT_R_loclevel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in falsecheckb.
function falsecheckb_Callback(hObject, eventdata, handles)
% hObject    handle to falsecheckb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of falsecheckb
end


function EDIT_frame_Callback(hObject, eventdata, handles)
% hObject    handle to EDIT_frame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EDIT_frame as text
%        str2double(get(hObject,'String')) returns contents of EDIT_frame as a double

end

% --- Executes during object creation, after setting all properties.
function EDIT_frame_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EDIT_frame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function EDIT_path_Callback(hObject, eventdata, handles)
% hObject    handle to EDIT_path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EDIT_path as text
%        str2double(get(hObject,'String')) returns contents of EDIT_path as a double

end
% --- Executes during object creation, after setting all properties.
function EDIT_path_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EDIT_path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%FUNZIONI




function initialize_gui(handles)

%POSITION
axes(handles.axes1);
hold off;
y = 0;
z = 80;
x = 0;
grid;
stem3(x,y,z, 'r','MarkerFaceColor','r')
y = 0;
z = 0;
x = 0;
hold on;
grid;
stem3(x,y,z,'b*','MarkerFaceColor','b');
y = 0;
z = 0;
x = 0;
hold on;
grid;
stem3(x,y,z,'g*','MarkerFaceColor','g');

axis([0 5 -50 50 0 300]);
%axis([0 5 -2 2 0 300]);
ylabel('Direction (degree)', 'Color','blue', 'FontSize',9,'FontAngle','italic');
zlabel('Height (cm)', 'Color','blue', 'FontSize',9,'FontAngle','italic');
xlabel('Depth (m) [not running]', 'Color','blue', 'FontSize',9,'FontAngle','italic');
hold on;
legend('Microphone','Voice', 'Sound','FontSize',8,'Location','northoutside','Orientation','horizontal');


%IMAGE
axes(handles.axes2);
hold off;
plot(0,0);
axis off

%STREAM AUDIO GRAFIC
axes(handles.axes3);
hold off;
plot(0,0);
axis off;

%DATA
handles.dati.EDIT_1='';
handles.dati.EDIT_2='new folder name';
%Quello scritto inizialmente
set(handles.EDIT_2,'String',handles.dati.EDIT_2);


%CONTROL PANNEL
handles.dati.EDIT_Numev = '0';
handles.dati.EDIT_3='V or S + filename';
%Quello scritto inizialmente
set(handles.EDIT_Numev,'String',handles.dati.EDIT_Numev);
set(handles.EDIT_3,'String',handles.dati.EDIT_3);

if get(handles.EDIT_soglia,'String') == '0'
    %SOGLIA
    handles.dati.EDIT_soglia='80';
    %Quello scritto inizialmente
    set(handles.EDIT_soglia,'String',handles.dati.EDIT_soglia);
end


%CURRENT RESULT
handles.dati.EDIT_R_numev='';
handles.dati.EDIT_R_pos='';
handles.dati.EDIT_R_height='';
handles.dati.EDIT_R_match='';
handles.dati.EDIT_R_diff='';
handles.dati.EDIT_R_start='';
handles.dati.EDIT_R_dur='';
handles.dati.EDIT_R_tresh='';
handles.dati.EDIT_R_noise='';
handles.dati.EDIT_R_loclevel='';
%Quello scritto inizialmente
set(handles.EDIT_R_numev,'String',handles.dati.EDIT_R_numev);
set(handles.EDIT_R_pos,'String',handles.dati.EDIT_R_pos);
set(handles.EDIT_R_height,'String',handles.dati.EDIT_R_height);
set(handles.EDIT_R_match,'String',handles.dati.EDIT_R_match);
set(handles.EDIT_R_diff,'String',handles.dati.EDIT_R_diff);
set(handles.EDIT_R_start,'String',handles.dati.EDIT_R_start);
set(handles.EDIT_R_dur,'String',handles.dati.EDIT_R_dur);
set(handles.EDIT_R_tresh,'String',handles.dati.EDIT_R_tresh);
set(handles.EDIT_R_noise,'String',handles.dati.EDIT_R_noise);
set(handles.EDIT_R_loclevel,'String',handles.dati.EDIT_R_loclevel);

%salvole strutture appena create (dati e vettori)
%nellastruttura principale handles
guidata(handles.axes1,handles);
guidata(handles.axes2,handles);
guidata(handles.axes3,handles);

%attivo disattivo bottoni
set(handles.BUTTON_RUN,'Enable','on');
set(handles.BUTTON_P_P,'Enable','off');
set(handles.BUTTON_SAVE,'Enable','off');
set(handles.BUTTON_LISTEN,'Enable','off');
set(handles.BUTTON_C_D,'Enable','off');
set(handles.BUTTON_P_P,'String','Ready');

%ALTRO
%set(handles.EDIT_path,'String','','Visible','Off');
set(handles.EDIT_path,'String','');
set(handles.EDIT_frame,'String','');

end


function Run(hObject, handles)

initialize_gui(handles)

a = get(handles.RADB_1,'Value');
b = get(handles.RADB_2,'Value');
if a == 1 && b == 0
    handles.dati.EDIT_1 = 1;
    %funzioni sui bottoni
    set(handles.BUTTON_P_P,'Enable','off');
    Analisi(handles);
end    
if b == 1 && a == 0  
    handles.dati.EDIT_1 = 0;
    %funzioni sui bottoni
    set(handles.BUTTON_RUN,'Enable','off');
    set(handles.BUTTON_P_P,'Enable','off');
    Analisi(handles);
end 
    


end



% End of the process
%-----------------------
