%CREATECLUSTERGRAPH Takes in a list of factors and returns a Bethe cluster
%   graph. It also returns an assignment of factors to cliques.
%
%   C = CREATECLUSTERGRAPH(F) Takes a list of factors and creates a Bethe
%   cluster graph with nodes representing single variable clusters and
%   pairwise clusters. The value of the clusters should be initialized to 
%   the initial potential. 
%   It returns a cluster graph that has the following fields:
%   - .clusterList: a list of the cluster beliefs in this graph. These entries
%                   have the following subfields:
%     - .var:  indices of variables in the specified cluster
%     - .card: cardinality of variables in the specified cluster
%     - .val:  the cluster's beliefs about these variables
%   - .edges: A cluster adjacency matrix where edges(i,j)=1 implies clusters i
%             and j share an edge.
%  
%   NOTE: The index of the cluster for each factor should be the same within the
%   clusterList as it is within the initial list of factors.  Thus, the cluster
%   for factor F(i) should be found in P.clusterList(i) 
%
% Copyright (C) Daphne Koller, Stanford University, 2012

function P = CreateClusterGraph(F, Evidence)
P.clusterList = [];
N = length(F);
P.edges = zeros(N, N);
for j = 1:length(Evidence),
    if (Evidence(j) > 0),
        F = ObserveEvidence(F, [j, Evidence(j)]);
    end;
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
a = {};
for i=1:length(F),
    P.clusterList(i) = F(i);
    if length(F(i).var) == 1,
        a{F(i).var(1)} = [i];
    end
end
for i=1:length(F),
    if length(F(i).var) == 2,
        P.edges(i, a{F(i).var(1)}) = 1;
        P.edges(i, a{F(i).var(2)}) = 1;
        P.edges(a{F(i).var(1)}, i) = 1;
        P.edges(a{F(i).var(2)}, i) = 1;
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
