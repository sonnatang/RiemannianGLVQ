function cost = RiemanGLVQ_costfun(trainSet,trainLab,model,squashsigmoid)
%%RiemanGLVQ_costfun.m - computes the costs for a given training set and
% RGLVQ model
%  example for usage:
%  trainSet is n times n times m array, containing m  n times n SPD matrix
%  trainLab = [1;1;2;...];
%  model=RiemanGLVQ_train(trainSet,trainLab); % minimal parameters required
%  estimatedTrainLabels = RiemanGLVQ_classify(trainSet, model);
%  trainError = mean( trainLab ~= estimatedTrainLabels );
%
% input: 
%  testSet :  matrix array with training samples in its 3rd dimension
%  model    : RiemanGLVQ model with prototypes w their labels c_w 
% 
% output    : the estimated labels
%  
% Fengzhen Tang
% tangfengzhen@sia.cn
% Thursday Aug 27 08:27 2020
LabelEqPrototype = bsxfun(@eq,trainLab,model.c_w');
dists = computeDistanceRieman(trainSet, model.w);

Dwrong = dists;
Dwrong(LabelEqPrototype) = realmax(class(Dwrong));   % set correct labels impossible
distwrong = min(Dwrong.'); % closest wrong
clear Dwrong;

Dcorrect = dists;
Dcorrect(~LabelEqPrototype) = realmax(class(Dcorrect)); % set wrong labels impossible
distcorrect = min(Dcorrect.'); % closest correct
clear Dcorrect;
clear dists;
distcorrectpluswrong = distcorrect + distwrong;
distcorrectminuswrong = distcorrect - distwrong;
mu = distcorrectminuswrong ./ distcorrectpluswrong;
if strcmp(model.squashFunction,'sigmoid')
    mu = 1./(1 + exp(-squashsigmoid * mu)); % apply sigmoidal
   
end
cost = sum(mu);
end

