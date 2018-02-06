%   Name-Rohitkrishna Nambiar
%   UID-115507944


clear all;
clc;
%   Read Image
image = imread('TestImgResized.jpg');

%-----2.3.2 Find total number of coloured objects-----%

%   Convert to HSV Color scale
imageHSV = rgb2hsv(image);
% figure
% imshow(imageHSV(:,:,2));

%   Convert the HSV image to BW after thresholding
%   Thresholding cutoff decided after looking at histogram
% figure
% imhist(imageHSV(:,:,2));
imageBW = im2bw(imageHSV(:,:,2), 0.5);

%   Find number of connected components in binary image
cc = bwconncomp(imageBW);
number  = cc.NumObjects;

%   Print number of coloured pins
fprintf('Total Number of Coloured Objects = %d \n', number);

%------------------------------------------------%
%-----2.3.3 Find individual coloured objects-----%

%   Number of Clusters = number if colors + 1 for background
nColors = 5;

%   Color conversion and reshape
imageLAB = rgb2lab(image);
imageLAB = double(imageLAB(:,:,2:3));
nrows = size(imageLAB,1);
ncols = size(imageLAB,2);
imageAB = reshape(imageLAB,nrows*ncols,2);

%   Clustering using kmeans
[cluster_idx, cluster_center] = kmeans(imageAB,nColors,'distance','sqEuclidean','Replicates',3);
%   Pixel labels for each pixel 
pixel_labels = reshape(cluster_idx,nrows,ncols);

segmented_images = cell(1,nColors);
binarized_images = cell(1,nColors);
rgb_label = repmat(pixel_labels,[1 1 3]);

%   Generating binarized and segmented images
for k = 1:nColors
    color = image;    
    color(rgb_label ~= k) = 0;
    segmented_images{k} = color;
    
    binImage = zeros(nrows,ncols);
    binImage(pixel_labels ~= k) = 0;
    binImage(pixel_labels == k) = 255;
    binarized_images{k} = binImage;
end

%   Filtering the binarized images for noise reduction
for k = 1:nColors
    binarized_images{k} = medfilt2(binarized_images{k});
end

%   Regionprops also works
%  stats = regionprops(binarized_images{2}, 'FilledArea');
%  area = stats.FilledArea;
 
%   Get pixel areas from blobs
pixelArea = getBlobArea(binarized_images, nrows, ncols, nColors);

%   Get pin color from pixel area
pinColor = getColor(pixelArea, segmented_images, nColors);

%   Get count of each color pins
pinCount = getPinCount(binarized_images, nColors);

%   Printing the number of pins
for k = 1:nColors
    if ~strcmp(pinColor{k},'background')
        fprintf('Number of pins of %s color = %d \n', pinColor{k}, pinCount(k))
    else
        backgroundIndex = k;
    end
end

%   Plotting segmented images
figure
subplot(2,4,1);
imshow(image)
title('Input Image');

subplot(2,4,2);
imshow(pixel_labels,[])
title('image labeled by cluster index');

for k = 1:nColors
    subplot(2,4,k+2);
    imshow(segmented_images{k})
    title(pinColor{k}); 
    xlabel(pinCount(k));
%     if k ~= backgroundIndex
%         xlabel(['Count = ' pc]);
%     end
end
