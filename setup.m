%Parameters for Chord Recognition

%Chord labels
%type = {'M' 'M4' 'M6' 'V' 'm' 'm4' 'm6' 'm7' 'd' 'd4' 'd6' 'd7' 'hd' 'M7' 'd7b9'}; % chord labels
%type = {'M' 'M4' 'M6' 'V' 'm' 'm4' 'm6' 'm7' 'd' 'd7'};
type = {'M' 'M4' 'M6' 'V' 'm' 'm7' 'd' 'd7'};
%type = {'M' 'm'};
%type = {'M' 'M7' 'm' 'm7' 'd' 'd7' 'hd' '7' 'd7b9'};
nt = size(type,2);
K = nt*12; % number of labels

%Dataset
[X,T] = parseDataset('Datasets/jsbach_chorals_harmony.f1',type,1);
%[X,T] = parseDataset('Datasets/kpcorpus3.f1',type,1);
N = size(X,2); % number of training examples

%Basis Functions
VERT = 70;
HORZ = 33;
BO = [VERT+1, VERT+HORZ];

