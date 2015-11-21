% HMM PERCEPTRON

MAX_EPOCH = 100;
ETA = 1;
[X,T] = parseDataset('jsbach_chorals_harmony.data');

% initialize weights to zero
% weights used at every vertical evalu'ation and horizontal evaluation
W = zeros(43,1); % 43 basis functions used in paper
K = 144; % number of labels
N = 6;%size(X,2); % number of training examples
    
for epoch=1:MAX_EPOCH
    fprintf('EPOCH %d CORRECT %d\n',epoch, CORRECT);
    %rp = randperm(size(Xt, 1));
    for n_i=1:N % for each training example
        TE = X(n_i).numEvents; % number of events in n_ith training example (will vary)
        Hx = carpe_diem_alg(X(n_i),W,K,TE);
        Hx = Hx - 1;
        
        COMP = [Hx,T(n_i).chord];
        
        if (isequal(Hx,T(n_i).chord) == 0) % compare estimate (Hx) with target values
            for t=1:TE
                if (t > 1)
                    F = basis(X(n_i),Hx(t),Hx(t-1),t,2);
                else
                    F = basis(X(n_i),Hx(t),1,t,2);
                end
                for s=1:43
                    if (Hx(t) == T(n_i).chord(t))
                        W(s) = W(s) + ETA * F(s);
                    else
                        W(s) = W(s) - ETA * F(s);
                    end
                end
            end
        end
    end
end
