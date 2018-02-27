function [ curve, averageSlope, laneImageCurve ] = getCurve( transImage )
%GETCURVE Summary of this function goes here
%   Detailed explanation goes here

[laneImageCurve, lanes] = getLines(transImage);

[n,lanesLength] = size(lanes);
lanesValue = extractfield(lanes, 'theta');
averageSlope = ((sum(lanesValue))/lanesLength);

if averageSlope > 10
    curve = 'Turn Right';
elseif averageSlope < -10
    curve = 'Turn Left';
else
    curve = 'Head Straight';
end

end



