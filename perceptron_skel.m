% HMM PERCEPTRON

MAX_EPOCH = 100;
ETA = 1;
[X,T] = parseDataset('jsbach_chorals_harmony.data');

% initialize weights to zero
% weights used at every vertical evalu'ation and horizontal evaluation
W = zeros(43,1); % 43 basis functions used in paper
K = 144; % number of labels
N = 1;%size(X,2); % number of training examples
    
for epoch=1:MAX_EPOCH
    fprintf('EPOCH %d\n',epoch);
    %rp = randperm(size(Xt, 1));
    for n_i=1:N % for each training example
        TE = X(n_i).numEvents; % number of events in n_ith training example (will vary)
        Hx = zeros(TE,1); % estimated labels
        F = zeros(43,TE,K);
        
        for t=1:TE % for each event
            RES = zeros(K,1); % results of basis functions
            for k=0:K-1 % for each label
                if (t > 1)
                    F(:,t,k+1) = basis(X(n_i),k,Hx(t-1),t);
                else
                    F(:,t,k+1) = basis(X(n_i),k,0,t);
                end
                RES(k+1) = sum(W' * F(:,t,k+1));
            end
            % testing stuff for me
            [no, IN] = min(RES);
            [no, ON] = max(RES);
            if (IN > 1)
                CBOTH = [IN,T(n_i).chord(t), RES(IN), RES(IN-1)];
            end
            % testing stuff for me
            Hx(t) = IN;
        end
        
        % testing stuff for me
        CORRECT = sum(Hx - T(n_i).chord==0);
        COMP = [mod(Hx,12),mod(T(n_i).chord,12), Hx, T(n_i).chord];
        % testing stuff for me
        
        if (isequal(Hx,T(n_i).chord) == 0) % compare estimate (Hx) with target values
            for s=1:43
                for t=1:TE
                    if (Hx(t) == T(n_i).chord(t))
                        W(s) = W(s) + ETA * F(s,t,Hx(t));
                    else
                        W(s) = W(s) - ETA * F(s,t,Hx(t));
                    end
                end
            end
        end
    end
end
