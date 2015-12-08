function F = basis(X,yt,ytm,t,S,type,BASISTYPE)

if (BASISTYPE == 0)
    F = breve_basis(X,yt,ytm,t,S,type);
else
    F = m_basis(X,yt,ytm,t,S,type);
end

end

