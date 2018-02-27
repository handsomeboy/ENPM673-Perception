function [ edgeMask ] = edgeDetect( undistortedImage, false )
%EDGEDETECT Summary of this function goes here
%   Detailed explanation goes here

% Convert to gray scale and filter 
grayImage = rgb2gray(undistortedImage);
grayImage = medfilt2(grayImage);

edgeMask = edge(grayImage, 'Sobel');

edgeMask = edgeMask > 0.5;

end

