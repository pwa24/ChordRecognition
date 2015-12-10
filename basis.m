function F = basis(X,yt,ytm,t,S)
global BASISTYPE;

if (BASISTYPE == 0)
    F = breve_basis(X,yt,ytm,t,S);
else
    F = m_basis(X,yt,ytm,t,S);
end

end

