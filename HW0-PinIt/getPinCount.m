function [ pinCount ] = getPinCount( binarized_images, nColors )
%GET Summary of this function goes here
%   Detailed explanation goes here

pinCount = zeros(nColors,1);

for i = 1:nColors
    cc = bwconncomp(binarized_images{i},8);
    pinCount(i,1)  = cc.NumObjects;
end

end

