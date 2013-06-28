function accuracy = ClassifyDataset(dataset, labels, P, G)
% returns the accuracy of the model P and graph G on the dataset 
%
% Inputs:
% dataset: N x 10 x 3, N test instances represented by 10 parts
% labels:  N x 2 true class labels for the instances.
%          labels(i,j)=1 if the ith instance belongs to class j 
% P: struct array model parameters (explained in PA description)
% G: graph structure and parameterization (explained in PA description) 
%
% Outputs:
% accuracy: fraction of correctly classified instances (scalar)
%
% Copyright (C) Daphne Koller, Stanford Univerity, 2012

N = size(dataset, 1);
accuracy = 0.0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
K = length(P.c); % number of classes
logProb = zeros(N, K);
for i=1:N,
    for k=1:K,
        tmp = log(P.c(k));
        for j=1:10,
            if length(size(G)) == 3,
                if G(j, 1, k) == 0,
                    tmp += lognormpdf(dataset(i, j, 1), P.clg(j).mu_y(k), P.clg(j).sigma_y(k));
                    tmp += lognormpdf(dataset(i, j, 2), P.clg(j).mu_x(k), P.clg(j).sigma_x(k));
                    tmp += lognormpdf(dataset(i, j, 3), P.clg(j).mu_angle(k), P.clg(j).sigma_angle(k));
                else,
                    mu = P.clg(j).theta(k, 1) +...
                            P.clg(j).theta(k, 2) * dataset(i, G(j, 2, k), 1) +...
                            P.clg(j).theta(k, 3) * dataset(i, G(j, 2, k), 2) +...
                            P.clg(j).theta(k, 4) * dataset(i, G(j, 2, k), 3);
                    tmp += lognormpdf(dataset(i, j, 1), mu, P.clg(j).sigma_y(k));
                    mu = P.clg(j).theta(k, 5) +...
                            P.clg(j).theta(k, 6) * dataset(i, G(j, 2, k), 1) +...
                            P.clg(j).theta(k, 7) * dataset(i, G(j, 2, k), 2) +...
                            P.clg(j).theta(k, 8) * dataset(i, G(j, 2, k), 3);
                    tmp += lognormpdf(dataset(i, j, 2), mu, P.clg(j).sigma_x(k));
                    mu = P.clg(j).theta(k, 9) +...
                            P.clg(j).theta(k, 10) * dataset(i, G(j, 2, k), 1) +...
                            P.clg(j).theta(k, 11) * dataset(i, G(j, 2, k), 2) +...
                            P.clg(j).theta(k, 12) * dataset(i, G(j, 2, k), 3);
                    tmp += lognormpdf(dataset(i, j, 3), mu, P.clg(j).sigma_angle(k));
                end
            else
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
            end
        end
        logProb(i, k) = tmp;
    end
end
predict = (logProb == max(logProb, [], DIM=2));
accuracy = sum(sum(predict == labels)) / 2;
accuracy /= N;
fprintf('Accuracy: %.2f\n', accuracy);
