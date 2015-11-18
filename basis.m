function F = basis(X,yt,ytm,t)

% X = the training data (X from parseDataset())
% yt = the current label
% yt-1 = the previous label
% t = event number

F = zeros(43,1);

% input label
% 1. c-maj
% 2. c-min
% ...
% 10. c#-maj etc

% i % 9 gives chord type (i.e. maj)
% i / 9 gives gives chord root (0-11) with C == 0

% ------------------
% 1. Asserted Root Note
% ------------------

if (X(t).pitch(t, round(yt ./ 9) + 1) == 1)
    F(1) = 1;
end


end
