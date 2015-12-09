function F = m_basis(X,yt,ytm,t,S)
% X(i) = the training data (X from parseDataset())
% yt = the current label
% yt-1 = the previous label
% t = event number
global CHORD_L;
%F(30) = m_prob(X,t,type,yt);
type = CHORD_L;
VERT = 70;
HORZ = 33;

nt = size(type,2);
F = zeros(VERT+HORZ,1);

[r1,m1,a1] = getChordDetails(yt);
[r0,m0,a0] = getChordDetails(ytm);
%r = root of chord (ex. C)
%m = mode of chord (ex. M)
%a = added note of chord (ex. 7)

C = mod(yt,nt) + 1; %Current chord type index (from 1)
% ----------------------------------
% 0. VARIOUS ANALYSIS OF INPUT NOTES
% ----------------------------------

ST = t;
E = t;
CopyT = t;
while (t > 1 && m_sim(X.pitch(t-1,:),X.pitch(t,:)) == 1 && X.meter(t) < X.meter(t-1) )
    ST = ST - 1;
    t = t - 1;
end
t = CopyT;
while (t < X.numEvents && m_sim(X.pitch(t+1,:),X.pitch(t,:)) == 1 && X.meter(t) > X.meter(t+1))
    E = E + 1;
    t = t + 1;
end
t = CopyT;

PITCH = zeros(1,12);
P_A = zeros(1,12);
P_B = zeros(1,12);
COMMON = zeros(1,12);

for i=ST:E
    if (i ~= t)
        PITCH = PITCH + X.pitch(i,:);
    end
end
for i=ST:t-1
    P_A = P_A + X.pitch(i,:);
end
for i=t+1:E
    P_B = P_B + X.pitch(i,:);
end
for i=1:12
    if (PITCH(1,i) == E-ST+1)
        COMMON(1,i) = 1;
    end
end

% ----------------------------
% Asserted Added Note Matrices
% ----------------------------

ChordType   = {'M' 'M4' 'M6' 'M7' 'm' 'm4' 'm6' 'm7' 'd' 'd4' 'd6' 'd7' 'hd7' 'V' 'd7b9' 'N'};
Index       = [ 1   2    3    4    5   6    7    8    9   10   11  12    13   14  15     16];
in = Index(strcmp(ChordType,type{C}));

AddedNote   = {0, 5, 9,11, 0, 5, 9,10, 0, 5, 9, 9,10,10, 0, 0};
THIRD       = {4, 4, 4, 4, 3, 3, 3, 3, 3, 3, 3, 3, 3, 4, 3, 0};
FIFTH       = {7, 7, 7, 7, 7, 7, 7, 7, 6, 6, 6, 6, 6, 7, 6, 0};

CT = {  [0,4,7];    % M
        [0,5,7];    % M4
        [0,4,7,9];  % M6
        [0,4,7,11]; % M7
        [0,3,7];    % m
        [0,3,5,7];  % m4
        [0,3,9];    % m6
        [0,3,7,10]; % m7
        [0,3,6];    % d
        [0,3,6,5];  % d4
        [0,3,6,9];  % d6
        [0,3,6,9];  % d7
        [0,3,6,10]; % hd
        [0,4,7,10]; % V
        [0];        %
        [0];};

n_c = [0,0,0];
for i=1:size(CT{in},2)
    if( X.pitch(t,j_mod(CT{in}(i)+r1+1,12)) >= 1)
        n_c(1) = n_c(1) + 1;
    end
    %if (t > 1 && X.pitch(t-1,j_mod(CT{in}(i)+r1+1,12)) >= 1)
    if (PITCH(1, j_mod(CT{in}(i)+r1+1,12)) >= 1)
        n_c(2) = n_c(2) + 1;
    end
    if (P_B(1, j_mod(CT{in}(i)+r1+1,12)) >= 1)
        n_c(3) = n_c(3) + 1;
    end
end

% ------------------------------------------
% 1. Penalize Added Note Chords on Weak Beats
% ------------------------------------------

if (t > 1 && t <= X.numEvents)
    if (X.meter(t) < X.meter(t-1) && a1 ~= 0)
        F(1) = 0;
    else
        F(1) = 1;
    end
end


% -----------------------------------
% 5-21. Asserted NOTES IN CONTEXT
% -----------------------------------

if (X.pitch(t, r1+1) >= 1)
    F(5) = 1;
end
if (X.pitch(t,j_mod(r1+1+THIRD{in},12)) >= 1)
    F(6) = 1;
end
if (X.pitch(t,j_mod(r1+1+FIFTH{in},12)) >= 1)
    F(7) = 1;
