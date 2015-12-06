function F = basis(X,yt,ytm,t,S,type)

%F = m_basis(X,yt,ytm,t,S,nt);

%%{
VERT = 70;
HORZ = 33;
F = zeros(VERT+HORZ,1);

% X(i) = the training data (X from parseDataset())
% yt = the current label
% yt-1 = the previous label
% t = event number

%%%INTEGRATE THIS?%
[r1,m1,a1] = getChordDetails(yt,type);
[r0,m0,a0] = getChordDetails(ytm,type);
%%%
%F = zeros(43,1);
nt = size(type,2); % number of chord types (i.e maj min)
C = mod(yt,nt) + 1;

% input label
% 1. c-M
% 2. c-M4
% 3. c-M6
% 4. c-M7
% 5. c-m
% 6. c-m4
% 7. c-m6
% 8. c-m7
% 9. c-d
% 10. c-d4
% 11. c-d6
% 12. c-d7
% nt + 1. c#-maj etc

% according to the paper  Additionally, we individuate the added notes that possibly enrich the
% basic harmony: we handle the cases of seventh, sixth and fourth. By considering 12
% root notes Ã 3 possible modes (see below) Ã 3 possible added notes, we obtain 108
% possible labels. Does this mean they do not count the generic M, m, dim
% cases?

% i % nt gives chord type (i.e. maj)
% i / nt gives gives chord root (0-11) with C == 0

% ------------------
% 1. Asserted Root Note
% ------------------

if (X.pitch(t, r1+1) == 1)
    F(1) = 1;
end

% ------------------
% 2. Asserted Root in Next Event
% ------------------

if (t+1 <= X.numEvents && X.pitch(t+1, r1+1) == 1)
    F(2) = 1;
end

% ------------------
% 3. Asserted Added Note
% ------------------

PP =[0,5,9,10,0,5,9,10,0,5,9,9;
     0,5,9,11,0,5,9,10,0,5,9,10];

for i=1:2
    if (X.pitch(t,mod(mod(r1+1+PP(i,C),12)+11,12)+1) == 1)
        F(3) = 1;
        if (mod(C,4) == 0) % marginally improves accuracy
            F(3) = 0;
        end
    end
end

% ------------------
% 5-9. Asserted Notes of Chord
% ------------------

%%{

CT = struct('sh',[]);
CT(1).sh = [0,4,7];
CT(2).sh = [0,5,7];
CT(3).sh = [0,4,7,9];
CT(4).sh = [0,4,7,10,11]; %for some stupid reason CM7 and CDOM7 get same label
CT(5).sh = [0,3,7];
CT(6).sh = []; %[0,3,5,7];
CT(7).sh = [0,3,9]; % [0,3,7,9]
CT(8).sh = [0,3,10];
CT(9).sh = [0,3,6];
CT(10).sh = []; %[0,3,5,6]
CT(11).sh = []; %[0,3,6,9]
CT(12).sh = [0,3,6,9,10]; % for half diminished chord


n_count = 0;
for i=1:size(CT(C).sh,2)
   if( X.pitch(t,mod(mod(CT(C).sh(i)+r1+1,12)+11,12)+1) == 1)
       n_count = n_count + 1;
   end
end

if (C == 2 && X.pitch(t,j_mod(r1+6,12)) == 0)
    F(5) = 1;
else
    F(5 + n_count) = 1;
end

%%}

% ------------------
% 4. Fully statesd
% ------------------
    
if (n_count ~= 0 && n_count == size(CT(C).sh,2))
    F(4) = 1;
end
if (C == 4 && n_count == 4)
    F(4) = 1;
end

% ------------------
% 10. Bass is Root Note
% ------------------

if (X.bass(t) == r1+1)
    F(10) = 1;
end

% ------------------
% 11. Bass is Third
% ------------------

if (C <= 4) % it's a major third
    if (X.bass(t) == mod(mod(r1+5,12)+11,12)+1);
        F(11) = 1;
    end
else
    if (X.bass(t) == mod(mod(r1+4,12)+11,12)+1);
        F(11) = 1;
    end
end  

% ------------------
% 12. Bass is Fifth
% ------------------

if (X.bass(t) == mod(mod(r1+7,12)+11,12)+1);
   F(12) = 1; 
end

% ------------------
% 13. Bass is Added Note
% ------------------

if (X.bass(t) == mod(mod(r1+1+PP(C),12)+11,12)+1)
    F(13) = 1;
    if (mod(C,4) == 0)
        F(13) = 0;
    end
end

% ------------------
% 14-21 ChordChangeOnMetricalPattern
% ------------------
chordchange=(yt~=ytm);
meterbnd=3; %consider meter>3 as accented

if (t>1 && t<X.numEvents)
    ChordChangeMeter = [chordchange X.meter(t-1)>meterbnd X.meter(t)>meterbnd X.meter(t+1)>meterbnd];    
elseif t==1
    ChordChangeMeter = [chordchange 0 X.meter(t)>meterbnd X.meter(t+1)>meterbnd];
elseif t==X.numEvents
    ChordChangeMeter = [chordchange X.meter(t-1)>meterbnd X.meter(t)>meterbnd 0];
end;
    
ChordChangeOnMetricalPattern = [1 0 0 0;
                                1 0 0 1;
                                1 0 1 0;
                                1 0 1 1;
                                1 1 0 0;
                                1 1 0 1;
                                1 1 1 0;
                                1 1 1 1];

F(14:21) = all(repmat(ChordChangeMeter, 21-14+1, 1) == ChordChangeOnMetricalPattern, 2);  
%F(14:21) = 0;

% ------------------
% 22-43 Sucessions
% ------------------

semitoneDist = mod(abs(r1-r0),12);
chordDistComp = repmat([m0 a0 semitoneDist m1 a1], [43-22+1, 1]);

%{
ChordDistance = [1 0 5 1 0;    %M 5 M
                 1 0 5 2 0;    %M 5 m
                 1 7 5 2 0;    %M7 5 m
                 1 7 5 1 0;    %M7 5 M
                 2 0 5 1 0;    %m 5 M
                 2 0 5 1 7;    %m 5 M7
                 2 7 5 1 0;    %m7 5 M
                 2 7 5 1 7;    %m7 5 M7
                 1 0 7 1 0;    %M 7 M
                 1 0 7 1 7;    %M 7 M7
                 1 0 2 1 0;    %M 2 M
                 1 0 2 2 0;    %M 2 m
                 1 0 2 1 7;    %M 2 M7
                 2 6 2 1 0;    %m6 2 M
                 2 6 2 1 7;    %m6 2 M7
                 3 0 1 1 0;    %d 1 M
                 3 0 1 2 0;    %d 1 m
                 2 0 3 1 0;    %m 3 M
                 2 0 8 1 0;    %m 8 M
                 1 0 9 2 0;    %M 9 m
                 1 0 9 2 7;    %M 9 m7
                 1 4 0 1 7];   %M4 0 M7
%}        
ChordDistance = [0 0 5 0 0;    %M 5 M
                 0 0 5 1 0;    %M 5 m
                 0 3 5 1 0;    %M7 5 m
                 0 3 5 0 0;    %M7 5 M
                 1 0 5 0 0;    %m 5 M
                 1 0 5 0 3;    %m 5 M7
                 1 3 5 0 0;    %m7 5 M
                 1 3 5 0 3;    %m7 5 M7
                 0 0 7 0 0;    %M 7 M
                 0 0 7 0 3;    %M 7 M7
                 0 0 2 0 0;    %M 2 M
                 0 0 2 1 0;    %M 2 m
                 0 0 2 0 3;    %M 2 M7
                 1 2 2 0 0;    %m6 2 M
                 1 2 2 0 3;    %m6 2 M7
                 2 0 1 0 0;    %d 1 M
                 2 0 1 1 0;    %d 1 m
                 1 0 3 0 0;    %m 3 M
                 1 0 8 0 0;    %m 8 M
                 0 0 9 1 0;    %M 9 m
                 0 0 9 1 3;    %M 9 m7
                 0 1 0 0 3];   %M4 0 M7
             
F(22:43) = all(ChordDistance == chordDistComp, 2);

switch S
    case 0
        F = F(1:VERT);
    case 1
        F = F(VERT+1:VERT+HORZ);
end

%%}
    
end

