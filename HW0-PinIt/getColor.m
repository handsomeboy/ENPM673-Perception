function [pinColor] = getColor( pixelArea, segmented_images, nColors )
%GETCOLOR Summary of this function goes here


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

