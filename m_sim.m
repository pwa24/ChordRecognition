function S = m_sim(C1, C2)
    %%{
    S = 0;
    for i=1:12
        if (C1(i) >= 1 && C2(i) >= 1)
            S = S + C1(i) + C2(i);
        end
    end
    if (S >= 4) %% 4 is best
        S = 1;
    else
        S = 0;
    end
    %%}
    

end