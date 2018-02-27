%   ENPM 673 - Perception 
%   HW1 - Lane Detection

clc;
%clear all;

videoFReader = vision.VideoFileReader('Dataset/challenge_video.mp4');

videoPlayer = vision.VideoPlayer('Name', 'Video Player', 'Position',[300 100 1280 720]);

testFrame = videoFReader.step();
frameHeight = size(testFrame,1);
frameWidth = size(testFrame,2);

maskImage = vertcat(zeros(frameHeight/2, frameWidth),ones(frameHeight/2, frameWidth)); 

%   Pipeline

while ~isDone(videoFReader)
    videoFrame = videoFReader.step();

    hsvImage = rgb2hsv(videoFrame);
    grayImage = rgb2gray(videoFrame);
    
    yellowFilteredImage = ((hsvImage(:,:,1) > 0.08 & hsvImage(:,:,1) < 1.3) ...
        & (hsvImage(:,:,2) > 0.2 & hsvImage(:,:,3) > 0.6));
    
    whiteFilteredImage = (grayImage > 0.7);
    
    %imshow(grayImage)
     
     filteredImage = medfilt2(grayImage);
     edgeImage = edge(filteredImage, 'sobel');
     blackAndWhiteEdgeImage = imbinarize(im2uint8(edgeImage));
     
     colorThresholdAndEdge = (whiteFilteredImage | yellowFilteredImage | blackAndWhiteEdgeImage) & maskImage ;
     
    videoPlayer.step(grayImage);
end

release(videoPlayer);
release(videoFReader);