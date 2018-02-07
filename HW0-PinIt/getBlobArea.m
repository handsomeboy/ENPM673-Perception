%   This code is for the HW0 for course ENPM673 - Perception 
%   for autonomous robots. Kindly find the implementation details 
%   in the README. 
%   Author      -Rohitkrishna Nambiar
%   UID         -115507944
%   Email       -rohit517@terpmail.umd.edu
%   Github      -https://github.com/rohit517

function [ pixelArea ] = getBlobArea( binarized_images, nrows, ncols, nColors )
%GETBLOBAREA Summary of this function goes here

%   This function returns the pixel area of each blobs given binary images.

%   -------Input Arguments-------
%   1. nrows            - Number of rows of image
%   2. ncols            - Number of colom of image
%   3. binarized_images - Cell containing binary images
%   4. nColors          - Total numbers of colors to be detected.

%   -------Output Arguments-------
%   1. pixelArea        - Area of each blob required for calculating average color.

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

