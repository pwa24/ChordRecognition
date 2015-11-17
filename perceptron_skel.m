% HMM PERCEPTRON

MAX_EPOCH = 100;
[X,T] = parseDataset('jsbach_chorals_harmony.data');

% initialize weights to zero
% weights used at every vertical evalu'ation and horizontal evaluation
W = zeros(43,1); % 43 basis functions used in paper
S = 43; % number of basis functions
K = 24; % number of labels
N = size(X,2); % number of training examples

% mock random values
Yt = ones(20:1);
PHI = randn(S,K);
W = randn(S,1);
I = 2;
    
for epoch=1:MAX_EPOCH
    rp = randperm(size(Xt, 1));
    for n_i=1:N % for each training example
        % calculate H(X) for n_ith training example in Xt
        T = X(n_i).numEvents; % number of events in n_ith training example (will vary)
        r = zeros(T,K); % results of basis functions
        for t=1:T % for each event
            for k=1:K % for each label
                for s=1:S % for each basis function
                    r(t,k) = r(t,k) + W(s) * PHI(s,k);
                end
            end
        end
        [no,Hx] = max(r'); % get arg max for each event
        
        if (isequal(Hx,Yt) == 0) % compare estimate (Hx) with target values
            for s=1:S % for each basis function
                A = 0;
                for t=1:T % for each event
                    A = PHI(s,k) * I;
                end
                W(s) = W(s) + A;
            end
        end
    end
end
