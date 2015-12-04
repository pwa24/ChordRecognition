function L = m_label(ID,type)

nt = size(type,2);

r = fix(ID/nt);
m = mod(ID,nt);

rootLetter  = {'C' 'Db' 'D' 'Eb' 'E' 'F' 'Gb' 'G' 'Ab' 'A' 'Bb' 'B'};

L = sprintf('%s_%s',rootLetter{r+1}, type{m+1});