% SCOPO FUNZIONE:   Paragona 2 file e trova l'allineamento a costo minimo.
% Necessità 3 funzioni associate: dp, simmx e calculate_norm.
%
% PARAMETRI INPUT:
%                   -path_file_name: percorso per trovare il file sonoro.
%                   -path_pattern_name: percorso per trovare il file template.
%                   -time: tempo di inizio evento in ms.                
%
% PARAMETRI OUTPUT:
%                   - Norm_value: risultato di somiglianza tra due file in
%                   centesimi e normalizzato.
%
function Norm_value = Time_warp (file_ep, path_file_name , path_pattern_name)

%Modifiche per file stereo (algoritmo lavora solo con mono)
    [y, Fs] = wavread(path_file_name);
    y = file_ep;
    %y = file_name; %si tratta di una matrice e non di un file
    y1 = y(:,1);
    d1 = y1;
    %sr = 16000;
    sr1 = Fs;
    
    [y, Fs] = wavread(path_pattern_name);
    y1 = y(:,1);
    d2 = y1;
    sr2 = Fs;


 
%ml = min(length(d1));
%m2 = min(length(d2)); 
%soundsc([d1(1:ml)],sr)
%soundsc([d2(1:m2)],sr)    
    
 % Calculate STFT features for both sounds (25% window overlap)
 D1 = specgram(d1,512,sr1,512,384);
 D2 = specgram(d2,512,sr2,512,384);

 % Construct the 'local match' scores matrix as the cosine distance 
 % between the STFT magnitudes
 SM = simmx(abs(D1),abs(D2));

 % Use dynamic programming to find the lowest-cost path between the 
 % opposite corners of the cost matrix
 % Note that we use 1-SM because dp will find the *lowest* total cost
 C = dp(1-SM);

 
%fprintf('CALCOLO PERCENTUALE DIFFERENZA tra due eventi sonori.\n');
 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %Aggiunta per il calcolo della normalizzazione
 size_a = size(C,1);
 size_b = size(C,2);
 Norm = Calculate_norm(size_a, size_b);
 %fprintf('Norm = %d.\n', Norm);
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
  % Bottom right corner of C gives cost of minimum-cost alignment of the two
 result = C(size(C,1),size(C,2));
 %fprintf('Risultato non normalizzato = %d.\n', result);
 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %Aggiunta risultato normalizato messo in scala su 100
 %13 è la soglia per considerare 2 suoni simili
 Norm_value = (result*100) / Norm;
 Norm_value = 100-Norm_value;
 
 if Norm_value >= 99; 
    Norm_value = 100;
 end
 
 if Norm_value < 99;
    %troncatura per risultato più pulito 
    T = num2str(Norm_value,'%.0f');
    Norm_value = str2num(T);
 end
 
end




% SCOPO FUNZIONE:   Calcola la matrice dei costi totali delle matrici A e B
%
% PARAMETRI INPUT:
%                   - A: matrice contenente un file sonoro.
%                   - B: matrice contenente un file sonoro.
%
% PARAMETRI OUTPUT:
%                   - M: matrice di costo totale tra A e B.
%
function M = simmx(A,B)

EA = sqrt(sum(A.^2));
EB = sqrt(sum(B.^2));

% this is 10x faster
M = (A'*B)./(EA'*EB);
end



% SCOPO FUNZIONE:   Usa programmazione dinamica per trovare il costo
% minimo della matrice M.
%
% PARAMETRI INPUT:
%                   - M: matrice di costo totale.
%
% PARAMETRI OUTPUT:
%                   - D: percorso di costo minimo.
%
function D = dp(M)

[r,c] = size(M);

% costs
D = zeros(r+1, c+1);
D(1,:) = NaN;
D(:,1) = NaN;
D(1,1) = 0;
D(2:(r+1), 2:(c+1)) = M;

% traceback
phi = zeros(r,c);

for i = 1:r; 
  for j = 1:c;
    [dmax, tb] = min([D(i, j), D(i, j+1), D(i+1, j)]);
    D(i+1,j+1) = D(i+1,j+1)+dmax;
    phi(i,j) = tb;
  end
end

% Traceback from top left
i = r; 
j = c;
p = i;
q = j;
while i > 1 & j > 1
  tb = phi(i,j);
  if (tb == 1)
    i = i-1;
    j = j-1;
  elseif (tb == 2)
    i = i-1;
  elseif (tb == 3)
    j = j-1;
  else    
    error;
  end
  p = [i,p];
  q = [j,q];
end

% Strip off the edges of the D matrix before returning
D = D(2:(r+1),2:(c+1));
end



% SCOPO FUNZIONE:   Trova una scala di normalizzazione del risultato
% tramite il calcolo della dimensione della matrice (lunghezza della diagonale)
%
% PARAMETRI INPUT:
%                   - size_a: numero di colonne della matrice di costo.
%                   - size_b: numero di righe della matrice di costo.
%
% PARAMETRI OUTPUT:
%                   - Norm: lunghezza diagonale matrice di costo.
%
function Norm = Calculate_norm(size_a, size_b)
 
 Num_righe = size_a;
 Num_col = size_b;
 
 %Calcolo la diagonale per poi usarla come normalizzazione
 diagonale = sqrt(Num_righe^2 + Num_col^2);
 Norm = diagonale;
 
end
