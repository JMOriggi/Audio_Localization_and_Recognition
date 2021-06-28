% SCOPO FUNZIONE:   Trova l'immagine corrispondente ad un evento sonoro e
% la stampa nel riquadro dell'interfaccia grafica.
%
% PARAMETRI INPUT:
%                   - PathName: path di dove si trovano le immagini.
%                   - FileName: nome immagine.
%                   - time: tempo di inizio evento in ms.                
%
% PARAMETRI OUTPUT:
%
function dex = extract_index_image(PathName, File_index, time)

%ESTRAGGO E FORMO L INDEX CORRETTO
PathFileName = fullfile(PathName,File_index);

row = 1; 
x(row,1) = 0; 

if(time == 0)
    num_index = 0;
end

if(time ~= 0)
    
    %while  time ~= x(row)
    while  time > x(row)
        row = row+1;
        [x] = textread(PathFileName, '%d', row);
    end
    num_index = row-1;    
end

dex = num2str(num_index);
token = strtok(File_index, '.'); 

if(num_index < 10)    
    index = strcat(token,'[000000000',dex,']'); 
end    
if(num_index > 9 && num_index < 100 )
    index = strcat(token,'[00000000',dex,']');
end    
if(num_index > 99 && num_index < 1000)
    index = strcat(token,'[0000000',dex,']');
end    
if(num_index > 999 && num_index < 10000)
    index = strcat(token,'[000000',dex,']');
end    

%ESTRAGGO E STAMPO IMAGE
image_name = strcat(index,'.jpg');
imageFileName = fullfile(PathName,image_name);

rgb = imread(imageFileName);
image(rgb);
axis off
axis image

end