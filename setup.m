%Parameters for Chord Recognition

%Chord labels
type = {'M' 'M4' 'M6' 'V' 'm' 'm7' 'd' 'd7'};

%type = {'M' 'M4' 'M6' 'M7' 'V' 'm' 'm6' 'm7' 'd' 'd7' 'hd7'};   %Full list
%type = {'M' 'M4' 'M6' 'V' 'm' 'm6' 'm7' 'd' 'd7'};   %BREVE chords
%type = {'M' 'M7' 'V' 'm' 'm6' 'm7' 'd' 'd7' 'hd7'};   %KP chords
%type = {'M' 'm' 'd'} %Simple model


nt = size(type,2);
K = nt*12; % number of labels

%Dataset
[X,T] = parseDataset('Datasets/allchords.f1',type,1);
%[X,T] = parseDataset('Datasets/jsbach_chorals_harmony.f1',type,1);
%[X,T] = parseDataset('Datasets/kpcorpus3.f1',type,1);
N = size(X,2); % number of training examples

%Basis Functions
VERT = 70;
HORZ = 33;
BO = [VERT+1, VERT+HORZ];
BASISTYPE = 0;

