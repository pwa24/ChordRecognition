function chordID = parseChord(chordLabel)
%Parses chord string label '<Root>_<Type>' to its corresponding ID
global ALLCHORDS_L CHORD_MAP CHORD_L;

if (chordLabel == 'N')
    chordID = 0;
    return;
end

rootLetter  = {'C' 'B#' 'C#' 'Db' 'D' 'D#' 'Eb' 'E' 'Fb' 'F' 'E#' 'F#' 'Gb' 'G' 'G#' 'Ab' 'A' 'A#' 'Bb' 'B' 'Cb'};
rootNum     = [ 1   1    2    2    3   4    4    5   5    6   6    7    7    8   9    9    10  11   11   12  12];

typeNum = 1:size(CHORD_L,2);

chordPart = strsplit(chordLabel, '_');
rL = chordPart(1);
mL = chordPart(2);

%Map chord labels to current chord alphabet map
mL = CHORD_MAP{strcmp(ALLCHORDS_L, mL)};

r = rootNum(strcmp(rootLetter,rL));
m = typeNum(strcmp(CHORD_L,mL));

chordID = size(typeNum,2)*(r-1) + (m-1);

if (isempty(m) || isempty(r))
    fprintf('Error: chord does not belong in chord alphabet (type) - %s \n', chordLabel);
    chordID = 0;
end

end