end
if (X.pitch(t,j_mod(r1+1+AddedNote{in},12)) >= 1)
    F(8) = 1;
end

% Asserted NEXT

%{
if (t < X.numEvents && X.meter(t) > X.meter(t+1) && m_sim(X.pitch(t+1,:),X.pitch(t,:)) == 1)
%if (t < X.numEvents && m_sim(X.pitch(t+1,:),X.pitch(t,:)) == 1)
    if (X.pitch(t+1, r1+1) <= 1)
        F(10) = 1;
    end
    if (X.pitch(t+1,j_mod(r1+1+THIRD{in},12)) >= 1)
        F(11) = 1;
    end
    if (X.pitch(t+1,j_mod(r1+1+AddedNote{in},12)) >= 1)
        F(12) = 1;
    end
    if (X.pitch(t+1,j_mod(r1+1+FIFTH{in},12)) >= 1)
        F(13) = 1;
    end
end

% Asserted LAST

if (t > 1 && X.meter(t-1) > X.meter(t) && m_sim(X.pitch(t-1,:),X.pitch(t,:)) == 1)
%if (t > 1 && m_sim(X.pitch(t-1,:),X.pitch(t,:)) == 1)
    if (X.pitch(t - 1,r1 + 1) <= 1)
        F(14) = 1;
    end
    if (X.pitch(t-1,j_mod(r1+1+THIRD{in},12)) >= 1)
        F(15) = 1;
    end
    if (X.pitch(t-1,j_mod(r1+1+AddedNote{in},12)) >= 1)
         F(16) = 1;
    end
    if (X.pitch(t-1,j_mod(r1+1+FIFTH{in},12)) >= 1)
         F(17) = 1;
    end
end
%}

if (COMMON(1,r1 + 1) >= 1)
    F(10) = 1;
end
if (COMMON(1,j_mod(r1+1+THIRD{in},12)) >= 1)
    F(11) = 1;
end
if (COMMON(1,j_mod(r1+1+FIFTH{in},12)) >= 1)
    F(12) = 1;
end
if (COMMON(1,j_mod(r1+1+AddedNote{in},12)) >= 1)
    F(13) = 1;
end


%%{
if (t > 1 && X.meter(t-1) > X.meter(t) && m_sim(X.pitch(t-1,:),X.pitch(t,:)) == 1)
    if (X.pitch(t-1,r1 + 1) >= 1 && X.pitch(t,r1 + 1) >= 1)
        F(40) = 1;
    end
    if (X.pitch(t-1,j_mod(r1+1+THIRD{in},12)) >= 1 && X.pitch(t,j_mod(r1+1+THIRD{in},12)) >= 1)
        F(41) = 1;
    end
    if (X.pitch(t-1,j_mod(r1+1+AddedNote{in},12)) >= 1 && X.pitch(t,j_mod(r1+1+AddedNote{in},12)) >= 1)
        F(42) = 1;
    end
    if (X.pitch(t-1,j_mod(r1+1+FIFTH{in},12)) >= 1 && X.pitch(t,j_mod(r1+1+FIFTH{in},12)) >= 1)
        F(43) = 1;
    end
end

if (t < X.numEvents && X.meter(t+1) < X.meter(t) && m_sim(X.pitch(t+1,:),X.pitch(t,:)) == 1)
    if (X.pitch(t+1,r1 + 1) >= 1 && X.pitch(t,r1 + 1) >= 1)
        F(44) = 1;
    end
    if (X.pitch(t+1,j_mod(r1+1+THIRD{in},12)) >= 1 && X.pitch(t,j_mod(r1+1+THIRD{in},12)) >= 1)
        F(45) = 1;
    end
    if (X.pitch(t+1,j_mod(r1+1+AddedNote{in},12)) >= 1 && X.pitch(t,j_mod(r1+1+AddedNote{in},12)) >= 1)
        F(46) = 1;
    end
    if (X.pitch(t+1,j_mod(r1+1+FIFTH{in},12)) >= 1 && X.pitch(t,j_mod(r1+1+FIFTH{in},12)) >= 1)
        F(47) = 1;
    end
end
%%}


% ROOT in CONTEXT

if (t < X.numEvents && X.pitch(t+1, r1+1) == 1)
    F(18) = 1;
end
if (t < X.numEvents && X.pitch(t+1, r1+1) > 1)
    %F(10) = 1;
end
if (t > 1 && X.pitch(t-1, r1+1) == 1)
    F(19) = 1;
end
if (t > 1 && X.pitch(t-1, r1+1) > 1)
    %F(11) = 1;
end

% BASS of CONTEXT

if (t < X.numEvents && X.bass(t+1) == r1)
    F(20) = 1;
