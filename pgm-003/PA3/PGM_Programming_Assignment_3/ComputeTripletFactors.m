function factors = ComputeTripletFactors (images, tripletList, K)
% This function computes the triplet factor values for one word.
%
% Input:
%   images: An array of structs containing the 'img' value for each
%     character in the word.
%   tripletList: An array of the character triplets we will consider (other
%     factor values should be 1). tripletList(i).chars gives character
%     assignment, and triplistList(i).factorVal gives the value for that
%     entry in the factor table.
%   K: The alphabet size (accessible in imageModel.K for the provided
%     imageModel).
%
% Hint: Every character triple in the word will use the same 'val' table.
%   Consider computing that array once and then reusing for each factor.
%
% Copyright (C) Daphne Koller, Stanford University, 2012


n = length(images);

% If the word has fewer than three characters, then return an empty list.
if (n < 3)
    factors = [];
    return
end

factors = repmat(struct('var', [], 'card', [], 'val', []), n - 2, 1);

table = ones(1, K*K*K);
for i=1:length(tripletList),
    assignment = tripletList(i).chars;
    I = AssignmentToIndex(assignment, [K, K, K]);
    table(I) = tripletList(i).factorVal;
end

% Your code here:
for i=1:n-2,
    factors(i).var = [i, i+1, i+2];
    factors(i).card = [K, K, K];
    factors(i).val = table;
end

end
