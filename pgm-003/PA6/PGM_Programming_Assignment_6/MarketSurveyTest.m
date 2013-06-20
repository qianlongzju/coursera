function [MEU1, MEU2, DEC1, DEC2] = MarketSurveyTest()

N = 1;
R = repmat(struct('var', [], 'card', [], 'val', []), N, 1);
D = repmat(struct('var', [], 'card', [], 'val', []), N, 1);
U = repmat(struct('var', [], 'card', [], 'val', []), N, 1);

U(1).var = [1, 3];
U(1).card = [3, 2];
U(1).val = [0, 0, 0, -7, 5, 20];

R(1).var = [1];
R(1).card = [3];
R(1).val = [0.5, 0.3, 0.2];

D(1).var = [3];
D(1).card = [2];
D(1).val = [0, 1];

MS.RandomFactors = R;
MS.DecisionFactors = D;
MS.UtilityFactors = U;

[MEU1, DEC1] = OptimizeMEU(MS)

N = 2;
R = repmat(struct('var', [], 'card', [], 'val', []), N, 1);

R(1).var = [1];
R(1).card = [3];
R(1).val = [0.5, 0.3, 0.2];

R(2).var = [1, 2];
R(2).card = [3, 3];
R(2).val = [0.6, 0.3, 0.1, 0.3, 0.4, 0.4, 0.1, 0.3, 0.5];

D(1).var = [3, 2];
D(1).card = [2, 3];
D(1).val = [0, 1, 0, 1];

MS.RandomFactors = R;
MS.DecisionFactors = D;
MS.UtilityFactors = U;

[MEU2, DEC2] = OptimizeMEU(MS)

end
