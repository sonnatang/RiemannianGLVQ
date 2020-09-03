%%% demo of Riemannian GLVQ
addpath('./source')
datadir = './data/';
%%run RGLVQ
fname = 'CV_normF10_30CA01';
load([datadir fname '.mat']);

trainIdx = ~testIdx;

trainP = P(:,:,trainIdx);
trainLab = Label(trainIdx);

testP = P(:,:,testIdx);
testLab = Label(testIdx);

nPrototype = 1;%needs to specify
nb_epochs = 20;%needs to specify


classes = unique(trainLab);
testSetLab = zeros(size(testP,1)+1,size(testP,2)+1,size(testP,3));
testSetLab(1:end-1,1:end-1,:) = testP;
testSetLab(end,end,:) = testLab;

[model RGLVQ_settting, costs, trainerr,testerr] = RiemanGLVQ_train(trainP, ...
    trainLab,'PrototypesPerClass',nPrototype,...
    'squashFunction','sigmoid','nb_epochs',nb_epochs, 'testSet',testSetLab);

%%%training 
predtrainLab  = RiemanGLVQ_classify(trainP,model);
trainacc = evaluation_measures(trainLab,predtrainLab,classes, 'RA' );
trainkappa= evaluation_measures(trainLab,predtrainLab,classes, 'KAPPA' );
fprintf('RGLVQ: accuracy on the training set: %f\n',trainacc);
fprintf('RGLVQ: kappa on the training set: %f\n',trainkappa);
%%%test
[predLab] = RiemanGLVQ_classify(testP, model);
testacc = evaluation_measures(testLab, predLab,classes, 'RA' );
testkappa = evaluation_measures(testLab, predLab,classes, 'KAPPA' );
fprintf('RGLVQ: accuracy on the test set: %f\n',testacc);
fprintf('RGLVQ: kappa on the test set: %f\n',testkappa);

