% Rohitkrishna Nambiar
% Project 2

clc;
clear all;

cd .. 
cd Input\Oxford_dataset
sensorAlignment = 'gbrg';
warning('off', 'Images:initSize:adjustingMag');

imagefilesDemo = dir('.\stereo\centre\*.png');     
%imagefilesDemo = dir('.\demo\*.png');      
nfilesDemo = length(imagefilesDemo);    % Number of files found

%Extract camera parameters
%imagefiles = dir('.\stereo\centre\*.png');      
%nfiles = length(imagefiles);    % Number of files found

image_dir = fullfile('stereo\centre\');
models_dir = fullfile('model');

[fx, fy, cx, cy, G_camera_image, LUT] = ReadCameraModel(image_dir,models_dir);

K = [fx 0 cx; 0 fy cy; 0 0 1];
IntrinsicMatrix = K';
cameraParams = cameraParameters('IntrinsicMatrix',IntrinsicMatrix);

worldFrameCoordinates = [0; 0; 0];
initialRot = eye(3);
totalTranslation = [0;0;0];

initialRot1 = eye(3);
totalTranslation1 = [0;0;0];

beginFrame = 20;
%frameIndex = 1;
debug = false;

%   Normalize flag during fundamental matrix computation
normalize = true;

fprintf('Here we go... \n');
for i=beginFrame:nfilesDemo-1
    
   % ========================================= %
   % ========== Image Preprocessing ========== %
   % ========================================= %
    
   %    Bayer - RGB 
   if (i == beginFrame)
    currentfilename = imagefilesDemo(i).name;
    currentfilename = fullfile('.\stereo\centre',currentfilename);
   else
    currentfilename = nextfilename;   
   end
   
   nextfilename = imagefilesDemo(i+1).name;
   nextfilename = fullfile('.\stereo\centre',nextfilename);
   
   if(debug)
       fprintf('Current File Path %s | Next File Path %s \n',currentfilename, nextfilename);
   end
   
   currentImage = imread(currentfilename);
   nextImage = imread(nextfilename);

   currentRGBImage = demosaic(currentImage,sensorAlignment);
   nextRGBImage = demosaic(nextImage,sensorAlignment);
  
   %    Undistort
   undistortedCurrentImage = UndistortImage(currentRGBImage, LUT);
   undistortedNextImage = UndistortImage(nextRGBImage, LUT);
   
   % ========================================= %
   % ======== Feature Points Extraction =======%
   % ========================================= %
   
   %    Find SURF Correspndence points
   uCGrayImage = rgb2gray(undistortedCurrentImage);
   uNGrayImage = rgb2gray(undistortedNextImage);
   
   currentImagePoints = detectSURFFeatures(uCGrayImage);
   nextImagePoints = detectSURFFeatures(uNGrayImage);
   
   [currentFeatures,currentValidPoints] = extractFeatures(uCGrayImage,currentImagePoints);
   [nextFeatures,nextValidPoints] = extractFeatures(uNGrayImage,nextImagePoints);
   
   [indexPairs, matchmetric] = matchFeatures(currentFeatures,nextFeatures, 'MaxRatio', 0.2);
   matchedPointsCurrent = currentValidPoints(indexPairs(:,1));
   matchedPointsNext = nextValidPoints(indexPairs(:,2));
   indexWithMetric = [single(matchedPointsCurrent.Location), single(matchedPointsNext.Location), matchmetric];
   
   % ========================================= %
   % === Fundamental Matrix calculations ===== %
   % ========================================= %
  
   [Fbest, fMatrixInbuilt] = estFundamentalMatrix([indexWithMetric(:,1) indexWithMetric(:,2)] ,[indexWithMetric(:,3) indexWithMetric(:,4)], matchedPointsCurrent, matchedPointsNext, 0.001);
   
   % ========================================= %
   % ========= Get Essential Matrix ========== %
   % ========================================= %
   
   % Inbuilt Function
   Einbuilt = K' * fMatrixInbuilt * K;
   
   [U,~,V] = svd(Einbuilt);
   
   Einbuilt = U*diag([1 1 0])*V';
   
   
   % Custom Method
   E = K' * Fbest * K;
   
   [U,S,V] = svd(E);
   
   E = U*diag([1 1 0])*V';
   
   % ========================================= %
   % ======= Camera Pose Estimation ========== %
   % ========================================= %
   
   % Custom Function
   [Tsolutions, Rsolutions, translateVector1, translateVector2, R1, R2] = getCameraPose(E);
     
   % ========================================= %
   % ======== Get Correct Pose =============== %
   % ========================================= %
   
   % Custom Function
   [Tactual, Ractual] = getCorrectPose(Tsolutions, Rsolutions, indexWithMetric(1:8,:), K);
   
   % Inbuilt Function
   [orient, loc] = relativeCameraPose(Einbuilt, cameraParams, matchedPointsCurrent, matchedPointsNext);
    
   if(debug)
       disp('T and R');
       disp(Tactual);
       disp(Ractual);
   end
   
   % ========================================= %
   % ======= Get total translation =========== %
   % ========================================= %
    
    totalTranslation = totalTranslation + initialRot * Tactual;
    initialRot = initialRot * Ractual;
    
    totalTranslation1 = totalTranslation1 + initialRot1 * loc';
    initialRot1 = initialRot1 * orient;
    
    map(:,:,i) = totalTranslation;
    map1(:,:,i) = totalTranslation1;
    
    % ========================================= %
    % =============== Plot Points ============= %
    % ========================================= %
    
    figure(1)
    subplot(2,1,1)
    showMatchedFeatures(undistortedCurrentImage,undistortedNextImage,matchedPointsCurrent,matchedPointsNext);
    legend('matched points 1','matched points 2');
    
    subplot(2,1,2)
    scatter(-map1(1,1,:), map1(3,1,:),'Marker','o','MarkerFaceColor','green'); hold on; scatter(map(1,1,:), map(3,1,:),'Marker','o','MarkerFaceColor','red'); xlim([-500 1500]);
    title('Visual Odometry | Red - Custom Implementation | Green/Blue - Inbuilt Matlab Implementation');
    hold on

    fprintf('Iteration No - %d \n', i);
end   

disp('Exiting');