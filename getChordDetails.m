function [r, m, a] = getChordDetails(chordID,type)
%Gets the root, mode, and added note of chordID in [0-143]
if (chordID < 0)
    fprintf('Error: invalid chordID - %n\n', chordID);
    r = -1; m = -1; a = -1;
    return;
end

modeLetter = {'M' 'm' 'd' 'V'};
modeNum = [0,1,2,3];
addLetter = {'4' '6' '7'};
addNum = [1,2,3];

nt = size(type,2);
r = fix(chordID/nt);

L = type{mod(chordID,nt) + 1};

m = modeNum(strcmp(modeLetter,L));
a = addNum(strcmp(addLetter,L));
if (isempty(a))
    a = 0;
end
if (isempty(m))
    m = 0;
end

end