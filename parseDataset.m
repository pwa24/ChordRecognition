function [X,T] = parseDataset(filename,type,mode)
%Converts csv dataset file into training data X and labels T
%
%<sid, event#, C, C#, D, D#, E, F, F#, G, G#, A, A#, B, bass, metric, chord>
% mode == 1 : includes meter data
% mode == 0 : does not include meter data

fileID = fopen(filename,'r');
if (mode == 1)
    F = textscan(fileID, '%s %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %s', 'Delimiter', ',');
    F_chord = cell2mat(cellfun(@(x) parseChord(x,type),F{17}, 'UniformOutput', 0));
    F_label = F{17};
else
    F = textscan(fileID, '%s %f %f %f %f %f %f %f %f %f %f %f %f %f %f %s', 'Delimiter', ',');
    F_chord = cell2mat(cellfun(@(x) parseChord(x,type), F{16}, 'UniformOutput', 0));
    F_label = F{16};
end
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
    if (mode == 1)
        X(i).meter = F_meter(eStart:eEnd);
    end
    
    T(i).sid = sid;
    T(i).numEvents = songLength;
    T(i).chord = F_chord(eStart:eEnd,:);
    T(i).label = F_label(eStart:eEnd,:);
    
    eStart = eEnd + 1;
end

end
