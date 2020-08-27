function [predictLabel] = RiemanGLVQ_classify(testSet, model)
%%RiemanGLVQ_classify.m - classifies the given data with the given model
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
%
%
d = computeDistanceRieman(testSet,model.w);
[min_v,min_id] = min(d,[],2);
predictLabel = model.c_w(min_id);

