
function out = Riemannian_dist(p,x)
% Riemannian distance
g = p^(-1)*x;
[V,D] = eig(g);
d = diag(D);
out  = sum(log(d).^2);