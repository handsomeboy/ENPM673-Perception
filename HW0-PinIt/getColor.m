%   This code is for the HW0 for course ENPM673 - Perception 
%   for autonomous robots. Kindly find the implementation details 
%   in the README. 
%   Author      -Rohitkrishna Nambiar
%   UID         -115507944
%   Email       -rohit517@terpmail.umd.edu
%   Github      -https://github.com/rohit517

function [pinColor] = getColor( pixelArea, segmented_images, nColors )
%GETCOLOR Summary of this function goes here

%   This function returns the color of pins given segmented images.

%   -------Input Arguments-------
%   1. pixelArea        - Pixel Area of each blob in a cluster after kmeans
%   2. segmented_images - Cell containing segmented images
%   3. nColors          - Total numbers of colors to be detected.

%   -------Output Arguments-------
%   1. pinColor         - Pin color in an cell of each color.

%   Detailed explanation goes here

pinColor = cell(nColors,1);


for i = 1:nColors

    redFrame = segmented_images{i}(:,:,1);
    greenFrame = segmented_images{i}(:,:,2);
    blueFrame = segmented_images{i}(:,:,3);

    redVal = sum(redFrame(:));
    greenVal = sum(greenFrame(:));
    blueVal = sum(blueFrame(:));

    redValAvg = ceil(redVal/pixelArea(i));
    greenValAvg = ceil(greenVal/pixelArea(i));
    blueValAvg = ceil(blueVal/pixelArea(i));
    
    %   Uncommment following line for debug purposes.
    %fprintf('R = %d G = %d B = %d and area = %d \n', redValAvg, greenValAvg, blueValAvg, pixelArea(i));
    
    %   Color values will have to be hardcoded i guess at somestage. Either during initial 
    %   binarization or later.
    if (redValAvg > 100) && (greenValAvg < 50) && (blueValAvg < 50)
        pinColor(i,1) = cellstr('red');
    elseif (redValAvg < 50) && (greenValAvg < 100) && (blueValAvg > 100)
        pinColor(i,1) = cellstr('blue');
    elseif (redValAvg < 50) && (greenValAvg > 75) && (blueValAvg > 50) && (blueValAvg < 100)
        pinColor(i,1) = cellstr('green');
    elseif (redValAvg > 150) && (greenValAvg > 150) && (blueValAvg < 50)
        pinColor(i,1) = cellstr('yellow');
    elseif (redValAvg > 125) && (greenValAvg > 125) && (blueValAvg > 125)
        pinColor(i,1) = cellstr('background');
    else
        pinColor(i,1) = cellstr('unknown');
    end

end
end

