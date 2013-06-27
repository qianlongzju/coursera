function loglikelihood = ComputeLogLikelihood(P, G, dataset)
% returns the (natural) log-likelihood of data given the model and graph structure
%
% Inputs:
% P: struct array parameters (explained in PA description)
% G: graph structure and parameterization (explained in PA description)
%
%    NOTICE that G could be either 10x2 (same graph shared by all classes)
%    or 10x2x2 (each class has its own graph). your code should compute
%    the log-likelihood using the right graph.
%
% dataset: N x 10 x 3, N poses represented by 10 parts in (y, x, alpha)
% 
% Output:
% loglikelihood: log-likelihood of the data (scalar)
%
% Copyright (C) Daphne Koller, Stanford Univerity, 2012

N = size(dataset,1); % number of examples
K = length(P.c); % number of classes

loglikelihood = 0;
% You should compute the log likelihood of data as in eq. (12) and (13)
% in the PA description
% Hint: Use lognormpdf instead of log(normpdf) to prevent underflow.
%       You may use log(sum(exp(logProb))) to do addition in the original
%       space, sum(Prob).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
logProb = zeros(N, K);
for i=1:N,
    for k=1:K,
        tmp = log(P.c(k));
        for j=1:10,
            %if length(size(G)) == 3,
            %    if G(j, 1, k) == 0,
            %        tmp += lognormpdf(dataset(i, j, 1), P.clg(j).mu_y(k), P.clg(j).sigma_y(k));
            %        tmp += lognormpdf(dataset(i, j, 2), P.clg(j).mu_x(k), P.clg(j).sigma_x(k));
            %        tmp += lognormpdf(dataset(i, j, 3), P.clg(j).mu_angle(k), P.clg(j).sigma_angle(k));
            %    else,
            %        mu = P.clg(j).theta(k, 1) +...
            %                P.clg(j).theta(k, 2) * dataset(i, G(j, 2, k), 1) +...
            %                P.clg(j).theta(k, 3) * dataset(i, G(j, 2, k), 2) +...
            %                P.clg(j).theta(k, 4) * dataset(i, G(j, 2, k), 3);
            %        tmp += lognormpdf(dataset(i, j, 1), mu, P.clg(j).sigma_x(k));
            %        mu = P.clg(j).theta(k, 5) +...
            %                P.clg(j).theta(k, 6) * dataset(i, G(j, 2, k), 1) +...
            %                P.clg(j).theta(k, 7) * dataset(i, G(j, 2, k), 2) +...
            %                P.clg(j).theta(k, 8) * dataset(i, G(j, 2, k), 3);
            %        tmp += lognormpdf(dataset(i, j, 2), mu, P.clg(j).sigma_y(k));
            %        mu = P.clg(j).theta(k, 9) +...
            %                P.clg(j).theta(k, 10) * dataset(i, G(j, 2, k), 1) +...
            %                P.clg(j).theta(k, 11) * dataset(i, G(j, 2, k), 2) +...
            %                P.clg(j).theta(k, 12) * dataset(i, G(j, 2, k), 3);
            %        tmp += lognormpdf(dataset(i, j, 3), mu, P.clg(j).sigma_angle(k));
            %    end
            %else
                if G(j, 1) == 0,
                    tmp += lognormpdf(dataset(i, j, 1), P.clg(j).mu_y(k), P.clg(j).sigma_y(k));
                    tmp += lognormpdf(dataset(i, j, 2), P.clg(j).mu_x(k), P.clg(j).sigma_x(k));
                    tmp += lognormpdf(dataset(i, j, 3), P.clg(j).mu_angle(k), P.clg(j).sigma_angle(k));
                else,
                    mu = P.clg(j).theta(k, 1) +...
                            P.clg(j).theta(k, 2) * dataset(i, G(j, 2), 1) +...
                            P.clg(j).theta(k, 3) * dataset(i, G(j, 2), 2) +...
                            P.clg(j).theta(k, 4) * dataset(i, G(j, 2), 3);
                    tmp += lognormpdf(dataset(i, j, 1), mu, P.clg(j).sigma_y(k));
                    mu = P.clg(j).theta(k, 5) +...
                            P.clg(j).theta(k, 6) * dataset(i, G(j, 2), 1) +...
                            P.clg(j).theta(k, 7) * dataset(i, G(j, 2), 2) +...
                            P.clg(j).theta(k, 8) * dataset(i, G(j, 2), 3);
                    tmp += lognormpdf(dataset(i, j, 2), mu, P.clg(j).sigma_x(k));
                    mu = P.clg(j).theta(k, 9) +...
                            P.clg(j).theta(k, 10) * dataset(i, G(j, 2), 1) +...
                            P.clg(j).theta(k, 11) * dataset(i, G(j, 2), 2) +...
                            P.clg(j).theta(k, 12) * dataset(i, G(j, 2), 3);
                    tmp += lognormpdf(dataset(i, j, 3), mu, P.clg(j).sigma_angle(k));
                end
            %end
        end
        logProb(i, k) = tmp;
    end
end
Prob = log(sum(exp(logProb), 2));
loglikelihood = sum(Prob);
