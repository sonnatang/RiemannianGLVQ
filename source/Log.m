function [out] = Log(p,x)
% Riemannian Log Map
    [u,Lambda] = eig(p);
    g = u*sqrt(Lambda);
    g_iv = g^-1;
    Y = g_iv*x*g_iv';

    [v,Sigma] = eig(Y);
    gmv = g*v;

    sigma = diag(Sigma);
    log_sigma = log(sigma);
    log_sigma = diag(log_sigma);

    out = gmv*log_sigma*gmv';