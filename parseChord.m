function chordID = parseChord(chordLabel,typeLetter)
%Parses chord string label '<Root>_<Mode><AddedNote>' to its corresponding ID

if (chordLabel == 'N')
    chordID = 0;
    return;
end

rootLetter  = {'C' 'B#' 'C#' 'Db' 'D' 'D#' 'Eb' 'E' 'Fb' 'F' 'E#' 'F#' 'Gb' 'G' 'G#' 'Ab' 'A' 'A#' 'Bb' 'B' 'Cb'};
rootNum     = [ 1   1    2    2    3   4    4    5   5    6   6    7    7    8   9    9    10  11   11   12  12];

%typeLetter  = {'M' 'M4' 'M6' 'M7' 'm' 'm4' 'm6' 'm7' 'd' 'd4' 'd6' 'd7' '7'}; % add aug etc d7b9, hd
typeNum     = (1:size(typeLetter,2));

rL = regexp(chordLabel, '[ABCDEFG#b]*', 'match');
mL = regexp(chordLabel, '[MmdV467]*', 'match');

if (isempty(rL) || isempty(mL))
    fprintf('Error: invalid chord label - %s \n', chordLabel);
    chordID = 0;
    return;
end

r = rootNum(strcmp(rootLetter,rL{1}));
m = typeNum(strcmp(typeLetter,mL{1}));

chordID = size(typeNum,2)*(r-1) + (m-1);

if (isempty(m) || isempty(r))
    chordID = 0;
end

end