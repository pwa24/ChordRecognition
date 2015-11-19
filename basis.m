function F = basis(X,yt,ytm,t)

% X(i) = the training data (X from parseDataset())
% yt = the current label
% yt-1 = the previous label
% t = event number

F = zeros(43,1);
nt = 10; % number of chord types (i.e maj min)

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
% 10. c-d7
% nt + 1. c#M etc

% according to the paper  Additionally, we individuate the added notes that possibly enrich the
% basic harmony: we handle the cases of seventh, sixth and fourth. By considering 12
% root notes × 3 possible modes (see below) × 3 possible added notes, we obtain 108
% possible labels. Does this mean they do not count the generic M, m, dim
% cases? That seems to suggest (M4, M6, M7, m4, m6, m7, d4, d6, d7)

% i % nt gives chord type (i.e. maj)
% i / nt gives gives chord root (0-11) with C == 0

% ------------------
% 1. Asserted Root Note
% ------------------

if (X.pitch(t, round(yt./nt) + 1) == 1)
    F(1) = 1;
end

% ------------------
% 2. Asserted Root in Next Event
% ------------------

if (t+1 <= X.numEvents && X.pitch(t+1, round(yt./nt) + 1) == 1)
    F(2) = 1;
end

% ------------------
% 3. Asserted Added Note
% ------------------



% ------------------
% 22-43 Sucessions
% ------------------

semitoneDist = mod(yt(1)-ytm(1),12);
chordDistComp = repmat([ytm(2) ytm(3) semitoneDist yt(2) yt(3)], [43-22+1, 1]);
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
F(22:43) = all(ChordDistance == chordDistComp, 2);
end

