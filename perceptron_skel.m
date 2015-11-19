% HMM PERCEPTRON

MAX_EPOCH = 100;
[X,T] = parseDataset('jsbach_chorals_harmony.data');

% initialize weights to zero
% weights used at every vertical evalu'ation and horizontal evaluation
W = zeros(43,1); % 43 basis functions used in paper
K = 144; % number of labels
N = size(X,2); % number of training examples
    
for epoch=1:MAX_EPOCH
    fprintf('EPOCH %d\n',epoch);
    %rp = randperm(size(Xt, 1));
    for n_i=1:N % for each training example
        TE = X(n_i).numEvents; % number of events in n_ith training example (will vary)
        Hx = zeros(TE,1); % estimated labels
        F = zeros(43,TE);
        
        for t=1:TE % for each event
            r = zeros(K,1); % results of basis functions
            for k=1:K % for each label
                if (t > 1)
                    F(:,t) = basis(X(n_i),k,Hx(t-1),t);
                else
                    F(:,t) = basis(X(n_i),k,0,t);
                end
                r(k) = sum(W' * F(:,t));
            end
            [no, IN] = max(r);
            Hx(t) = IN;
        end
        
        if (isequal(Hx,T(n_i).chord(:,4)) == 0) % compare estimate (Hx) with target values
            for s=1:43
                for t=1:TE
                    if (Hx(t) == T(n_i).chord(t,4))
                        W(s) = W(s) + F(s,t);
                    else
                        W(s) = W(s) - F(s,t);
                    end
                end
            end
        end
    end
end
