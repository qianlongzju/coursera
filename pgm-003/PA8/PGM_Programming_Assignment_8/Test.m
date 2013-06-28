load PA8Data.mat;
%VisualizeDataset(trainData.data);

%[P1 likelihood1] = LearnCPDsGivenGraph(trainData.data, G1, trainData.labels);
%accuracy1 = ClassifyDataset(testData.data, testData.labels, P1, G1)
%VisualizeModels(P1, G1);

%[P2 likelihood2] = LearnCPDsGivenGraph(trainData.data, G2, trainData.labels);
%accuracy2 = ClassifyDataset(testData.data, testData.labels, P2, G2)
%VisualizeModels(P2, G2);


[P3 G3 likelihood3] = LearnGraphAndCPDs(trainData.data, trainData.labels);
ClassifyDataset(testData.data, testData.labels, P3, G3);
VisualizeModels(P3, G3);
