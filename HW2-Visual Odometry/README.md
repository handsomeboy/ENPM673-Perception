# Project 2 - Monocular Visual Odometry

In this project we aim to perform Visual Odometry for estimating the trajectory of the Robot(camera).  

## Getting Started

The code is written in Matlab 2018a. You must additionally download the Oxford dataset and place it in the Input folder or make changes
in the code accordingly. 

The implementation pipeline is explained below. 

## Visual Odometry Pipeline

### Step 1 - Image PreProcessing

The input images are in the Bayer format which are converted to RGB image using the demosaic function.

Bayer Image - 

![Bayer](https://github.com/rohit517/ENPM673-Perception/blob/master/HW2-Visual%20Odometry/Output/bayerImage.jpg)

RGB Image - 

![RGB](https://github.com/rohit517/ENPM673-Perception/blob/master/HW2-Visual%20Odometry/Output/colorImage.jpg) 

After demosaicing of the image, the distorted Image is undistorted which will then be used for feature detection.

![Undistort](https://github.com/rohit517/ENPM673-Perception/blob/master/HW2-Visual%20Odometry/Output/UndistortImage.jpg) 

### Step 2 - Feature Point Detection 

In this step, the image is searched for salient key points that are likely to match well in other images. 
SURF which is a Blob detector is used for detecting features. SURF features are Rotation, Scale and Affine Invariant.
They are faster than SIFT and are good at repeatability which are important when tracking features.

Feature Point Detection - 

![Features](https://github.com/rohit517/ENPM673-Perception/blob/master/HW2-Visual%20Odometry/Output/FeaturePoints.jpg)

### Step 3 - Fundamental Matrix Computation 

A fundamental Matrix is a 3x3 matrix that relates corresponding points in two images. Here, SURF features detected in subsequent 
images are used to estimate the Fundamental Matrix. Now, we encounter many outliers in the tracked features which 
give erroneous output. Therefore, RANSAC (Random Sample Consensus) is used for outlier rejection. 
This gives us a robust fundamental Matrix.

The function prototype is:

```
[Fbest, fMatrixInbuilt, inliersIndex] = estFundamentalMatrix([currentX currentY] ,[nextX nextY], matchedPointsCurrent, matchedPointsNext, 0.001);
```

Function Name: estFundamentalMatrix

Output: Fbest - Custom Fundamental Matrix Computation
fMatrixInbuilt – Using Inbuilt Function
inliersIndex – Index for Inliers

### Step 4 - Essential Matrix Computation 

The Essential Matrix is computed from the Fundamental Matrix and the Camera Intrinsic Parameters by Singular Value Decomposition. Rank 2 is enforced.

### Step 5 - Camera Pose Estimation

This step gives us the possible rotation and translation matrices for a given essential matrix. We observe that we get 4 possible combinations of Rotations and Translation. This is stored in Tsolutions and Rsoutions.

Function Prototype:
```
[Tsolutions, Rsolutions, translateVector1, translateVector2, R1, R2] = getCameraPose(E);
```
Function Name: getCameraPose

Now we must extract the correct camera pose from the 4 possible options. This is done through triangulation. In this method, we reconstruct the 
3D point and check is it is in front of both the cameras. We will only get one solution for which this holds true. 
That is out Rotation and Translation.

```
[Tactual, Ractual] = getCorrectPose(Tsolutions, Rsolutions, indexWithMetric(1:8,:), K);
```
Function Name: getCorrectPose

### Step 5 - Output

Edge Detection - 

Once we get translation and rotations for pair of frames, we update the global translation and rotation values. This is plotted on every iteration to get a graph that represents the motion of the vehicle. 
The full output(path) can be seen in the next image.

Output Image -

![Output](https://github.com/rohit517/ENPM673-Perception/blob/master/HW2-Visual%20Odometry/Output/OutputRuntime.jpg)

Here we can see the plot which compares custom written functions (Red output) versus inbuilt functions of MATLAB (blue output). Although the overall structure 
appears to be the same, it is a scaled down version of the inbuilt implementation. We have no Loop-Closure and local adjustment (Bundle Adjustment) implementation
which corrects the trajectory based on ‘m’ past values and closes a loop is the scene has been visited before. All these methods will 
help increase accuracy of the system.

![Output](https://github.com/rohit517/ENPM673-Perception/blob/master/HW2-Visual%20Odometry/Output/Comparison.jpg)

## Author

* **Rohitkrishna Namnbiar**  - [rohit517](https://github.com/rohit517)

## Acknowledgments

Implementation of the RANSAC function and Sampson distance for fundamental matrix estimation (ransacn.m and funddist.m) 
has been used from (http://www.peterkovesi.com/matlabfns/Robust/ransac.m) by Peter Kovesi.

## References

- MATLAB Documentation
- Visual Odometry Part 1 and Part 2 by Davide Scaramuzza and Friedrich Fraundorfer.
