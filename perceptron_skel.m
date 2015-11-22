% HMM PERCEPTRON

MAX_EPOCH = 50;
ETA = 0.001;
[X,T] = parseDataset('jsbach_chorals_harmony.data');

% initialize weights to zero
% weights used at every vertical evalu'ation and horizontal evaluation
K = 144; % number of labels
W = zeros(43,1); % 43 basis functions used in paper
N = 43;%size(X,2); % number of training examples

FLAG = 0;
    
for epoch=1:MAX_EPOCH
    %rp = randperm(size(Xt, 1));
    for n_i=N:N % for each training example
        TE = X(n_i).numEvents; % number of events in n_ith training example (will vary)
        if (FLAG == 0)
            Hx = zeros(TE,1);
            FLAG = 1;
        else
            Hx = carpe_diem_alg(X(n_i),W,K,TE);
            Hx = Hx - 1;
        end
        %Hx = viterbi(X(n_i),W,K,TE);
        
        CORRECT = sum((Hx - T(n_i).chord(1:TE))==0);
        fprintf('EPOCH %d CORRECT %d\n',epoch, floor(CORRECT./TE * 100));
        
        if (isequal(Hx,T(n_i).chord(1:TE)) == 0) % compare estimate (Hx) with target values
            for t=1:TE
                if (t > 1)
                    F = basis(X(n_i),Hx(t),Hx(t-1),t,2);
                    %FT = basis(X(n_i),T(n_i).chord(t),T(n_i).chord(t-1),t,2);
                    FT = basis(X(n_i),T(n_i).chord(t),Hx(t-1),t,2);
                else
                    F = basis(X(n_i),Hx(t),1,t,2);
                    F(14:43) = 0;
                    FT = basis(X(n_i),T(n_i).chord(t),1,t,2);
                    FT(14:43) = 0;
                end
                
                if (Hx(t) == T(n_i).chord(t))
                    W = W + F;
                else
                    W = W - F;
                    W = W + FT;
                end
            end
        end
    end
end
