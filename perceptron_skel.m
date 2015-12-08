% HMM PERCEPTRON


% partition the input by metric features and only assign added notes as
% part of the label in cases where the added note is on the relatively
% dominant beat. To determine m4 for instance check the proceding input.
% M4 on the dominant --> give M label to the rest
% M on dominant beat --> give M label to the rest ignore added notes.
%

setup

%Indicies of X to train
I = [1:N];

% initialize weights to zero
% weights used at every vertical evalu'ation and horizontal evaluation
W = zeros(VERT+HORZ,1);

MAX_EPOCH = 4;
ETA = 0.1;
FLAG = 0;
for epoch=1:MAX_EPOCH
    CORRECT = 0;
    RELATIVE = 0;
    TET = 0;
    for n_i=1:N % for each training example
        ii = I(n_i);
        TE = floor(min(1000,X(ii).numEvents)); % number of events in n_ith training example (will vary)
        %%if (TE > 80)
        %    TE = 80;
        %end
        TET = TET + TE;
        
        %if (epoch == 2)
         %   W(VERT+1:VERT+8) = [-9.6,-92.5,-23,-1.8,-84,-552,-10,-82];
        %end
        
        if (FLAG == 0)
            Hx = zeros(TE,1);
            FLAG = 1;
        else
            Hx = carpe_diem_alg(X(ii),W,K,TE,type,BO,BASISTYPE);
            %Hx = viterbi(X(n_i),W,K,TE);
            Hx = Hx - 1;
        end
        
        CORRECT = CORRECT + sum((Hx - T(ii).chord(1:TE))==0);
        fprintf('EPOCH %d:%d CORRECT %d\n',epoch,n_i,floor(CORRECT./TET * 100));
        
        % take a look at mis-labels
        % count relative minor errors
        %{
        if (epoch == 2)
            for e=2:TE-1
                if (Hx(e) ~= T(n_i).chord(e))
                    %fprintf('ERROR %d %d: %s %s DATA : %s : %s : %s\n',n_i,e,m_label(Hx(e),type),T(n_i).label{e},m_getnotes(X(n_i).pitch(e-1,:)),m_getnotes(X(n_i).pitch(e,:)),m_getnotes(X(n_i).pitch(e+1,:)));
                    if (floor(Hx(e)./nt) - floor(T(n_i).chord(e)./nt) == 3)
                        RELATIVE = RELATIVE + 1;
                        %fprintf('ERROR (REL : %d) %d %d: %s %s DATA : %s : %s : %s\n', RELATIVE,n_i,e,m_label(Hx(e),type),T(n_i).label{e},m_getnotes(X(n_i).pitch(e-1,:)),m_getnotes(X(n_i).pitch(e,:)),m_getnotes(X(n_i).pitch(e+1,:)));
                    end
                end
            end
        end
        %}
        
        if (isequal(Hx,T(ii).chord(1:TE)) == 0) % compare estimate (Hx) with target values
            for t=1:TE
                if (t > 1)
                    F = basis(X(ii),Hx(t),Hx(t-1),t,2,type,BASISTYPE); %Hx(t-1)
                    FT = basis(X(ii),T(ii).chord(t),T(ii).chord(t-1),t,2,type,BASISTYPE);
                    %FT = basis(X(n_i),T(n_i).chord(t),Hx(t-1),t,2);
                else
                    F = basis(X(ii),Hx(t),1,t,2,type,BASISTYPE);
                    F(BO(1):BO(2)) = 0;
                    FT = basis(X(ii),T(ii).chord(t),1,t,2,type,BASISTYPE);
                    FT(BO(1):BO(2)) = 0;
                end
                
                if (Hx(t) == T(ii).chord(t))
                    W = W + ETA * FT; % F
                else
                    W = W - ETA * F;
                    W = W + ETA * FT;
                end
            end
        end
        %MIN = min(W);
        %W = W + 1 - MIN;
        %W(W == (1-MIN))=0;
    end
end
