function [ pixelArea ] = getBlobArea( binarized_images, nrows, ncols, nColors )
%GETBLOBAREA Summary of this function goes here
%   Detailed explanation goes here

pixelArea = zeros(nColors,1);
tempSum = 0;
 
for m = 1:nColors
    for i = 1:nrows
        for j = 1:ncols
            if binarized_images{m}(i,j) == 255
               tempSum = tempSum + 1;
            end
        end
    end
    pixelArea(m,1) = tempSum;
    tempSum = 0;
end

