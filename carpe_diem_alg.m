% CARPE DIEM
function yh = carpe_diem_alg(X,W,K,T,nt,BO);

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
        S0(k+1,t) = W(1:BO(1)-1)' * basis(X,k,1,t,0,nt);
    end
end
% calculate first layer of transition weights
%for k1=0:K-1
%    for k2=0:K-1
%        S1(k1+1,k2+1,1) = W(22:43)'* basis(X,k1,k2,1,1);
%    end
%end

for y_i=1:K
    % initialize each y1 to vertical weight.
    % each vertex in layer is open
    G(y_i, 1) = S0(y_i,1); % vertical_feature_weight;
end

[no, yh(1)] = max(G(:,1)); % select index of max of first layer

%S1h can also be the sum of all positive horizontal weights
WH = W(BO(1):BO(2));
WH(WH<0)=0;
S1h = sum(WH) + 1;

B(2) = G(yh(1)) + S1h; % S1 is the maximal transitional weight

% get sorted order of all vertical weights.
[no, Order] = sort(S0,'descend');
%[no, Order] = sort(S0);

for t=2:T
    
    %if (mod(t,20) == 0)
    %fprintf('T: %d\n',t);
    %end
    
    % algorithm 3:
    
    yh(t) = Order(1,t); % most promising vertex according to vertical weight
    yp(t) = Order(2,t);% next most promising according to vertical weight
    o_pos = 3;
    
    % algorithm 4 with yh(t_i) = yt
    [G,yh] = alg_4(t,yh(t),B,Order,S0,S1,G,yh,yp,K,X,W,S1h,nt,BO);
    
    while( G(yh(t),t) < B(t) + S0(yp(t),t) )
        
        [G,yh] = alg_4(t,yp(t),B,Order,S0,S1,G,yh,yp,K,X,W,S1h,nt,BO);
        
        if ( G(yp(t),t) > G(yh(t),t) )
            yh(t) = yp(t); % the argmax of G(yh(t_i), t_i) and G(yp, t_i)
        end
        
        if (o_pos > K)
            break;
        end
        
        yp(t) = Order(o_pos,t);
        o_pos = o_pos + 1; %increment position in order
    end
    
    B(t + 1) = G(yh(t),t) + S1h; %transition value S1
    
end
