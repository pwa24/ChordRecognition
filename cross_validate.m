name = 'Res_JSB_91_Full_';

I = [1:50]
perceptron_skel
Res = validate(X,T,W,[51:60])
save([name, '51-60'], 'Res')

I = [1:40,51:60]
perceptron_skel
Res = validate(X,T,W,[41:50])
save([name, '41-50'], 'Res')

I = [1:30,41:60]
perceptron_skel
Res = validate(X,T,W,[31:40])
save([name, '31-40'], 'Res')

I = [1:20,31:60]
perceptron_skel
Res = validate(X,T,W,[21:30])
save([name, '21-30'], 'Res')

I = [1:10,21:60]
perceptron_skel
Res = validate(X,T,W,[11:20])
save([name, '11-20'], 'Res')

I = [11:60]
perceptron_skel
Res = validate(X,T,W,[1:10])
save([name, '1-10'], 'Res')