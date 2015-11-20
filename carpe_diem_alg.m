% CARPE DIEM
function yh = carpe_diem_alg(X,W,K,T);

% takes any input of events and labels them using the weights learnt above
% these two algorithms should be separated

G = zeros(K, T);
B = zeros(T, 1); % contains the values Bt
yh = zeros(T, 1);
yp = zeros(T, 1);
S0 = zeros(K,T);
S1 = zeros(K,K,T);

for k=0:K-1
    for t=1:T
        F = basis(X,k,1,t);
        S0(k+1,t) = W(1:21)' * F(1:21);
    end
end
for k1=0:K-1
    for k2=0:K-1
        for t=1:T-1
            F = basis(X,k1,k2,t)
            S1(k1+1,k2+1,t) = W(22:43)' * F(22:43);
        end
    end
end

%S0 = rand(K, T); % mock vertical values
%S1 = rand(K, K, T-1); % mock horizontal values

for y_i=1:K
    % initialize each y1 to vertical weight.
    % each vertex in layer is open
    G(y_i, 1) = S0(y_i,1); % vertical_feature_weight;
end

[no, yh(1)] = max(G(:,1)); % select index of max of first layer

[no, xt] = max(S1(:,:,1));
[no, yt] = max(max(S1(:,:,1))); %first number row second column

B(2) = G(yh(1)) + S1(xt(yt),yt,1); % S1 is the maximal transitional weight

% get sorted order of all vertical weights.
[no, Order] = sort(S0);

for t_i=2:T
    
    % algorithm 3:
    
    yh(t_i) = Order(1,t_i); % most promising vertex according to vertical weight
    yp(t_i) = Order(2,t_i);% next most promising according to vertical weight
    o_pos = 3;
    
    % algorithm 4 with yh(t_i) = yt
    alg_4(t_i, yh(t_i), B, Order, S0, S1, G, yh, yp, K);
    
    while( G(yh(t_i),t_i) < B(t_i) + S0(yp(t_i),t_i) )
        
        alg_4(t_i, yp(t_i), B, Order, S0, S1, G, yh, yp, K);
        
        if ( G(yp(t_i),t_i) > G(yh(t_i),t_i) )
            yh(t_i) = yp(t_i); % the argmax of G(yh(t_i), t_i) and G(yp, t_i)
        end
        
        if (o_pos > K)
            break;
        end
        yp(t_i) = Order(o_pos,t_i);
        o_pos = o_pos + 1; %increment position in order
    end
    
    [no, xt] = max(S1(:,:,t_i-1));
    [no, yt] = max(max(S1(:,:,t_i-1))); %first number row second column
    
    B(t_i + 1) = G(yh(t_i),t_i) + S1(xt(yt),yt,t_i-1); %transition value S1
    
end

%LEARNED_PATH = yh; % the learnt path on input
% done !!
