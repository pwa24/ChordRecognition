% HMM PERCEPTRON


% partition the input by metric features and only assign added notes as
% part of the label in cases where the added note is on the relatively
% dominant beat. To determine m4 for instance check the proceding input.
% M4 on the dominant --> give M label to the rest
% M on dominant beat --> give M label to the rest ignore added notes.
%
 

MAX_EPOCH = 2;
ETA = 0.1;

%type = {'M' 'M4' 'M6' 'V' 'm' 'm4' 'm6' 'm7' 'd' 'd4' 'd6' 'd7' 'hd' 'M7' 'd7b9'}; % chord labels
%type = {'M' 'M4' 'M6' 'V' 'm' 'm4' 'm6' 'm7' 'd' 'd7'};
type = {'M' 'M4' 'M6' 'V' 'm' 'm7' 'd' 'd7'};
%type = {'M' 'M7' 'm' 'm7' 'd' 'd7' 'hd' '7' 'd7b9'};
nt = size(type,2);

[X,T] = parseDataset('Datasets/jsbach_chorals_harmony.f1',type,1);
%[X,T] = parseDataset('Datasets/kpcorpus2.f1',type,1);

% initialize weights to zero
% weights used at every vertical evalu'ation and horizontal evaluation
K = nt*12; % number of labels
VERT = 70;
HORZ = 33;
W = zeros(VERT+HORZ,1); % 43 basis functions used in paper
BO = [VERT+1, VERT+HORZ];
N = 50;%size(X,2); % number of training examples

FLAG = 0;

I = [1:40,51:60];
    
for epoch=1:MAX_EPOCH
    %rp = randperm(size(Xt, 1));
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
%            Hx = T(ii).chord;
            Hx = carpe_diem_alg(X(ii),W,K,TE,type,BO);
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
                    F = basis(X(ii),Hx(t),Hx(t-1),t,2,type); %Hx(t-1)
                    FT = basis(X(ii),T(ii).chord(t),T(ii).chord(t-1),t,2,type);
                    %FT = basis(X(n_i),T(n_i).chord(t),Hx(t-1),t,2);
                else
                    F = basis(X(ii),Hx(t),1,t,2,type);
                    F(BO(1):BO(2)) = 0;
                    FT = basis(X(ii),T(ii).chord(t),1,t,2,type);
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

% validate
% DO : 10-fold cross validation
% BREVE has been trained on two chorales by J.S. Bach: one in major
% key, one in minor key. It then has been tested on 58 chorales by the same author.
% We repeated this test 5 times, each time with two different training sequences. We
% obtained an average accuracy of 75.55%.