end
if (t > 1 && X.bass(t-1) == r1)
    F(21) = 1;
end

if (t < X.numEvents && X.bass(t+1) == j_mod(r1+7,12))
    F(47) = 1;
end
if (t > 1 && X.bass(t-1) == j_mod(r1+7,12))
    F(48) = 1;
end


% -----------------------------------
% 50-69. Percentage of notes in Chord
% -----------------------------------

% does increasing or decreasing accuracy have much of an effect

IC = 0;
IE = 0;
IA = 0;
IB = 0;

TOTAL = PITCH + X.pitch(t,:);

for i=1:size(CT{in},2)
    IC = IC + X.pitch(t,j_mod(CT{in}(i)+r1+1,12));
    IE = IE + TOTAL(1, j_mod(CT{in}(i)+r1+1,12));
    IA = IA + PITCH(1, j_mod(CT{in}(i)+r1+1,12));
    IB = IB + COMMON(1, j_mod(CT{in}(i)+r1+1,12));
end

SCALE = 5;

IC = floor( ((IC./sum(X.pitch(t,:))).^1) * (SCALE - 0.001));
IE = floor( ((IE./sum(TOTAL(1,:))).^1) * (SCALE - 0.001));
IA = floor( (IA./sum(PITCH(1,:))) * (SCALE - 0.001));
IB = floor( (IB./sum(COMMON(1,:))) * (SCALE - 0.001));

F(50 + IC) = 1;
if (isnan(IE) ~= 1)
    F(55 + IE) = 1;
end
if (isnan(IA) ~= 1)
    F(60 + IA) = 1;
end
if (isnan(IB) ~= 1)
    F(65 + IB) = 1;
end

% ------------------
% 4. Fully stated
% ------------------
    
if (n_c(1) ~= 0 && n_c(1) == size(CT{in},2))
    F(4) = 1;
end

% ------------------
% 26. Clearly stated
% ------------------

%if (n_c(1) == nnz(X.pitch(t)))
%    F(26) = 1;
%end

% ---------------------------
% 22-23. Fully Stated Last Chord
% ---------------------------

if (n_c(2) ~= 0 && n_c(2) == size(CT{in},2))
    F(22) = 1;
end

if (t > 1 && X.meter(t) < X.meter(t-1) && n_c(2) ~= 0 && n_c(2) == size(CT{in},2))
    F(23) = 1;
end

% ---------------------------
% 24-25. Fully Stated Next Chord
% ---------------------------

if (n_c(3) ~= 0 && n_c(3) == size(CT{in},2))
    F(24) = 1;
end

% not very important
if (t < X.numEvents && X.meter(t+1) < X.meter(t) && n_c(3) ~= 0 && n_c(3) == size(CT{in},2))
    F(25) = 1;
end

% ---------------------------------
% 30. Chord type likelihood
% ---------------------------------

F(30 + mod(yt,nt)) = 1;

% ---------------------------------
% 28. MOST CLOSEST DOWN-BEAT BASS IS ROOT
% ---------------------------------

%{
sr = 0;
DR = -1;
while (sr < 5 && t-sr > 0 && t+sr < X.numEvents)
    if (X.meter(t-sr) == 5)
        DR = X.bass(t-sr);
        break;
    end
    if (X.meter(t+sr) == 5)
        DR = X.bass(t+sr);
        break;
    end
    sr = sr + 1;
end
if(DR ~= -1 && r1 == DR)
    F(28) = 1;
end
%}

% ----------------------------------------
% 10-14. PERCENTAGE OF BASS NOTES IN CHORD 
% ----------------------------------------

