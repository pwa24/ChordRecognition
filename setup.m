%Parameters for Chord Recognition

%-----Basis Functions
global BASISTYPE VERT HORZ BO;
BASISTYPE = 0;  %0 = BREVE, 1 = JEFF's
VERT = 70;
HORZ = 33;
BO = [VERT+1, VERT+HORZ];

%-----Chord labels
global ALLCHORDS_L CHORD_MAP CHORD_L CHORD_M CHORD_A K;
%type = {'M' 'M4' 'M6' 'V' 'm' 'm7' 'd' 'd7'};

ALLCHORDS_L = {'M' 'M4' 'M6' 'M7' 'V' 'm' 'm6' 'm7' 'd' 'd7' 'hd7'};
ALLCHORDS_M = [ 0   0    0    0    3   1   1    1    2   2    2]; %Mode: 0 = M, 1 = m, 2 = d, 3 = V
ALLCHORDS_A = [ 0   5    9    11   10  0   9    10   0   9    10]; %Added Note: in semitones

%All Chords (132 labels)
%CHORD_MAP   = ALLCHORDS_L;
%CHORD_L     = ALLCHORDS_L;

%BREVE Chords (108 labels)
%CHORD_MAP   = {'M' 'M4' 'M6' 'V' 'V' 'm' 'm6' 'm7' 'd' 'd7' 'd7'};
%CHORD_L     = {'M' 'M4' 'M6' 'V' 'm' 'm6' 'm7' 'd' 'd7'};

%KP Chords (108 labels)
%CHORD_MAP   = {'M' 'M'  'M' 'M7' 'V' 'm' 'm6' 'm7' 'd' 'd7' 'hd7'};
%CHORD_L     = {'M' 'M7' 'V' 'm' 'm6' 'm7' 'd' 'd7' 'hd7'};

%Simple Model (36 labels)
CHORD_MAP   = {'M' 'M'  'M'  'M'  'M' 'm' 'm'  'm'  'd' 'd'  'd'};
CHORD_L     = {'M' 'm' 'd'};


CHORD_M = ALLCHORDS_M(ismember(ALLCHORDS_L, CHORD_L));
CHORD_A = ALLCHORDS_A(ismember(ALLCHORDS_L, CHORD_L));
K = size(CHORD_L,2)*12; % number of labels

%-----Dataset
%[X,T] = parseDataset('Datasets/allchords.f1');

%JS Bach
%[X,T] = parseDataset('Datasets/jsbach2.f1');

%KP
[X,T] = parseDataset('Datasets/kp1.f1');

%Combined and randomized
%{
[X1,T1] = parseDataset('Datasets/jsbach2.f1');
[X2,T2] = parseDataset('Datasets/kp1.f1');
X = [X1, X2];
T = [T1, T2];
%fixed randperm(89)
RP = [29,37,19,31,89,88,32,3,52,65,13,66,8,51,27,42,74,57,71,75,69,59,...
      67,48,30,4,83,35,55,73,78,86,39,25,14,38,44,77,11,43,53,60,5,64,...
      81,87,80,56,76,2,45,50,26,18,22,49,34,61,28,46,24,58,85,47,84,23,...
      40,16,41,12,70,33,79,68,20,62,1,15,82,72,21,36,10,6,63,17,54,7,9];
X = X(RP);
T = T(RP);
%}

N = size(X,2); % number of training examples

%Indicies of X to train
I = [1:50];


