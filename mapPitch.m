function eqList = mapPitch(list)

original = {'C' 'B#' 'C#' 'Db' 'D' 'D#' 'Eb' 'E' 'Fb' 'F' 'E#' 'F#' 'Gb' 'G' 'G#' 'Ab' 'A' 'A#' 'Bb' 'B' 'Cb'};
new      = [ 1   1    2    2    3   4    4    5   5    6   6    7    7    8   9    9    10  11   11   12  12];

%map each element of cell list to corresponding numerical representation
eqList = arrayfun(@(x) new(strcmp(original,x)),list);

end