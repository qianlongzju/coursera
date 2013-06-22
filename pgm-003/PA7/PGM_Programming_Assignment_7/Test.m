% load Train1X.mat;
% load Train1Y.mat;
% theta = LRTrainSGD(Train1X, Train1Y, 0);
% pred = LRPredict(Train1X, theta);
% acc = LRAccuracy(Train1Y, pred)
% 
% load Test1X.mat;
% load Test1Y.mat;
% pred = LRPredict(Test1X, theta);
% acc = LRAccuracy(Test1Y, pred)
% 
% load Validation1X.mat;
% load Validation1Y.mat;
% load Part1Lambdas.mat;
% allAcc = LRSearchLambdaSGD(Train1X, Train1Y, Validation1X, Validation1Y,...
%                                 Part1Lambdas);
% load ValidationAccuracy.mat;
% allAcc' == ValidationAccuracy


%VisualizeCharacters(X),

load Part2Sample.mat;

featureSet = GenerateAllFeatures(sampleX, sampleModelParams);
%uncalibratedTree = GetUncalibratedTree(featureSet);
%sampleUncalibratedTree

%[P, logZ] = CliqueTreeCalibrate(sampleUncalibratedTree, 0);
%sampleCalibratedTree ; P;
%sampleLogZ == logZ;
%[nll, grad] = InstanceNegLogLikelihood(sampleX, sampleY, sampleTheta, sampleModelParams);
%nll == sampleNLL;
%grad == sampleGrad;
% sampleNLL == sampleLogZ - sum(sampleWeightedFeatureCounts)...
%                     + sampleRegularizationCost
% sampleGrad == sampleModelFeatureCounts - sampleFeatureCounts...
%                     + sampleRegularizationGradient
