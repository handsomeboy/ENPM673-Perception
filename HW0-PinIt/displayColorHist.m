function displayColorHist( image )
%   displayColorHist Summary of this function goes here
%   This function displays a color histogram

%   Implementation
%   Split into RGB Channels
    R = image(:,:,1);
    G = image(:,:,2);
    B = image(:,:,3);
%   Get histValues for each channel
    [yRed, x] = imhist(R);
    [yGreen, x] = imhist(G);
    [yBlue, x] = imhist(B);
%   Plot them together in one plot
    figure
    plot(x, yRed, 'Red', x, yGreen, 'Green', x, yBlue, 'Blue');

%   Detailed explanation goes here
%   This function displays a color histogram
end

