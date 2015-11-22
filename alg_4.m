function [G,yh] = alg_4(t, yt, B, Order, S0, S1, G, yh, yp, K, X, W, S1h)

%fprintf('AT: %d\n',t);

yh(t-1) = Order(1,t-1);
yp(t-1) = Order(2,t-1);
in = 3; % index for algorithm 4;

% vertex is open if the reward of its best incoming path has been computed
% i.e. G is not -1

while( G(yp(t-1),t-1) >= 0 )
    
    S1(yh(t-1),yt,t-1) = W(14:43)' * basis(X,yt-1,yh(t-1)-1,t-1,1);
    S1(yp(t-1),yt,t-1) = W(14:43)' * basis(X,yt-1,yp(t-1)-1,t-1,1);
    
    if ( G(yh(t-1),t-1) + S1(yh(t-1),yt,t-1) < G(yp(t-1),t-1) + S1(yp(t-1),yt,t-1) )
        yh(t-1) = yp(t-1); 
    end
    
    if (in > K)
        break;
    end
    
    yp(t-1) = Order(in,t-1);
    in = in + 1;
    
end
%B(t-1)
while ( G(yh(t-1),t-1) + S1(yh(t-1),yt,t-1) < B(t-1) + S0(yp(t-1),t-1) + S1h )
    
    S1(yh(t-1),yt,t-1) = W(14:43)' * basis(X,yt-1,yh(t-1)-1,t-1,1);
    S1(yp(t-1),yt,t-1) = W(14:43)' * basis(X,yt-1,yp(t-1)-1,t-1,1);
    
    % call algorithm 4 on yp(t-1)
    if (t-1 > 1)
        [G,yh] = alg_4(t-1,yp(t-1),B,Order,S0,S1,G,yh,yp,K,X,W,S1h);
    end
    
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

end

