%   This code is for the HW0 for course ENPM673 - Perception 
%   for autonomous robots. Kindly find the implementation details 
%   in the README. 
%   Author      -Rohitkrishna Nambiar
%   UID         -115507944
%   Email       -rohit517@terpmail.umd.edu
%   Github      -https://github.com/rohit517


function [ pinCount ] = getPinCount( binarized_images, nColors )
%GET Summary of this function goes here

%   This function returns the number of pins given binary image

%   -------Input Arguments-------
%   1. binarized_images - Cell containing binary images
%   2. nColors          - Total numbers of colors to be detected.

%   -------Output Arguments-------
%   1. pinCount         - Total pin count in an array of each color.

%   Detailed explanation goes here

pinCount = zeros(nColors,1);

for i = 1:nColors
    cc = bwconncomp(binarized_images{i},8);
    pinCount(i,1)  = cc.NumObjects;
end

end

