function [ yellowMask ] = generateYellowMask( undistortedImage, debug )
%GENERATEYELLOWMASK Summary of this function goes here
%   Detailed explanation goes here


minThresh = [0.1, 0.2, 0.6];
maxThresh = [0.4, 1, 1];

hsvImage = rgb2hsv(undistortedImage);

yellowMask = ((hsvImage(:,:,1) > minThresh(1) & hsvImage(:,:,1) < maxThresh(1)) ...
        & (hsvImage(:,:,2) > 0.6 & hsvImage(:,:,3) > 0.6));
    
if debug
    %implay(hsvImage);
end

end

