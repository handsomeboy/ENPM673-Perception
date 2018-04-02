function [ Tactual, Ractual ] = getCorrectPose( translationSet, rotationSet, indexWithMetric, K )
%GETCORRECTPOSE Summary of this function goes here
%   Detailed explanation goes here

    
   Tactual = [0;0;0];
   Ractual = eye(3);

   %    Extract points for both images  
   currentPoint = indexWithMetric(1,1:2);   
   nextPoint = indexWithMetric(1,3:4);

   %    Homogeneous points before normalizing
   currentPoint = convertToHomogeneous(currentPoint, '2D');
   nextPoint = convertToHomogeneous(nextPoint, '2D');
   
   %    Normalize Image Points 3x3 * 3*N
   currentNormalizedPoint = inv(K)*currentPoint;
   nextNormalizedPoint = inv(K)*nextPoint;

   currentSkewMatrix = [0, -currentNormalizedPoint(3,1), currentNormalizedPoint(2,1); ...
                        currentNormalizedPoint(3,1), 0, -currentNormalizedPoint(1,1); ...
                        -currentNormalizedPoint(2,1), currentNormalizedPoint(1,1), 0];
                    
   nextSkewMatrix = [0, -nextNormalizedPoint(3,1), nextNormalizedPoint(2,1); ...
                        nextNormalizedPoint(3,1), 0, -nextNormalizedPoint(1,1); ...
                        -nextNormalizedPoint(2,1), nextNormalizedPoint(1,1), 0];              
   
   % Camera Matrix
   P1 = [eye(3,3), zeros(3,1)];
   
   rtCombinations = size(translationSet,3);
   
   %fprintf('New Frame iteration ');
   for i=1:rtCombinations
       P2 = [rotationSet(:,:,i),translationSet(:,:,i)];
       translationMatrixc2c1 = [P2; 0 0 0 1];
       translationMatrixc1c2 = inv(translationMatrixc2c1);
       P2 = translationMatrixc1c2(1:3,1:4);
       
       A = [currentSkewMatrix * P1; nextSkewMatrix * P2];
       
       [~,~,V] = svd(A);
       
       point = V(:,4);
       currentPointEstimate = point/point(4);
       nextPointEstimate = translationMatrixc1c2 * currentPointEstimate;
       
       % check for positve z
       if currentPointEstimate(3) > 0 && nextPointEstimate(3) > 0
           %fprintf('Found in %d combination', i);
           Tactual = translationSet(:,:,i);
           Ractual = rotationSet(:,:,i);
           break;
       end
       
   end
   %fprintf('  Done. \n');
end

