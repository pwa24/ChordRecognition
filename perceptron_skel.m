% HMM PERCEPTRON

MAX_EPOCH = 100;
ETA = 1;
[X,T] = parseDataset('jsbach_chorals_harmony.data');

% initialize weights to zero
% weights used at every vertical evalu'ation and horizontal evaluation
W = randn(43,1); % 43 basis functions used in paper
K = 144; % number of labels
N = 6;%size(X,2); % number of training examples
    
for epoch=1:MAX_EPOCH
    fprintf('EPOCH %d CORRECT %d\n',epoch, CORRECT);
    %rp = randperm(size(Xt, 1));
    for n_i=1:N % for each training example
        TE = X(n_i).numEvents; % number of events in n_ith training example (will vary)
        Hx = zeros(TE,1); % estimated labels
        F = zeros(43,TE,K);
        
        Hx = carpe_diem_alg(X(n_i),W,K,TE);
        
        if (isequal(Hx,T(n_i).chord) == 0) % compare estimate (Hx) with target values
            for s=1:43
                for t=1:TE
                    if (Hx(t) == T(n_i).chord(t))
                        W(s) = W(s) + ETA * F(s,t,Hx(t)+1);
                    else
                        W(s) = W(s) - ETA * F(s,t,Hx(t)+1);
                    end
                end
            end
        end
    end
end
