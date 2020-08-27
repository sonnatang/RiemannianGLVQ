function out = Exp(p,x)
%%% Riemannian Exponential Map
    [u,Lambda] = eig(p);
    g = u*sqrt(Lambda);
    g_iv = g^-1;
    Y = g_iv*x*g_iv';

    [v,Sigma] = eig(Y);
    gmv = g*v;

    sigma = diag(Sigma);
    exp_sigma = exp(sigma);
    exp_sigma = diag(exp_sigma);

    out = gmv*exp_sigma*gmv';
    

    