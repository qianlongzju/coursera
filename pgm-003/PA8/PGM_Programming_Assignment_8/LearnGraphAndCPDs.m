function [P G loglikelihood] = LearnGraphAndCPDs(dataset, labels)

% dataset: N x 10 x 3, N poses represented by 10 parts in (y, x, alpha) 
% labels: N x 2 true class labels for the examples. labels(i,j)=1 if the 
%         the ith example belongs to class j
%
% Copyright (C) Daphne Koller, Stanford Univerity, 2012

N = size(dataset, 1);
K = size(labels,2);

G = zeros(10,2,K); % graph structures to learn
% initialization
for k=1:K
    G(2:end,:,k) = ones(9,2);
end

% estimate graph structure for each class
for k=1:K
    % fill in G(:,:,k)
    % use ConvertAtoG to convert a maximum spanning tree to a graph G
    %%%%%%%%%%%%%%%%%%%%%%%%%
    % YOUR CODE HERE
    %%%%%%%%%%%%%%%%%%%%%%%%%
    [A W] = LearnGraphStructure(dataset(find(labels(:, k)), :, :));
    G(:, :, k) = ConvertAtoG(A);
end

% estimate parameters

P.c = zeros(1,K);
% compute P.c

% the following code can be copied from LearnCPDsGivenGraph.m
% with little or no modification
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
        if G(i, 1, k) == 0,
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
                    squeeze(dataset(find(labels(:, k)), G(i, 2, k), :)));
            Beta1 = Beta1';
            Beta1 = [Beta1(4) Beta1(1:3)];
            [Beta2, P.clg(i).sigma_x(k)] = FitLinearGaussianParameters(
                    dataset(find(labels(:, k)), i, 2),...
                    squeeze(dataset(find(labels(:, k)), G(i, 2, k), :)));
            Beta2 = Beta2';
            Beta2 = [Beta2(4) Beta2(1:3)];
            [Beta3, P.clg(i).sigma_angle(k)] = FitLinearGaussianParameters(
                    dataset(find(labels(:, k)), i, 3),...
                    squeeze(dataset(find(labels(:, k)), G(i, 2, k), :)));
            Beta3 = Beta3';
            Beta3 = [Beta3(4) Beta3(1:3)];
            P.clg(i).theta(k, :) = [Beta1, Beta2, Beta3];
        end
    end
end
loglikelihood = ComputeLogLikelihood(P, G, dataset);

fprintf('log likelihood: %f\n', loglikelihood);
