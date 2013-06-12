%COMPUTEINITIALPOTENTIALS Sets up the cliques in the clique tree that is
%passed in as a parameter.
%
%   P = COMPUTEINITIALPOTENTIALS(C) Takes the clique tree skeleton C which is a
%   struct with three fields:
%   - nodes: cell array representing the cliques in the tree.
%   - edges: represents the adjacency matrix of the tree.
%   - factorList: represents the list of factors that were used to build
%   the tree. 
%   
%   It returns the standard form of a clique tree P that we will use through 
%   the rest of the assigment. P is struct with two fields:
%   - cliqueList: represents an array of cliques with appropriate factors 
%   from factorList assigned to each clique. Where the .val of each clique
%   is initialized to the initial potential of that clique.
%   - edges: represents the adjacency matrix of the tree. 
%
% Copyright (C) Daphne Koller, Stanford University, 2012


function P = ComputeInitialPotentials(C)

% number of cliques
N = length(C.nodes);

% initialize cluster potentials 
P.cliqueList = repmat(struct('var', [], 'card', [], 'val', []), N, 1);
map = repmat(struct('val', []), N, 1);
%P.edges = zeros(N);
P.edges = C.edges;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
%
% First, compute an assignment of factors from factorList to cliques. 
% Then use that assignment to initialize the cliques in cliqueList to 
% their initial potentials. 

% C.nodes is a list of cliques.
% So in your code, you should start with: P.cliqueList(i).var = C.nodes{i};
% Print out C to get a better understanding of its structure.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[vars indexA] = unique([C.factorList.var],"first"); % All the variables
cards = [C.factorList.card](indexA); % Their cardinalities
for i=1:N,
    P.cliqueList(i).var = C.nodes{i};
    P.cliqueList(i).card = cards(C.nodes{i});
    P.cliqueList(i).val = ones(1, prod(P.cliqueList(i).card));
end

for i=1:length(C.factorList),
    C.factorList(i) = ReorderFactorVariables(C.factorList(i));
end

for i=1:length(C.factorList),
    for j=1:N,
        if isempty(setdiff(C.factorList(i).var, P.cliqueList(j).var)),
            map(j).val = [map(j).val, i];
            break;
        end
    end
end

for i=1:N,
    if (length(map(i).val) >= 2),
        tmp = FactorProduct(C.factorList(map(i).val(1)),...
                                    C.factorList(map(i).val(2)));
        for j=3:length(map(i).val),
            tmp = FactorProduct(tmp, C.factorList(map(i).val(j)));
        end
        P.cliqueList(i).val = tmp.val;
    elseif (length(map(i).val) == 1),
        P.cliqueList(i).val = C.factorList(map(i).val(1)).val;
    end
end

end

function out = ReorderFactorVariables(in)   
% Function accepts a factor and reorders the factor variables  
% such that they are in ascending order  
[S, I] = sort(in.var);  
out.var = S;  
out.card = in.card(I);  

allAssignmentsIn = IndexToAssignment(1:prod(in.card), in.card);  
allAssignmentsOut = allAssignmentsIn(:,I); % Map from in assgn to out assgn  
out.val(AssignmentToIndex(allAssignmentsOut, out.card)) = in.val;  
end  
