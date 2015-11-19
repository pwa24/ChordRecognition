function chordID = parseChord(chordLabel)
%Parses chord string label '<Root>_<Mode><AddedNote>' to its corresponding ID

chordID = 0;
rootLetter  = {'C' 'B#' 'C#' 'Db' 'D' 'D#' 'Eb' 'E' 'Fb' 'F' 'E#' 'F#' 'Gb' 'G' 'G#' 'Ab' 'A' 'A#' 'Bb' 'B' 'Cb'};
rootNum     = [ 1   1    2    2    3   4    4    5   5    6   6    7    7    8   9    9    10  11   11   12  12];
modeLetter  = {'M' 'm' 'd'};
modeNum     = [ 1   2   3];
%output for addedNote is equivalent to input (if no added notes, default is 0

rL = regexp(chordLabel, '[ABCDEFG#b]*', 'match');
mL = regexp(chordLabel, '[Mmd]', 'match');
a = regexp(chordLabel, '[467]', 'match');

if (isempty(rL) || isempty(mL))
    fprintf('Error: invalid chord label - %s \n', chordLabel);
    return;
end

r = rootNum(strcmp(rootLetter,rL{1}));
m = modeNum(strcmp(modeLetter,mL{1}));
if (isempty(a))
    a = 0;
else
    a = str2double(a{1});
    switch a
        case 4
            a = 1;
        case 6
            a = 2;
        case 7
            a = 3;
    end
end

chordID = 12*(r-1) + 4*(m-1) + a;
end