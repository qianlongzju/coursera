function uncalibratedTree = GetUncalibratedTree(featureSet)

N = 
F = repmat(struct('var', [], 'card', [], 'val', []), 1, N);
for i=1:length(featureSet.features),
end
uncalibratedTree = CreateCliqueTree(F);

end
