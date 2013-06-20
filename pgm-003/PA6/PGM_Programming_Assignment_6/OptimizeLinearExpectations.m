% Copyright (C) Daphne Koller, Stanford University, 2012

function [MEU OptimalDecisionRule] = OptimizeLinearExpectations( I )
% Inputs: An influence diagram I with a single decision node and one or more utility nodes.
%         I.RandomFactors = list of factors for each random variable.  These are CPDs, with
%              the child variable = D.var(1)
%         I.DecisionFactors = factor for the decision node.
%         I.UtilityFactors = list of factors representing conditional utilities.
% Return value: the maximum expected utility of I and an optimal decision rule 
% (represented again as a factor) that yields that expected utility.
% You may assume that there is a unique optimal decision.
%
% This is similar to OptimizeMEU except that we will have to account for
% multiple utility factors.  We will do this by calculating the expected
% utility factors and combining them, then optimizing with respect to that
% combined expected utility factor.  
MEU = [];
OptimalDecisionRule = [];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% YOUR CODE HERE
%
% A decision rule for D assigns, for each joint assignment to D's parents, 
% probability 1 to the best option from the EUF for that joint assignment 
% to D's parents, and 0 otherwise.  Note that when D has no parents, it is
% a degenerate case we can handle separately for convenience.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
D = I.DecisionFactors(1);
U = I.UtilityFactors;
I.UtilityFactors = U(1);
EUF = CalculateExpectedUtilityFactor(I);
for i=2:length(U),
    I.UtilityFactors = U(2);
    EUF = FactorSum(EUF, CalculateExpectedUtilityFactor(I));
end
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
    MEU = -inf;
    for i=1:D.card(1),
        tmp = 0;
        for j=1:length(assignments),
            assignment = [i assignments(j,:)];
            value = GetValueOfAssignment(EUF, assignment);
            tmp += value;
        end
        if tmp > MEU,
            MEU = tmp;
        end
    end

    for i=1:length(assignments),
        old = -inf;
        for j=1:D.card(1),
            assignment = [j assignments(i,:)];
            value = GetValueOfAssignment(EUF, assignment);
            if value > old,
                old = value;
                k = j;
            end
        end
        OptimalDecisionRule = SetValueOfAssignment(OptimalDecisionRule,...
                                    [k assignments(i, :)], 1.0);
    end
end
OptimalDecisionRule = ReorderFactorVars(OptimalDecisionRule, sort(D.var));




end
