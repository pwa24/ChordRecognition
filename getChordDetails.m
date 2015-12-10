function [r, m, a] = getChordDetails(chordID)
%Gets the root, mode, and added note of chordID
%r,m ZERO INDEXED
%a is the added note in semitones from root
global CHORD_L CHORD_M CHORD_A;
if (chordID < 0)
    fprintf('Error: invalid chordID - %n\n', chordID);
    r = -1; m = -1; a = -1;
    return;
end

nt = size(CHORD_L,2);
t = mod(chordID,nt);

r = fix(chordID/nt);
m = CHORD_M(t+1);
a = CHORD_A(t+1);

end