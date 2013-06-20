% Copyright (C) Daphne Ksetdiff(tmp.var, U.var)tanford University, 2012

function EU = SimpleCalcExpectedUtility(I)

% Inputs: An influence diagram, I (as described in the writeup).
%         I.RandomFactors = list of factors for each random variable.  These are CPDs, with
%              the child variable = D.var(1)
%         I.DecisionFactors = factor for the decision node.
%         I.UtilityFactors = list of factors representing conditional utilities.
% Return Value: the expected utility of I
% Given a fully instantiated influence diagram with a single utility node and decision node,
% calculate and return the expected utility.  Note - assumes that the decision rule for the 
% decision node is fully assigned.

% In this function, we assume there is only one utility node.
F = [I.RandomFactors I.DecisionFactors];
U = I.UtilityFactors(1);
EU = [];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% YOUR CODE HERE
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Fnew = VariableElimination(F, setdiff(unique([F.var]), U.var));
tmp = Fnew(1);
for j=2:length(Fnew),
    tmp = FactorProduct(tmp, Fnew(j));
end
EU(1) = sum(FactorProduct(tmp, U).val);
%for i=1:length(I.UtilityFactors),
%    U = I.UtilityFactors(i);
%    Fnew = VariableElimination(F, setdiff(unique([F.var]), U.var));
%    tmp = Fnew(1);
%    for j=2:length(Fnew),
%        tmp = FactorProduct(tmp, Fnew(j));
%    end
%    EU(i) = sum(FactorProduct(tmp, U).val);
%end

end
