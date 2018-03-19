% ENPM 673 - Perception
% Problem 4

clc;
clear all;

%   Variables and Initializations
disparityWindow = 16;
filterSize = 15;
leftImage = imread('tsukuba_l.png');
rightImage = imread('tsukuba_r.png');

% Similarity measure 1 - SSD, 0 - SAD
similarityMeasure = 1;

%disparityMap = stereoMatch(leftImage, rightImage, filterSize, disparityWindow);

noOfRows = size(leftImage,1);
noOfCols = size(leftImage,2);

disparityMap = zeros(noOfRows,noOfCols);
disparityMap_SAD = zeros(noOfRows,noOfCols);
halfFilterSize = (filterSize - 1)/2;

combinedImage = [leftImage rightImage];


for i = 1:noOfRows
    
    minR = max(1,i - halfFilterSize);
    maxR = min(noOfRows, i + halfFilterSize);
    
    for j = 1:noOfCols          
        
        minC = max(1, j -  halfFilterSize);
        maxC = min(noOfCols, j + halfFilterSize);
        
        minDisparityIter = 0;
        
        % Number of blocks in this iteration
        disparityIter = min(disparityWindow, noOfCols - maxC);
        
        % Get template block from right Padded Image
        templateBlock = rightImage(minR:maxR, minC:maxC);
        
        % Create vector to store SSD differences
        ssdValues = zeros(disparityIter +1, 1);
        sadValues = zeros(disparityIter +1, 1);
        
        for k = minDisparityIter:disparityIter
            
            %fprintf('i = %d and j = %d, disparityIter = %d, k = %d, totalCol = %d \n', i,j,disparityIter,k, noOfCols); 
            
            % Store left padded image template
            presentBlock = leftImage(minR:maxR, (minC + k):(maxC + k));
            
            % Iterations to store SSD Values
            blockIndex = k + 1; 
                            
            % Get SSD of templates between right and left
            ssdValues(blockIndex, 1) = sum(sum(power(abs(double(templateBlock) - double(presentBlock)), 2))); 
            sadValues(blockIndex, 1) = sum(sum(abs(double(templateBlock) - double(presentBlock))));
        
        
        end
        
        % Sort the Values
        [sortedSSDMatrix, sortIndex] = sort(ssdValues);
        
        [sortedSADMatrix, sortIndex_SAD] = sort(sadValues);
        
        % Get the best match with least SSD value
        bestMatchIndex = sortIndex(1,1);
        bestMatchIndex_SAD = sortIndex_SAD(1,1);
        
        % Get disparity value
        disparityValue = bestMatchIndex - 1;
        disparityValue_SAD = bestMatchIndex_SAD - 1;
        
        % Add values in Map
        disparityMap(i,j) = disparityValue;
        disparityMap_SAD(i,j) = disparityValue_SAD;
        
        
    end
    
    if (mod(i,10) == 0)
        
        fprintf('Presently in Row %d \n', i);
        
    end
    
    
end

disp('Displaying Image');

figure(1)
imshow(combinedImage);
title('Left and Right Stereo Image');

figure(2)
subplot(1,2,1)
imshow(disparityMap_SAD,[]), axis image, colormap('jet'), colorbar;
caxis([0 disparityWindow]);
title(['Depth map from SSD matching with window size = ' num2str(filterSize) ' and maxDisparity = ' num2str(disparityWindow)]);

subplot(1,2,2)
imshow(disparityMap,[]), axis image, colormap('jet'), colorbar;
caxis([0 disparityWindow]);
title(['Depth map from SAD block matching with window size = ' num2str(filterSize) ' and maxDisparity = ' num2str(disparityWindow)]);

