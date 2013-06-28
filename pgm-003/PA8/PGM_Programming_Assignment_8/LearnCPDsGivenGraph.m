function [P loglikelihood] = LearnCPDsGivenGraph(dataset, G, labels)
%
% Inputs:
% dataset: N x 10 x 3, N poses represented by 10 parts in (y, x, alpha)
% G: graph parameterization as explained in PA description
% labels: N x 2 true class labels for the examples. labels(i,j)=1 if the 
%         the ith example belongs to class j and 0 elsewhere        
%
% Outputs:
% P: struct array parameters (explained in PA description)
% loglikelihood: log-likelihood of the data (scalar)
%
% Copyright (C) Daphne Koller, Stanford Univerity, 2012

N = size(dataset, 1);
K = size(labels,2);

loglikelihood = 0;
P.c = zeros(1,K);

% estimate parameters
% fill in P.c, MLE for class probabilities
% fill in P.clg for each body part and each class
% choose the right parameterization based on G(i,1)
% compute the likelihood - you may want to use ComputeLogLikelihood.m
% you just implemented.
%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:K
    P.c(i) = sum(labels(:, i)) / N;
end
P.clg = repmat(struct('mu_y', [], 'sigma_y', zeros(1, K), 
                    'mu_x', [], 'sigma_x', zeros(1, K),...
                    'mu_angle', [], 'sigma_angle', zeros(1, K), 
                    'theta', []), 1, 10);
for k=1:K,
    for i=1:10,
        if G(i, 1) == 0,
            if length(P.clg(i).mu_y) != K, 
                P.clg(i).mu_y = zeros(1, K);
                P.clg(i).mu_x = zeros(1, K);
                P.clg(i).mu_angle = zeros(1, K);
            end
            [P.clg(i).mu_y(k), P.clg(i).sigma_y(k)] = FitGaussianParameters(...
                                        dataset(find(labels(:, k)), i, 1));
            [P.clg(i).mu_x(k), P.clg(i).sigma_x(k)] = FitGaussianParameters(...
                                        dataset(find(labels(:, k)), i, 2));
            [P.clg(i).mu_angle(k), P.clg(i).sigma_angle(k)] =...
                    FitGaussianParameters(dataset(find(labels(:, k)), i, 3));
        else
            if length(P.clg(i).theta) == 0,
                P.clg(i).theta = zeros(k, 12);
            end
            [Beta1, P.clg(i).sigma_y(k)] = FitLinearGaussianParameters(
                    dataset(find(labels(:, k)), i, 1),...
                    squeeze(dataset(find(labels(:, k)), G(i, 2), :)));
            Beta1 = Beta1';
            Beta1 = [Beta1(4) Beta1(1:3)];
            [Beta2, P.clg(i).sigma_x(k)] = FitLinearGaussianParameters(
                    dataset(find(labels(:, k)), i, 2),...
                    squeeze(dataset(find(labels(:, k)), G(i, 2), :)));
            Beta2 = Beta2';
            Beta2 = [Beta2(4) Beta2(1:3)];
            [Beta3, P.clg(i).sigma_angle(k)] = FitLinearGaussianParameters(
                    dataset(find(labels(:, k)), i, 3),...
                    squeeze(dataset(find(labels(:, k)), G(i, 2), :)));
            Beta3 = Beta3';
            Beta3 = [Beta3(4) Beta3(1:3)];
            P.clg(i).theta(k, :) = [Beta1, Beta2, Beta3];
        end
    end
end
loglikelihood = ComputeLogLikelihood(P, G, dataset);
fprintf('log likelihood: %f\n', loglikelihood);
