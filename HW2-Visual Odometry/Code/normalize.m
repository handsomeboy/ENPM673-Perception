function [ updatedPoints, T ] = normalize( pointLocations )
%NORMALIZE Summary of this function goes here
%   Detailed explanation goes here

% Input 3xN | Output 3xN

colsize = size(pointLocations,2);

% Extracting x and y values
xval = pointLocations(1,:);
yval = pointLocations(2,:);

%   Computing centroid
xcentroid = mean(xval);
ycentroid = mean(yval);

xdiff = xval - xcentroid * ones(1,colsize);
ydiff = yval - ycentroid * ones(1,colsize);

averageDistance = sqrt(sum(xdiff.^2 + ydiff.^2)) / colsize;

scale = sqrt(2)/averageDistance;

% Normalizing Transformations
T = [scale, 0, -scale * xcentroid; ...
     0, scale, -scale * ycentroid; ...
     0, 0, 1];


updatedPoints = T * pointLocations;

end

