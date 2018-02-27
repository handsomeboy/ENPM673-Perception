function [ roiImage ] = applyROI( binarizedImage, false )
%APPLYROI Summary of this function goes here
%   Detailed explanation goes here

leftTopCorner = [580 440 6];
rightTopCorner = [700 440 6];
leftBottomCorner = [0 720 6];
rightBottomCorner = [1280 720 6];
middle = [640 440 6 6];

x = [580 700 1280 0 580];
y = [440 440 720 720 440];

mask = poly2mask(x,y,720,1280);

roiImage = binarizedImage & mask;

end

