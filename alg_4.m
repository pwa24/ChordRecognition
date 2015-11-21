function alg_4(t, yt, B, Order, S0, S1, G, yh, yp, K, X, W)

yh(t-1) = Order(1,t-1);
yp(t-1) = Order(2,t-1);
in = 3; % index for algorithm 4;

% vertex is open if the reward of its best incoming path has been computed
% i.e. G is non-zero

%fprintf('%d %d\n', yp(t-1), t);

S1(yh(t-1),yt,t-1) = W(22:43)'* basis(X,yh(t-1),yt,t-1,1);
S1(yp(t-1),yt,t-1) = W(22:43)'* basis(X,yp(t-1),yt,t-1,1);

while( G(yp(t-1),t-1) > 0 )
    
    if ( G(yh(t-1),t-1) + S1(yh(t-1),yt,t-1) < G(yp(t-1),t-1) + S1(yp(t-1),yt,t-1) )
        yh(t-1) = yp(t-1); 
    end
    
    if (in > K)
        break;
    end
    yp(t-1) = Order(in,t-1);
    in = in + 1;
    
end

while ( G(yh(t-1),t-1) + S1(yh(t-1),yt,t-1) < B(t-1) + S0(yp(t-1),t-1) ) % + max(S1(yh(t)), S1(yh(t-1)))

    % call algorithm 4 on yp(t-1)
    alg_4(t-1,yp(t-1),B,Order,S0,S1,G,yh,yp,K,X,W);
    
    if (in > K)
        break;
    end
    if ( G(yh(t-1),t-1) + S1(yh(t-1),yt,t-1) < G(yp(t-1),t-1) + S1(yp(t-1),yt,t-1) )
        yh(t-1) = yp(t-1); 
    end
    yp(t-1) = Order(in,t-1);
    in = in + 1;
end

G(yt,t) = G(yh(t-1),t-1) + S1(yh(t-1),yt,t-1) + S0(yt,t);


