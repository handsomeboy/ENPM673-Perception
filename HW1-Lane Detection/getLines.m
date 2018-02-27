function [ laneImage, lines ] = getLines( roiImage )
%GETLINES Summary of this function goes here
%   Detailed explanation goes here


[H,T,R] = hough(roiImage);

P  = houghpeaks(H,5,'threshold',ceil(0.3*max(H(:))));

lines = houghlines(roiImage,T,R,P,'FillGap',5,'MinLength',3);

laneImage = im2uint8(roiImage);

for k = 1:length(lines)
   xy = [lines(k).point1, lines(k).point2];
   %plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
   firstPoint = xy(:,1);
   secondPoint = xy(:,2);
   laneImage = insertShape(laneImage, 'Line', xy,'LineWidth', 5, 'Color', 'red');
end


