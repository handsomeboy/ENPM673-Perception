function [ laneImage, leftLane, rightLane ] = getLane( undistortedImage, roiImage, position, curve )
%GETLANE Summary of this function goes here
%   Detailed explanation goes here

laneImage = undistortedImage;

%[laneImage, lanes] = getLines(roiEdge);

%------------ Hough Lines -----------------

% roiEdge = edge(roiImage, 'Sobel');
%
% [H,T,R] = hough(roiEdge);
% 
% P  = houghpeaks(H,20);
% 
% lines = houghlines(roiEdge,T,R,P,'MinLength',3);
% 
% laneImage = im2uint8(roiEdge);
% 
% for k = 1:length(lines)
%    xy = [lines(k).point1, lines(k).point2];
%    %plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
%    firstPoint = xy(:,1);
%    secondPoint = xy(:,2);
%    laneImage = insertShape(laneImage, 'Line', xy,'LineWidth', 5, 'Color', 'red');
% end

%-----------------------------------------

% 1 - Left, 2 - Right

leftLane = [roiImage(:,1:640) zeros(720,640)];
rightLane = [zeros(720,640) roiImage(:,641:1280)];
numrows_resize = 144;
numcols_resize = 256;

[y1, x1] = find(leftLane);
[y2, x2] = find(rightLane);

coefficients1 = polyfit(x1, y1, 1);
m1 = coefficients1 (1);
c1 = coefficients1 (2);

coefficients2 = polyfit(x2, y2, 1);
m2 = coefficients2 (1);
c2 = coefficients2 (2);

%leftTopCorner = [580 440 6];
%rightTopCorner = [700 440 6];

y_bottom_intercept = 670;
y_top_intercept = 460;

x_left_bottom_intercept = (y_bottom_intercept - c1)/m1;
x_left_top_intercept = (y_top_intercept - c1)/m1;

x_right_bottom_intercept = (y_bottom_intercept - c2)/m2;
x_right_top_intercept = (y_top_intercept - c2)/m2;

filledPoly = [x_left_bottom_intercept y_bottom_intercept x_left_top_intercept y_top_intercept x_right_top_intercept y_top_intercept x_right_bottom_intercept y_bottom_intercept];

laneImage = insertShape(laneImage, 'Line', [x_left_bottom_intercept y_bottom_intercept x_left_top_intercept y_top_intercept],'LineWidth', 7, 'Color', 'red', 'Opacity', 0.6);
laneImage = insertShape(laneImage, 'Line', [x_right_bottom_intercept y_bottom_intercept x_right_top_intercept y_top_intercept],'LineWidth', 7, 'Color', 'blue', 'Opacity', 0.6);
laneImage = insertShape(laneImage, 'FilledPolygon', filledPoly, 'Color', 'cyan', 'Opacity', 0.4);
laneImage = insertText(laneImage, position, curve, 'FontSize', 18, 'BoxColor', 'Red', 'BoxOpacity', 0.4, 'TextColor', 'white');


% Embed Images
leftLaneResized = imresize(leftLane,[numrows_resize numcols_resize]);
rightLaneResized = imresize(rightLane,[numrows_resize numcols_resize]);

%laneImage(35:178,150:405) = leftLaneResized;


end

