function [ outputPoint ] = convertToHomogeneous( inputPoint, dimension )
%CONVERTTOHOMOGENEOUS Summary of this function goes here


%   Detailed explanation goes here
%   Input Dimension Nx2
%   Output Dimension 3XN or 4xN
dim = size(inputPoint,2);
noOfElements = size(inputPoint,1);

if (strcmp(dimension, '2D'))
    if (dim == 3)
        outputPoint(:,1) = inputPoint(:,1) ./ inputPoint(:,3);
        outputPoint(:,2) = inputPoint(:,2) ./ inputPoint(:,3);
        outputPoint(:,3) = inputPoint(:,3) ./ inputPoint(:,3);
    elseif (dim == 2)
        outputPoint = [inputPoint ones(noOfElements,1)];
    end
elseif (strcmp(dimension, '3D'))
    if (dim == 4)
        outputPoint(:,1) = inputPoint(:,1) ./ inputPoint(:,4);
        outputPoint(:,2) = inputPoint(:,2) ./ inputPoint(:,4);
        outputPoint(:,3) = inputPoint(:,3) ./ inputPoint(:,4);
        outputPoint(:,4) = inputPoint(:,4) ./ inputPoint(:,4);
    elseif (dim == 3)
        outputPoint = [inputPoint ones(noOfElements,1)];
    end
end

outputPoint = outputPoint'; % 3XN or 4xN


end

