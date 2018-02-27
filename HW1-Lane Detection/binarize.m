function [ binarizedImageWhite, binarizedImageYellow, binarizedImage ] = binarize( undistortedImage, debug)
%BINARIZE Summary of this function goes here
%   Detailed explanation goes here

hsvImage = rgb2hsv(undistortedImage);

% Get size of Image
[imageHeight, imageWidth, imageChannel] = size(undistortedImage);

% Generate Binarized Image and initialize with zeros
binarizedImageWhite = zeros(imageHeight, imageWidth);
binarizedImageYellow = zeros(imageHeight, imageWidth);
binarizedImage = zeros(imageHeight, imageWidth);

yellowMask = generateYellowMask(undistortedImage, false);
whiteMask = generateWhiteMask(undistortedImage, false);
edgeMask = edgeDetect(undistortedImage, false);

binarizedImageWhite = (whiteMask | binarizedImageWhite);
binarizedImageYellow = (yellowMask | binarizedImageYellow);
binarizedImage = (whiteMask | yellowMask | binarizedImageYellow);

%binarizedImage = imclose(binarizedImage,se);

%binarizedImage = edgeMask;

%binarizedImage = hsvImage;

if debug 
    disp('Hi');
    
end


end