%%{
B_CHORD = zeros(1,12);
B_C = 0;
for i=ST:E
    B_CHORD(X.bass(i) + 1) = 1;%B_CHORD(X.bass(i) + 1) + 1;
end
%{
for i=1:size(CT{in},2)
    B_C = B_C + B_CHORD(1,j_mod(CT{in}(i)+r1+1,12));
end
B_C = floor((B_C./sum(B_CHORD)) * (5 - 0.001));

if (isnan(B_C) == 0)
    F(10 + B_C) = 1;
end

if (B_CHORD(1,j_mod(r1+1,12)) >= 1)
    F(10) = 1;
end
if (B_CHORD(1,j_mod(r1+1+THIRD{in},12)) >= 1)
    F(11) = 1;
end
if (B_CHORD(1,j_mod(r1+1+FIFTH{in},12)) >= 1)
    F(12) = 1;
end
if (B_CHORD(1,j_mod(r1+1+AddedNote{in},12)) >= 1)
    F(13) = 1;
end
%}

% ------------------
% 26. Bass is Root Note
% ------------------

if (X.bass(CopyT) == r1)
    F(26) = 1;
end

% ------------------
% 27. Bass is Third
% ------------------

if (C <= 4) % it's a major third
    if (X.bass(CopyT) == j_mod(r1+4,12));
        F(27) = 1;
    end
else
    if (X.bass(CopyT) == j_mod(r1+3,12));
        F(27) = 1;
    end
end  

% ------------------
% 28. Bass is Fifth
% ------------------

if (X.bass(CopyT) == j_mod(r1+7,12));
   F(28) = 1; 
end

% ------------------
% 29. Bass is Added Note
% ------------------

for i=1:size(AddedNote{in},2)
if (X.bass(CopyT) == j_mod(r1+AddedNote{in}(i),12))
    F(29) = 1;
end
end

t = CopyT;

% ------------------
% 24-31 ChordChangeOnMetricalPattern
% ------------------

%%{
% consider root change not just mode change
chordchange=(yt~=ytm);
%chordchange = 0;
%if (floor(yt./nt) ~= floor(ytm./nt))
%    chordchange=1;
%end
meterbnd=3; %consider meter>3 as accented

if (t>1 && t<X.numEvents)
    maxb = X.meter(t-1);
    if (X.meter(t+1)>maxb)
        maxb = X.meter(t+1);
    end
    ChordChangeMeter = [chordchange X.meter(t-1)>X.meter(t) X.meter(t)>maxb X.meter(t+1)>X.meter(t)];    
elseif t==1
    ChordChangeMeter = [chordchange 0 X.meter(t)>X.meter(t+1) X.meter(t+1)>X.meter(t)];
elseif t==X.numEvents
    ChordChangeMeter = [chordchange X.meter(t-1)>X.meter(t) X.meter(t)>X.meter(t-1) 0];
end;
    
ChordChangeOnMetricalPattern = [1 0 0 0;
                                1 0 0 1;
                                1 0 1 0;
                                1 0 1 1;
                                1 1 0 0;
                                1 1 0 1;
                                1 1 1 0;
                                1 1 1 1];

F(VERT+1:VERT+8) = all(repmat(ChordChangeMeter, 21-14+1, 1) == ChordChangeOnMetricalPattern, 2);  
%F(24:31) = 0;
%%}

% ------------------
% 22-43 Sucessions
% ------------------

semitoneDist = mod(abs(r1-r0),12);
chordDistComp = repmat([m0 a0 semitoneDist m1 a1], [43-22+1, 1]);
    
% m: M = 0, m = 1, d = 2, V = 3
% a: value = added note

ChordDistance = [0  0 5 0  0;    %M 5 M
                 0  0 5 1  0;    %M 5 m
                 3 10 5 1  0;    %V 5 m
                 3 10 5 0  0;    %V 5 M
                 1  0 5 0  0;    %m 5 M
                 1  0 5 3  10;    %m 5 V
                 1 10 5 0  0;    %m7 5 M
                 1 10 5 3  10;    %m7 5 V
                 0  0 7 0  0;    %M 7 M
                 0  0 7 3  10;    %M 7 V
                 0  0 2 0  0;    %M 2 M
                 0  0 2 1  0;    %M 2 m
                 0  0 2 3  10;    %M 2 V
                 1  9 2 0  0;    %m6 2 M
                 1  9 2 3  10;    %m6 2 V
                 2  0 1 0  0;    %d 1 M
                 2  0 1 1  0;    %d 1 m
                 1  0 3 0  0;    %m 3 M
                 1  0 8 0  0;    %m 8 M
                 0  0 9 1  0;    %M 9 m
                 0  0 9 1 10;    %M 9 m7
                 0  5 0 3 10];   %M4 0 V
             
F(VERT+9:VERT+30) = all(ChordDistance == chordDistComp, 2);

% ---------------------------------
% SAME LABEL GIVEN METER PREFERENCE
% ---------------------------------

if (t > 1 && t <= X.numEvents)
    if (X.meter(t) < X.meter(t-1) && yt == ytm)
        %F(VERT + 31) = 1;
    end
end

% ---------------------------------
% SAME LABEL GIVEN SIMILARITY
% ---------------------------------

if (t > 1)
    if (m_sim(X.pitch(t-1,:),X.pitch(t,:)) == 1 && yt == ytm)
        %F(VERT + 32) = 1;
    end
end

if (t > 1)
    if (m_sim(X.pitch(t-1,:),X.pitch(t,:)) == 1 && X.meter(t) < X.meter(t-1) && yt == ytm)
        F(VERT + 33) = 1;
    end
end


switch S
    case 0
        F = F(1:VERT);
    case 1
        F = F(VERT+1:VERT+HORZ);
end
    
end

