[G, F] = ConstructToyNetwork(1, .1);
randi('seed',1);
for i = 1:2
    [M all_samples] = MCMCInference(G, F, [], 'Gibbs', 1, 12000, 1, repmat(i, 1, 16));
    samples_list{i} = all_samples;
end
ExM = ComputeExactMarginalsBP(F, [], 0);
VisualizeMCMCMarginals(samples_list, 1:length(G.names), G.card, F, 1500, ExM, 'Gibbs');
