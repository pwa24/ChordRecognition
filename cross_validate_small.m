name = 'Res_JSB_91_Full_';

I = [1:29]
perceptron_skel
Res = validate(X,T,W,[20:29])
save([name, '51-60'], 'Res')

I = [1:19,20:29]
perceptron_skel
Res = validate(X,T,W,[10:29])
save([name, '41-50'], 'Res')

I = [1:9]
perceptron_skel
Res = validate(X,T,W,[10:29])
save([name, '31-40'], 'Res')