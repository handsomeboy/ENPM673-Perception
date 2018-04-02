%   ENPM 673 - Perception 
%   HW1 - Lane Detection

clc;
%clear all;

%   Variables and Flags
enableUndistort = false;

% Input Video
videoFReader = vision.VideoFileReader('Dataset/project_video.mp4');

% Output Display
videoPlayer = vision.VideoPlayer('Name', 'Video Player', 'Position',[300 100 1280 720]);
videoPlayer1 = vision.VideoPlayer('Name', 'Video Player 1', 'Position',[300 100 1280 720]);
videoPlayer2 = vision.VideoPlayer('Name', 'Video Player 1', 'Position',[300 100 1280 720]);
%v = VideoWriter('myFile.avi');

testFrame = videoFReader.step();
frameHeight = size(testFrame,1);
frameWidth = size(testFrame,2);

maskImage = vertcat(zeros(frameHeight/2, frameWidth),ones(frameHeight/2, frameWidth)); 

position = [50 50];
%open(v)


% ------------------  Pipeline   --------------------- %

while ~isDone(videoFReader)
    videoFrame = videoFReader.step();
    
    % Undistort the image using the camera matrix and distortion coefficient 
    if enableUndistort
       %undistortedImage = undistortimage(videoFrame, 1.6281e+03, 6.71627794e+02, 3.86046312e+02, -2.42565104e-01,-4.77893070e-02,-1.31388084e-03,-8.79107779e-05,2.20573263e-02);
    else
       undistortedImage = videoFrame;
    end
    
    % Binarize the image which will contain lanes
    [binarizedImageWhite, binarizedImageYellow, binarizedImage] = binarize(undistortedImage , false);  
    
    % Extract Region of Interest
    %roiImageWhite = applyROI(binarizedImageWhite, false);
    %roiImageYellow = applyROI(binarizedImageYellow, false);
    roiImage = applyROI(binarizedImage, false);
    
    %testimg = rgb2gray(undistortedImage);
    % Perspective Transform 
    transImage = transformImage(roiImage, false);
    
    % Get Curve value
    [ curve, averageSlope, laneImageCurve ] = getCurve(transImage);
    %fprintf('Head %s with slope = %f \n', curve, averageSlope);  

    [laneImage, leftLane, rightLane] = getLane(undistortedImage, roiImage, position, curve);
    
    %imshow(testimg);
    %videoPlayer.step(laneImageCurve);
    %videoPlayer1.step(leftLane);
    videoPlayer2.step(laneImage);
 
    %writeVideo(v,laneImage);
end

%close(v);
release(videoPlayer);
release(videoFReader);