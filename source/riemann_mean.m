% A = riemann_mean(B,epsilon,tol)
%
% Calcul du barycentre des matrice de covariances.
% A : baricentre des K matrices NxN
%
% B : Matrice NxNxK
% epsilon : Pas de la descente de gradient
% tol : arret de la descente si le crite < tol


function [A, critere, niter] = riemann_mean(B,args)

N_itermax = 1000;
if (nargin<2)||(isempty(args))
    tol = 10^-5;
    A = mean(B,3);
else
    tol = args{1};
    A = args{2};
end

niter = 0;
fc = 0;

while (niter<N_itermax)
    niter = niter+1;
    % Tangent space mapping
    T = Tangent_space(B,A);
    % sum of the squared distance
    fcn = sum(sum(T.^2));
    % improvement
    conv = abs((fcn-fc)/fc);
    if conv<tol % break if the improvement is below the tolerance
       break; 
    end
    % arithmetic mean in tangent space
    TA = mean(T,2);
    % back to the manifold
    A = UnTangent_space(TA,A);
    fc = fcn;
end

if niter==N_itermax
    disp('Warning : Nombre d''it�rations maximum atteint');
end

critere = fc;



function COV = UnTangent_space(T,C)
NTrial = size(T,2);
N_elec = (sqrt(1+8*size(T,1))-1)/2;
COV = zeros(N_elec,N_elec,NTrial);

if nargin<2
    C = riemann_mean(COV);
end

index = reshape(triu(ones(N_elec)),N_elec*N_elec,1)==0;

Out = zeros(N_elec*N_elec,NTrial);

Out(not(index),:) = T;
P = C^0.5;
for i=1:NTrial
  tmp = reshape(Out(:,i),N_elec,N_elec,[]);
  tmp =  diag(diag(tmp))+triu(tmp,1)/sqrt(2) + triu(tmp,1)'/sqrt(2);
  tmp = P*tmp*P;
  COV(:,:,i) = Exp(C,tmp);
end

function [Feat C] = Tangent_space(COV,C)
NTrial = size(COV,3);
N_elec = size(COV,1);
Feat = zeros(N_elec*(N_elec+1)/2,NTrial);

if nargin<2
    C = riemann_mean(COV);
end

index = reshape(triu(ones(N_elec)),N_elec*N_elec,1)==1;
P = C^-0.5;
for i=1:NTrial
    %Tn =  C^-0.5*RiemannLogMap(C,COV(:,:,i))*C^-0.5;
    Tn = logm(P*COV(:,:,i)*P);
    tmp = reshape(sqrt(2)*triu(Tn,1)+diag(diag(Tn)),N_elec*N_elec,1);
    Feat(:,i) = tmp(index);
end

function Out = logm(X)

[V D] = eig(X);
Out = V*diag(log(diag(D)))*V';