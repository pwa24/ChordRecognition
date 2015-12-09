function [X,T] = parseDataset(filename)
%Converts .f1 dataset file into training data X and labels T
%
%<sid, event#, C, C#, D, D#, E, F, F#, G, G#, A, A#, B, bass, metric, chord>

fileID = fopen(filename,'r');
F = textscan(fileID, '%s %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %s', 'Delimiter', ',');
F_chord = cell2mat(cellfun(@(x) parseChord(x),F{17}, 'UniformOutput', 0));
F_label = arrayfun(@(x) m_label(x), F_chord, 'UniformOutput', 0);
fclose(fileID);

F_pitch = [F{3:14}];
F_bass = F{15};
F_meter = F{16};

%Divide the songs
sidList = {};
ct = 1;
prevSid = '';
for i = 1:size(F{1},1)
    sid = F{1}{i};
    
    if (strcmp(sid, prevSid))
        ct = ct + 1;
        sidList{end} = {prevSid, ct};
    else
        prevSid = sid;
        sidList{end+1} = {prevSid, ct};
        ct = 1;
    end
end
clear sid;

X = struct('sid', '', 'numEvents', 0, 'pitch', [], 'bass', [], 'meter', []);
T = struct('sid', '', 'numEvents', 0, 'chord', {}, 'label', {});
eStart = 1;
for i = 1:size(sidList,2)
    sid = sidList{i}{1};
    songLength = sidList{i}{2};    
    
    eEnd = eStart + songLength - 1;
    
    X(i).sid = sid;
    X(i).numEvents = songLength;
    X(i).pitch = F_pitch(eStart:eEnd,:);
    X(i).bass = F_bass(eStart:eEnd);
    X(i).meter = F_meter(eStart:eEnd);
    
    T(i).sid = sid;
    T(i).numEvents = songLength;
    T(i).chord = F_chord(eStart:eEnd,:);
    T(i).label = F_label(eStart:eEnd,:);
    
    eStart = eEnd + 1;
end

end
