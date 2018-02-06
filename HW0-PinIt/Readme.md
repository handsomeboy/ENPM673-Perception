# HW 0 - PinIt! 

This is the first assignemnt for the course ENPM 673 - Perception for Autonomous Robots. An image of coloured objects on a white
background is given (TestImgResized.jpg). The objective is to segment out the objects, count the total number of coloured objects 
and also count the objects of same color. 

Input Image -> 

![Input Image](https://github.com/rohit517/ENPM673-Perception/blob/master/HW0-PinIt/Images/TestImgResized.jpg)

## Getting Started

The code is written in MATLAB and basic functions from the Image Processing Toolbox has been used. The assignment is split into 
three parts:

1) Find total number of colored pins
2) Find count of individual colored pins
3) Detect white and transparent pins

## Running the code

To run the code, simply run the matlab file HW0.m. Make sure you have the image TestImgResized.jpg in the same folder as your 
MATLAB file is. Also make sure the other three functions (getBobArea, getColor, getPinCount)  are also in the same directory.
The output will be an image with several sub-images that show the segmented output based on pin color and the total number of pins 
along with the individual count can be seen on the console. 

Output Image ->

![Output Image](https://github.com/rohit517/ENPM673-Perception/blob/master/HW0-PinIt/Images/Output.jpg)

## Author

* **Rohitkrishna Namnbiar**  - [rohit517](https://github.com/rohit517)

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

I would like to thank the course faculty and TA's for their guidance and support. 
