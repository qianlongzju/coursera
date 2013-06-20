% Copyright (C) Daphne Koller, Stanford University, 2012

function [MEU OptimalDecisionRule] = OptimizeMEU( I )

% Inputs: An influence diagram I with a single decision node and a single utility node.
%         I.RandomFactors = list of factors for each random variable.  These are CPDs, with
%              the child variable = D.var(1)
%         I.DecisionFactors = factor for the decision node.
%         I.UtilityFactors = list of factors representing conditional utilities.
% Return value: the maximum expected utility of I and an optimal decision rule 
% (represented again as a factor) that yields that expected utility.

% We assume I has a single decision node.
% You may assume that there is a unique optimal decision.
D = I.DecisionFactors(1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% YOUR CODE HERE...
% 
% Some other information that might be useful for some implementations
% (note that there are multiple ways to implement this):
% 1.  It is probably easiest to think of two cases - D has parents and D 
%     has no parents.
% 2.  You may find the Matlab/Octave function setdiff useful.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
% From the pdf notes:
% By convention, the decision variable itself is
% the first variable listed in the structure, i.e. D.var(1), 
% so the parents are D.var(2:end).
EUF = CalculateExpectedUtilityFactor(I);
EUF = ReorderFactorVars(EUF, D.var);
OptimalDecisionRule = struct('var', [], 'card', [], 'val', []);
OptimalDecisionRule.var = D.var;
OptimalDecisionRule.card = D.card;
if length(D.var) == 1,
    [MEU I] = max(EUF.val);
    OptimalDecisionRule.val = zeros(1, prod(D.card));
    OptimalDecisionRule.val(I) = 1;
else,
    OptimalDecisionRule.val = zeros(1, prod(OptimalDecisionRule.card));
    assignments = IndexToAssignment(1:prod(EUF.card), EUF.card);
    assignments = assignments(:, 2:end);
    assignments = unique(assignments);
    MEU = 0;
    for i=1:length(assignments),
        tmp = -inf;
        for j=1:D.card(1),
            assignment = [j assignments(i,:)];
            value = GetValueOfAssignment(EUF, assignment);
            if value > tmp,
                tmp = value;
                k = j;
            end
        end
        MEU += tmp;
        OptimalDecisionRule = SetValueOfAssignment(OptimalDecisionRule,...
                                    [k assignments(i, :)], 1.0);
    end
end
OptimalDecisionRule = ReorderFactorVars(OptimalDecisionRule, sort(D.var));

end
