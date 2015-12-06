function Res = validate(X,W,K,type,BO, I,T)
%---For Carpe Diem Alg
%X - Data
%W - Weights (70 + 33)
%K - Number of Labels (8 * 12)
%type - vector of labels used (size 8)
%BO - Size of Vert/Horiz basis vectors
%---For Validation
%I - Indicies of data X to validate
%T - Test labels of X

TET = 0;
CORRECT = 0;
N = length(I);
Res = struct('sid', '', 'numEvents', 0, 'oChords', [], 'nChords', [], 'numCorrect', 0, 'ratioCorrect', 0);
for i = 1:N
    ii = I(i);
    Res(i).sid = T(ii).sid;
    Res(i).numEvents = T(ii).numEvents;
    Res(i).oChords = T(ii).chord;
    
    Hx = carpe_diem_alg(X(ii),W,K,X(ii).numEvents,type,BO);
    Hx = Hx - 1;    
    
    Res(i).nChords = Hx;
    Res(i).numCorrect = sum((Hx - T(ii).chord) == 0);
    Res(i).ratioCorrect = Res(i).numCorrect / Res(i).numEvents;
    
    TET = TET + Res(i).numEvents;
    CORRECT = CORRECT + Res(i).numCorrect;
    fprintf('validate %d : %d\n', ii, CORRECT./TET);
end

fprintf('accuracy: %d\n', (sum([Res.numCorrect])/sum([Res.numEvents])));

end