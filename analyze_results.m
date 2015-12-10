%Make sure setup has been run with correct global parameters!
fprintf('Total # of misclassifications: %d\n', sum([Res.numEvents] - [Res.numCorrect]));
diffL = [];
for i = 1:size(Res,2)
    index = not(cellfun(@(x,y) strcmp(x,y), Res(i).oChords, Res(i).nChords));
    n = [Res(i).oChords(index), Res(i).nChords(index)];
    diffL = [diffL ; n];
end

diffID = cell2mat(cellfun(@parseChord, diffL, 'UniformOutput', 0));
[diffR, diffM, diffA] = arrayfun(@getChordDetails, diffID);
diff = [diffR(:,1), diffM(:,1), diffA(:,1), diffR(:,2), diffM(:,2), diffA(:,2)];

%Error 1: X_V classified as X_M
err1 = arrayfun(@(r1,m1,r2,m2) (r1 == r2) && (m1 == 3) && (m2 == 0), ...
                diff(:,1), diff(:,2), diff(:,4), diff(:,5));
fprintf('V classified as M: %d\n', sum(err1));

diffL(err1,:) = [];
diff(err1,:) = [];
%Error 2: X_V classified as (X+4)_d
err2 = arrayfun(@(r1,m1,r2,m2) (m1 == 3) && (m2 == 2) && (mod(r2-r1,12) == 4), ...
                diff(:,1), diff(:,2), diff(:,4), diff(:,5));
fprintf('X_V classified as (X+4)_d: %d\n', sum(err2));

diffL(err2,:) = [];
diff(err2,:) = [];
%Error 3: Root/Mode okay, added note misclassified
err3 = arrayfun(@(r1,m1,a1,r2,m2,a2) (r1 == r2) && (m1 == m2) && (a1 ~= a2), ...
                diff(:,1), diff(:,2), diff(:,3), diff(:,4), diff(:,5), diff(:,6));
fprintf('Added note misclassified: %d\n', sum(err3));

diffL(err3,:) = [];
diff(err3,:) = [];
%Error 4: Relative minor error (C_M -> A_m)
err4 = arrayfun(@(r1,m1,r2,m2) ...
                ((m1 == 0) && (m2 == 1) && (mod(r1-r2,12) == 3)) || ...
                ((m1 == 1) && (m2 == 0) && (mod(r2-r1,12) == 3)), ...
                diff(:,1), diff(:,2), diff(:,4), diff(:,5));
fprintf('Relative minor mixup: %d\n', sum(err4));

diffL(err4,:) = [];
diff(err4,:) = [];

%Error 4: Relative major 3rd modes (no added notes) (C_M -> E_m)
err5 = arrayfun(@(r1,m1,a1,r2,m2,a2) ...
                ((m1 == 0) && (m2 == 1) && (mod(r2-r1,12) == 4) && (a1+a2 == 0)) || ...
                ((m1 == 1) && (m2 == 0) && (mod(r1-r2,12) == 4) && (a1+a2 == 0)), ...
                diff(:,1), diff(:,2), diff(:,3), diff(:,4), diff(:,5), diff(:,6));
fprintf('Relative major 3rd modes (no added notes): %d\n', sum(err5));

diffL(err5,:) = [];
diff(err5,:) = [];