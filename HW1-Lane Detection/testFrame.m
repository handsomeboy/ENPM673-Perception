
leftTopCorner = [580 440 6];
rightTopCorner = [700 440 6];
leftBottomCorner = [0 720 6];
rightBottomCorner = [1280 720 6];
middle = [640 440 6 6];

I = imread('Dataset/test_image.png');
%I = undistortimage(I, 1.6281e+03, 6.71627794e+02, 3.86046312e+02, -2.42565104e-01,-4.77893070e-02,-1.31388084e-03,-8.79107779e-05,2.20573263e-02);
I = imresize(I, [720 1280]);
shapes = insertShape(I, 'FilledCircle', [0 720 6; 1280 720 6; 600 440 6; 680 440 6], 'Color', {'red','white', 'blue', 'green'});
shapes = insertShape(shapes, 'FilledRectangle', middle, 'Color', 'red');

movingPoints = [600 440; 680 440; 0 720; 1280 720];
fixedPoints = [0 0; 1280 0; 0 720; 1280 720 ]; 
imshow(shapes);
tform = fitgeotrans(movingPoints,fixedPoints,'Projective');

output = imwarp(I,tform,'OutputView',imref2d(size(I)));
figure
imshow(output);