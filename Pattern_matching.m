% SCOPO FUNZIONE:   Trova il file sonoro più simile all'evento sonoro
% individuato precedentemente. Utilizza un sistema di valutazione del
% risultato (se tenere o scartare il risultato) attraverso un sistema di soglie.
%
% PARAMETRI INPUT:
%                   - path_folder_pattern: percorso dove si trovano i
%                   template.
%                   - path_file_name: percorso dove si trovano il file acquisito.
%                   - file_ep: matrice con solo l'evento sonoro individuato.
%                   - soglia_min: soglia minima di somiglianza che un file
%                   deve avere con un template per essere considerati
%                   compatibili.
%                
% PARAMETRI OUTPUT:
%                   - res_mm: nome completo dell'evento riscontrato.
%                   - res_m: nome dell'evento riscrontrato per l'etichetta.
%                   - res_p: risultato di somiglianza massima trovata.
%                   - indexsv: indice di natura dell'evento, conterra 'S' 
%                   per gli evento sonori e "V" per gli eventi vocali.
%
function [res_mm, res_m, res_p, indexsv] = Pattern_matching(path_folder_pattern, path_file_name, file_ep, soglia_min)

soglia_min = str2double(soglia_min);
%fprintf('soglia = %d\n', soglia_min);


%Creo f struttura con numero di elementi pari al numero di file.wav della cartella
f = dir(strcat(path_folder_pattern,'\*.wav'));

%variabili per salvare il primo e il secondo evento 
%tabulato piu simile al mio evento
min_diff1 = 0; %massima somiglianza trovata
min_event1 = ''; %evento a cui corrisponde la massima simiglianza
min_diff2 = 0;
min_event2 = '';

%Ciclo che estrae una alla volta i file della cartella libreria 
%e richiama il pattern matching. Ogni volta salva il file con la prima e
%seconda maggior percentuale di somiglianza.
for i=1:length(f)
    
    path_pattern_name = strcat(path_folder_pattern,'\',f(i).name);  
    %Norm_value = Time_warp(path_file_name, path_pattern_name);
    Norm_value = Time_warp(file_ep, path_file_name , path_pattern_name);
    %fprintf('Percentuale differenza con %s = %d/100.\n\n', f(i).name, Norm_value);
    
    if min_diff1 <= Norm_value 
        min_diff2 = min_diff1;
        min_event2 = min_event1;
        min_diff1 = Norm_value;
        min_event1 = strtok(f(i).name, '.'); %taglio il formato che segue il nome file ".wav"
    end
    
    if min_diff1 > Norm_value && min_diff2 < Norm_value
        min_diff2 = Norm_value;
        min_event2 = strtok(f(i).name, '.');
    end
end    

%fprintf('min_diff1= %d, min_diff2= %d\n',min_diff1, min_diff2);

soglia_max = soglia_min+7;

%se sopra la soglia min allora molto somiglianti
if min_diff1 >= soglia_max
    % se i due minimi non sono vicini allora restituisco tutti e 2 perché
	% ambiguo.
	if min_diff1 - min_diff2 <= 1
        %tolgo l'iniziale
        xx=min_event1;
        x=min_event2;
        yy='';
        y='';
        k=1;
        [m,n]=size(xx);
        for i=2:n
            yy(k) = xx(i);
            k=k+1;
        end
        k=1;
        [m,n]=size(x);
        for i=2:n
            y(k) = x(i);
            k=k+1;
        end    
        min_event1=yy;
        min_event2=y;
        
        res_mm = strcat(min_event1,', o ,',min_event2);
        res_m = min_event1;
        res_p = min_diff1;
        indexsv = xx(1);
	end
	% se i due minimi non sono vicini allora considero solo il min1
    if min_diff1 - min_diff2 >= 2 
        %tolgo l'iniziale
        xx=min_event1;
        yy='';
        k=1;
        [m,n]=size(xx);
        for i=2:n
            yy(k) = xx(i);
            k=k+1;
        end
        min_event1=yy;
        
        res_mm = min_event1;
        res_m = min_event1;
        res_p = min_diff1;
        indexsv = xx(1);
    end    
end

if min_diff1 < soglia_max
    %se la somiglianza massima riscontrata è inferiore a soglia max allora considero
    %che non esiste neanche la minima somiglianza con suoni tabulati
    if min_diff1 < soglia_min
        res_mm = 'Not found';
        res_m = 'Not found';
        res_p = min_diff1;
        indexsv = 'S';
    end    
    %se <25% allora restituisco il risultato informando cmq del grado
    %notevole di differenza
    if min_diff1 >= soglia_min
        %tolgo l'iniziale
        xx=min_event1;
        yy='';
        k=1;
        [m,n]=size(xx);
        for i=2:n
            yy(k) = xx(i);
            k=k+1;
        end
        min_event1=yy;
        
        res_mm = strcat('Somiglianza con :',min_event1);
        res_m = min_event1;
        res_p = min_diff1;
        indexsv = xx(1);
    end
end


end

