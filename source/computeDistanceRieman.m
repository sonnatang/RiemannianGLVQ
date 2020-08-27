function distances = computeDistanceRieman(X, W)
%computeDistanceRieman.m - Compute AIRM induced geodesci distance between 
%samples X, and prototpyes W
% input: 
%  X : instances organized in matrix array of size n*n*m, 
%      containing m instances, each instance is an is n times n SPD matrix;
%  W: prototypes organized in matrix array of size n*n*M, 
%     containing M prototypes, each prototype is an  n * n SPD matrix;
% Fengzhen Tang
% tangfengzhen@sia.cn
% Thursday Aug 27 08:27 2020
nb_samples = size(X,3);
nb_w = size(W,3);
distances = zeros(nb_samples,nb_w);
for i = 1:nb_samples
    for j = 1:nb_w
        distances(i,j) = Riemannian_dist(X(:,:,i),W(:,:,j));
    end
end

