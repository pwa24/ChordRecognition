function [r, m, a] = getChordDetails(chordID)
%Gets the root, mode, and added note of chordID in [0-143]
if (chordID < 0)
    fprintf('Error: invalid chordID - %n\n', chordID);
    r = -1; m = -1; a = -1;
    return;
end
r = fix(chordID/12);
rem = mod(chordID,12);
m = fix(rem/4);
a = mod(rem,4);
end