function [A W] = LearnGraphStructure(dataset)

% Input:
% dataset: N x 10 x 3, N poses represented by 10 parts in (y, x, alpha)
% 
% Output:
% A: maximum spanning tree computed from the weight matrix W
% W: 10 x 10 weight matrix, where W(i,j) is the mutual information between
%    node i and j. 
%
% Copyright (C) Daphne Koller, Stanford Univerity, 2012

N = size(dataset,1);
K = size(dataset,3);

W = zeros(10,10);
% Compute weight matrix W
% set the weights following Eq. (14) in PA description
% you don't have to include M since all entries are scaled by the same M
%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE        
%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:10,
    for j=1:10,
        if j < i,
            x = dataset(:, i, :);
            x = squeeze(x);
            y = dataset(:, j, :);
            y = squeeze(y);
            cov_x_x = cov(x, x);
            cov_y_y = cov(y, y);
            cov_x_y = cov(x, y);
            cov_y_x = cov(y, x);
            cov_all = [cov_x_x cov_x_y; cov_y_x cov_y_y];
            W(i, j) = 0.5*log((det(cov_x_x) * det(cov_y_y)) / det(cov_all));
        end
    end
end
for i=1:10,
    for j=1:10,
        if j > i,
            W(i, j) = W(j, i);
        end
    end
end

% Compute maximum spanning tree
A = MaxSpanningTree(W);
