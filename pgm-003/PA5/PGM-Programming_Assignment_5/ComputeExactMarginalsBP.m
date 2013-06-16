%COMPUTEEXACTMARGINALSBP Runs exact inference and returns the marginals
%over all the variables (if isMax == 0) or the max-marginals (if isMax == 1). 
%
%   M = COMPUTEEXACTMARGINALSBP(F, E, isMax) takes a list of factors F,
%   evidence E, and a flag isMax, runs exact inference and returns the
%   final marginals for the variables in the network. If isMax is 1, then
%   it runs exact MAP inference, otherwise exact inference (sum-prod).
%   It returns an array of size equal to the number of variables in the 
%   network where M(i) represents the ith variable and M(i).val represents 
%   the marginals of the ith variable. 
%
% Copyright (C) Daphne Koller, Stanford University, 2012


function M = ComputeExactMarginalsBP(F, E, isMax)

% initialization
% you should set it to the correct value in your code
%M = [];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
%
% Implement Exact and MAP Inference.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
P = CreateCliqueTree(F, E);
P = CliqueTreeCalibrate(P, isMax);
[vars indexA] = unique([P.cliqueList.var],"first"); % All the variables
cards = [F.card](indexA); % Their cardinalities
M = repmat(struct('var', [], 'card', [], 'val', []), 1, length(vars));
for i=1:length(vars),
    M(i).var = [i];
    M(i).card = [cards(i)];
    M(i).val = ones(1, cards(i));
end

for i=1:length(vars),
    for j=1:length(P.cliqueList),
        if isempty(setdiff(vars(i), P.cliqueList(j).var)),
            if isMax,
                M(i) = FactorMaxMarginalization(P.cliqueList(j), ...
                            setdiff(P.cliqueList(j).var, vars(i)));
            else
                M(i) = FactorMarginalization(P.cliqueList(j), ...
                            setdiff(P.cliqueList(j).var, vars(i)));
                M(i).val = M(i).val / sum(M(i).val);
            end
            break;
        end
    end
end

end
