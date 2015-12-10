name = 'Res_JSB_91_Full_';

I = [1:29]
perceptron_skel
Res = validate(X,T,W,[26:29])
save([name, '51-60'], 'Res')

I = [1:20,26:29]
perceptron_skel
Res = validate(X,T,W,[21:29])
save([name, '41-50'], 'Res')

I = [1:16,21:29]
perceptron_skel
Res = validate(X,T,W,[16:29])
save([name, '31-40'], 'Res')

I = [1:10,16:29]
perceptron_skel
Res = validate(X,T,W,[11:29])
save([name, '31-40'], 'Res')

I = [1:5,11:29]
perceptron_skel
Res = validate(X,T,W,[10:29])
save([name, '31-40'], 'Res')

I = [6:29]
perceptron_skel
Res = validate(X,T,W,[1:5])
save([name, '31-40'], 'Res')