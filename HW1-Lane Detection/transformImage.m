function [ transImage ] = transformImage( binarizedImage, false )
%TRANSFORMIMAGE Summary of this function goes here
%   Detailed explanation goes here

movingPoints = [600 440; 680 440; 0 720; 1280 720];
fixedPoints = [0 0; 1280 0; 0 720; 1280 720 ]; 

tform = fitgeotrans(movingPoints,fixedPoints,'Projective');

transImage = imwarp(binarizedImage,tform,'OutputView',imref2d(size(binarizedImage)));

end

