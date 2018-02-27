function [ whiteMask ] = generateWhiteMask( undistortedImage, debug  )
%GENERATEWHITEMASK Summary of this function goes here
%   Detailed explanation goes here

% Convert to gray scale and filter 
grayImage = rgb2gray(undistortedImage);
grayImage = medfilt2(grayImage);

% Histogram Eq
%grayImage = histeq(grayImage);

whiteMask = grayImage > 0.90;

end

