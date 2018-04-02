function [Fbest, fMatrixInbuilt] = estFundamentalMatrix(x1, x2, matchedPointsCurrent, matchedPointsNext, t)
%ESTFUNDAMENTALMATRIX Summary of this function goes here
%   Detailed explanation goes here

%   Input is a Nx2 dimension

    %[noOfPoints,~] = size(x1)
    feedback = 0;
    
    % Input Nx2 | Output 3xN
    x1 = convertToHomogeneous(x1, '2D');
    x2 = convertToHomogeneous(x2, '2D');

    % Normalize
    % Input 3xN | Output 3xN
    [x1, T1] = normalize(x1);
    [x2, T2] = normalize(x2);

    fittingfn = @calcFundamentalMatrix;
    distfn    = @funddist;
    degenfn   = @isdegenerate;
    
    [F, inliers] = ransacn([x1; x2], fittingfn, distfn, degenfn, 8, t, feedback);

    if isempty(F)
        return;
    end
    
    Fbest = calcFundamentalMatrix(x1(:,inliers), x2(:,inliers));
    
    Fbest = T2'*Fbest*T1;
    
    fMatrixInbuilt = estimateFundamentalMatrix(matchedPointsCurrent,matchedPointsNext, 'Method', 'RANSAC', 'NumTrials', 2000, 'DistanceThreshold', 1e-4);

end

function fMatrix = calcFundamentalMatrix(varargin)
    
    [x1, x2] = parse(varargin(:));

    [x1, T1] = normalize(x1);
    [x2, T2] = normalize(x2);
    
    indexTemp = size(x1,2);
    
    xCurrent = x1(1,:);
    yCurrent = x1(2,:);
   
    xNext = x2(1,:);
    yNext = x2(2,:);
    
     A = [xCurrent'.*xNext' xNext'.*yCurrent' xNext' ...
         yNext'.*xCurrent' yNext'.*yCurrent' yNext' ...
         xCurrent' yCurrent' ones(indexTemp,1)];
    
    [~,~,V] = svd(A,0);
    
    fMatrix = reshape(V(:,9),3,3)';
    
    [U,S,V] = svd(fMatrix,0);
    
    fMatrix = U*diag([S(1,1) S(2,2) 0])*V';
    
    fMatrix = T2'*fMatrix*T1;
      
end

function [x1, x2] = parse(arg)
    if length(arg) == 2
        x1 = arg{1};
        x2 = arg{2};             
    elseif length(arg) == 1       
            x1 = arg{1}(1:3,:);
            x2 = arg{1}(4:6,:);       
    else
        error('Wrong number of arguments');
    end   
end

function [bestInliers, bestF] = funddist(F, x, t)
    
    x1 = x(1:3,:);    % Extract x1 and x2 from x
    x2 = x(4:6,:);
    
    
    if iscell(F)  % We have several solutions each of which must be tested
		  
	nF = length(F);   % Number of solutions to test
	bestF = F{1};     % Initial allocation of best solution
	ninliers = 0;     % Number of inliers
	
	for k = 1:nF
	    x2tFx1 = zeros(1,length(x1));
	    for n = 1:length(x1)
		x2tFx1(n) = x2(:,n)'*F{k}*x1(:,n);
	    end
	    
	    Fx1 = F{k}*x1;
	    Ftx2 = F{k}'*x2;     

	    % Evaluate distances
	    d =  x2tFx1.^2 ./ ...
		 (Fx1(1,:).^2 + Fx1(2,:).^2 + Ftx2(1,:).^2 + Ftx2(2,:).^2);
	    
	    inliers = find(abs(d) < t);     % Indices of inlying points
	    
	    if length(inliers) > ninliers   % Record best solution
		ninliers = length(inliers);
		bestF = F{k};
		bestInliers = inliers;
	    end
	end
    
    else     % We just have one solution
	x2tFx1 = zeros(1,length(x1));
	for n = 1:length(x1)
	    x2tFx1(n) = x2(:,n)'*F*x1(:,n);
	end
	
	Fx1 = F*x1;
	Ftx2 = F'*x2;     
	
	% Evaluate distances
	d =  x2tFx1.^2 ./ ...
	     (Fx1(1,:).^2 + Fx1(2,:).^2 + Ftx2(1,:).^2 + Ftx2(2,:).^2);
	
	bestInliers = find(abs(d) < t);     % Indices of inlying points
	bestF = F;                          % Copy F directly to bestF
	
    end
end

function r = isdegenerate(x)
    r = 0; 
end