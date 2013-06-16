% CLUSTERGRAPHCALIBRATE Loopy belief propagation for cluster graph calibration.
%   P = CLUSTERGRAPHCALIBRATE(P, useSmart) calibrates a given cluster graph, G,
%   and set of of factors, F. The function returns the final potentials for
%   each cluster. 
%   The cluster graph data structure has the following fields:
%   - .clusterList: a list of the cluster beliefs in this graph. These entries
%                   have the following subfields:
%     - .var:  indices of variables in the specified cluster
%     - .card: cardinality of variables in the specified cluster
%     - .val:  the cluster's beliefs about these variables
%   - .edges: A cluster adjacency matrix where edges(i,j)=1 implies clusters i
%             and j share an edge.
%  
%   UseSmart is an indicator variable that tells us whether to use the Naive or Smart
%   implementation of GetNextClusters for our message ordering
%
%   See also FACTORPRODUCT, FACTORMARGINALIZATION
%
% Copyright (C) Daphne Koller, Stanford University, 2012

function [P MESSAGES] = ClusterGraphCalibrate(P,useSmartMP)

if(~exist('useSmartMP','var'))
  useSmartMP = 0;
end

N = length(P.clusterList);

MESSAGES = repmat(struct('var', [], 'card', [], 'val', []), N, N);
[edgeFromIndx, edgeToIndx] = find(P.edges ~= 0);

for m = 1:length(edgeFromIndx),
    i = edgeFromIndx(m);
    j = edgeToIndx(m);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % YOUR CODE HERE
    %
    %
    %
    % Set the initial message values
    % MESSAGES(i,j) should be set to the initial value for the
    % message from cluster i to cluster j
    %
    % The matlab/octave functions 'intersect' and 'find' may
    % be useful here (for making your code faster)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [MESSAGES(i, j).var, IA, IB] = intersect(P.clusterList(i).var, ...
                                        P.clusterList(j).var);
    MESSAGES(i, j).card = P.clusterList(i).card(IA);
    MESSAGES(i, j).val = ones(1, prod(MESSAGES(i, j).card));
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end;



% perform loopy belief propagation
tic;
iteration = 0;

lastMESSAGES = MESSAGES;

DELTAS = {};
DELTAS{N, N} = [];

while (1),
    iteration = iteration + 1;
    [i, j] = GetNextClusters(P, MESSAGES,lastMESSAGES, iteration, useSmartMP); 
    prevMessage = MESSAGES(i,j);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % YOUR CODE HERE
    % We have already selected a message to pass, \delta_ij.
    % Compute the message from clique i to clique j and put it
    % in MESSAGES(i,j)
    % Finally, normalize the message to prevent overflow
    %
    % The function 'setdiff' may be useful to help you
    % obtain some speedup in this function
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    tmp = P.clusterList(i);                                                      
    for k=1:N,                                                                  
        if k == j,                                                              
            continue;                                                           
        end                                                                     
        if P.edges(i, j) != 0,
            tmp = FactorProduct(tmp, MESSAGES(k, i));                       
        end                                                                     
    end                                                                         
    MESSAGES(i, j) = FactorMarginalization(tmp, ...                         
                            setdiff(P.clusterList(i).var, intersect(...          
                            P.clusterList(i).var, P.clusterList(j).var)));        
    MESSAGES(i, j).val = MESSAGES(i, j).val / sum(MESSAGES(i, j).val);      
    

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if(useSmartMP==1)
      lastMESSAGES(i,j)=prevMessage;
    end
    
    delta = MessageDelta(prevMessage, MESSAGES(i, j));
    if length(DELTAS{i, j}) == 0,
        DELTAS{i, j} = [delta; iteration];
    else
        DELTAS{i, j} = [DELTAS{i, j}(1,:), delta; DELTAS{i, j}(2,:), iteration];
    end

    if iteration >= 100000,
        break;
    end

    % Check for convergence every m iterations
    if mod(iteration, length(edgeFromIndx)) == 0
        if (CheckConvergence(MESSAGES, lastMESSAGES))
            break;
        end
        disp(['LBP Messages Passed: ', int2str(iteration), '...']);
        if(useSmartMP~=1)
          lastMESSAGES=MESSAGES;
        end
    end
    
end;
toc;
DELTAS{19, 3}(1,:)
%hold on;
semilogy(DELTAS{19, 3}(2,:), DELTAS{19, 3}(1,:), '+');
print("2.png")
%semilogy(DELTAS{15, 40}(2,:), DELTAS{15, 40}(1,:), 'o');
%semilogy(DELTAS{17, 2}(2,:), DELTAS{17, 2}(1,:), '*');
%hold off;
disp(['Total number of messages passed: ', num2str(iteration)]);


% Compute final potentials and place them in P
for m = 1:length(edgeFromIndx),
    j = edgeFromIndx(m);
    i = edgeToIndx(m);
    P.clusterList(i) = FactorProduct(P.clusterList(i), MESSAGES(j, i));
end


% Get the max difference between the marginal entries of 2 messages -------
function delta = MessageDelta(Mes1, Mes2)
delta = max(abs(Mes1.val - Mes2.val));
return;

