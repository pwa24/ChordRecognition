function L = m_label(ID)
global CHORD_L;

nt = size(CHORD_L,2);

r = fix(ID/nt);
m = mod(ID,nt);

rootLetter  = {'C' 'Db' 'D' 'Eb' 'E' 'F' 'Gb' 'G' 'Ab' 'A' 'Bb' 'B'};

L = sprintf('%s_%s',rootLetter{r+1}, CHORD_L{m+1});