%   This code is for the HW0 for course ENPM673 - Perception 
%   for autonomous robots. Kindly find the implementation details 
%   in the README. 
%   Author      -Rohitkrishna Nambiar
%   UID         -115507944
%   Email       -rohit517@terpmail.umd.edu
%   Github      -https://github.com/rohit517


function [ filtered_image ] = medfilt2_custom( image )
%MEDFILT2_CUSTOM Summary of this function goes here

%   Implementation of the median filter code 
%   without using medfilt2

%   Detailed explanation goes here

%   Padded Image
image_padded = padarray(image,[1 1],0,'both');

%   Getting number of rows and columns
nrows = size(image_padded,1) - 2;
ncols = size(image_padded,2) - 2;
temp_array = [];

%   New array for storing the filtered output
filtered_image = zeros(nrows,ncols);

for i = 2:nrows+1
    for j = 2:ncols+1
        temp_array(1) = image_padded(i-1,j-1);
        temp_array(2) = image_padded(i-1,j);
        temp_array(3) = image_padded(i-1,j+1);
        temp_array(4) = image_padded(i,j-1);
        temp_array(5) = image_padded(i,j);
        temp_array(6) = image_padded(i,j+1);
        temp_array(7) = image_padded(i+1,j-1);
        temp_array(8) = image_padded(i+1,j);
        temp_array(9) = image_padded(i+1,j+1);
        
        %   Get median value
        median_value = median(temp_array);
        
        %   Store median value in new image
        filtered_image(i-1,j-1) = median_value; 
    end
end

%   Converting to uint8 format from double
filtered_image = uint8(filtered_image);

end

